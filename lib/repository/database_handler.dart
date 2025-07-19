// ignore_for_file: depend_on_referenced_packages
import 'dart:async';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../model/book.dart';

class DatabaseHandler {
  static DatabaseHandler? _databaseHandler;
  static Database? _database;
  final db = 'metadata.db';

  DatabaseHandler._createInstance();

  Future<Database> get database async {
    _database ??= await initDB();
    return _database!;
  }

  factory DatabaseHandler() {
    _databaseHandler ??= DatabaseHandler._createInstance();
    return _databaseHandler!;
  }

  Future<Database> initDB() async {
    sqfliteFfiInit();
    final databaseFactory = databaseFactoryFfi;
    final appDocumentsDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentsDir.path, "ebooks/$db");
    return await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      ),
    );
  }

// Get Booklist from database
  Future<List<Book>> getBookItemList() async {
    final db = await database;
    var resultSet = await db.rawQuery('SELECT * FROM books');

    List<Book> books = <Book>[];

    if (resultSet.isNotEmpty) {
      for (var item in resultSet) {
        Book book = Book.fromMap(item);
        books.add(book);
      }
      return books;
    }
    return books;
  }

  // Fetch Operation: Get item from database by id
  Future<Book?> selectItemById(int id, String table) async {
    final db = await database;
    Book? item;
    List<Map<String, dynamic>> itemMap =
        await db.query(table, where: 'id = ?', whereArgs: [id], limit: 1);
    if (itemMap.isEmpty) {
      return null;
    }
    for (var element in itemMap) {
      item = Book.fromMap(element);
    }
    return item;
  }

  // Insert Operation: Insert new record to database
  Future<int> insert({
    required table,
    required item,
  }) async {
    Database db = await database;
    int result;
    try {
      result = await db.insert(table, item.toMap());
    } catch (e) {
      throw Exception('Some error$e');
    }

    return result;
  }

  // Update Operation: Update record in the database
  Future<int> update({
    required String table,
    required int id,
    required dynamic item,
  }) async {
    var db = await database;
    int result;
    try {
      result = await db.update(table, item.toMap(),
          where: 'id = ?',
          whereArgs: [id],
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw Exception('Some error$e');
    }
    return result;
  }

  // Delete Operation: Delete record from database
  Future<int> delete(String tableName, int id) async {
    var db = await database;
    int result = await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
    return result;
  }

// This creates tables in our database.
  Future<void> _onCreate(Database database, int version) async {
    final db = database;
    await db.execute("""
CREATE TABLE books (
  id INTEGER PRIMARY KEY AUTOINCREMENT,                          
  title     TEXT NOT NULL DEFAULT 'Unknown' COLLATE NOCASE,
  author_sort TEXT COLLATE NOCASE,
  path TEXT NOT NULL DEFAULT "");

 """);
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {
    db.execute("""
CREATE TABLE authors (
  id INTEGER PRIMARY KEY AUTOINCREMENT,                          
  name     TEXT NOT NULL DEFAULT 'Unknown' COLLATE NOCASE,
  sort TEXT COLLATE NOCASE
  "");

 """);
  }
}
