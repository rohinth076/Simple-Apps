import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:take_notes/models/note.dart';

class DatabaseHelper{
  static DatabaseHelper _databaseHelper;
  static Database _database;
  DatabaseHelper.createInstance();
  factory DatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper.createInstance();
    }
    return _databaseHelper;
  }
  String noteTable = 'notes_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';

  Future<Database> get database async{
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }
  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path+"notes";

    var database = await openDatabase(path,version: 1,onCreate: _createDb);
    return database;
  }
  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colDescription TEXT, $colDate TEXT)');
  }
  Future<int> insertNote(Note note)async{
    Database db = await this.database;
    var l = await db.insert(noteTable,note.toMap());
    return l;
  }

  Future<int> updateNote(Note note)async{
    Database db = await this.database;
    var l = await db.update(noteTable,note.toMap(),where: '$colId =?',whereArgs: [note.id]);
    return l;
  }

  Future<int> deleteNote(int id)async{
    Database db =await this.database;
    var l = await db.rawDelete("Delete from $noteTable where $colId=?",[id]);
    return l;
  }

  Future<int> getCount() async{
    Database db = await this.database;
    var x = await db.rawQuery('Select Count(*) from $noteTable');
    int ans = Sqflite.firstIntValue(x);
    return ans;
  }



  Future<List<Note>> getNoteList() async{
    Database db = await this.database;
    var result = await db.query(noteTable);

    List<Note> list = List<Note>();
    int n = await getCount();
    for(int i=0;i<n;i++){
      list.add(Note.toObject(result[i]));
    }
    return list;
  }




}