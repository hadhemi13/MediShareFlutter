import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medishareflutter/main.dart';
import 'package:medishareflutter/viewModels/ImageViewModel.dart';
import 'package:medishareflutter/models/ImageDao.dart';

class UploadImage extends StatefulWidget {
  // final Function(int) updateIndex;
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? _image;
  final ImageViewModel _viewModel = ImageViewModel();

  @override
  void initState() {
    super.initState();
    _pickImage(); // Sélectionner une image à l'ouverture de la page
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(
            pickedFile.path); // Met à jour _image avec l'image sélectionnée
      });
    } else {
      // Si aucune image n'est choisie, revenir à la page précédente
      print('Aucune image sélectionnée.');
       Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage()),
            
          );
    }
  }

  Future<void> _uploadImage() async {

    if (_image != null) {
      // Créer une instance de Image

      final newImage = ImageDao(
       path: _image!.path, // Chemin dynamique
        title: "Uploaded Image", // Titre par défaut
        description: "Description automatique", // Description par défaut
        date: DateTime.now(), // Date dynamique
      );
      // Enregistrer dans SQLite via le ViewModel
      int result = await _viewModel.insertImage(newImage);
      if (result > 0) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image enregistrée avec succès !")),
        );
        _image=null;
         Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage()),
            
          );
        //widget.updateIndex(0); 
       // Navigator.popUntil(context, ModalRoute.withName('/'));
      } else {
    

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Erreur lors de l'enregistrement de l'image.")),
        );
      }
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
                    const Text("Image sélectionnée avec succès."),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _uploadImage,
                      child: const Text("Upload"),
                    ),
                  ],
                )
              : const CircularProgressIndicator(), // Loader temporaire
        ),
      ),
    );
  }
}
