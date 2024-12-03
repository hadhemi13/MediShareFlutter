import 'package:medishareflutter/models/Comment.dart';
import 'package:medishareflutter/models/Post.dart';
import 'package:medishareflutter/sqflite/database_helper.dart';

import 'package:sqflite/sqflite.dart';


class PostViewModel {

final String tableName = 'post';


Future<void> saveCommentToDatabase(Comment comment) async {
  final db = await DatabaseHelper().database;
  await db.insert(
    'comment', // Nom de la table
    comment.toJson(), // Convertir l'objet en JSON
    conflictAlgorithm: ConflictAlgorithm.replace, // Gérer les conflits d'ID
  );
}
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
  print('Post added: ${post.toJson()}');  // Log pour vérifier l'insertion
}

  /// Fetch all Posts with associated Comments from the database
Future<List<Post>> fetchPosts() async {
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

    List<Comment> comments = List.generate(commentMaps.length, (i) {
      return Comment.fromJson(commentMaps[i]);
    });

    // Create a Post object with its comments
    posts.add(Post.fromJson(postMap, comments));
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
