import 'package:flutter/material.dart';
import 'dart:io';
import 'package:medishareflutter/utils/constants.dart';

class FullScreenImage extends StatelessWidget {
  final String imagePath;

  const FullScreenImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: InteractiveViewer(
          panEnabled: true, // Allow panning
          minScale: 1.0, // Minimum zoom scale
          maxScale: 8.0, // Maximum zoom scale
          boundaryMargin: const EdgeInsets.all(100), // Movement beyond screen edges
          child: Image.network(
            "${Constants.baseUrl}${imagePath.replaceAll('\\', '/')}",
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Text("Failed to load image", style: TextStyle(color: Colors.white)));
            },
          ),
        ),
      ),
    );
  }
}
