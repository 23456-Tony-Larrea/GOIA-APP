import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:rtv/controllers/BluetoohController.dart';
import 'package:rtv/class/Trama.dart';

class BluetoothView extends StatefulWidget {
  const BluetoothView({Key? key}) : super(key: key);

  @override
  _BluetoothViewState createState() => _BluetoothViewState();
}

class _BluetoothViewState extends State<BluetoothView> {
  final BluetoohController _bluetoothController = BluetoohController();
  bool isBluetoothOn = false;
  String? modoSeleccionado = 'manual';

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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Bluetooh Apagado"),
            content: Text(
                "Asegurate que el Bluetooh este encendido. ¿Escanear nuevamente?"),
            actions: <Widget>[
              TextButton(
                child: Text('Refrescar'),
                onPressed: () {
                  Navigator.pop(context); // Cierra el diálogo actual
                  _bluetoothController.startScan();
                },
              ),
            ],
          );
        },
      );
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
            _showDeviceNameDialog(context, scanResults[index].device.name,
                scanResults[index].device);
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

  void _showDeviceNameDialog(
      BuildContext context, String deviceName, BluetoothDevice device) async {
   BluetoothDevice? connectedDevice = await _bluetoothController.connectDevice2(device);
  bool connected = connectedDevice != null;
     if (connected) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Conectado al dispositivo $deviceName'),
              ),
              body: SingleChildScrollView(
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Items a Considerar',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ToggleButtons(
                              children: [
                                Icon(Icons.lightbulb_outline),
                                Icon(Icons.lightbulb),
                              ],
                              onPressed: (int index) {
                                if (index == 0) {
                                  _bluetoothController.writeDataToDevice(device,[36, 49, 49, 49, 49, 49, 35]);
                                } else if (index == 1) {
                                  _bluetoothController.writeDataToDevice(device,[36, 48, 48, 48, 48, 48, 35]);
                                }
                              },
                              isSelected: [true, false],
                            ),
                          Card(
  elevation: 4, // Puedes ajustar la elevación según tus preferencias
  margin: EdgeInsets.all(16), // Ajusta el margen según tus preferencias
  child: Column(
    children: [
      Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Modo',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Radio(
            value: 'manual',
            groupValue: 'modo',
            onChanged: (value) {
              setState(() {
                modoSeleccionado = value;
              });
            },
          ),
          Text(
            'Manual',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Radio(
            value: 'automatico',
            groupValue: 'modo',
            onChanged: (value) {
              enviarTramaAsync(TramaType.AUTOMATICO);
            },
          ),
          Text(
            'Automático',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    ],
  ),
),
const SizedBox(height: 4),
Card(
  elevation: 4, // Ajusta la elevación según tus preferencias
  margin: EdgeInsets.all(16), // Ajusta el margen según tus preferencias
  child: Column(
    children: [
      Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Lados',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Radio(
            value: 'izquierda',
            groupValue: modoSeleccionado,
            onChanged: (value) {
              enviarTramaAsync(TramaType.MANUALIZ);
            },
          ),
          Text(
            'Izquierdo',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Radio(
            value: 'derecha',
            groupValue: modoSeleccionado,
            onChanged: (value) {
              enviarTramaAsync(TramaType.MANUALDE);
            },
          ),
          Text(
            'Derecho',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    ],
  ),
),

                          ],
                        ),
                      ),
                      const SizedBox(height:4),
Card(
  elevation: 4, // Ajusta la elevación según tus preferencias
  margin: EdgeInsets.all(16), // Ajusta el margen según tus preferencias
  child: Column(
    children: [
      Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Direcciones',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_upward),
            onPressed: () {
              _bluetoothController.sendTrama(TramaType.SUBIDA);
              _bluetoothController.sendTrama(TramaType.SUBIDAD);
            },
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              _bluetoothController.sendTrama(TramaType.IZQUIERDA);
              _bluetoothController.sendTrama(TramaType.IZQUIERDAD);
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              _bluetoothController.sendTrama(TramaType.DERECHA);
              _bluetoothController.sendTrama(TramaType.DERECHAD);
            },
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_downward),
            onPressed: () {
              _bluetoothController.sendTrama(TramaType.BAJADA);
              _bluetoothController.sendTrama(TramaType.BAJADAD);
            },
          ),
        ],
      ),
    ],
  ),
),
                      const SizedBox(height: 4),
                      
                    Card(
  elevation: 4, // Ajusta la elevación según tus preferencias
  margin: EdgeInsets.all(16), // Ajusta el margen según tus preferencias
  child: Column(
    children: [
      Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Direcciones Automáticas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.swap_vertical_circle),
            onPressed: () {
              _bluetoothController.sendTrama(TramaType.VERTICAL);
            },
          ),
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: () {
              _bluetoothController.sendTrama(TramaType.HORIZONTAL);
            },
          ),
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: () {
              _bluetoothController.sendTrama(TramaType.STOP);
            },
          ),
        ],
      ),
    ],
  ),
),
Center(
  child: ElevatedButton.icon(
    onPressed: () {
      // Coloca aquí la lógica para desconectar el dispositivo Bluetooth
      _bluetoothController.disconnectDevice(
                            device, TramaType.Apagar);
      Navigator.pop(context); // Cierra la pantalla actual
    },
    icon: Icon(
      Icons.bluetooth_disabled, // Icono de Bluetooth desconectado
      color: Colors.white, // Color del icono
    ),
    label: Text(
      'Desconectar Bluetooth',
      style: TextStyle(
        color: Colors.white, // Color del texto
      ),
    ),
    style: ElevatedButton.styleFrom(
      primary: Colors.red, // Color de fondo rojo
    ),
  ),
),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else {
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

  Future<void> enviarTramaAsync(TramaType type) async {
    try {
      await _bluetoothController
          .sendTrama(type); // Llama a tu función sendTrama

      // Puedes realizar otras acciones aquí después de enviar la trama
    } catch (e) {
      print('Error al enviar la trama: $e');
    }
  }
}
