import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';



enum TramaType {
  Enviar,
  Apagar,
}

class BluetoohController {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResults = [];
  List<BluetoothService>? _services;
 
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
          scanResults.add(r);

          print('${r.device.name} encontrado! rssi: ${r.rssi}');
        }
      });
    } else {
      print("Permiso de ubicación denegado");
    }
  }

  Future<void> stop() async {
    flutterBlue.stopScan();
  }

  Future<bool> connectDevice(
      BuildContext context, BluetoothDevice device) async {
    try {
      await device.connect();

      _services = await device.discoverServices();
      return true; // Indica que el dispositivo se ha conectado correctamente
    } catch (e) {
      print('Error al conectar con el dispositivo: $e');
      return false; // Indica que ha ocurrido un error al conectar el dispositivo
    }
  }

 Future<void> sendTrama(TramaType type) async {
  try {
    if (_services == null) {
      print('Error: No se han descubierto los servicios del dispositivo.');
      return;
    }

    List<int> trama;

    switch (type) {
      case TramaType.Enviar:
        trama = [36, 49, 49, 49, 49, 49, 35];
        print('Enviando trama: [36, 49, 49, 49, 49, 49, 35]');
        break;
      case TramaType.Apagar:
        trama = [36, 48, 48, 48, 48, 48, 35];
        print('Enviando trama: [36, 48, 48, 48, 48, 48, 35]');
        break;
      default:
        print('Tipo de trama no válido');
        return;
    }

    for (BluetoothService service in _services!) {
      var characteristics = service.characteristics;
      // Obtener característica
      for (BluetoothCharacteristic c in characteristics) {
        if (c.properties.write) {
          await c.write(trama);
        }
      }
    }
  } catch (e) {
    print('Error al enviar la trama: $e');
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
 //disconnect device
  Future<void> disconnectDevice(BluetoothDevice device) async {
    try {
      await device.disconnect();
      print('Dispositivo desconectado');
    } catch (e) {
      print('Error al desconectar el dispositivo: $e');
    }
  }
}
