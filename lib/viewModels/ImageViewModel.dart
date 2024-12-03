import 'package:medishareflutter/models/Comment.dart';
import 'package:medishareflutter/models/ImageDao.dart';
import 'package:medishareflutter/models/Post.dart';
import 'package:medishareflutter/sqflite/database_helper.dart';
import 'package:sqflite/sqflite.dart';


class ImageViewModel {
  final String tableName = 'images';


  // Insérer une image
  Future<int> insertImage(ImageDao image) async {
    final db = await DatabaseHelper().database;
    return await db.insert('images', image.toJson(),conflictAlgorithm: ConflictAlgorithm.replace,);
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
}
