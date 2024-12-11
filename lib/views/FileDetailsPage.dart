import 'package:flutter/material.dart';
import 'package:medishareflutter/models/ImageResponse.dart';
import 'package:medishareflutter/models/Post.dart';
import 'package:medishareflutter/utils/constants.dart';
import 'package:medishareflutter/viewModels/post_view_model.dart';
import 'package:medishareflutter/views/full_screen_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileDetailsPage extends StatelessWidget {
  final ImageResponse image;
  final PostViewModel postViewModel = PostViewModel();
  final TextEditingController _descriptionController = TextEditingController();

  FileDetailsPage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(image.title)),
        body: SingleChildScrollView(
          // Wrap body in SingleChildScrollView to make it responsive
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Affichage de l'image
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
                  child:Image.network(
                        "${Constants.baseUrl}${image.imageName.replaceAll('\\', '/')}", // Affiche l'image depuis le fichier
                        
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  image.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),
                Text(
                  'Date: "21/02/2024"',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Title du post',
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
                ),

                SizedBox(
                  height: 20,
                ),
                // Champ de texte pour la description du post
                TextField(
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
                ),
                const SizedBox(height: 50),

                // Spacer to push the button to the bottom when keyboard is visible
                ElevatedButton(
                  onPressed: () async {
                    // Récupérer la description
                    final newPost = Post(
                      idImage: image.id,
                      image: image.imageName, // Utiliser le chemin de l'image
                      description: _descriptionController
                          .text, // Pass description from the TextField
                      //comments: [],
                      title: 'Auto title', // Vous pouvez ajouter de plus tard
                    );
                   final prefs = await SharedPreferences.getInstance();
                   final userId = await prefs.getString('userId');
                    // Insérer le post dans la base de données
                   // await postViewModel.insertPost(newPost);
                    await postViewModel.createPost({"title":newPost.title,"imageId":newPost.idImage,"content":newPost.description,"userid":userId!,"subreddit":"dfsdfds"});
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.transparent, // Make the background transparent
                    minimumSize: Size(double.infinity, 50), // Button height
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                    side: BorderSide.none, // Optional: Remove any border
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
                        begin: Alignment.centerLeft, // Start gradient from left
                        end: Alignment.centerRight, // End gradient at right
                      ),
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50, // Button height
                      child: const Text(
                        "Ajouter le Post", // Text on the button
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold, // Bold text
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
    );
  }
}
