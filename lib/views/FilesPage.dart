import 'package:flutter/material.dart';
import 'package:medishareflutter/viewModels/ImageViewModel.dart';
import 'package:medishareflutter/models/ImageDao.dart';
import 'dart:io';

import 'package:medishareflutter/views/FileDetailsPage.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({super.key});

  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  final ImageViewModel _viewModel = ImageViewModel();
  late Future<List<ImageDao>> _images;

  @override
  void initState() {
    super.initState();
    _images = _viewModel.getImages(); // Récupérer les images depuis SQLite
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Files Page')),
      body: FutureBuilder<List<ImageDao>>(
        future: _images, // Récupérer la liste des images
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune image disponible.'));
          } else {
            // Afficher les images sous forme de ListView.builder
            final images = snapshot.data!;
            return ListView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: Image.file(
                      File(image.path), // Affiche l'image depuis le fichier
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(image.title),
                    subtitle: Text(image.description),
                    trailing: Icon(Icons.more_vert),
                    onTap: () {
                      // Naviguer vers la page de détails du fichier
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FileDetailsPage(image: image),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
