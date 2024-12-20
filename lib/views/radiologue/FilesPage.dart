import 'package:flutter/material.dart';
import 'package:medishareflutter/models/ImageResponse.dart';
import 'package:medishareflutter/utils/constants.dart';
import 'package:medishareflutter/viewModels/ImageViewModel.dart';
import 'package:medishareflutter/models/ImageDao.dart';
import 'dart:io';

import 'package:medishareflutter/views/radiologue/FileDetailsPage.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({super.key});

  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  final ImageViewModel _viewModel = ImageViewModel();
  late Future<List<ImageResponse>> _imagesRes;
  late Future<List<ImageDao>> _images;

  @override
  void initState() {
    super.initState();
    _imagesRes = _viewModel.getImages1();

    _images = _viewModel.getImages();
    print(_imagesRes);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Files Page')),
        body: FutureBuilder<List<ImageResponse>>(
          future: _imagesRes, // Récupérer la liste des images
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
             return  Center( // Show the error image when no images are available
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/notfound.png',
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              'No images available',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    
            
        
            } else {
            
              // Afficher les images sous forme de ListView.builder
              final images = snapshot.data!;
              return ListView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final image = images[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: Image.network(
                        "${Constants.baseUrl}${image.imageName.replaceAll('\\', '/')}", // Affiche l'image depuis le fichier
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text("Add Post"),
                      subtitle: Text("Click to add this image as Post"),
                      
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
      ),
    );
  }
}
