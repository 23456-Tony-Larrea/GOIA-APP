import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:rtv/controllers/BluetoohSerialController.dart';
/* import 'package:rtv/views/Holguras/HolgurasConnectView.dart';
 */import 'package:rtv/views/JostickControllerView.dart';

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
            child: StreamBuilder<List<BluetoothDiscoveryResult>>(
              stream: _bluetoothController.getScanResultsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final results = snapshot.data!;
                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final device = results[index].device;
                      return Card(
                        // Usar un Card en lugar de un ListTile
                        child: ListTile(
                            leading: Icon(Icons
                                .bluetooth), // Agregar un icono de Bluetooth
                            title: Text(device.name ?? device.address),
                            subtitle: Text(device.address),
                            onTap: () {
                              _connectToDevice(
                                  context, results[index], device.name!);
                                /*  _connectToDevice2(
                                  context, results[index], device.name!);   */
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

  void _connectToDevice(BuildContext context, BluetoothDiscoveryResult device,
      String deviceName) async {
    BluetoothConnection connection = await _bluetoothController.connectToDevice(
        context, device) as BluetoothConnection;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JoystickControllerView(
          isConnected: true,
          deviceName: deviceName,
          connection: connection,
        ),
      ),
    );
  }
 /* void _connectToDevice2(BuildContext context, BluetoothDiscoveryResult device,
      String deviceName) async {
    BluetoothConnection connection = await _bluetoothController.connectToDevice(
        context, device) as BluetoothConnection;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HolgurasConnectView(
          isConnected: true,
          deviceName: deviceName,
          connection: connection,
        ),
      ),
    );
  } */
}
