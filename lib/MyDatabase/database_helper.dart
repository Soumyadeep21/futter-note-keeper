import 'dart:io';
import 'package:note_keeper_flutter/Model/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{

  static Database _database;
  static DatabaseHelper _databaseHelper;
  String colTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if(_databaseHelper == null)
      _databaseHelper = DatabaseHelper._createInstance();
    return _databaseHelper;
  }

  Future<Database> get database async{
    if(_database == null)
      _database = await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    var notesDatabase = await openDatabase(path,version: 1,onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db , int newVersion) async{
    await db.execute(
        'CREATE TABLE $colTable('
        '$colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT,$colDescription TEXT,$colPriority INTEGER,$colDate TEXT)'
    );
  }

  Future<List<Map<String, dynamic>>> getNoteListMap() async{
    Database db = await this.database;
    var result = db.query(colTable,orderBy: '$colPriority ASC');
    return result;
  }

  Future<int> insertNote(Note note) async{
    Database db = await this.database;
    var result = db.insert(colTable, note.toMap());
    print(note.date);
    return result;
  }

  Future<int> updateNote(Note note) async{
    Database db = await this.database;
    var result = db.update(colTable, note.toMap(),where: '$colId = ?',whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(Note note) async{
    Database db = await this.database;
    var result = db.delete(colTable,where: '$colId = ?',whereArgs: [note.id]);
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $colTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Note>> getNoteList() async{
    var noteMapList = await getNoteListMap();
    List<Note> noteList = List<Note>();
    for(int i = 0; i < noteMapList.length; i++)
      noteList.add(Note.fromMapObject(noteMapList[i]));
    return noteList;
  }

}