import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:medishareflutter/services/patient/views/FullScreenMap.dart';
import 'package:medishareflutter/services/patient/views/ListImagePatient.dart';
import 'dart:convert';

import 'package:medishareflutter/services/patient/views/AllrecommandationPatient.dart';
import 'package:medishareflutter/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MyHomePagePatient extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePagePatient> {
  int _selectedIndex = 0;  // Track the selected index
  final String baseUrl=Constants.baseUrl;
  String userName = "";

// List to store clinics fetched from the API
  List<Map<String, dynamic>> clinics = [];

  // Fetch clinics from the API
  Future<void> fetchClinics() async {
    final url = Uri.parse('${baseUrl}cliniques/clinics'); // API Endpoint
    try {
      print("clicnks fetchClinics function is called ");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          // Update the list with the fetched clinics
          clinics = List<Map<String, dynamic>>.from(data['cliniques'].map((clinic) {
            return {
              'name': clinic['nom'],
              'latitude': clinic['latitude'],
              'longitude': clinic['longitude'],
              'region': clinic['region'],
              'openTime': '8:00 AM', // Default times if not provided in API
              'closeTime': '6:00 PM',
            };
          }));
        });
      } else {
        throw Exception("Failed to load clinics. Status Code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching clinics: $error");
    }
  }


  @override
  void initState() {
    super.initState();
    _fetchUserName();
    fetchClinics(); // Fetch clinics on widget initialization
  }

  Future<String> _fetchUserId() async {
    final prefs = await SharedPreferences.getInstance();

    var userId =  await prefs.getString('userId');
    
        return userId!; // Replace with your user ID logic
  }
  Future<String> _fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();

    var userId =  await prefs.getString('userName');
     this.userName  = userId as String;
     print("00000000000000000000000the name of the user is "+this.userName);
    
        return userName!; // Replace with your user ID logic
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
    backgroundColor: Colors.grey[100],
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
               "Hi ${this.userName}",
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
                      "Stuck on where to start? Use the Home MediShare.",
                      style: TextStyle(color: Colors.green[900]),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 17.0),
           SizedBox(
                height: 210, // Adjust height to fit the mini-map
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: clinics.length,
                  itemBuilder: (context, index) {
                    final clinic = clinics[index];
                    return _buildClinicCard(context, clinic);
                  },
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
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchUserId().then((userId) => _fetchRecommendations(userId)),
              builder: (context, recommendationsSnapshot) {
                if (recommendationsSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (recommendationsSnapshot.hasError) {
                  return Center(child: Text('Error: ${recommendationsSnapshot.error}'));
                } else if (recommendationsSnapshot.hasData) {
                  final recommendations = recommendationsSnapshot.data!;



                  if (recommendations.isEmpty) {
    // Show error image when no recommendations are found
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/error_notfound.jpg',
            height: 100,
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












                  final visibleRecommendations = recommendations.take(3).toList();
                  return SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: visibleRecommendations.length,
                      itemBuilder: (context, index) {
                        final recommendation = visibleRecommendations[index];
                        final imageUrl =
                            '${Constants.baseUrl}upload/${recommendation['imageUrl']}';
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
                            height: 100, // Set a fixed height for the card
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
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildClinicCard(BuildContext context, Map<String, dynamic> clinic) {
    return GestureDetector(
      onTap: () {
        // You can navigate to a full-screen map or details page here.
        print("Tapped on ${clinic['name']}");



          Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenMap(
            latitude: clinic['latitude'],
            longitude: clinic['longitude'],
            clinicName: clinic['name'],
          ),
        ),
      );
      },
      child: SizedBox(
        height: 200,
        width: 200,
        child: Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mini Map inside the card
              SizedBox(
                height: 120,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(clinic['latitude'], clinic['longitude']),
                    initialZoom: 13,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(clinic['latitude'], clinic['longitude']),
                          width: 30.0,
                          height: 30.0,
                          child: Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Clinic Details
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clinic['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      "Open: ${clinic['openTime']}",
                      style: TextStyle(color: Colors.green[800]),
                    ),
                    Text(
                      "Close: ${clinic['closeTime']}",
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

