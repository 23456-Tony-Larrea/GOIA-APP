import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  return WillPopScope(
    onWillPop: () async {
      Navigator.pushReplacementNamed(context, '/holguras');
      return false; // Cambia esto a true si deseas permitir la navegación de retroceso nativa.
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth'),
        //desactivar el atras
        automaticallyImplyLeading:false,
         leading: IconButton(
          icon: Icon(Icons.arrow_back), // Icono de navegación personalizado
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/holguras'); // Navegar a la ruta /holguras
          },
        ),
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
    ),
    );
  }

void _connectToDevice(BuildContext context, BluetoothDevice device,
      String deviceName) async {
    if (BluetoothManager().isConnected) {
      // Si ya hay una conexión abierta, muestra un diálogo de confirmación antes de desconectar
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tu dispositivo $deviceName sigue conectado'),
            content: Text('¿Quieres desconectarlo y volver a conectarte?'),
            actions: [
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Desconectar'),
                onPressed: () async {
                  await BluetoothManager().disconnect();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
        
      );
    Fluttertoast.showToast(
    msg: 'Presiona dos veces para desconectar',
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.orange,
    textColor: Colors.white,
    fontSize: 16.0,
  );  
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Conectando al dispositivo $deviceName...',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      );

      await Future.delayed(Duration(seconds: 2));

      await BluetoothManager().connectToDevice(device);

      Navigator.pop(context);

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


}