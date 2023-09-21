import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:rtv/class/Trama.dart';
import 'package:rtv/controllers/BluetoohSerialController.dart';

class JoystickControllerView extends StatefulWidget {
  final bool isConnected;
  final String deviceName;

  final BluetoothConnection connection;

  JoystickControllerView({
    required this.isConnected,
    required this.deviceName,
    required this.connection, // Add the connection parameter to the constructor
  });
  @override
  _JoystickControllerViewState createState() => _JoystickControllerViewState();
}

class _JoystickControllerViewState extends State<JoystickControllerView> {
  final List<bool> isSelected = [false, true];
  final _bluetoothController = BluetoothSerialController();
  bool _viewContenentManually = false;
  bool _viewContenentAutomatly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conectado al dispositivo ${widget.deviceName}'),
        //omite la felcha
        automaticallyImplyLeading: false,
      ),
      body: widget.isConnected
          ? SingleChildScrollView(
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
                          Column(
                            children: [
                              Text('Encender/Apagar'),
                              Switch(
                                value: isSelected[0],
                                onChanged: (value) {
                                  setState(() {
                                    isSelected[0] = value;
                                    if (isSelected[0]) {
                                      _bluetoothController.sendTrama(
                                          widget.connection,
                                          Trama(TramaType.Encender));
                                    } else {
                                      _bluetoothController.sendTrama(
                                          widget.connection,
                                          Trama(TramaType.Apagar));
                                    }
                                  });
                                },
                                activeTrackColor: Colors.blueAccent,
                                activeColor: Colors.blueAccent,
                              ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _viewContenentManually = true;
                                                                                    _viewContenentAutomatly=false;

                                        });
                                      },
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'M',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'MANUAL',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _viewContenentManually = false;
                                          _viewContenentAutomatly=true;
                                          _bluetoothController.sendTrama(
                                              widget.connection,
                                              Trama(TramaType.AUTOMATICO));
                                        });
                                      },
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'A',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'AUTOMATICO',
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
                          if (_viewContenentManually)
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
                                        groupValue: '',
                                        onChanged: (value) {
                                          setState(() {
                                            _bluetoothController.sendTrama(
                                                widget.connection,
                                                Trama(TramaType.MANUALIZ));
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
                                        groupValue: '',
                                        onChanged: (value) {
                                          setState(() {
                                            _bluetoothController.sendTrama(
                                                widget.connection,
                                                Trama(TramaType.MANUALDE));
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
                                                icon: Icon(Icons.arrow_upward),
                                                onPressed: () {
                                                  // Maneja la acción para la flecha hacia arriba en el lado izquierdo.
                                                  _bluetoothController
                                                      .sendTrama(
                                                          widget.connection,
                                                          Trama(TramaType
                                                              .SUBIDA));
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
                                                      .sendTrama(
                                                          widget.connection,
                                                          Trama(TramaType
                                                              .IZQUIERDA));
                                                },
                                              ),
                                              Text('Izquierda'),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                icon:
                                                    Icon(Icons.arrow_downward),
                                                onPressed: () {
                                                  // Maneja la acción para la flecha hacia abajo en el lado izquierdo.
                                                  _bluetoothController
                                                      .sendTrama(
                                                          widget.connection,
                                                          Trama(TramaType
                                                              .BAJADA));
                                                },
                                              ),
                                              Text('Abajo'),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.arrow_forward),
                                                onPressed: () {
                                                  // Maneja la acción para la flecha hacia la derecha en el lado izquierdo.
                                                  _bluetoothController
                                                      .sendTrama(
                                                          widget.connection,
                                                          Trama(TramaType
                                                              .DERECHA));
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
                                                icon: Icon(Icons.arrow_upward),
                                                onPressed: () {
                                                  _bluetoothController
                                                      .sendTrama(
                                                          widget.connection,
                                                          Trama(TramaType
                                                              .SUBIDAD));
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
                                                      .sendTrama(
                                                          widget.connection,
                                                          Trama(TramaType
                                                              .IZQUIERDAD));
                                                },
                                              ),
                                              Text('Izquierda'),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                icon:
                                                    Icon(Icons.arrow_downward),
                                                onPressed: () {
                                                  // Maneja la acción para la flecha hacia abajo en el lado derecho.
                                                  _bluetoothController
                                                      .sendTrama(
                                                          widget.connection,
                                                          Trama(TramaType
                                                              .BAJADAD));
                                                },
                                              ),
                                              Text('Abajo'),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.arrow_forward),
                                                onPressed: () {
                                                  // Maneja la acción para la flecha hacia la derecha en el lado derecho.
                                                  _bluetoothController
                                                      .sendTrama(
                                                          widget.connection,
                                                          Trama(TramaType
                                                              .DERECHAD));
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
                          if (_viewContenentAutomatly)
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
                                        _bluetoothController.sendTrama(
                                            widget.connection,
                                            Trama(TramaType.VERTICAL));
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.swap_horiz),
                                      onPressed: () {
                                        _bluetoothController.sendTrama(
                                            widget.connection,
                                            Trama(TramaType.HORIZONTAL));
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.stop),
                                      onPressed: () {
                                        _bluetoothController.sendTrama(
                                            widget.connection,
                                            Trama(TramaType.STOP));
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
                                _bluetoothController.disconnect();
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
            )
          : AlertDialog(
              title: Text('Error'),
              content: Text(
                  'No se pudo conectar al dispositivo ${widget.deviceName}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Aceptar'),
                ),
              ],
            ),
    );
  }
}
