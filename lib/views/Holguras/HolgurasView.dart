import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtv/class/BluetoohConnection.dart';
import 'package:rtv/class/ListProcedureHolguras.dart';
import 'package:rtv/class/Trama.dart';
import 'package:rtv/controllers/HolgurasBluetoohController.dart';
import 'package:rtv/controllers/HolgurasController.dart';
import 'package:rtv/views/BluetoohSerialView.dart';
import 'package:rtv/views/ExitView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rtv/views/Holguras/CalificationHolgurasView.dart';
import 'package:rtv/views/Holguras/CalificationOtrosHolgurasView.dart';

class HolgurasView extends StatefulWidget {
  @override
  _HolgurasViewState createState() => _HolgurasViewState();
}

class _HolgurasViewState extends State<HolgurasView> {
  final HolgurasController _controller = HolgurasController();
  final HolgurasBluetoothController _sendBluetooh =
      HolgurasBluetoothController();

  List<List<ListProcedureHolguras>> _holgurasLists = [];
  int codeRTV = 0;
  String? _connectedDeviceName;

  @override
  void initState() {
    super.initState();
    clearCodeTVFromSharedPreferences();
    _connectedDeviceName = BluetoothManager().connectedDeviceName ?? '';
    BluetoothManager().setConnectedDeviceName('');
    _sendBluetooh.sendTrama(TramaType.Encender);
  }

  void clearCodeTVFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(
        'codeTV'); // Esto eliminará el valor 'codeTV' de SharedPreferences
  }

  Future<void> _loadProcedures() async {
    try {
      List<ListProcedureHolguras> holgurasInspection =
          await _controller.listInspectionProcedure();

      if (holgurasInspection.isNotEmpty) {
        for (int i = 0; i < 265; i++) {
          _holgurasLists.add(holgurasInspection
              .where((procedure) => procedure.numero == i)
              .toList());
        }
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Holguras'),
        automaticallyImplyLeading: false,
        actions: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BluetoothScreen(),
                ),
              );
            },
            child: Icon(Icons.bluetooth),
            mini: true,
          ),
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ExitView();
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.bluetooth, size: 24),
                      SizedBox(width: 8),
                      Text(
                        _connectedDeviceName != null
                            ? 'Dispositivo conectado a : $_connectedDeviceName'
                            : 'Ningun dispositivo conectado',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _controller.placaController,
                decoration: InputDecoration(
                  hintText: 'Buscar por placa',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _controller.placaController.clear();
                      setState(() {
                        _controller.carData =
                            null; // Limpiamos la información del vehículo
                        _controller.searchCompleted = false;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await _controller.searchVehicle(
                      context, _controller.placaController.text);
                  await _loadProcedures();
                  setState(
                      () {}); // Actualiza la vista después de obtener los datos
                },
                child: Text('Buscar'),
              ),
              SizedBox(height: 16.0),
              if (_controller.carData != null)
                Card(
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(Icons.info),
                        title: Text(
                          'Información del vehículo',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoField(
                                'Marca', _controller.carData!.marca),
                            _buildInfoField(
                                'Modelo', _controller.carData!.modelo),
                            _buildInfoField(
                                'Cliente', _controller.carData!.cliente),
                            _buildInfoField(
                                'Cédula', _controller.carData!.cedula),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else if (_controller.searchCompleted)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Sin información de este vehículo.',
                          style: TextStyle(fontSize: 16),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _controller.placaController.clear();
                            setState(() {
                              _controller.carData = null;
                              _controller.searchCompleted = false;
                            });
                          },
                          child: Text('Realizar una nueva consulta'),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_holgurasLists.isNotEmpty)
                Card(
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var procedures in _holgurasLists)
                        for (var procedure in procedures)
                          GestureDetector(
                            onTap: () {
                              _showDefectsModal(context, procedure.defectos);
                            },
                            child: Card(
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${procedure.abreviaturaDescripcion}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ), // Espacio entre el título y el subtítulo
                                              Text(
                                                "${procedure.procedimiento}", // Agrega el subtítulo aquí
                                                overflow: TextOverflow
                                                    .ellipsis, // Manejo del desbordamiento
                                                maxLines:
                                                    2, // Número máximo de líneas antes de mostrar el desbordamiento
                                                style: TextStyle(
                                                  fontSize: 13.5,
                                                  color: Colors
                                                      .grey, // Puedes personalizar el color y estilo según tus necesidades
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
      floatingActionButton: BluetoothManager().isConnected
          ? SpeedDial(
              icon: Icons.menu_outlined,
              backgroundColor: Colors.blueAccent,
              children: [
                SpeedDialChild(
                  child: Icon(Icons.stop),
                  backgroundColor: Colors.blueAccent,
                  onTap: () {
                    _sendBluetooh.sendTrama(TramaType.STOP);
                  },
                ),
                SpeedDialChild(
                  child: Icon(Icons.swap_horiz),
                  backgroundColor: Colors.blueAccent,
                  onTap: () {
                    _sendBluetooh.sendTrama(TramaType.HORIZONTAL);
                  },
                ),
                SpeedDialChild(
                  child: Icon(Icons.swap_vertical_circle),
                  backgroundColor: Colors.blueAccent,
                  onTap: () {
                    _sendBluetooh.sendTrama(TramaType.VERTICAL);
                  },
                ),
              ],
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            2, // Set the current index to 2 to highlight the Holguras tab
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/identification');
              break;
            case 1:
              Navigator.pushNamed(context, '/visual_inspection');
              break;
            case 2:
              Navigator.pushNamed(context, '/holguras');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.car_crash_rounded),
            label: 'Identificación',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye),
            label: 'Inspección Visual',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Holguras',
          ),
        ],
      ),
    );
  }

  Widget _buildProcedureField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showDefectsModal(BuildContext context, List<Defecto> defectos) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Defectos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: defectos.length,
                itemBuilder: (context, index) {
                  final defecto = defectos[index];
                  return ListTile(
                    title: Text(defecto.abreviatura),
                    subtitle: Text(defecto.descripcion),
                    onTap: () {
                      Navigator.pop(context);
                      _showDefectoModal(context, defecto);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDefectoModal(BuildContext context, Defecto defecto) {
    if (defecto.abreviatura == "OTROS") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OtrosHolgurasWidget(defecto: defecto),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPageHolgurasWidget(defecto: defecto),
        ),
      );
    }
  }
}
