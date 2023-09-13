import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtv/class/ListProcedureHolguras.dart';
import 'package:rtv/controllers/HolgurasController.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HolgurasView extends StatefulWidget {
  @override
  _HolgurasViewState createState() => _HolgurasViewState();
}

class _HolgurasViewState extends State<HolgurasView> {
  final HolgurasController _controller = HolgurasController();
  List<List<ListProcedureHolguras>> _holgurasLists = [];
  int codeRTV = 0;
  @override
  void initState() {
    super.initState();
    clearCodeTVFromSharedPreferences();
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
    actions: [
      Align(
        alignment: Alignment.topRight,
        child: FloatingActionButton(
          onPressed: () {
                         Navigator.pushNamed(context, '/bluetooh');
          },
          child: Icon(Icons.bluetooth),
          mini: true,
        ),
      ),
    ],
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
              else
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
                      Text(
                        'Holguras',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 8),
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
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Procedimiento : ${procedure.procedimiento}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              SizedBox(
                                                  height:
                                                      4), // Espacio entre el título y el subtítulo
                                              Text(
                                                "Descripción: ${procedure.abreviaturaDescripcion}", // Agrega el subtítulo aquí
                                                overflow: TextOverflow
                                                    .ellipsis, // Manejo del desbordamiento
                                                maxLines:
                                                    2, // Número máximo de líneas antes de mostrar el desbordamiento
                                                style: TextStyle(
                                                  fontSize: 16,
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
                                    SizedBox(height: 8),
                                    _buildProcedureField(
                                        'Codigo', procedure.codigo.toString()),
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
       floatingActionButton: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          onPressed: () {
            // Acción para el primer botón flotante
          },
          child: Icon(Icons.stop),
          backgroundColor: Colors.red,
        ),
        SizedBox(height: 4.0), // Espacio entre los botones
        FloatingActionButton(
          onPressed: () {
            // Acción para el segundo botón flotante
          },
          child: Icon(Icons.swap_horiz),
          backgroundColor: Colors.red,
        ),
        SizedBox(height: 4.0), // Espacio entre los botones
        FloatingActionButton(
          onPressed: () {
            // Acción para el tercer botón flotante
          },
          child: Icon(Icons.swap_vertical_circle),
          backgroundColor: Colors.red,
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

  void _showOtrosModal(BuildContext context, Defecto defecto) {
    List<int> selectedLocations = [];
    int? selectedCalification = null;
    final HolgurasController _controller = HolgurasController();
    final TextEditingController _ob = TextEditingController();
    final FocusNode _obFocusNode = FocusNode();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return SingleChildScrollView(
                child: GestureDetector(
              onTap: () {
                _obFocusNode.unfocus();
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Defecto: ${defecto.abreviatura}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Descripción: ${defecto.descripcion}'),
                    SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: 'Elige las ubicaciones',
                        border: OutlineInputBorder(),
                      ),
                      value: 9, // Establece el valor inicial aquí
                      onChanged: (int? newValue) {
                        setState(() {
                          if (newValue != null) {
                            selectedLocations.add(newValue);
                          }
                        });
                      },
                      items: List.generate(
                        9,
                        (index) => DropdownMenuItem<int>(
                          value: index + 9,
                          child: Text((index + 9).toString()),
                        ),
                      ),
                    ),
                    if (selectedLocations.isNotEmpty)
                      Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('Ubicaciones seleccionadas:'),
                            ),
                            Column(
                              children: selectedLocations.map((location) {
                                return ListTile(
                                  title: Text(location.toString()),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        selectedLocations.remove(location);
                                      });
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 16),
                    Image.asset(
                      'assets/images/carrito.png',
                      width: 250,
                      height: 250,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _ob,
                      focusNode: _obFocusNode,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Observación',
                      ),
                    ),
                    SizedBox(height: 16),
                     Card(
                      // Card para la calificación
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('Calificación'),
                          ),
                           ListTile(
                title: Text('Calificación: ${selectedCalification ?? 'Sin calificación'}'),
              ),
                            RadioListTile<int>(
                title: Text('1'),
                value: 1,
                groupValue: selectedCalification,
                onChanged: (value) {
                  setState(() {
                    selectedCalification = value!;
                  });
                },
              ),
              RadioListTile<int>(
                title: Text('2'),
                value: 2,
                groupValue: selectedCalification,
                onChanged: (value) {
                  setState(() {
                    selectedCalification = value!;
                  });
                },
              ),
              RadioListTile<int>(
                title: Text('3'),
                value: 3,
                groupValue: selectedCalification,
                onChanged: (value) {
                  setState(() {
                    selectedCalification = value!;
                  });
                },
              ),
               RadioListTile<int>(
                title: Text('Cancelar'),
                value: 4,
                groupValue: selectedCalification,
                onChanged: (value) {
                  setState(() {
                    selectedCalification = value!;
                  });
                },
              ),
            ],
          ),
        ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _controller.savesaveInspectionHolgurasObservation(
                          context,
                          defecto.codigo,
                          defecto.numero,
                          defecto.abreviatura,
                          defecto.descripcion,
                          defecto.codigoAs400,
                          _ob.text,
                          selectedLocations.join(','),
                          selectedCalification, // Agrega la calificación
                        );
                      },
                      child: Text('Guardar'),
                    ),
                  ],
                ),
              ),
            ));
          },
        );
      },
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
                    trailing: Text('Código AS400: ${defecto.codigoAs400}'),
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
    List<int> selectedLocations = [];
    int ?selectedCalification = null;
    final HolgurasController _controller = HolgurasController();
    final FocusNode _obFocusNode = FocusNode();
    if (defecto.abreviatura == "OTROS") {
      _showOtrosModal(context, defecto);
    } else {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SingleChildScrollView(
                  child: GestureDetector(
                onTap: () {
                  _obFocusNode.unfocus();
                },
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Defecto: ${defecto.abreviatura}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Descripción: ${defecto.descripcion}'),
                      SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Elige las ubicaciones',
                          border: OutlineInputBorder(),
                        ),
                        value: 9, // Establece el valor inicial aquí
                        onChanged: (int? newValue) {
                          setState(() {
                            if (newValue != null) {
                              selectedLocations.add(newValue);
                            }
                          });
                        },
                        items: List.generate(
                          9,
                          (index) => DropdownMenuItem<int>(
                            value: index + 9,
                            child: Text((index + 9).toString()),
                          ),
                        ),
                      ),
                      if (selectedLocations.isNotEmpty)
                        Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text('Ubicaciones seleccionadas:'),
                              ),
                              Column(
                                children: selectedLocations.map((location) {
                                  return ListTile(
                                    title: Text(location.toString()),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          selectedLocations.remove(location);
                                        });
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 16),
                      Image.asset(
                        'assets/images/carrito.png',
                        width: 250,
                        height: 250,
                      ),
            
                      SizedBox(height: 16),
                       Card(
                      // Card para la calificación
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('Calificación'),
                          ),
                          ListTile(
                title: Text('Calificación: ${selectedCalification ?? 'Sin calificación'}'),
              ),
                            RadioListTile<int>(
                title: Text('1'),
                value: 1,
                groupValue: selectedCalification,
                onChanged: (value) {
                  setState(() {
                    selectedCalification = value!;
                  });
                },
              ),
              RadioListTile<int>(
                title: Text('2'),
                value: 2,
                groupValue: selectedCalification,
                onChanged: (value) {
                  setState(() {
                    selectedCalification = value!;
                  });
                },
              ),
              RadioListTile<int>(
                title: Text('3'),
                value: 3,
                groupValue: selectedCalification,
                onChanged: (value) {
                  setState(() {
                    selectedCalification = value!;
                  });
                },
              ),
               RadioListTile<int>(
                title: Text('Cancelar'),
                value: 4,
                groupValue: selectedCalification,
                onChanged: (value) {
                  setState(() {
                    selectedCalification = value!;
                  });
                },
              ),
            ],
          ),
        ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          _controller.saveInspectionHolguras(
                            context,
                            defecto.codigo,
                            defecto.numero,
                            defecto.abreviatura,
                            defecto.descripcion,
                            defecto.codigoAs400,
                            selectedLocations.join(','),
                            selectedCalification, // Agrega la calificación
                          );
                        },
                        child: Text('Guardar'),
                      ),
                    ],
                  ),
                ),
              ));
            },
          );
        },
      );
    }
  }
}
