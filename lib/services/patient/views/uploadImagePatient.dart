import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:medishareflutter/utils/constants.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UploadAndAnalyzeScreen extends StatefulWidget {
  @override
  _UploadAndAnalyzeScreenState createState() => _UploadAndAnalyzeScreenState();
}

class _UploadAndAnalyzeScreenState extends State<UploadAndAnalyzeScreen> {
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<String> _fetchUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? ''; // Ensure a fallback value if userId is null
  }

  Future<void> _uploadAndAnalyze() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = await _fetchUserId(); // Await the userId fetch
      if (userId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User ID not found. Please log in again.')),
        );
        return;
      }

      final uri = Uri.parse('${Constants.baseUrl}files/upload');
      final request = http.MultipartRequest('POST', uri)
        ..fields['userId'] = userId
        ..files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));

      final response = await request.send();

      if (response.contentLength !> 0) {
        final responseData = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Analysis complete: ${jsonResponse['message']}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed. Status code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload and Analyze Image')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectedImage == null
                ? Text('No image selected.')
                : Image.file(File(_selectedImage!.path), height: 200),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _selectedImage != null && !_isLoading ? _uploadAndAnalyze : null,
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('Upload and Analyze'),
            ),
          ],
        ),
      ),
    );
  }
}
