import 'dart:async';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.getInstance();
  DatabaseHelper.getInstance();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await _initDb();

    return _db ;
  }

  Future _initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'appGestao.db');
    print("db $path");

    var db = await openDatabase(path, version: 1, onCreate: _onCreate, onUpgrade: _onUpgrade);
    print("create");
    return db;
  }

  void _onCreate(Database db, int newVersion) async {

    String s = await rootBundle.loadString("assets/sql/create.sql");

    List<String> sqls = s.split(";");

    for(String sql in sqls) {
      if(sql.trim().isNotEmpty) {
        print("sql: $sql");
        await db.execute(sql);
      }
    }
   // print("_onUpgrade: oldVersion:  > newVersion: $newVersion");
    // Adicionar as colunas se a tabela existir
    bool columnExists = await _isColumnExists(db, 'dados_basiscos', 'capacidade_atendimento');

    if (!columnExists) {
      await db.execute("ALTER TABLE dados_basiscos ADD COLUMN capacidade_atendimento TEXT DEFAULT '0'");
    }
    columnExists = await _isColumnExists(db, 'dados_basiscos', 'dados_basicos_atual');
    if (!columnExists) {
      await db.execute("ALTER TABLE dados_basiscos ADD COLUMN dados_basicos_atual TEXT DEFAULT 'S'");
    }
    columnExists = await _isColumnExists(db, 'dados_basiscos', 'data_cadastro');
    if (!columnExists) {
      await db.execute("ALTER TABLE dados_basiscos ADD COLUMN data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP ");
    }
  }

  Future<FutureOr<void>> _onUpgrade(Database db, int oldVersion, int newVersion) async {
   // print("_onUpgrade: oldVersion: $oldVersion > newVersion: $newVersion");

    if(oldVersion == 1 && newVersion == 2) {
      await db.execute("ALTER TABLE dados_basiscos   ADD COLUMN data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP, ADD COLUMN dados_basicos_atual TEXT DEFAULT 'S', ADD COLUMN capacidade_atendimento TEXT DEFAULT '0'");
    }
  }

  Future<bool> _isColumnExists(Database db, String table, String column) async {
    List<Map<String, dynamic>> columns = await db.rawQuery("PRAGMA table_info($table)");
    for (Map<String, dynamic> columnInfo in columns) {
      String columnName = columnInfo['name'];
      if (columnName == column) {
        return true;
      }
    }
    return false;
  }



  Future close() async {
    var dbClient = await db;
    return dbClient?.close();
  }
}