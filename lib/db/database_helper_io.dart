import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/record.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('matooke_log.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE planting_records (
        id $idType,
        crop_name $textType,
        date $textType,
        quantity $realType,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE harvest_records (
        id $idType,
        crop_name $textType,
        date $textType,
        quantity $realType,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE sales_records (
        id $idType,
        crop_name $textType,
        date $textType,
        quantity $realType,
        notes TEXT
      )
    ''');
  }

  Future<int> createRecord(String table, Record rec) async {
    final db = await instance.database;
    return await db.insert(table, rec.toMap());
  }

  Future<List<Record>> readAllRecords(String table) async {
    final db = await instance.database;
    final orderBy = 'date DESC';
    final result = await db.query(table, orderBy: orderBy);
    return result.map((m) => Record.fromMap(m)).toList();
  }

  Future<int> updateRecord(String table, Record rec) async {
    final db = await instance.database;
    if (rec.id == null) return 0;
    return await db.update(
      table,
      rec.toMap(),
      where: 'id = ?',
      whereArgs: [rec.id],
    );
  }

  Future<int> deleteRecord(String table, int id) async {
    final db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<double> totalQuantity(String table) async {
    final db = await instance.database;
    final res = await db.rawQuery('SELECT SUM(quantity) as total FROM $table');
    final value = res.first['total'];
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    return value as double;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
