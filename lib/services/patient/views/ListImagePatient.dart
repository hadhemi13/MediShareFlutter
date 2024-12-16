import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageListScreen1 extends StatefulWidget {
  final String userId = "67475e3306c359da38b6b227";

  @override
  _ImageListScreenState createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen1> {
  List<dynamic> _images = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    final url = Uri.parse('http://172.18.7.130:3000/files/getAllImages');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': "67475e3306c359da38b6b227"}),
    );

    if (response.contentLength! > 0) {
      setState(() {
        _images = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch images.')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image List'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Top Container with Blue Background
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      'Manage your documents easily',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // List of images
                Expanded(
                  child: ListView.builder(
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      final image = _images[index];
                      return _buildImageItem(image);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  // Build the list item with shadow and icon
  Widget _buildImageItem(dynamic image) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.0),
      elevation: 5, // Adding shadow to the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: ListTile(
        leading: Image.network(
          'http://172.18.7.130:3000/upload/${image["image_name"]}',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(
          image['title'] ?? 'No Title',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.blue), // ">" icon on the right
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageDetailsScreen(imageId: image['_id']),
            ),
          );
        },
      ),
    );
  }
}

class ImageDetailsScreen extends StatelessWidget {
  final String imageId;

  const ImageDetailsScreen({Key? key, required this.imageId}) : super(key: key);

  Future<Map<String, dynamic>> _fetchImageDetails() async {
    final url = Uri.parse('http://172.18.7.130:3000/files/getImageDetails');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': imageId}),
    );

    if (response.contentLength! > 0) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load image details');
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Image Details')),
    body: FutureBuilder<Map<String, dynamic>>(
      future: _fetchImageDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          final title = data['title'] ?? 'No Title';
          final imageName = data['image_name'];
          final imageUrl = 'http://172.18.7.130:3000/upload/$imageName';

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Container with Blue Background
                
                SizedBox(height: 16),
                
                // Image section
                if (imageUrl != null)
                  Image.network(imageUrl, height: 200, fit: BoxFit.cover),
                SizedBox(height: 16),
                
                // Title
                Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                // Dynamic Fields with Shadow and Icon
                ..._buildDynamicFields(data),
              ],
            ),
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    ),
  );
}

// Updated _buildDynamicFields with shadow and icon
List<Widget> _buildDynamicFields(Map<String, dynamic> data) {
  List<Widget> widgets = [];

  data.forEach((key, value) {
    if (key == 'title' || key == 'userId' || key == 'image_name' || key == '_id' || key == '__v') return;

    widgets.add(
      Card(
        margin: EdgeInsets.only(bottom: 12.0),
        elevation: 5, // Adding shadow to the card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        child: ListTile(
          leading: Icon(Icons.info, color: Colors.blue),
          title: Text(
            key,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: _buildFieldValue(value),
          trailing: Icon(Icons.wysiwyg, color: Colors.blue), // ">" icon on the right
        ),
      ),
    );
  });

  return widgets;
}

Widget _buildFieldValue(dynamic value) {
  if (value is String || value is int || value is double) {
    return Text(
      value.toString(),
      style: TextStyle(fontSize: 14),
    );
  } else if (value is List) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: value.map((item) => Text('• $item')).toList(),
    );
  } else if (value is Map) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: value.entries.map((entry) {
        return Text('${entry.key}: ${entry.value}');
      }).toList(),
    );
  } else {
    return Text('Unsupported data type');
  }
}
}