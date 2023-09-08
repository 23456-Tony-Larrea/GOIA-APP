import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

enum TramaType {
  Encender,
  Apagar
}


class BluetoohController {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResults = [];
  List<BluetoothService>? _services;
  bool isDeviceOn = false;

  Stream<List<ScanResult>> getScanResultsStream() {
    return flutterBlue.scanResults;
  }

  Future<void> startScan() async {
    if (await Permission.location.request().isGranted) {
      print("Permiso de ubicación otorgado");
      scanResults.clear(); // Limpiar resultados anteriores
      try {
        await flutterBlue.startScan(timeout: const Duration(seconds: 10));
      } catch (e) {
        print("Error al iniciar el escaneo: $e");
      }
    } else {
      print("Permiso de ubicación denegado");
    }
    if (await Permission.bluetoothScan.request().isGranted) {
      print("Bluetooh otorgado");
      scanResults.clear(); // Limpiar resultados anteriores
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
      print("Error al conectar el dispositivo: $e");
      return false; // Indica que ha ocurrido un error al conectar el dispositivo
    }
  }

Future<void> sendTrama(TramaType type) async {
  
  try {
    if (_services == null) {
      print('Error: No se han descubierto los servicios del dispositivo.');
      return;
    }

    List<int> tramaOn;
    List<int> tramaOff;
    
    switch (type) {
      case TramaType.Encender:
        tramaOn = [36, 49, 49, 49, 49, 49, 35];
        tramaOff = []; // Inicializa tramaOff como una lista vacía en esta rama
        break;
      case TramaType.Apagar:
        tramaOn = []; // Inicializa tramaOn como una lista vacía en esta rama
        
        tramaOff = [36, 48, 48, 48, 48, 48, 35];
        break;
      default:
        print('Tipo de trama no válido');
        return;
    }

    for (BluetoothService service in _services!) {
      var characteristics = service.characteristics;
      for (BluetoothCharacteristic c in characteristics) {
        if (c.properties.write) {
          if (type == TramaType.Encender) {
            await c.write(tramaOn);
          } else if (type == TramaType.Apagar) {
            await c.write(tramaOff);
          }
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
      return bondedDevices;
    } catch (e) {
      print('Error al obtener dispositivos vinculados: $e');
      return [];
    }
  }

  // Desconectar dispositivo
  Future<void> disconnectDevice(BluetoothDevice device) async {
    try {
      await device.disconnect();
    } catch (e) {
      print('Error al desconectar el dispositivo: $e');
    }
  }

  // Verificar si el dispositivo está conectado
  bool isConnected(BluetoothDevice device) {
    return device.state == BluetoothDeviceState.connected;
  }
}
