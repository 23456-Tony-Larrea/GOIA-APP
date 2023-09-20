import 'package:flutter/material.dart';
import 'package:rtv/class/ListProcedureVisualInspection.dart';
import 'package:rtv/controllers/VisualInspectionController.dart';

class OtrosHolgurasWidget extends StatefulWidget {
  final Defecto defecto;

  OtrosHolgurasWidget({required this.defecto});

  @override
  _OtrosHolgurasWidgetState createState() => _OtrosHolgurasWidgetState();
}

class _OtrosHolgurasWidgetState extends State<OtrosHolgurasWidget> {
    final VisualInspectionController _controller = VisualInspectionController();
  final _obFocusNode = FocusNode();
  final TextEditingController _ob = TextEditingController();


  List<int> selectedLocations = [];
 int? selectedCalification = null;  

  @override
  void dispose() {
    _obFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calificacion'),
      ),
      body: SingleChildScrollView(
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
                  'Defecto: ${widget.defecto.abreviatura}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Text('Descripción: ${widget.defecto.descripcion}'),
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
                          title: Text(
                              'Calificación:${selectedCalification ?? 'Sin calificación'}'),
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
                    _controller.saveIdentificationVisualInspectionObservation(
                      context,
                      widget.defecto.codigo,
                      widget.defecto.numero,
                      widget.defecto.abreviatura,
                      widget.defecto.descripcion,
                      widget.defecto.codigoAs400,
                      _ob.text,
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
      ),
    );
  }
}