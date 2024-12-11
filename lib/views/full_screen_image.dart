
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
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 1.0,
          maxScale: 4.0,
          child: Image.network("${Constants.baseUrl}${imagePath.replaceAll('\\', '/')}",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
