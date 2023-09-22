import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:rtv/controllers/BluetoohSerialController.dart';
import 'package:rtv/views/JostickControllerView.dart';

import '../class/BluetoohConnection.dart';

class BluetoothScreen extends StatefulWidget {
  
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  final _bluetoothController = BluetoothSerialController();
  List<bool> isSelected = [true, false];

  @override
  void initState() {
    super.initState();
    _bluetoothController.initBluetooth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<BluetoothDevice>>(
              stream: Stream.fromFuture(_bluetoothController.getBondedDevices()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final devices = snapshot.data!;
                  return ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final device = devices[index];
                      return Card(
                        // Usar un Card en lugar de un ListTile
                        child: ListTile(
                            leading: Icon(Icons
                                .bluetooth), // Agregar un icono de Bluetooth
                            title: Text(device.name ?? device.address),
                            subtitle: Text(device.address),
                            onTap: () {
                              _connectToDevice(
                                  context, device, device.name!);
                            }),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

 void _connectToDevice(BuildContext context, BluetoothDevice device,
      String deviceName) async {
    await BluetoothManager().connectToDevice(device);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JoystickControllerView(
          isConnected: true,
          deviceName: deviceName,
          connection: BluetoothManager().connection!,
        ),
      ),
    );
  }

}