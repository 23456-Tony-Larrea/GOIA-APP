import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rtv/class/BluetoohConnection.dart';
import 'package:rtv/class/ListProcedureHolguras.dart';
import 'package:rtv/class/Trama.dart';
import 'package:rtv/controllers/HolgurasBluetoohController.dart';
import 'package:rtv/controllers/HolgurasController.dart';
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
  bool isLoading = false;
  bool hasSearched = false;
  bool _saving = false; // variable para controlar el estado del ProgressBar

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
        for (int i = 0; i < 500; i++) {
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

  void openModal() async {
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
                  'Guardando por favor espere ...',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      // Intercepta el evento de retroceso y realiza la acción que desees,
      // en este caso, puedes no hacer nada para desactivar el botón de retroceso nativo.
      return false; // Cambia esto a true si deseas permitir la navegación de retroceso nativa.
    },
    child:Scaffold(
      appBar: AppBar(
        title: Text('Holguras'),
        automaticallyImplyLeading: false,
        actions: [
          Visibility(
            visible: _holgurasLists.isNotEmpty && _controller.carData != null,
            child: FloatingActionButton(
              onPressed: () async {
                setState(() {
                  _saving = true; // cambiamos el estado del ProgressBar a true
                });
                _controller.placaController.clear();
                setState(() {
                  _controller.carData = null;
                  _controller.searchCompleted = false;
                  hasSearched = false;
                });
                openModal();
                await Future.delayed(
                    Duration(seconds: 3)); // esperamos 3 segundos
                Navigator.of(context).pop(); // cerramos el AlertDialog
                Fluttertoast.showToast(
                  msg: "Holguras guardada con exito",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.greenAccent,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                _sendBluetooh.sendTrama(TramaType.Apagar);
                setState(() {
                  _saving =
                      false; // cambiamos el estado del ProgressBar a false
                });
              },
              child: _saving
                  ? CircularProgressIndicator()
                  : Icon(Icons.save),
              mini: true,
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/bluetooh_serial');
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
      body:Padding(
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
                          _controller.carData = null;
                          _controller.searchCompleted = false;
                          //limpiar list
                          _holgurasLists.clear();
                          hasSearched = false;
                        });
                      },
                    ),
                  ),
                  textCapitalization: TextCapitalization.characters),
              SizedBox(height: 16.0),
              Stack(
                children: [
                  SizedBox(
                    width: 580.0,
                    child: ElevatedButton(
                      onPressed: hasSearched
                          ? null
                          : () async {
                              setState(() {
                                isLoading = true;
                              });

                              await _controller.searchVehicle(
                                  context, _controller.placaController.text);
                              await _loadProcedures();
                              setState(() {
                                isLoading = false;
                                hasSearched = true;
                              });
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isLoading)
                            SizedBox(
                              width: 24.0,
                              height: 24.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 3.0,
                              ),
                            ),
                          SizedBox(width: isLoading ? 8.0 : 0.0),
                          Text(
                            isLoading
                                ? 'Cargando RTV, por favor espere...'
                                : 'Buscar',
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.white.withOpacity(0.5),
                        child: Center(
                          child: SizedBox(
                            width: 48.0,
                            height: 48.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 4.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
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
                              hasSearched = false;
                            });
                          },
                          child: Text('Realizar una nueva consulta'),
                        ),
                      ],
                    ),
                  ),
                ),
    if (_holgurasLists.isNotEmpty && _controller.carData != null)
  Expanded(
    child: SingleChildScrollView(
      child: Column(
        children: [
          TypeAheadField(
             textFieldConfiguration: TextFieldConfiguration(
                          decoration: InputDecoration(
                            hintText: 'Buscar por codigo',
                          ),
                          textCapitalization: TextCapitalization.characters),
                      suggestionsCallback: (pattern) async {
                        final suggestions = _holgurasLists
                            .expand((procedures) => procedures)
.where((procedure) =>
      "${procedure.familia}${procedure.subfamilia}${procedure.categoria}".toLowerCase().contains(pattern.toLowerCase())
    )
    .toList();
                        return suggestions;
                      },
                      itemBuilder: (context, suggestion) {
                                                 return Card(
  child: ListTile(
    title: Row(
      children: [
        Text(
          suggestion.abreviaturaDescripcion,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    ),
    subtitle: Text(
      suggestion.procedimiento,
      style: TextStyle(
        color: Colors.grey,
      ),
    ),
    trailing: Text(
      "${suggestion.familia}${suggestion.subfamilia}${suggestion.categoria}",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  ),
);          },
                      onSuggestionSelected: (suggestion) {
                        _showDefectsModal(context, suggestion.defectos,
                            suggestion.procedimiento);
                      },
                    ),
          SizedBox(height: 16),
          Card(
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var procedures in _holgurasLists)
                  for (var procedure in procedures)
                    GestureDetector(
                      onTap: () {
                        _showDefectsModal(context, procedure.defectos,
                            procedure.procedimiento);
                      },
child: Card(
  elevation: 4,
  color: procedure.isRated ? Colors.lightBlueAccent : null,
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                     Row(
              children: [   
                Text(
                  "${procedure.familia}${procedure.subfamilia}${procedure.categoria}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
                  Text(
                    "${procedure.categoriaDescripcion}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "${procedure.procedimiento}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
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
          ),
        ],
      ),
    ),
  ),
            ],
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
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/identification');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/visual_inspection');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/holguras');
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

  void _showDefectsModal(
      BuildContext context, List defectos, String Procedure) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$Procedure',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Defectos',
                style: TextStyle(
                  color: Colors.black87.withOpacity(0.7),
                  fontSize: 15,
                ),
              ),
              // Usar un ListView con physics para permitir el desplazamiento
              Expanded(
                child: Scrollbar(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: defectos.length,
                    physics:
                        BouncingScrollPhysics(), // O AlwaysScrollableScrollPhysics()
                    itemBuilder: (context, index) {
                      final defecto = defectos[index];
                     return Card(
  child: ListTile(
    title: Text(defecto.abreviatura),
    subtitle: Text(defecto.descripcion),
    onTap: () {
      Navigator.pop(context);
      _showDefectoModal(context, defecto);
    },
  ),
);
                    },
                  ),
                ),
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
      ).then((value) {
        // Aquí actualizas el estado de isRated cuando el usuario califica
        if (value == true) {
          setState(() {
            for (var procedures in _holgurasLists) {
              for (var procedure in procedures) {
                if (procedure.defectos.contains(defecto)) {
                  procedure.isRated = true;
                }
              }
            }
          });
        }
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPageHolgurasWidget(defecto: defecto),
        ),
      ).then((value) {
        // Aquí actualizas el estado de isRated cuando el usuario califica
        if (value == true) {
          setState(() {
            for (var procedures in _holgurasLists) {
              for (var procedure in procedures) {
                if (procedure.defectos.contains(defecto)) {
                  procedure.isRated = true;
                }
              }
            }
          });
        }
      });
    }
  }
}
