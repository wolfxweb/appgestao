import 'package:appgestao/classes/sqlite/dbhelper.dart';
import 'package:sqflite/sqflite.dart';

class DadosBasicosSqlite {
  Future<Database?> get db => DatabaseHelper.getInstance().db;

  Future<int> save(dados) async {
   //  print('dados save');
   //  print(dados);
    var dbClient = await db;
    try {
      bool columnExists1 = await _isColumnExists(dbClient!, 'dados_basiscos', 'data_cadastro');
      bool columnExists2 = await _isColumnExists(dbClient!, 'dados_basiscos', 'dados_basicos_atual');
      bool columnExists3 = await _isColumnExists(dbClient!, 'dados_basiscos', 'capacidade_atendimento');

      if (!columnExists1) {
        // Adiciona a coluna com um valor padrão constante
        await dbClient!.execute("ALTER TABLE dados_basiscos ADD COLUMN data_cadastro TIMESTAMP DEFAULT NULL");

        var data_cadastro = DateTime.now().toIso8601String();
        await dbClient!.execute("UPDATE dados_basiscos SET data_cadastro = ${data_cadastro} WHERE data_cadastro IS NULL");
      }
      if (!columnExists2) {
        await dbClient!.execute("ALTER TABLE dados_basiscos ADD COLUMN dados_basicos_atual TEXT DEFAULT 'S'");
      }
      if (!columnExists3) {
        await dbClient!.execute("ALTER TABLE dados_basiscos ADD COLUMN capacidade_atendimento TEXT DEFAULT '0'");
      }
      List<Map<String, dynamic>> resultados = await dbClient.rawQuery(
          "SELECT COUNT(*) as qtd FROM dados_basiscos"
      );

      int quantidade = resultados.isNotEmpty ? resultados.first['qtd'] as int : 0;
      if (quantidade > 0) {
       // await dbClient!.execute("DELETE FROM dados_basiscos WHERE id = 1");
        await dbClient!.execute("UPDATE dados_basiscos SET dados_basicos_atual = 'N' WHERE dados_basicos_atual ='S'");
      }

      var id = await dbClient!.insert('dados_basiscos', dados, conflictAlgorithm: ConflictAlgorithm.replace);
    //  await dbClient!.execute("UPDATE dados_basiscos SET dados_basicos_atual = 'S' WHERE id = ' ${id}' ");
      final list = await dbClient!.rawQuery("SELECT  * FROM dados_basiscos  ");

    } catch (e) {
      print('Erro ao atualizar o banco de dados: $e');
    }



    return 1;
  }

  Future<bool> _isColumnExists(Database db, String table, String column) async {
    List<Map<String, dynamic>> columns =
        await db.rawQuery("PRAGMA table_info($table)");
    for (Map<String, dynamic> columnInfo in columns) {
      String columnName = columnInfo['name'];
      if (columnName == column) {
        return true;
      }
    }
    return false;
  }


  Future<List<dynamic>> getDadosBasicoAtual() async {
    final dbClient = await db;
    final list = await dbClient!.rawQuery("SELECT  * FROM dados_basiscos where dados_basicos_atual = 'S' ");
   // final list = await dbClient!.rawQuery("SELECT  * FROM dados_basiscos  ");

    print(list);
    return list;
  }
  Future<List<dynamic>> lista() async {
    final dbClient = await db;
    final list = await dbClient!.rawQuery("SELECT  * FROM dados_basiscos where 1=1 order by dados_basicos_atual desc  ");
    print(list);
    return list;
  }
  Future<List<dynamic>> listaTodos() async {
    final dbClient = await db;
    final list = await dbClient!.rawQuery("SELECT  * FROM dados_basiscos  ");
    print(list);
    return list;
  }

  Future<void> deleteDadosBasicos(id) async {
    try{
      final dbClient = await db;
      print('deleteDadosBasicos');
      print(id);
      await dbClient!.execute("DELETE FROM dados_basiscos WHERE id = ${id} ");
      await dbClient!.execute("UPDATE dados_basiscos SET dados_basicos_atual = 'S' WHERE id = (SELECT  id FROM dados_basiscos where 1=1 limit 1 )");
      final list = await dbClient!.rawQuery("SELECT  * FROM dados_basiscos ");

      print(list);
      return id;
    }catch (e) {
      print('Erro ao atualizar o banco de dados: $e');
      return id;
    }
  }
 // reutilizar
  Future<List<dynamic>> reutilizar(id) async {
    final dbClient = await db;
    await dbClient!.execute("UPDATE dados_basiscos SET dados_basicos_atual = 'N' WHERE dados_basicos_atual ='S'");
    await dbClient!.execute("UPDATE dados_basiscos SET dados_basicos_atual = 'S' WHERE id = ' ${id}' ");
    final list = await dbClient!.rawQuery("SELECT  * FROM dados_basiscos  ");
    print('reutilizar');
    print(id);
    print('list');
    print(list);
    return list;
  }
}

