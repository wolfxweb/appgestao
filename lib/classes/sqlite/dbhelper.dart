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
    if (_db != null) {      return _db; }
    _db = await _initDb();
    return _db ;
  }

  Future _initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'appGestao.db');
    print("init");
    var db = await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    print("init");
    if (db != null) {
      int version = await db.getVersion();
      print('Versão atual do banco de dados: $version');
    } else {
      print('Erro ao abrir o banco de dados');
    }
    return db;
  }
  void _onCreate(Database db, int newVersion) async {
    print("init creata");
    String s = await rootBundle.loadString("assets/sql/create.sql");

    List<String> sqls = s.split(";");

    for(String sql in sqls) {
      if(sql.trim().isNotEmpty) {
        print("sql: $sql");
        await db.execute(sql);
      }
    }
    print("initsadas");
    if (db != null) {
      int version = await db.getVersion();
      print('Versão atual do banco de dados: $version');
    } else {
      print('Erro ao abrir o banco de dados');
    }

  }

  Future<FutureOr<void>> _onUpgrade(Database db, int oldVersion, int newVersion) async {
   // print("_onUpgrade: oldVersion: $oldVersion > newVersion: $newVersion");

    if (db != null) {
      int version = await db.getVersion();
      print('Versão atual do banco de dados: $version');
    } else {
      print('Erro ao abrir o banco de dados');
    }
    try {
        await db.execute("ALTER TABLE dados_basiscos ADD COLUMN data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP");
        await db.execute("ALTER TABLE dados_basiscos ADD COLUMN dados_basicos_atual TEXT DEFAULT 'S'");
        await db.execute("ALTER TABLE dados_basiscos ADD COLUMN capacidade_atendimento TEXT DEFAULT '0'");
      } catch (e) {
        print('Erro ao atualizar o banco de dados: $e');
      }
  }

  Future close() async {
    var dbClient = await db;
    return dbClient?.close();
  }
}