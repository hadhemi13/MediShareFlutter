import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medishareflutter/services/radiologue/detect_tumor_service.dart';
import 'dart:io';
import 'package:medishareflutter/utils/constants.dart';

class FullScreenImage extends StatelessWidget {
  final String imagePath;

  const FullScreenImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      final DetectTumorService detectTumor= DetectTumorService();

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
          child: GestureDetector(
            onTap: () async {
                try {
                  final response = await detectTumor.detectTumor(imagePath);
                 final Map<String, dynamic> decodedResponse = jsonDecode(response.body);

                // Access the predictions list and extract the first confidence value
                final List<dynamic> predictions = decodedResponse['predictions'] ?? [];
                final double confidence = predictions.isNotEmpty
                    ? predictions[0]['confidence']
                    : 0.0;

                  // Handle the response, e.g., show a dialog or navigate
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Detection Tumor"),
                      content: Text("result : ${confidence * 100}%"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  // Handle error
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Error"),
                      content: Text(e.toString()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                }},
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
      ),
    );
  }
}
