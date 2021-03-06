import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final String columnId = "id";
final String columnTitle = "title";
final String columnDone = "done";
final String tableName = 'todo';

class Todo {
  int id;
  String title;
  bool done;

  Todo({
    this.id,
    this.title,
    this.done,
  });

  factory Todo.fromMap(Map<String, dynamic> json) => new Todo(
        id: json[columnId],
        title: json[columnTitle],
        done: json[columnDone] == 1,
      );

  Map<String, dynamic> toMap() => {
        columnTitle: title,
        columnDone: done == true ? 1 : 0,
      };
}

class TodoProvider {
  TodoProvider._();

  static final TodoProvider db = TodoProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "todo.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE $tableName ("
          "$columnId INTEGER PRIMARY KEY AUTOINCREMENT,"
          "$columnTitle TEXT,"
          "$columnDone INTEGER"
          ")");
    });
  }

  insertTodo(Todo todo) async {
    final db = await database;
    // var table =
    //     await db.rawQuery("SELECT MAX($columnId)+1 as $columnId FROM Subject");
    // int id = table.first[columnId];
    // var raw = await db.rawInsert(
    //     "INSERT Into Subject ($columnId,$columnTitle,$columnDone)"
    //     " VALUES (?,?,?)",
    //     [id, newSubject.title, newSubject.done]);
    // return raw;
    todo.id = await db.insert(tableName, todo.toMap());
    return todo;
  }

  doneOrUndone(Todo todo) async {
    final db = await database;
    Todo done =
        Todo(id: todo.id, title: todo.title, done: !todo.done);
    var res = await db.update(tableName, done.toMap(),
        where: "$columnId = ?", whereArgs: [todo.id]);
    return res;
  }

  Future<List<Todo>> getDoneTodo() async {
    final db = await database;

    // var res = await db.rawQuery("SELECT * FROM Subject WHERE done=1");
    var res = await db.query(tableName, where: "done = ? ", whereArgs: [1]);

    List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Todo>> getUnDoneTodo() async {
    final db = await database;

    // var res = await db.rawQuery("SELECT * FROM Subject WHERE done=1");
    var res = await db.query(tableName, where: "done = ? ", whereArgs: [0]);

    List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
    return list;
  }

  deleteDone() async {
    final db = await database;
    db.rawDelete("Delete from $tableName where $columnDone = 1");
  }

  // ------------------- UN USE METHOD -------------------

  // updateSubject(Subject newSubject) async {
  //   final db = await database;
  //   var res = await db.update(tableName, newSubject.toMap(),
  //       where: "$columnId = ?", whereArgs: [newSubject.id]);
  //   return res;
  // }

  // getSubject(int id) async {
  //   final db = await database;
  //   var res =
  //       await db.query(tableName, where: "$columnId = ?", whereArgs: [id]);
  //   return res.isNotEmpty ? Subject.fromMap(res.first) : null;
  // }

  // Future<List<Subject>> getAllSubjects() async {
  //   final db = await database;
  //   var res = await db.query(tableName);
  //   List<Subject> list =
  //       res.isNotEmpty ? res.map((c) => Subject.fromMap(c)).toList() : [];
  //   return list;
  // }

  // deleteSubject(int id) async {
  //   final db = await database;
  //   return db.delete(tableName, where: "$columnId = ?", whereArgs: [id]);
  // }
  
  // deleteAll() async {
  //   final db = await database;
  //   db.rawDelete("Delete from Subject");
  // }
}
