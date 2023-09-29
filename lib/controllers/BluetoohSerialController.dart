import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rtv/class/Trama.dart';
import 'dart:async';

class BluetoothSerialController {
  final FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  List<BluetoothDiscoveryResult> scanResults = [];

Future<void> initBluetooth() async {
  // Solicitar los permisos necesarios
  if (await Permission.bluetoothScan.request().isGranted &&
      await Permission.location.request().isGranted) {
    // Los permisos han sido concedidos
    await FlutterBluetoothSerial.instance.requestEnable();
  } else {
    // Los permisos han sido denegados
    throw Exception('No se han concedido los permisos necesarios');
  }
}


 Future<BluetoothConnection> connectToDevice(BuildContext context, device) async {
    BluetoothConnection connection = await BluetoothConnection.toAddress(device.device.address);
    return connection;
  }


 Future<void> disconnect(BluetoothConnection connection) async {
  await connection.close(); // Cierra la conexión pasada como argumento
}

 Future<void> sendTrama(BluetoothConnection connection, Trama trama) async {
    try {
      final bytes = trama.toBytes();
      connection.output.add(bytes);
      await connection.output.allSent;
    } catch (e) {
      print("Error al enviar la trama: $e");
    }
  }
  Future<List<BluetoothDevice>> getBondedDevices() async {
    final bondedDevices = await bluetooth.getBondedDevices();
    return bondedDevices;
  }
}