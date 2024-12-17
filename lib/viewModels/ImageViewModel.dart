import 'dart:convert';

import 'package:medishareflutter/models/ImageDao.dart';
import 'package:medishareflutter/models/ImageResponse.dart';
import 'package:medishareflutter/sqflite/database_helper.dart';
import 'package:medishareflutter/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class ImageViewModel {
  final String tableName = 'images';

  // Insérer une image
  Future<int> insertImage(ImageDao image) async {
    final db = await DatabaseHelper().database;
    return await db.insert(
      'images',
      image.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Récupérer toutes les images
  Future<List<ImageDao>> getImages() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('images');

    return List.generate(maps.length, (i) {
      return ImageDao.fromJson(maps[i]);
    });
  }

  // Supprimer une image
  Future<int> deleteImage(int id) async {
    final db = await DatabaseHelper().database;
    return await db.delete('images', where: 'id = ?', whereArgs: [id]);
  }

  // Mettre à jour une image
  Future<int> updateImage(ImageDao image) async {
    final db = await DatabaseHelper().database;
    return await db.update(
      'images',
      image.toJson(),
      where: 'id = ?',
      whereArgs: [image.id],
    );
  }

  Future<List<ImageResponse>> getImages1() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = await prefs.getString('userId');
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}image/getAllImages'),
        body: {'userId': userId!},
      );

      if (response.statusCode == 201) {
        // Parse the response
       // print(response.body);
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => ImageResponse.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      throw Exception('Failed to load images: $e');
    }
  }
}
