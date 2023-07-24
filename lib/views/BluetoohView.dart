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
      appBar: AppBar(
        title: const Text('Bluetooth'),
      ),
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
            ElevatedButton(
              onPressed: _bluetoothController.stop,
              child: const Text('Detener escaneo'),
            ),
            ElevatedButton(
              onPressed: () => _bluetoothController.connectDevice(context),
              child: const Text('Conectar dispositivo'),
            ),
            ElevatedButton(
              onPressed: _bluetoothController.sendData,
              child: const Text('Enviar datos'),
            ),
            Expanded(
              child: FutureBuilder<List<BluetoothDevice>>(
                future: _bluetoothController.getBondedDevices(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Muestra un indicador de carga mientras espera los datos.
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final List<BluetoothDevice> bondedDevices = snapshot.data!;
                    return ListView.builder(
                      itemCount: bondedDevices.length,
                      itemBuilder: (BuildContext context, int index) {
                        final BluetoothDevice device = bondedDevices[index];
                        return ListTile(
                          title: Text(device.name.isNotEmpty
                              ? device.name
                              : "Desconocido"),
                          subtitle: Text(device.id.toString()),
                          onTap: () {
                            // Puedes agregar lógica para conectar con el dispositivo cuando se haga clic en él
                          },
                        );
                      },
                    );
                  }
                },
              ),
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
                  title: Text(device.name.isNotEmpty
                      ? device.name
                      : "Desconocido"),
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

}
