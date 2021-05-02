import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:qr_reader/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String tipoSeleccionado = 'http';

  Future<ScanModel> nuevoScan(String valor) async {
    final nuevoScan = new ScanModel(valor: valor);
    final id = await DBProvider.db.nuevoScan(nuevoScan);
    // Asignar el ID de la base de datos al modelo
    nuevoScan.id = id;

    if (this.tipoSeleccionado == nuevoScan.tipo) {
      this.scans.add(nuevoScan);
    }

    notifyListeners();
    return nuevoScan;
  }

  cargarScans() async {
    final scans = await DBProvider.db.getTodosLosScans();
    this.scans = [...scans]; //Crear un nuevo lista
    notifyListeners(); //Para que actualizaer la pantalla
  }

  cargarScansPorTipo(String tipo) async {
    final scans = await DBProvider.db.getScanPorTipo(tipo);
    this.scans = [...scans]; //Crear un nuevo lista
    notifyListeners(); //Para que actualizaer la pantalla
  }

  borrarTodos() async {
    await DBProvider.db.deleteAllScans();
    this.scans = [];
    notifyListeners();
  }

  borrarScanPorId(int id) async {
    await DBProvider.db.deleteScan(id);
  }
}
