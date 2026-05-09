import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/trip.dart';

class TripDatabase {
  static final TripDatabase instance = TripDatabase._init();

  static Database? _database;

  TripDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('my_trips.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final databasesDirectory = await getDatabasesPath();
    final path = join(databasesDirectory, fileName);
    return openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE my_trips (
        id $idType,
        location $textType,
        date $textType,
        timeFrom $textType,
        timeTo $textType,
        travelers $intType,
        fee $realType,
        language $textType,
        attractions $textType,
        status $textType,
        createdAt $textType,
        isDeleted $intType
      )
    ''');
  }

  Future<Trip> create(Trip trip) async {
    final db = await instance.database;
    final id = await db.insert('my_trips', trip.toMap());
    return trip.copyWith(id: id);
  }

  Future<Trip?> readTrip(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'my_trips',
      columns: [
        'id',
        'location',
        'date',
        'timeFrom',
        'timeTo',
        'travelers',
        'fee',
        'language',
        'attractions',
        'status',
        'createdAt',
        'isDeleted'
      ],
      where: 'id = ? AND isDeleted = 0',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Trip.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Trip>> readAllTrips() async {
    final db = await instance.database;
    final result = await db.query(
      'my_trips',
      where: 'isDeleted = ?',
      whereArgs: [0],
      orderBy: 'createdAt DESC',
    );
    return result.map((json) => Trip.fromMap(json)).toList();
  }

  Future<int> update(Trip trip) async {
    final db = await instance.database;
    return db.update(
      'my_trips',
      trip.toMap(),
      where: 'id = ?',
      whereArgs: [trip.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return db.update(
      'my_trips',
      {'isDeleted': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    await db.close();
  }
}
