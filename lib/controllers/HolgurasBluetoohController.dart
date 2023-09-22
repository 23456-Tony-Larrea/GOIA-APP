import 'package:rtv/class/BluetoohConnection.dart';
import 'package:rtv/class/Trama.dart';

class HolgurasBluetoothController {
  final BluetoothManager _bluetoothManager = BluetoothManager();

  void sendTrama(TramaType type) {
    final trama = Trama(type);
    _bluetoothManager.sendTrama(trama);
  }
}