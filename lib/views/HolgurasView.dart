import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtv/class/ListProcedureHolguras.dart';
import 'package:rtv/controllers/HolgurasController.dart';

class HolgurasView extends StatefulWidget {
  @override
  _HolgurasViewState createState() => _HolgurasViewState();
}

class _HolgurasViewState extends State<HolgurasView> {
 final HolgurasController _controller = HolgurasController();
  List<List<ListProcedureHolguras>> _holgurasLists = [];
@override
  void initState() {
    super.initState();
    _loadProcedures();
  }

  Future<void> _loadProcedures() async {
    try {
      List<ListProcedureHolguras> holgurasInspection =
          await _controller.listInspectionProcedure();

      if (holgurasInspection.isNotEmpty) {
        for (int i = 0; i < 70; i++) {
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
      body: _holgurasLists.isNotEmpty
          ? Scrollbar(
              child: ListView(
                children: _holgurasLists.map((procedures) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: procedures.length,
                    itemBuilder: (BuildContext context, int index) {
                      final procedure = procedures[index];
                      return GestureDetector(
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
                                    Text(
                                      'Items', // Agrega el mensaje aquí
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward, // Agrega el icono aquí
                                      size: 24,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                _buildProcedureField(
                                    'Procedimiento', procedure.procedimiento),
                                _buildProcedureField(
                                    'Abreviatura', procedure.abreviatura),
                                _buildProcedureField(
                                    'Descripción Abreviatura',
                                    procedure.abreviaturaDescripcion),
                                // ...agrega los campos restantes aquí
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 16.0, right: 16.0),
        child: Align(
          alignment: Alignment.topRight,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/bluetooth');
            },
            child: Icon(Icons.directions_car),
          ),
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
void _showOtrosModal(BuildContext context, Defecto defecto) {
  List<int> selectedLocations = [];
 int selectedCalification = 1;
           final HolgurasController _controller =
              HolgurasController();
          final TextEditingController _ob = TextEditingController();
          final TextEditingController _kilometrajeController =
              TextEditingController();
              final FocusNode _obFocusNode = FocusNode();
final FocusNode _kilometrajeFocusNode = FocusNode();
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, setState) {

          return SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                _obFocusNode.unfocus();
                _kilometrajeFocusNode.unfocus();
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
), if (selectedLocations.isNotEmpty)
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
                  TextField(
                    maxLines: 1,
                    controller: _kilometrajeController,
                    focusNode: _kilometrajeFocusNode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Kilometraje',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
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
                          title: Text('Calificación: $selectedCalification'),
                          trailing: Icon(Icons.arrow_drop_down),
                          onTap: () {
                            // Abre un Dialog para seleccionar la calificación
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Selecciona la calificación'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        title: Text('1'),
                                        onTap: () {
                                          setState(() {
                                            selectedCalification = 1;
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        title: Text('2'),
                                        onTap: () {
                                          setState(() {
                                            selectedCalification = 2;
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        title: Text('3'),
                                        onTap: () {
                                          setState(() {
                                            selectedCalification = 3;
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                       ListTile(
                                        title: Text('Cancelar'),
                                        onTap: () {
                                          setState(() {
                                            selectedCalification = 4;
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                              
                                );
                              },
                            );
                          },
                        
                        ),

                      ],
                    ),
                  ),
          
                  SizedBox(height: 16),

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
                        _kilometrajeController.text,
                        selectedLocations.join(','),
                        selectedCalification, // Agrega la calificación
                      );
                    },
                    child: Text('Guardar'),
                  ),
                ],
              ),
            ),
            )
          );
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
 int selectedCalification = 1;
           final HolgurasController _controller =
              HolgurasController();
          final TextEditingController _kilometrajeC =
              TextEditingController();
              final FocusNode _obFocusNode = FocusNode();
final FocusNode _kilometrajeFocusNode = FocusNode();
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
                _kilometrajeFocusNode.unfocus();
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
), if (selectedLocations.isNotEmpty)
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
                    maxLines: 1,
                    controller: _kilometrajeC,
                    focusNode: _kilometrajeFocusNode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Kilometraje',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
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
                          title: Text('Calificación: $selectedCalification'),
                          trailing: Icon(Icons.arrow_drop_down),
                          onTap: () {
                            // Abre un Dialog para seleccionar la calificación
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Selecciona la calificación'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        title: Text('1'),
                                        onTap: () {
                                          setState(() {
                                            selectedCalification = 1;
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        title: Text('2'),
                                        onTap: () {
                                          setState(() {
                                            selectedCalification = 2;
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        title: Text('3'),
                                        onTap: () {
                                          setState(() {
                                            selectedCalification = 3;
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                       ListTile(
                                        title: Text('Cancelar'),
                                        onTap: () {
                                          setState(() {
                                            selectedCalification = 4;
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                              
                                );
                              },
                            );
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
                       _kilometrajeC.text, // Cambiar a _kilometrajeController.text
                       selectedLocations.join(','),
                       selectedCalification, // Agrega la calificación
                      );
                    },
                    child: Text('Guardar'),
                  ),
                ],
              ),
            ),
            )
          );
        },
      );
    },
  );
  }
}
}