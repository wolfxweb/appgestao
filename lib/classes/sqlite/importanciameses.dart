

import 'package:appgestao/classes/sqlite/dbhelper.dart';
import 'package:sqflite/sqflite.dart';

class InportanciasMeses{

  Future<Database?> get db => DatabaseHelper.getInstance().db;
  Future<int> save(dados) async {
    print(dados);
    var dbClient = await db;
    var id = await dbClient!.insert('importancia_meses', dados, conflictAlgorithm: ConflictAlgorithm.replace);
    print('id: $id');
    return 1;
  }

  Future<List<dynamic>> lista() async {
    final dbClient = await db;
    final list = await dbClient!.rawQuery('SELECT * FROM importancia_meses');
    return list;
  }

}


