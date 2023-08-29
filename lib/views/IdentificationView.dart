import 'package:flutter/material.dart';
import 'package:rtv/controllers/IdentificationController.dart';
import '../class/ListProcedure.dart';

class IdentificationView extends StatefulWidget {
  @override
  _IdentificationViewState createState() => _IdentificationViewState();
}

class _IdentificationViewState extends State<IdentificationView> {
  final IdentificationController _controller = IdentificationController();
  List<ListProcedure> _procedures = [];
  List<ListProcedure> _procedures0 = []; // Agrega esta línea
  List<ListProcedure> _procedures1 = []; // Agrega esta línea
  Defecto? selectedDefecto;
  DefectoEncontrado? defectoEncontrado;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                await _getProcedures();
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
                          _buildInfoField('Marca', _controller.carData!.marca),
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
            if (_procedures0.isNotEmpty)
              Column(
                children: _procedures0.asMap().entries.map((entry) {
                  final procedure = entry.value;

                  return GestureDetector(
                    onTap: () {
                      _showDefectsModal(context, procedure.defectos);
                    },
                    child: Card(
                      elevation: 4,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.list),
                            title: Text(
                              'Items',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildProcedureField(
                                    'Procedimiento', procedure.procedimiento),
                                _buildProcedureField(
                                    'Abreviatura', procedure.abreviatura),
                                _buildProcedureField('Descripción Abreviatura',
                                    procedure.abreviaturaDescripcion),
                                // ...agrega los campos restantes aquí
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            if (_procedures1.isNotEmpty)
              Column(
                children: _procedures1.asMap().entries.map((entry) {
                  final procedure = entry.value;

                  return GestureDetector(
                    onTap: () {
                      _showDefectsModal(context, procedure.defectos);
                    },
                    child: Card(
                      elevation: 4,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildProcedureField(
                                    'Procedimiento', procedure.procedimiento),
                                _buildProcedureField(
                                    'Abreviatura', procedure.abreviatura),
                                _buildProcedureField('Descripción Abreviatura',
                                    procedure.abreviaturaDescripcion),
                                // ...agrega los campos restantes aquí
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
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

  Future<void> _getProcedures() async {
    try {
      if (_controller.carData != null) {
        List<ListProcedure> procedures = await _controller.lisProcedure();
        setState(() {
          _procedures = procedures;
          if (_procedures.isNotEmpty) {
            _procedures0.add(_procedures[0]);
            if (_procedures.length > 1) {
              _procedures1.add(_procedures[1]);
            }
          }
        });
      }
    } catch (error) {
      print(error);
    }
  }
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

Widget _buildProcedureCard(ListProcedure procedure) {
  return Card(
    elevation: 4,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            'Procedimiento: ${procedure.procedimiento}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Abreviatura: ${procedure.abreviatura}'),
              Text('subfamilia: ${procedure.subfamilia}'),
              // Aquí puedes mostrar más detalles si lo necesitas
            ],
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
  if (defecto.abreviatura == "OTROS") {
    _showOtrosModal(context, defecto);
  } else {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            List<String> checkboxTitles = [
              'Calificación 1',
              'Calificación 2',
              'Calificación 3',
              'Cancelar',
            ];

            return Container(
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
                  // ... (mostrar más información del defecto)
                  SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: checkboxTitles.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Checkbox(
                          value:
                              false, // Aquí debes manejar el estado del checkbox

                          onChanged: (value) {
                            // Aquí puedes manejar el cambio de estado del checkbox
                          },
                        ),
                        title: Text(checkboxTitles[index]),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

void _showOtrosModal(BuildContext context, Defecto defecto) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, setState) {
          final IdentificationController _controller =
              IdentificationController();
          final TextEditingController _ob = TextEditingController();
          return Container(
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
                DropdownButton<int>(
                  value: 9, // Valor inicial del Dropdown (puedes ajustarlo)
                  onChanged: (int? newValue) {
                    setState(() {
                      // Aquí puedes manejar el cambio de valor del Dropdown
                    });
                  },
                  items: List.generate(
                    9, // Cantidad de ítems en el Dropdown (9 al 17)
                    (index) => DropdownMenuItem<int>(
                      value: index + 9,
                      child: Text((index + 9).toString()),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Image.asset('assets/images/carrito.png', width: 100, height: 100), // Ajusta el tamaño de la imagen según tus necesidades
                SizedBox(height: 16),
                TextField(
                  maxLines: 4,
                  controller: _ob,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Observación',
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _controller.saveIdentificationObservation(
                      context,
                      defecto.numero,
                      defecto.abreviatura,
                      defecto.descripcion,
                      defecto.codigoAs400,
                      _ob.text,
                    );
                  },
                  child: Text('Guardar'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void main() {
  runApp(MaterialApp(
    home: IdentificationView(),
  ));
}
