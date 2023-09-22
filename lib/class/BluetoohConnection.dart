import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:rtv/class/Trama.dart';

class BluetoothManager {
  static final BluetoothManager _instance = BluetoothManager._internal();
  BluetoothConnection? _connection;
  String? _connectedDeviceName;
  bool _isConnected = false;

  factory BluetoothManager() {
    return _instance;
  }

  BluetoothManager._internal();

  Future<void> connectToDevice(BluetoothDevice device) async {
    if (_connection != null) {
      // Si ya hay una conexión abierta, ciérrala antes de abrir una nueva
      await _connection!.close();
    }
    _connection = await BluetoothConnection.toAddress(device.address);
    _connectedDeviceName = device.name;
    _isConnected = true;
  }

  BluetoothConnection? get connection => _connection;

  String? get connectedDeviceName => _connectedDeviceName;

  bool get isConnected => _isConnected;

  void setConnectedDeviceName(String deviceName) {
    _connectedDeviceName = deviceName;
  }

  Future<void> disconnect() async {
    if (_connection != null) {
      await _connection!.close();
      _connection = null;
      _connectedDeviceName = null;
      _isConnected = false;
    }
  }
  Future<void> sendTrama(Trama trama) async {
    try {
      final bytes = trama.toBytes();
      _connection?.output.add(bytes);
      await connection?.output.allSent;
    } catch (e) {
      print("Error al enviar la trama: $e");
    }
  }
}