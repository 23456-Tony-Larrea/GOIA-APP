import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:rtv/controllers/BluetoohController.dart';

class BluetoothView extends StatefulWidget {
  const BluetoothView({Key? key}) : super(key: key);

  @override
  _BluetoothViewState createState() => _BluetoothViewState();
}

class _BluetoothViewState extends State<BluetoothView> {
  final BluetoohController _bluetoothController = BluetoohController();
bool isBluetoothOn = false;

  @override
  void initState() {
    super.initState();
    _startScanning(); // Inicia el escaneo cuando la pantalla se carga
  }

  void _startScanning() async {
    final bluetoothState = await FlutterBlue.instance.state;
  setState(() {
    isBluetoothOn = bluetoothState == BluetoothState.on;
  });

  if (isBluetoothOn) {
    await _bluetoothController.startScan();
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<ScanResult>>(
              stream: _bluetoothController.getScanResultsStream(),
              initialData: [],
              builder: (c, snapshot) => _buildDeviceList(snapshot.data!),
            ),
          ),ElevatedButton(
  onPressed: () {
    _bluetoothController.startScan();
  },
  child: const Text('Escanear'),
),
],
      ),
    );
  }

  ListView _buildDeviceList(List<ScanResult> scanResults) {
    return ListView.builder(
      itemCount: scanResults.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _showDeviceNameDialog(context, scanResults[index].device.name, scanResults[index].device);
          },
          child: Card(
            elevation: 2.0,
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(Icons.bluetooth),
              title: Text(scanResults[index].device.name),
              subtitle: Text('RSSI: ${scanResults[index].rssi}'),
            ),
          ),
        );
      },
    );
  }



void _showDeviceNameDialog(BuildContext context, String deviceName, BluetoothDevice device) async {
  bool connected = await _bluetoothController.connectDevice(context, device);

  if (connected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conectado al dispositivo $deviceName.'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.power_settings_new), // Icono para encender
                    onPressed: () async {
                      await _bluetoothController.sendTrama(TramaType.Encender);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.power_off), // Icono para apagar
                    onPressed: () async {
                      await _bluetoothController.disconnectDevice(device);
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.power_off), // Icono para apagar
                    onPressed: () async {
                      await _bluetoothController.sendTrama(TramaType.Apagar);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  } else {
    // Mostrar mensaje de error
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error de conexión'),
          content: Text('No se pudo conectar al dispositivo $deviceName.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
}