import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:rtv/class/ListProcedureVisualInspection.dart';
import 'package:rtv/class/Trama.dart';
import 'package:rtv/controllers/VisualInspectionController.dart';
import 'package:rtv/views/ExitView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/HolgurasBluetoohController.dart';
import 'CalificationVisualInspection.dart';
import 'CalificationOtrosVisualInspection.dart';

class VisualInspectionView extends StatefulWidget {
  @override
  _VisualInspectionViewState createState() => _VisualInspectionViewState();
}

class _VisualInspectionViewState extends State<VisualInspectionView> {
  final VisualInspectionController _controller = VisualInspectionController();
  List<List<ListProcedureInspection>> _procedureLists = [];
  final HolgurasBluetoothController _sendBluetooh =
      HolgurasBluetoothController();


  @override
  void initState() {
    super.initState();
    clearCodeTVFromSharedPreferences();

    _sendBluetooh.sendTrama(TramaType.Apagar);

  }

  Future<void> _loadProcedures() async {
    try {
      List<ListProcedureInspection> visualInspection =
          await _controller.listInspectionProcedure();

      if (visualInspection.isNotEmpty) {
        for (int i = 0; i < 256; i++) {
          _procedureLists.add(visualInspection
              .where((procedure) => procedure.numero == i)
              .toList());
        }
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  void clearCodeTVFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(
        'codeTV'); // Esto eliminará el valor 'codeTV' de SharedPreferences
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
                'Defecto a calificar :',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
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
          builder: (context) => CalificationVisualWidget(defecto: defecto),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inspección Visual'),
        actions: [
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
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                textCapitalization: TextCapitalization.characters
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
                              _controller.carData =
                                  null; // Limpiamos la información del vehículo
                              _controller.searchCompleted = false;
                            });
                          },
                          child: Text('Realizar una nueva consulta'),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 16.0),
              if (_procedureLists.isNotEmpty)  
              Column(
    children: [
      TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          decoration: InputDecoration(
            hintText: 'Buscar procedimiento',
          ),
          textCapitalization: TextCapitalization.characters
        ),
        suggestionsCallback: (pattern) async {
          final suggestions = _procedureLists.expand((procedures) => procedures)
              .where((procedure) => procedure.procedimiento.toLowerCase().contains(pattern.toLowerCase()))
              .toList();
          return suggestions;
        },
        itemBuilder: (context, suggestion) {
          return Card(
    child: ListTile(
      title: Text(
        suggestion.abreviaturaDescripcion,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        suggestion.abreviaturaDescripcion,
        style: TextStyle(
           color: Colors.grey,
        ),
      ),
    ),
  );
        },
        onSuggestionSelected: (suggestion) {
          _showDefectsModal(context, suggestion.defectos);
        },
      ),
      SizedBox(height: 16),
      Card(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var procedures in _procedureLists)
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
      ),
    ],
  ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            1, // Set the current index to 2 to highlight the Holguras tab
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
}
