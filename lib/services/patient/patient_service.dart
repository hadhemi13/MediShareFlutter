import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medishareflutter/utils/constants.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class ApiCommercials {
  final String baseUrl=Constants.baseUrl;

  

  Future<String> _fetchUserId() async {
    final prefs = await SharedPreferences.getInstance();

    var userId =  await prefs.getString('userId');
    
        return userId !!; // Replace with your user ID logic
  }
  Future<List<Map<String, dynamic>>> _fetchRecommendations(String userId) async {
    final url = Uri.parse('${baseUrl}ai/recommendations');
    print("_fetchRecommendations($userId)");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId}),
    );

    if (response.contentLength! > 0) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody['success'] == true) {
        return List<Map<String, dynamic>>.from(responseBody['data']);
      } else {
        throw Exception('Failed to load recommendations');
      }
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

 


}