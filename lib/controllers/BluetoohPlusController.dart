import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rtv/class/Trama.dart';
import 'dart:async';

class BluetoothPlusController {
  final FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<ScanResult> scanResults = [];
  List<BluetoothService>? _services;
  BluetoothDevice? _connectedDevice;
  Timer? reconnectionTimer;

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
  Future<bool> connectDevice(
      BuildContext context, BluetoothDevice device) async {
    try {
      if (_connectedDevice != null && _connectedDevice == device) {
        return true;
      }

      await device.connect(
          autoConnect: true); // Desactivar la reconexión automática
      _services = await device.discoverServices();
      _connectedDevice = device;
      return true;
    } catch (e) {
      print("Error al conectar el dispositivo: $e");
      // Implementar lógica de reconexión aquí
      return false;
    }
  }

  //send trama
  Future<void> sendTrama(TramaType type) async {
    try {
      if (_services == null) {
        print('Error: No se han descubierto los servicios del dispositivo.');
        return;
      }
      if (_connectedDevice == null) {
        print('Error: No hay dispositivo conectado.');
        return;
      }

      List<int> trama = [];
      switch (type) {
        case TramaType.Encender:
          trama = [36, 49, 49, 49, 49, 49, 35];

          //mantener el dispositivo activo
          break;
        case TramaType.Apagar:
          trama = [36, 48, 48, 48, 48, 48, 35];
          break;
        case TramaType.STOP:
          trama = [36, 49, 120, 49, 120, 84, 35];
          break;
        case TramaType.MANUALIZ:
          trama = [36, 49, 77, 49, 49, 49, 120, 35];
          break;
        case TramaType.SUBIDA:
          trama = [36, 49, 77, 120, 49, 83, 35];
          break;
        case TramaType.BAJADA:
          trama = [36, 49, 77, 120, 49, 66, 35];
          break;
        case TramaType.IZQUIERDA:
          trama = [36, 49, 77, 120, 49, 73, 35];
          break;
        case TramaType.DERECHA:
          trama = [36, 49, 77, 120, 49, 68, 35];
          break;
        case TramaType.MANUALDE:
          trama = [36, 49, 77, 49, 50, 120, 35];
          break;
        case TramaType.SUBIDAD:
          trama = [36, 49, 77, 120, 50, 83, 35];
          break;
        case TramaType.BAJADAD:
          trama = [36, 49, 77, 120, 50, 66, 35];
          break;
        case TramaType.IZQUIERDAD:
          trama = [36, 49, 77, 120, 50, 73, 35];
          break;
        case TramaType.DERECHAD:
          trama = [36, 49, 77, 120, 50, 68, 35];
          break;
        case TramaType.AUTOMATICO:
          trama = [36, 49, 65, 49, 120, 120, 35];
          break;
        case TramaType.HORIZONTAL:
          trama = [36, 49, 65, 72, 120, 120, 35];
          break;
        case TramaType.VERTICAL:
          trama = [36, 49, 65, 86, 120, 120, 35];
          break;
        default:
          print('Tipo de trama no válido');
          return;
      }
      for (BluetoothService service in _services!) {
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          if (c.properties.write) {
            try {
              await c.write(trama);
              print('Trama enviada correctamente: $trama');
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

  Future<List<BluetoothDevice>> getBondedDevices() async {
    try {
      List<BluetoothDevice> bondedDevices =
          await FlutterBluePlus.connectedSystemDevices;
      return bondedDevices;
    } catch (e) {
      print('Error al obtener dispositivos vinculados: $e');
      return [];
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
      if (_connectedDevice != null) {
        await _connectedDevice!
            .disconnect(); // Desconecta el dispositivo almacenado
        _connectedDevice = null; // Establece _connectedDevice como null
      }
    } catch (e) {
      print('Error al enviar la trama: $e');
    }
  }

  Future<bool> isBluetoothAvailable() async {
    bool isAvailable = await FlutterBluePlus.isAvailable;
    return isAvailable;
  }
}
