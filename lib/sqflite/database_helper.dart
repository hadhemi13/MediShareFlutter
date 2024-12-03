import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // Singleton pattern
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  // Get database
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Supprimer la base de données existante si elle existe
   // final dbPath = await getDatabasesPath();
    //final path = join(dbPath, 'social_app.db');
  //  await deleteDatabase(path); // Supprimer la base de données existante

    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'social_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // Crée la table 'post'
        db.execute('''
          CREATE TABLE post (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            image TEXT,
            description TEXT
          );
        ''');

        // Crée la table 'comment'
        db.execute('''
          CREATE TABLE comment (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            postId INTEGER,
            content TEXT,
            FOREIGN KEY(postId) REFERENCES post(id)
          );
        ''');

        db.execute('''
          CREATE TABLE images (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            path TEXT NOT NULL,
            title TEXT NOT NULL,
            description TEXT,
            date TEXT NOT NULL
          )
        ''');
      },
    );
  }
}
