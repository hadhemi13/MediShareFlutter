import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medishareflutter/services/patient/views/ListImagePatient.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import 'package:medishareflutter/services/patient/views/AllrecommandationPatient.dart';
class MyHomePagePatient extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePagePatient> {
  int _selectedIndex = 0;  // Track the selected index













  

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

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey[100],
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi, Jessica",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 18.0),
            Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.green),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      "Stuck on where to start? Use the Home Maintenance Planner.",
                      style: TextStyle(color: Colors.green[900]),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 17.0),
            SizedBox(
              height: 190,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildClinicCard(
                    context,
                    "Clinic A",
                    "assets/clinic1.jpg",
                    "https://www.google.com/maps?q=clinic+a",
                    "8:00 AM",
                    "7:00 PM",
                  ),
                  _buildClinicCard(
                    context,
                    "Clinic B",
                    "assets/clinic1.jpg",
                    "https://www.google.com/maps?q=clinic+b",
                    "8:00 AM",
                    "7:00 PM",
                  ),
                  _buildClinicCard(
                    context,
                    "Clinic C",
                    "assets/clinic1.jpg",
                    "https://www.google.com/maps?q=clinic+c",
                    "8:00 AM",
                    "7:00 PM",
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recommendations",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecommendationsScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "See More",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            FutureBuilder<String>(
              future: _fetchUserId(),
              builder: (context, userIdSnapshot) {
                if (userIdSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (userIdSnapshot.hasError) {
                  return Center(child: Text('Error fetching user ID'));
                } else {
                  return FutureBuilder<List<Map<String, dynamic>>>( 
                    future: _fetchRecommendations(userIdSnapshot.data!),
                    builder: (context, recommendationsSnapshot) {
                      if (recommendationsSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (recommendationsSnapshot.hasError) {
                        return Center(child: Text('Error: ${recommendationsSnapshot.error}'));
                      } else if (recommendationsSnapshot.hasData) {
                        final recommendations = recommendationsSnapshot.data!;
                        final visibleRecommendations = recommendations.take(3).toList();
                        return SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: visibleRecommendations.length,
                            itemBuilder: (context, index) {
                              final recommendation = visibleRecommendations[index];
                              final imageUrl = 'http://172.18.7.130:3000/upload/${recommendation['imageUrl']}';
                              final title = recommendation['title'];
                              final content = recommendation['content'];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecommendationDetailsScreen(
                                        title: title,
                                        imageUrl: imageUrl,
                                        content: content,
                                        id: '77754574575',
                                      ),
                                    ),
                                  );
                                },
                                
                                child: SizedBox(
                                    height: 100,  // Set a fixed height for the card

                                  width: 200,
                                  child: Card(
                                    elevation: 2,
                                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        if (imageUrl.isNotEmpty)
                                          Container(
                                            height: 65,
                                            width: double.infinity,
                                            child: Image.network(imageUrl, fit: BoxFit.cover),
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                title,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 1.0),
                                              Text(
                                                content.length > 50
                                                    ? content.substring(0, 50) + '...'
                                                    : content,
                                                style: TextStyle(color: Colors.grey[600]),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                           return Center(child: Text('No recommendations available'));
                      }
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    ),
   
  );
}

  Widget _buildClinicCard(BuildContext context, String name, String imagePath, String url,
      String openTime, String closeTime) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: SizedBox(
        height: 160,
        width: 180,
      
        child: Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                imagePath,
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      "Open: $openTime",
                      style: TextStyle(color: Colors.green[800]),
                    ),
                    Text(
                      "Close: $closeTime",
                      style: TextStyle(color: Colors.red[800]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
