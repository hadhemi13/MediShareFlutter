import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:medishareflutter/main.dart';
import 'package:medishareflutter/utils/constants.dart';
import 'package:medishareflutter/views/radiologue/my_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? _image;

  @override
  void initState() {
    super.initState();
    _pickImage(); // Pick an image when the page opens
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      // If no image is selected, navigate back
      print('No image selected.');
      Navigator.pop(context);
    }
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      try {
        final uri = Uri.parse('${Constants.baseUrl}image/upload');
        final request = http.MultipartRequest('POST', uri);

        // Attach the image file
        request.files.add(await http.MultipartFile.fromPath('file', _image!.path));
        final prefs = await SharedPreferences.getInstance();
        // Add additional fields like userId
        request.fields['userId'] = await prefs.getString('userId')!; // Replace with dynamic user ID if needed

        final response = await request.send();

        if (response.statusCode == 201) {
          final responseBody = await http.Response.fromStream(response);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload successful: ${responseBody.body}')),
          );
          setState(() {
            _image = null;
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: ${response.statusCode}')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Upload Image")),
        body: Center(
          child: _image != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.file(
                      _image!,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20),
                    const Text("Image selected successfully."),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _uploadImage,
                      child: const Text("Upload"),
                    ),
                  ],
                )
              : const CircularProgressIndicator(), // Temporary loader
        ),
      ),
    );
  }
}
