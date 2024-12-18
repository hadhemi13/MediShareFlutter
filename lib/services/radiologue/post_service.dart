import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medishareflutter/utils/constants.dart';

class PostService {
  String baseUrl = Constants.baseUrl;

  /// Increment upvotes for a post
  Future<http.Response> incrementUpvotes(
      String postId, String userId) async {
      final uri = Uri.parse('$baseUrl${Constants.likePost}');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'post_id': postId,
          'userId': userId,
        }),
      );

      return response;
      
    
  }

  /// Create a post
  Future<http.Response> createPost(Map<String, dynamic> postData) async {
    final uri = Uri.parse('$baseUrl${Constants.createPost}');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(postData),
    );
    print(jsonEncode(postData)+ uri.toString());

    return response;
  }

  /// Fetch all posts for a user
  Future<http.Response> getAllPosts(String userId) async {
    final uri = Uri.parse('$baseUrl${Constants.fetchPosts}');
    
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );
    return response;
  }




}
