import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:rtv/ignore/controllers/BluetoohPlusController.dart';
import 'package:rtv/class/Trama.dart';

class BluetoohPlusView extends StatefulWidget {
  const BluetoohPlusView({Key? key}) : super(key: key);

  @override
  _BluetoohPlusViewState createState() => _BluetoohPlusViewState();
}

class _BluetoohPlusViewState extends State<BluetoohPlusView> {
  final BluetoothPlusController _bluetoothController =
      BluetoothPlusController();

  @override
  void initState() {
    super.initState();
    _bluetoothController.startScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bluetooth"),
      ),
      body: StreamBuilder<List<ScanResult>>(
        stream: _bluetoothController.getScanResultsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildDeviceList(snapshot.data!);
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  ListView _buildDeviceList(List<ScanResult> scanResults) {
    return ListView.builder(
      itemCount: scanResults.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _showDeviceNameDialog(context, scanResults[index].device.localName,
                scanResults[index].device);
          },
          child: Card(
            elevation: 2.0,
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(Icons.bluetooth),
              title: Text(scanResults[index].device.localName),
              subtitle: Text('RSSI: ${scanResults[index].rssi}'),
            ),
          ),
        );
      },
    );
  }

  void _showDeviceNameDialog(
      BuildContext context, String deviceName, BluetoothDevice device) async {
         BluetoothDevice? connectedDevice = await _bluetoothController.connectDevice(context,device);
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
                              isSelected: [true, false],
                              onPressed: (index) {
                                if (index == 0) {
                                  _bluetoothController
                                      .sendTrama(TramaType.Encender);
                                }
                                if (index == 1) {
                                  _bluetoothController
                                      .sendTrama(TramaType.Apagar);
                                }
                              },
                            ),
                            Card(
                              elevation: 4,
                              margin: EdgeInsets.all(16),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Radio(
                                        value: 'manual',
                                        groupValue: 'modo',
                                        onChanged: (value) {
                                          setState(() {
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
                                          setState(() {
                                            _bluetoothController.sendTrama(TramaType.AUTOMATICO);
                                          });
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
                              elevation: 4,
                              margin: EdgeInsets.all(16),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Radio(
                                        value: 'izquierda',
                                        groupValue: "modoSeleccionado",
                                        onChanged: (value) {
                                          setState(() {
                                            _bluetoothController
                                                .sendTrama(TramaType.MANUALIZ);
                                          });
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
                                        groupValue: "modoSeleccionado",
                                        onChanged: (value) {
                                          setState(() {
                                            _bluetoothController.sendTrama(
                                                TramaType.MANUALDE);
                                          });
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
                            const SizedBox(height: 4),
                            Card(
                              elevation: 4,
                              margin: EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Lado Izquierdo
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Text(
                                            'Lado Izquierdo',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                IconButton(
                                                  icon:
                                                      Icon(Icons.arrow_upward),
                                                  onPressed: () {
                                                    // Maneja la acción para la flecha hacia arriba en el lado izquierdo.
                                                    _bluetoothController
                                                        .sendTrama(
                                                            TramaType.SUBIDA);
                                                  },
                                                ),
                                                Text('Arriba'),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.arrow_back),
                                                  onPressed: () {
                                                    // Maneja la acción para la flecha hacia la izquierda en el lado izquierdo.
                                                    _bluetoothController
                                                        .sendTrama(TramaType
                                                            .IZQUIERDA);
                                                  },
                                                ),
                                                Text('Izquierda'),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                      Icons.arrow_downward),
                                                  onPressed: () {
                                                    // Maneja la acción para la flecha hacia abajo en el lado izquierdo.
                                                    _bluetoothController
                                                        .sendTrama(
                                                            TramaType.BAJADA);
                                                  },
                                                ),
                                                Text('Abajo'),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                IconButton(
                                                  icon:
                                                      Icon(Icons.arrow_forward),
                                                  onPressed: () {
                                                    // Maneja la acción para la flecha hacia la derecha en el lado izquierdo.
                                                    _bluetoothController
                                                        .sendTrama(
                                                            TramaType.DERECHA);
                                                  },
                                                ),
                                                Text('Derecha'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Separador Vertical
                                  VerticalDivider(),

                                  // Lado Derecho
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Text(
                                            'Lado Derecho',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                IconButton(
                                                  icon:
                                                      Icon(Icons.arrow_upward),
                                                  onPressed: () {
                                                    _bluetoothController
                                                        .sendTrama(
                                                            TramaType.SUBIDAD);
                                                  },
                                                ),
                                                Text('Arriba'),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.arrow_back),
                                                  onPressed: () {
                                                    // Maneja la acción para la flecha hacia la izquierda en el lado derecho.
                                                    _bluetoothController
                                                        .sendTrama(TramaType
                                                            .IZQUIERDAD);
                                                  },
                                                ),
                                                Text('Izquierda'),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                      Icons.arrow_downward),
                                                  onPressed: () {
                                                    // Maneja la acción para la flecha hacia abajo en el lado derecho.
                                                    _bluetoothController
                                                        .sendTrama(
                                                            TramaType.BAJADAD);
                                                  },
                                                ),
                                                Text('Abajo'),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                IconButton(
                                                  icon:
                                                      Icon(Icons.arrow_forward),
                                                  onPressed: () {
                                                    // Maneja la acción para la flecha hacia la derecha en el lado derecho.
                                                    _bluetoothController
                                                        .sendTrama(
                                                            TramaType.DERECHAD);
                                                  },
                                                ),
                                                Text('Derecha'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Card(
                              elevation: 4,
                              margin: EdgeInsets.all(16),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.swap_vertical_circle),
                                        onPressed: () {
                                          _bluetoothController
                                              .sendTrama(TramaType.VERTICAL);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.swap_horiz),
                                        onPressed: () {
                                          _bluetoothController
                                              .sendTrama(TramaType.HORIZONTAL);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.stop),
                                        onPressed: () {
                                          _bluetoothController
                                              .sendTrama(TramaType.STOP);
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
                                  Navigator.pop(
                                      context); // Cierra la pantalla actual
                                },
                                icon: Icon(
                                  Icons
                                      .bluetooth_disabled, // Icono de Bluetooth desconectado
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
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else {
      // Si el dispositivo no está conectado, muestra un mensaje de error
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('No se pudo conectar al dispositivo $deviceName'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
    // mostrar el dialog si se deconecta el dispositvo
  }
}
