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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _showBondedDevices,
              child: const Text('Mostrar dispositivos vinculados'),
            ),
            ElevatedButton(
              onPressed: _bluetoothController.startScan,
              child: const Text('Iniciar escaneo'),
            ),
            Expanded(
              child: StreamBuilder<List<ScanResult>>(
                stream: _bluetoothController.getScanResultsStream(),
                initialData: [],
                builder: (c, snapshot) => _buildDeviceList(snapshot.data!),
              ),
            ),
            ElevatedButton(
              onPressed: _bluetoothController.stop,
              child: const Text('Detener escaneo'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBondedDevices() async {
    final List<BluetoothDevice> bondedDevices =
        await _bluetoothController.getBondedDevices();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dispositivos vinculados'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (BluetoothDevice device in bondedDevices)
                ListTile(
                  title: Text(
                      device.name.isNotEmpty ? device.name : "Desconocido"),
                  subtitle: Text(device.id.toString()),
                  onTap: () {
                    // Puedes agregar lógica para conectar con el dispositivo cuando se haga clic en él
                  },
                ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  ListView _buildDeviceList(List<ScanResult> scanResults) {
    return ListView.builder(
      itemCount: scanResults.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _connectToDevice(context, scanResults[index].device),
          child: ListTile(
            title: Text(scanResults[index].device.name),
            subtitle: Text('RSSI: ${scanResults[index].rssi}'),
            trailing: ElevatedButton(
              onPressed: () =>
                  _connectToDevice(context, scanResults[index].device),
              child: Text('Conectar'),
            ),
          ),
        );
      },
    );
  }

  void _showDeviceNameDialog(
      BuildContext context, String deviceName, BluetoothDevice device) {
    showDialog(
      //create connection device
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conectar con $deviceName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                  '¿Estás seguro de que quieres enviar datos a este dispositivo?'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _bluetoothController.disconnectDevice(device);
                    },
                    child: const Text('Desconectar'),
                  ),
                 ElevatedButton(
  onPressed: () {
    _bluetoothController.sendTrama(TramaType.Enviar);
  },
  child: const Text('Enviar'),
),

ElevatedButton(
  onPressed: () {
    _bluetoothController.sendTrama(TramaType.Apagar);
  },
  child: const Text('Apagar'),
),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

//funcion crear
  void _connectToDevice(BuildContext context, BluetoothDevice device) async {
    bool connected = await _bluetoothController.connectDevice(context, device);
    if (connected) {
      _showDeviceNameDialog(context, device.name, device);
    }
  }
}
