import 'package:flutter/material.dart';
import '../class/ListProcedure.dart';
import '../controllers/IdentificationController.dart';

class CalificacionViewWidget extends StatelessWidget {
  final Defecto defecto; // Asegúrate de importar y definir la clase Defecto aquí
   List<int> selectedLocations = [];
  int? selectedCalification = 1;
  final IdentificationController _controller = IdentificationController();
  final TextEditingController _kilometrajeC = TextEditingController();
  final FocusNode _obFocusNode = FocusNode();
  final FocusNode _kilometrajeFocusNode = FocusNode();

  CalificacionViewWidget({required this.defecto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Título de la página'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
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

                              SizedBox(height: 16),
                              Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text('Calificación'),
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
                                  _controller.saveIdentification(
                                    context,
                                    defecto.codigo,
                                    defecto.numero,
                                    defecto.abreviatura,
                                    defecto.descripcion,
                                    defecto.codigoAs400,
                                    _kilometrajeC.text,
                                    selectedLocations.join(','),
                                    selectedCalification,
                                  );
                                },
                                child: Text('Guardar'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
          child: Text('Mostrar modal'),
        ),
      ),
    );
  }
}
