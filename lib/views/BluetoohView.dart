import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rtv/controllers/BluetoohController.dart';

class BluetoothView extends StatefulWidget {
  const BluetoothView({Key? key}) : super(key: key);

  @override
  _BluetoothViewState createState() => _BluetoothViewState();
}

class _BluetoothViewState extends State<BluetoothView> {
  final BluetoohController bluetoothController = BluetoohController();
    List<ScanResult> scanResults = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Bluetooth',
            ),
            ElevatedButton(
              onPressed: () async{
                 await bluetoothController.startScan();
                  setState(() {
        scanResults = bluetoothController.scanResults;
    } );
              },
              child: const Text('Scan Bluetooth Devices'),
            ),
          ],
        ),
      ),
    );
  }
}
