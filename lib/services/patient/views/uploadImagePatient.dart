import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> _uploadAndAnalyze() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    final uri = Uri.parse('http://172.18.7.130:3000/files/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['userId'] = '67475e3306c359da38b6b227' // Replace with actual user ID
      ..files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
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
                : Image.file(File(_selectedImage!.path)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _selectedImage != null && !_isLoading ? _uploadAndAnalyze : null,
              child: _isLoading ? CircularProgressIndicator() : Text('Upload and Analyze'),
            ),
          ],
        ),
      ),
    );
  }
}
