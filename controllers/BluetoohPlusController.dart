import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rtv/class/Trama.dart';
import 'dart:async';

class BluetoothPlusController {
  final FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<ScanResult> scanResults = [];
  List<BluetoothService>? _services;

  Stream<List<ScanResult>>? getScanResultsStream() {
    return FlutterBluePlus.scanResults;
  }

  Future<void> startScan() async {
    if (await Permission.location.request().isGranted) {
      print("Permiso de ubicación otorgado");
      scanResults.clear(); // Limpiar resultados anteriores
      try {
        await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
      } catch (e) {
        print("Error al iniciar el escaneo: $e");
      }
    } else {
      print("Permiso de ubicación denegado");
    }
    if (await Permission.bluetoothScan.request().isGranted) {
      print("Bluetooh otorgado");
      scanResults.clear();
    }
  }

  Future<void> stop() async {
    FlutterBluePlus.stopScan();
  }

  //conectar device
  Future<BluetoothDevice?> connectDevice(
      BuildContext context, BluetoothDevice device) async {
    try {
      if (device.connectionState == BluetoothBondState.bonded) {
        await device.connect(autoConnect: true);
      } else {
        await device.connect();
        await device.createBond();
      }
      _services = await device.discoverServices();
      return device;
    } catch (e) {
      print("Error al conectar el dispositivo: $e");
      // Implementar lógica de reconexión aquí
      return null;
    }
  }

  Future<void> sendTrama(TramaType tramaType) async {
    try {
      if (_services == null) {
        print('Error: No se han descubierto los servicios del dispositivo.');
        return;
      }

      Trama trama = Trama(tramaType);

      for (BluetoothService service in _services!) {
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          if (c.properties.write) {
            try {
              // Escribe la trama en la característica
              await c.write(trama.trama);
              print('Trama enviada correctamente: ${trama.trama}');
            } catch (e) {
              print('Error al escribir en la característica: $e');
            }
          }
        }
      }
    } catch (e) {
      print('Error al enviar la trama: $e');
    } finally {
      print('Trama enviada correctamente');
    }
  }

  Future<void> disconnectDevice(BluetoothDevice device, TramaType type) async {
    List<int> tramaOff;
    try {
      if (type == TramaType.Apagar) {
        for (BluetoothService service in _services!) {
          var characteristics = service.characteristics;
          for (BluetoothCharacteristic c in characteristics) {
            if (c.properties.write) {
              if (type == TramaType.Apagar) {
                tramaOff = [36, 48, 48, 48, 48, 48, 35];
                await c.write(tramaOff);
              }
            }
          }
        }
      }
      device.disconnect();
    } catch (e) {
      print('Error al enviar la trama: $e');
    }
  }
}
