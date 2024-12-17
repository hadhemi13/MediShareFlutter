import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medishareflutter/utils/constants.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({Key? key}) : super(key: key);

  final String baseUrl=Constants.baseUrl;


  Future<String> _fetchUserId() async {
    final prefs = await SharedPreferences.getInstance();

    var userId =  await prefs.getString('userId');
    
        return userId !!; // Replace with your user ID logic
  }

  Future<List<Map<String, dynamic>>> _fetchRecommendations(String userId) async {
    final url = Uri.parse('${baseUrl}ai/recommendations');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recommendations')),
      body: FutureBuilder<String>(
        future: _fetchUserId(),
        builder: (context, userIdSnapshot) {
          if (userIdSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (userIdSnapshot.hasError) {
            return Center(child: Text('Error fetching user ID: ${userIdSnapshot.error}'));
          } else if (userIdSnapshot.hasData) {


















            final userId = userIdSnapshot.data!;
            return FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchRecommendations(userId),
              builder: (context, recommendationsSnapshot) {
                if (recommendationsSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (recommendationsSnapshot.hasError) {
                  return Center(child: Text('Error: ${recommendationsSnapshot.error}'));
                }
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                
                 else if (recommendationsSnapshot.hasData) {
                  final recommendations = recommendationsSnapshot.data!;
if (recommendations.isEmpty) {
    // Show error image when no recommendations are found
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/error_notfound.jpg',
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 16.0),
          Text(
            'No recommendations available',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }











                  return ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: recommendations.length,
                    itemBuilder: (context, index) {
                      final recommendation = recommendations[index];
                      final imageUrl =
                          '${Constants.baseUrl}upload/${recommendation['imageUrl']}';
                      final title = recommendation['title'];
                      final content = recommendation['content'];
                      final id = recommendation['_id'];

                      return Card(
                        margin: EdgeInsets.only(bottom: 16.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecommendationDetailsScreen(
                                  id: id,
                                  title: title,
                                  content: content,
                                  imageUrl: imageUrl,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (imageUrl.isNotEmpty)
                                Image.network(
                                  imageUrl,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      content.length > 100
                                          ? content.substring(0, 100) + '...'
                                          : content,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {

                  return Center(child: Text('No recommendations available'));
                }
              },
            );
          } else {
            return Center(child: Text('Unexpected error'));
          }
        },
      ),
    );
  }
}
class RecommendationDetailsScreen extends StatelessWidget {
  final String id;
  final String title;
  final String content;
  final String imageUrl;

  const RecommendationDetailsScreen({
    Key? key,
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recommendation Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl.isNotEmpty)
              Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 16.0),
            Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              content,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
