
import 'dart:async';
import 'package:appgestao/classes/sqlite/dbhelper.dart';
import 'package:sqflite/sqflite.dart';

class CalculadoraSqlite{

  Future<Database?> get db => DatabaseHelper.getInstance().db;
  Future<int> save(dados) async {
    print(dados);
    var dbClient = await db;
    var id = await dbClient!.insert('calculadora_historico', dados, conflictAlgorithm: ConflictAlgorithm.replace);
    print('id: $id');
    return 1;
  }

  Future<List<dynamic>> lista() async {
    final dbClient = await db;
    final list = await dbClient!.rawQuery('SELECT * FROM calculadora_historico ORDER by id DESC');
    return list;
  }
  Future<List<dynamic>> delete(id) async {
    final dbClient = await db;
    return await dbClient!.rawQuery('DELETE from calculadora_historico where id = $id ');
  }
}