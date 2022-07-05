




import 'package:appgestao/classes/sqlite/dbhelper.dart';
import 'package:sqflite/sqflite.dart';

class DadosBasicosSqlite{

  Future<Database?> get db => DatabaseHelper.getInstance().db;
  Future<int> save(dados) async {
    print(dados);
    var dbClient = await db;
  //  var id = await dbClient.insert(tableName, entity.toMap(),
  //      conflictAlgorithm: ConflictAlgorithm.replace);
//    print('id: $id');
    return 1;
  }

}

