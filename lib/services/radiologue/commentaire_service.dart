import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medishareflutter/utils/constants.dart';

class CommentaireService {
  

  String baseUrl= Constants.baseUrl;

  /// Create a comment
  Future<Map<String, dynamic>> createComment(Map<String, dynamic> commentData) async {
    try {
      final uri = Uri.parse('$baseUrl${Constants.createComment}');
      print(uri);
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(commentData),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create comment: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error creating comment: $e');
    }
  }

  /// Get all comments for a post
  Future<List<dynamic>> getCommentsForPost(String postId) async {
    try {
      final uri = Uri.parse('$baseUrl${Constants.fetchCommentsByIdPost}');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'post_id': postId}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch comments: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching comments: $e');
    }
  }

  Future<http.Response> getAllComments() async {
    try {
      final uri = Uri.parse('$baseUrl${Constants.fetchAllComments}');
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      
      );

      if (response.statusCode == 200) {
       // return jsonDecode(response.body);
       return response;
      } else {
        throw Exception('Failed to fetch comments: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching comments: $e');
    }
  }




/*
  @GET("comment")
    fun getComment(): Call<List<Comment>>
*/

}
