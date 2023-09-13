import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rtv/class/Trama.dart';

class BluetoohController {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResults = [];
  List<BluetoothService>? _services;
  BluetoothDevice? _connectedDevice;

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
      scanResults.clear(); 
    }
  }

  Future<void> stop() async {
    flutterBlue.stopScan();
  }
Future<BluetoothDevice?> connectDevice2(BluetoothDevice device) async {
  try {
    if (device.state == BluetoothDeviceState.connected) {
      return device;
    }

    await device.connect(autoConnect: false); // Desactivar la reconexión automática
    List<BluetoothService> services = await device.discoverServices();
    return device;
  } catch (e) {
    print("Error al conectar el dispositivo: $e");
    // Implementar lógica de reconexión aquí
    return null;
  }
}

  Future<void> sendTrama(TramaType type) async {
    try {
      if (_services == null) {
        print('Error: No se han descubierto los servicios del dispositivo.');
        return;
      }
      List<int> trama = [];
        switch (type) {
          case TramaType.Encender:
            trama = [36, 49, 49, 49, 49, 49, 35];
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
  
        await c.write(trama);
     
    }
}
  } catch (e) {
    print('Error al enviar la trama: $e');
  }
  }

Future<void> writeDataToDevice(BluetoothDevice device, List<int> data) async {
  try {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          await characteristic.write(data);
          print('Trama escrita con éxito en el dispositivo');
          return;
        }
      }
    }
    print('No se encontró una característica de escritura en el dispositivo');
  } catch (e) {
    print('Error al escribir en el dispositivo: $e');
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
  Future<void> disconnectDevice(BluetoothDevice device, TramaType type) async {
    List<int> tramaOff;
    try {
      if (type == TramaType.Apagar) {
        await sendTrama(TramaType.Apagar);
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
      await _connectedDevice!.disconnect(); // Desconecta el dispositivo almacenado
      _connectedDevice = null; // Establece _connectedDevice como null
    }
    } catch (e) {
      print('Error al desconectar el dispositivo: $e');
    }
  }

  // Verificar si el dispositivo está conectado
  bool isConnected(BluetoothDevice device) {
    return device.state == BluetoothDeviceState.connected;
  }
}
