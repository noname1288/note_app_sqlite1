import 'package:note_app_1/model/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  /* List<NoteModel> notes = [
    NoteModel(1, null, title: 'Note 1', content: 'Content 1', createAt: '2021/10/10'),
    NoteModel(2, null, title: 'Note 2', content: 'Content 2', createAt: '2021/10/11'),
    NoteModel(3, '2021/10/15', title: 'Note 3', content: 'Content 3', createAt: '2021/10/12'),
    NoteModel(4, '2021/10/19', title: 'Note 4', content: 'Content 4', createAt: '2021/10/13'),
    NoteModel(5, '2021/10/14', title: 'Note 5', content: 'Content 5', createAt: '2021/10/14'),
    NoteModel(6, null, title: 'Note 6', content: 'Content 1', createAt: '2021/10/10'),
    NoteModel(7, null, title: 'Note 7', content: 'Content 2', createAt: '2021/10/11'),
    NoteModel(8, '2021/10/15', title: 'Note 8', content: 'Content 3', createAt: '2021/10/12'),
    NoteModel(9, '2021/10/19', title: 'Note 9', content: 'Content 4', createAt: '2021/10/13'),
    NoteModel(10, '2021/10/14', title: 'Note 10', content: 'Content 5', createAt: '2021/10/14'),
    NoteModel(1, null, title: 'Note 1', content: 'Content 1', createAt: '2021/10/10'),
    NoteModel(2, null, title: 'Note 2', content: 'Content 2', createAt: '2021/10/11'),
    NoteModel(3, '2021/10/15', title: 'Note 3', content: 'Content 3', createAt: '2021/10/12'),
    NoteModel(4, '2021/10/19', title: 'Note 4', content: 'Content 4', createAt: '2021/10/13'),
    NoteModel(5, '2021/10/14', title: 'Note 5', content: 'Content 5', createAt: '2021/10/14'),
    NoteModel(6, null, title: 'Note 6', content: 'Content 1', createAt: '2021/10/10'),
    NoteModel(7, null, title: 'Note 7', content: 'Content 2', createAt: '2021/10/11'),
    NoteModel(8, '2021/10/15', title: 'Note 8', content: 'Content 3', createAt: '2021/10/12'),
    NoteModel(9, '2021/10/19', title: 'Note 9', content: 'Content 4', createAt: '2021/10/13'),
    NoteModel(10, '2021/10/14', title: 'Note 10', content: 'Content 5', createAt: '2021/10/14'),
  ];*/

  //Singleton pattern
  static final DatabaseService _databaseService = DatabaseService._internal();
  factory DatabaseService() => _databaseService;
  DatabaseService._internal();

  //init database
  static Database? _database;
  final tableName = 'Notes';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, tableName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''     CREATE TABLE $tableName (
       id INTEGER PRIMARY KEY autoincrement,
       title TEXT,
       content TEXT,
        createAt TEXT,
        updateAt TEXT)''');
  }

  //get list of notes from the {note} table
  Future<List<NoteModel>> getAllNote() async {
    final db = await _databaseService.database;
    final notes = await db.query(tableName);
    return notes.map((note) => NoteModel.fromMap(note)).toList();
  }

  //insert a note to the {note} table
  Future<int> insertNote(NoteModel note) async {
    final db = await _databaseService.database;
    return await db.insert(
      tableName,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //delete a note from the {note} table
  Future<void> deleteNote({required int id}) async {
    final db = await _databaseService.database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //update a note in the {note} table
  Future<void> updateNote(NoteModel note) async {
    final db = await _databaseService.database;
    await db.update(tableName, note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.rollback);
  }
/*
  //fetch a necessary note from the {note} table
  Future<NoteModel> fetchNote ({required int id}) async{
    final db = await _databaseService.database;
    final note = await db.query(
     ' SELECT * FROM $tableName WHERE id = ?'
    );// this query will return a list of notes
    return NoteModel.fromMap(note.first);
  }*/

  // fetch all notes from the {note} table
  Future<List<NoteModel>> fetchAllNotes() async {
    final db = await _databaseService.database;
    final notes = await db.rawQuery(
        'SELECT * FROM $tableName ORDER BY createAt, updateAt DESC'); //this query will return all of notes
    return notes.map((note) => NoteModel.fromSqliteDatabase(note)).toList();
  }

  Future<List<NoteModel>> searchNote(String word) async {
    final db = await _databaseService.database;
    final searchingNotes = await db.query('''
     $tableName WHERE title LIKE '%$word%'
      ''');
    return searchingNotes
        .map((note) => NoteModel.fromSqliteDatabase(note))
        .toList();
  }
}
