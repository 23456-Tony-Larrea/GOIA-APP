import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:rtv/class/Trama.dart';
import 'package:rtv/controllers/BluetoohSerialController.dart';

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  final _bluetoothController = BluetoothSerialController();
  bool _isScanning = false;
  bool _isConnected = false;
  List<bool> _toggleSelections = [false, false];

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
          ElevatedButton(
            onPressed: _isScanning ? null : _startScan,
            child: Text('Escanear dispositivos'),
          ),
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
                      return ListTile(
                        title: Text(device.name!),
                        subtitle: Text(device.address),
                        trailing: ElevatedButton(
                          onPressed: () => _connectToDevice(context, results[index]),
                          child: Text('Conectar'),
                        ),
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
          if (_isConnected)
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Switch(
      value: _toggleSelections[0],
      onChanged: (value) {
        setState(() {
          _toggleSelections[0] = value;
          final tramaType = _toggleSelections[0] ? TramaType.Encender : TramaType.Apagar;
          final trama = Trama(tramaType);
          _bluetoothController.sendTrama(trama);
        });
      },
    ),
    Text(_toggleSelections[0] ? 'Encendido' : 'Apagado'),
  ],
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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

_bluetoothController.sendTrama(Trama(TramaType.AUTOMATICO));              
}
);
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Radio(
            value: 'izquierda',
            groupValue: "modoSeleccionado",
            onChanged: (value) {
              setState(() {
                _bluetoothController.sendTrama(Trama(TramaType.MANUALIZ));
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
                _bluetoothController.sendTrama(Trama(TramaType.MANUALDE));
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
                                                            Trama(TramaType.SUBIDA));
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
                                                        .sendTrama(Trama(TramaType
                                                            .IZQUIERDA));
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
                                                            Trama(TramaType.BAJADA));
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
                                                            Trama(TramaType.DERECHA));
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
                                                            Trama(TramaType.SUBIDAD));
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
                                                        .sendTrama(Trama(TramaType
                                                            .IZQUIERDAD));
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
                                                            Trama(TramaType.BAJADAD));
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
                                                            Trama(TramaType.DERECHAD));
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
                                              .sendTrama(Trama(TramaType.VERTICAL));
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.swap_horiz),
                                        onPressed: () {
                                          _bluetoothController
                                              .sendTrama(Trama(TramaType.HORIZONTAL));
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.stop),
                                        onPressed: () {
                                          _bluetoothController
                                              .sendTrama(Trama(TramaType.STOP));
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
        ],
      ),
    );
  }

  Future<void> _startScan() async {
    setState(() {
      _isScanning = true;
    });
    await _bluetoothController.startScan();
    setState(() {
      _isScanning = false;
    });
  }

 Future<void> _connectToDevice(BuildContext context, BluetoothDiscoveryResult device) async {
  await _bluetoothController.connectToDevice(context, device);
  setState(() {
    _isConnected = true;
  });
}
}