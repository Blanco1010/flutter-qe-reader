import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';

class DBProvider {
  static Database _databases;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_databases != null) return _databases;

    _databases = await initDB();

    return _databases;
  }

  Future<Database> initDB() async {
    //Path de donde almacenaremos la bases de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    print(path);

    //crear base de datos

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Scans(id INTEGER PRIMARY KEY,tipo TEXT,valor TEXT)');
    });
  }

  Future<int> nuevoScanRaw(ScanModel nuevoScan) async {
    final id = nuevoScan.id;
    final tipo = nuevoScan.tipo;
    final valor = nuevoScan.valor;

    //Verificar la base de datos
    final db = await database;

    final res = await db.rawInsert(
        ' INSERT INTO Scans(id,tipo,valor) VALUES($id,${tipo.toString()},${valor.toString()})');
    return res;
  }

  Future<int> nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.insert('Scans', nuevoScan.toJson());
    print(res);
    //El ID del ultimo que se habia insertado
    return res;
  }

  Future<ScanModel> getScanById(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getTodosLosScans() async {
    final db = await database;
    final res = await db.query('Scans');

    return res.isNotEmpty
        ? res.map((element) => ScanModel.fromJson(element)).toList()
        : [];
  }

//----------------------PROBLEMA-----------------------
  // Future<ScanModel> getScanPorTipo(String cadena) async {
  //   final db = await database;
  //   final res = await db.rawQuery('SELECT * FROM Scans WHERE tipo = $cadena');

  //   return res.isNotEmpty ? ScanModel.fromJson(res.first) : [];
  // }

  Future<List<ScanModel>> getScanPorTipo(String cadena) async {
    final db = await database;
    final res = await db.query('Scans', where: 'tipo = ?', whereArgs: [cadena]);

    return res.isNotEmpty
        ? res.map((element) => ScanModel.fromJson(element)).toList()
        : [];
  }

  Future<int> updateScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.update('Scans', nuevoScan.toJson(),
        where: 'id=?', whereArgs: [nuevoScan.id]);
    return res;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id=?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Scans');
  }
}
