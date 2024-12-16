import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medishareflutter/utils/constants.dart';
import 'dart:io';

class ApiCommercials {
  final String baseUrl=Constants.baseUrl;

  

  Future<String> _fetchUserId() async {
    return "67475e3306c359da38b6b227"; // Replace with your user ID logic
  }

  Future<List<Map<String, dynamic>>> _fetchRecommendations(String userId) async {
    final url = Uri.parse('http://172.18.7.130:3000/ai/recommendations');
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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }


}