import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rtv/class/Trama.dart';
import 'dart:async';

class BluetoothSerialController {
  final FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  List<BluetoothDiscoveryResult> scanResults = [];
  StreamSubscription<BluetoothDiscoveryResult>? _scanSubscription;
  BluetoothConnection? _connection;
  

Stream<List<BluetoothDiscoveryResult>> getScanResultsStream() async* {
  final results = await bluetooth.startDiscovery().toList();
  yield results;
}

Future<void> initBluetooth() async {
    await bluetooth.requestEnable();
    await Permission.bluetooth.request();
  }
 Future<void> startScan() async {
  if (await Permission.location.request().isGranted &&
      await Permission.bluetoothScan.request().isGranted) {
      await bluetooth.requestEnable();
    _scanSubscription = bluetooth.startDiscovery().listen((result) {
      scanResults.add(result);
    });
  } else {
    print("Permisos denegados");
  }
}

  Future<void> stop() async {
    await _scanSubscription?.cancel();
  }

  Future<BluetoothDiscoveryResult?> connectToDevice( BuildContext context,BluetoothDiscoveryResult device) async {
    _connection = await BluetoothConnection.toAddress(device.device.address);
      return device;
  }

  Future<void> disconnect() async {
    await _connection?.close();
  }

  Future<void> sendTrama(Trama trama) async {
  try {
    final bytes = trama.toBytes();
    _connection?.output.add(bytes);
    await _connection?.output.allSent;
  } catch (e) {
    print("Error al enviar la trama: $e");
  }
}
}