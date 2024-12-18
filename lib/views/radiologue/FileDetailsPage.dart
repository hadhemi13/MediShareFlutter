import 'package:flutter/material.dart';
import 'package:medishareflutter/models/ImageResponse.dart';
import 'package:medishareflutter/models/Post.dart';
import 'package:medishareflutter/utils/constants.dart';
import 'package:medishareflutter/viewModels/post_view_model.dart';
import 'package:medishareflutter/views/radiologue/full_screen_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileDetailsPage extends StatelessWidget {
  final ImageResponse image;
  final PostViewModel postViewModel = PostViewModel();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController(); // Controller for title
  final _formKey = GlobalKey<FormState>(); // Key for the form

  FileDetailsPage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Add Post")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey, // Attach form key here
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image display with tap gesture
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FullScreenImage(imagePath: image.imageName),
                        ),
                      );
                    },
                    child: Image.network(
                      "${Constants.baseUrl}${image.imageName.replaceAll('\\', '/')}",
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Date: "21/02/2024"',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  // Title input field
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Titre du post',
                      labelStyle: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF113155)), // Smaller label font size
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFF113155),
                            width: 2.0), // Blue border when focused
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0), // Black border when not focused
                      ),
                    ),
                    validator: (value) {
                      // Validation logic for the title
                      if (value == null || value.trim().isEmpty) {
                        return 'Le titre ne doit pas être vide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Description input field
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description du post',
                      labelStyle: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF113155)), // Smaller label font size
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFF113155),
                            width: 2.0), // Blue border when focused
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black,
                            width: 1.0), // Black border when not focused
                      ),
                    ),
                    validator: (value) {
                      // Validation logic for the description
                      if (value == null || value.trim().isEmpty) {
                        return 'La description ne doit pas être vide';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 50),

                  // Button to add the post
                  ElevatedButton(
                    onPressed: () async {
                      // Check if the form is valid
                      if (_formKey.currentState!.validate()) {
                        // Create the new post object
                        final newPost = Post(
                          idImage: image.id,
                          image: image.imageName,
                          description: _descriptionController.text,
                          title: _titleController.text,
                        );

                        // Get userId from SharedPreferences
                        final prefs = await SharedPreferences.getInstance();
                        final userId = await prefs.getString('userId');

                        // Insert the post using the ViewModel
                        await postViewModel.createPost({
                          "title": newPost.title,
                          "imageId": newPost.idImage,
                          "content": newPost.description,
                          "userid": userId!,
                          "subreddit": "dfsdfds",
                        });

                        // Navigate back to the previous page
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ).copyWith(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.transparent,
                      ),
                      shadowColor: MaterialStateProperty.all<Color>(
                        Colors.transparent,
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0x9990CAF9), // Light Blue Start
                            Color(0xFF90CAF9), // Light Blue End
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        child: const Text(
                          "Ajouter le Post",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
