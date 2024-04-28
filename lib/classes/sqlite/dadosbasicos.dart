




import 'package:appgestao/classes/sqlite/dbhelper.dart';
import 'package:sqflite/sqflite.dart';

class DadosBasicosSqlite{

  Future<Database?> get db => DatabaseHelper.getInstance().db;
  Future<int> save(dados) async {
   // print(dados);
   var dbClient = await db;
   var id = await dbClient!.insert('dados_basiscos', dados, conflictAlgorithm: ConflictAlgorithm.replace);
    print('id: $id');
    print(dados);
    return 1;
  }

  Future<List<dynamic>> lista() async {
    final dbClient = await db;
    final list = await dbClient!.rawQuery('SELECT  * FROM dados_basiscos ');
    print(list);
    return list;
  }

}

