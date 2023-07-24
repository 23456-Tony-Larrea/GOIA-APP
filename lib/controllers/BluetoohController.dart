import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoohController {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResults = [];

  Stream<List<ScanResult>> getScanResultsStream() {
    return flutterBlue.scanResults;
  }

  Future<void> startScan() async {
    print("di click");
    if (await Permission.location.request().isGranted) {
      print("Permiso de ubicación otorgado");
      flutterBlue.startScan(timeout: const Duration(seconds: 10));
      //print device scanner
      flutterBlue.scanResults.listen((results) {
        for (ScanResult r in results) {
          print('${r.device.name} found! rssi: ${r.rssi}');
          scanResults.add(r);
        }
      }
      );
    } else {
      print("Permiso de ubicación denegado");
    }
  }

  Future<void> stop() async {
    flutterBlue.stopScan();
  }

  Future<bool> connectDevice(BuildContext context) async {
    for (ScanResult r in scanResults) {
      if (r.device.name == 'Dual-SPP') {
        await r.device.connect();
        // Mostrar un AlertDialog solo si el dispositivo se conecta correctamente
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Conexión exitosa'),
              content:
                  const Text('El dispositivo se ha conectado exitosamente.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return true; // Indica que el dispositivo se ha conectado correctamente
      }
    }
    return false; // Indica que no se encontró el dispositivo Dual-SPP
  }

  Future<void> sendData() async {
    for (ScanResult r in scanResults) {
      if (r.device.name == 'Dual-SPP') {
        await r.device.connect();
        List<BluetoothService> services = await r.device.discoverServices();
        for (BluetoothService service in services) {
          if (service.uuid.toString() ==
              '49535343-fe7d-4ae5-8fa9-9fafd205e455') {
            List<BluetoothCharacteristic> characteristics =
                service.characteristics;
            for (BluetoothCharacteristic c in characteristics) {
              if (c.uuid.toString() == '49535343-026e-3a9b-954c-97daef17e26e') {
                await c.write([36, 49, 49, 49, 49, 49, 35]);
              }
            }
          }
        }
      }
    }
  }

  Future<List<BluetoothDevice>> getBondedDevices() async {
    try {
      List<BluetoothDevice> bondedDevices = await flutterBlue.connectedDevices;
      print("Dispositivos vinculados encontrados: $bondedDevices");
      return bondedDevices;
    } catch (e) {
      print("Error al obtener dispositivos vinculados: $e");
      return [];
    }
  }
}
