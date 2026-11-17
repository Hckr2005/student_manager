import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/student.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('students.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        studentCode TEXT NOT NULL,
        email TEXT NOT NULL,
        avatar TEXT NOT NULL
      )
    ''');
  }

  // CREATE: Thêm sinh viên mới
  Future<int> insertStudent(Student student) async {
    final db = await instance.database;
    return await db.insert('students', student.toMap());
  }

  // READ: Lấy danh sách toàn bộ sinh viên
  Future<List<Student>> getAllStudents() async {
    final db = await instance.database;
    final result = await db.query('students', orderBy: 'id DESC');
    return result.map((json) => Student.fromMap(json)).toList();
  }

  // UPDATE: Cập nhật thông tin sinh viên
  Future<int> updateStudent(Student student) async {
    final db = await instance.database;
    return await db.update(
      'students',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );
  }

  // DELETE: Xóa sinh viên theo ID
  Future<int> deleteStudent(int id) async {
    final db = await instance.database;
    return await db.delete(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}