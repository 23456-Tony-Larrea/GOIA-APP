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
                Card(
                  elevation: 4, // Agrega sombra al card
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      // Usar una columna para organizar elementos verticalmente
                      children: [
                        Text(
                          'Items a Considerar',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        //implemntanto un toggle de encender y apagar
                        const SizedBox(height: 16),
                        ToggleButtons(
                          children: [
                            Icon(Icons.lightbulb_outline),
                            Icon(Icons.lightbulb),
                          ],
                          onPressed: (int index) {
                            // Acción al presionar el botón
                            // Puedes agregar tu lógica aquí
                            if (index == 0) {
                              // Presionó el botón de encender
                              _bluetoothController
                                  .sendTrama(TramaType.Encender);
                            } else if (index == 1) {
                              // Presionó el botón de apagar
                              _bluetoothController.sendTrama(TramaType.Apagar);
                            }
                          },
                          isSelected: [
                            true,
                            false
                          ], // Indica qué botón está seleccionado
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Radio(
                              value: 'manual',
                              groupValue: 'modo',
                              onChanged: (value) {
                            
                              },
                            ),
                            Text('Manual',
                                style: TextStyle(
                                    fontSize:
                                        16)), // Cambia el tamaño de la fuente
                            Radio(
                              value: 'automatico',
                              groupValue: 'modo',
                              onChanged: (value) {

                              },
                            ),
                            Text('Automático',
                                style: TextStyle(
                                    fontSize:
                                        16)), // Cambia el tamaño de la fuente
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Radio(
                              value: 'izquierda',
                              groupValue: 'direcciones',
                              onChanged: (value) {
                             
                              },
                            ),
                            Text('Izquierdo',
                                style: TextStyle(
                                    fontSize:
                                        16)), // Cambia el tamaño de la fuente
                            Radio(
                              value: 'derecha',
                              groupValue: 'direcciones',
                              onChanged: (value) {
                               
                              },
                            ),
                            Text('Derecho',
                                style: TextStyle(
                                    fontSize:
                                        16)), // Cambia el tamaño de la fuente
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_upward),
                              onPressed: () {
                                // Acción al presionar flecha arriba
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
                                // Acción al presionar flecha izquierda
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: () {
                                // Acción al presionar flecha derecha
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
                                // Acción al presionar flecha abajo
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.swap_vertical_circle),
                      onPressed: () {
                        // Acción al presionar flecha arriba (movimiento de atrás)
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.swap_horiz),
                      onPressed: () {
                        // Acción al presionar flecha abajo (movimiento de adelante)
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.stop),
                      onPressed: () {
                        // Acción al presionar el botón de detener
                        _bluetoothController.disconnectDevice(
                            device, TramaType.Apagar);
                        Navigator.pop(context);
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
