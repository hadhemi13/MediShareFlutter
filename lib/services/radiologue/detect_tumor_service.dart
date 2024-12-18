import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medishareflutter/utils/constants.dart';

class DetectTumorService {
  

  String baseUrl= Constants.baseUrl;

  /// Create a comment
 Future<http.Response> detectTumor(
      String imagePath) async {
      final uri = Uri.parse('${baseUrl}tumor-detection');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'imagePath': imagePath,
          
        }),
      );

      return response;
      
    
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
