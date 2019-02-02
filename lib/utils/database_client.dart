import 'dart:async';
import 'dart:io';

import 'package:flutter_notodo/model/todo_item.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import './db_constants.dart' as constants;

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.constructor();

  DatabaseHelper.constructor();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDB();
    return _db;
  }

  initDB() async {
    Directory docDire = await getApplicationDocumentsDirectory();
    String path = join(docDire.path,constants.DB_NAME);

    var ourDB = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(constants.QUERY_CREATE_MAIN);
  }

  ///insert the values in DB
  Future<int> saveItem(ItemTodo user) async {
    var dbClient = await db;
    int res =
        await dbClient.insert(constants.TABLE_MAIN, user.toMap());
    return res;
  }

  ///Get all data
  Future<List> getItems() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery(constants.SELECT_ALL_MAIN);

    return result.toList();
  }

  ///Get selectedItems data
  Future<List> getItemsSpecific(int isDone) async {
    var dbClient = await db;
    var result =
    await dbClient.rawQuery('${constants.GET_SPECIFIC} $isDone');

    return result.toList();
  }

  /// get db entries count
  Future<int> getCount() async {
    var dbClient = await db;

    return Sqflite.firstIntValue(
        await dbClient.rawQuery(constants.SELECT_ALL_MAIN_COUNT));
  }

  ///Get specific data item
  Future<ItemTodo> getSingleItem(int id) async {
    var dbClient = await db;
    var result =
        await dbClient.rawQuery('${constants.GET_USER} $id');
    return result == null ? null : new ItemTodo.fromMap(result.first);
  }

  ///Delete item by id
  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient.delete(constants.TABLE_MAIN,
        where: '${constants.COL_ID} = ?', whereArgs: [id]);
  }

  ///Update an item
  Future<int> udpateItem(ItemTodo user) async {
    var dbClient = await db;
    return dbClient.update(constants.TABLE_MAIN, user.toMap(),
        where: '${constants.COL_ID} = ?', whereArgs: [user.id]);
  }

  ///Close DB
  Future closeDb() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
