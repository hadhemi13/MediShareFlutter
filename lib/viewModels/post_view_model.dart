import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medishareflutter/models/Comment.dart';
import 'package:medishareflutter/models/ImageResponse.dart';
import 'package:medishareflutter/models/Post.dart';
import 'package:medishareflutter/models/PostResponse.dart';
import 'package:medishareflutter/services/radiologue/post_service.dart';
import 'package:medishareflutter/sqflite/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class PostViewModel extends ChangeNotifier {
  final PostService _postService = PostService();

  // States for Posts
  List<dynamic> posts = [];
  bool isLoading = false;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Method to fetch all posts
  Future<List<PostResponse>> fetchPosts() async {
    isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = await prefs.getString('userId')!;

      final response = await _postService.getAllPosts(userId);
      print(response.body);
      if (response.contentLength!>0) {
        List<dynamic> data = jsonDecode(response.body);
        print("èèèè-------------------------------");
        print(data.map((item) => PostResponse.fromJson(item)).toList());
        return data.map((item) => PostResponse.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load images 111');
      }
    } catch (e) {
      _errorMessage = 'Error fetching posts: $e';
      throw Exception('$e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Method to create a post
  Future<bool> createPost(Map<String, dynamic> postData) async {
    isLoading = true;
    notifyListeners();

    try {
      var response = await _postService.createPost(postData);
      print(response.body);
      print(postData);
      _errorMessage = 'Error fetching posts: $response';
      if (response.statusCode == 201) {
        return true;
      } else {
        _errorMessage = 'Error fetching posts else: ${postData}';
        return false;
      }
      //fetchPosts(postData['userId']);  // Optionally refresh posts after creating
    } catch (e) {
      _errorMessage = 'Error fetching posts catch: no response';
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return false;
  }

  // Method to increment upvotes
  Future<void> incrementUpvotes(String postId, String userId) async {
    isLoading = true;
    notifyListeners();

    try {
      await _postService.incrementUpvotes(postId, userId);
      _errorMessage = 'Error fetching posts: response';
      fetchPosts(); // Optionally refresh posts after upvoting
    } catch (e) {
      _errorMessage = 'Error fetching postscatch: response';
    }

    isLoading = false;
    notifyListeners();
  }

  //////////////////////////////////////////

  final String tableName = 'post';
/*
  Future<void> saveCommentToDatabase(Comment comment) async {
    final db = await DatabaseHelper().database;
    await db.insert(
      'comment', // Nom de la table
      comment.toJson(), // Convertir l'objet en JSON
      conflictAlgorithm: ConflictAlgorithm.replace, // Gérer les conflits d'ID
    );
  }
*/
  /// Insert a Post into the database
  Future<void> insertPost(Post post) async {
    print("__________________________");
    final db = await DatabaseHelper().database;
    print("__________________________");

    await db.insert(
      tableName,
      post.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Post added: ${post.toJson()}'); // Log pour vérifier l'insertion
  }

  /// Fetch all Posts with associated Comments from the database
  Future<List<Post>> fetchPostss() async {
    final db = await DatabaseHelper().database;

    // Fetch posts from the 'post' table
    final List<Map<String, dynamic>> postMaps = await db.query(tableName);

    print("Fetched ${postMaps.length} posts");

    List<Post> posts = [];

    // For each post, fetch its comments
    for (var postMap in postMaps) {
      // Fetch comments for this post
      final List<Map<String, dynamic>> commentMaps = await db.query(
        'comment',
        where: 'postId = ?',
        whereArgs: [postMap['id']],
      );

      print("Post ${postMap['id']} has ${commentMaps.length} comments");

     // List<Comment> comments = List.generate(commentMaps.length, (i) {
        //return Comment.fromJson(commentMaps[i]);
      //});

      // Create a Post object with its comments
    //  posts.add(Post.fromJson(postMap, comments));
    }

    return posts;
  }

  /// Delete a Post by its ID
  Future<void> deletePost(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
