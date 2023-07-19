import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoohController {
  FlutterBluePlus flutterBle = FlutterBluePlus.instance;
  List<ScanResult> scanResults = [];
  Stream<List<ScanResult>> get scanResultsStream => flutterBle.scanResults;

  Future<void> startScan() async {
    scanResults.clear();
    try{
      await flutterBle.startScan(timeout: Duration(seconds: 4));
    } catch (e) {
      print(e);
    }
  }
  void stopScan(){
    flutterBle.stopScan();
  }
}
