import 'package:flutter/material.dart';
import 'package:medishareflutter/models/Post.dart';
import 'package:medishareflutter/viewModels/PostViewModel.dart';
import 'package:medishareflutter/models/ImageDao.dart';
import 'dart:io';

class FileDetailsPage extends StatelessWidget {
  final ImageDao image;
  final PostViewModel postViewModel = PostViewModel();
  final TextEditingController _descriptionController = TextEditingController();

  FileDetailsPage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(image.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Affichage de l'image
            Image.file(
              File(image.path),
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              image.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              image.description ?? 'No description available',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Date: ${image.date}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Champ de texte pour la description du post
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description du post'),
            ),
            Spacer(),

            // Bouton pour ajouter le post
            ElevatedButton(
              onPressed: () async {
                // Récupérer la description

                
                  // Créer un nouveau post
                  final newPost = Post(
                    image: image.path,  // Utiliser le chemin de l'image
                    description: image.description,
                    comments: [],  // Vous pouvez ajouter des commentaires plus tard
                  );

                  // Insérer le post dans la base de données
                  await postViewModel.insertPost(newPost);
                  

                
              },
              child: Text('Ajouter le Post'),
            ),
          ],
        ),
      ),
    );
  }
}
