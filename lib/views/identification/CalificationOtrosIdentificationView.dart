import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:rtv/class/ListProcedure.dart';
import 'package:rtv/controllers/IdentificationController.dart';

class OtrosWidget extends StatefulWidget {
  final Defecto defecto;

  OtrosWidget({required this.defecto});

  @override
  _OtrosWidgetState createState() => _OtrosWidgetState();
}

class _OtrosWidgetState extends State<OtrosWidget> {
  final IdentificationController _controller = IdentificationController();
  final _obFocusNode = FocusNode();
  final _kilometrajeFocusNode = FocusNode();
  final _kilometrajeController = TextEditingController();
  final TextEditingController _ob = TextEditingController();



  List<int> selectedLocations = [];
  int? selectedCalification = null;

  @override
  void dispose() {
    _obFocusNode.dispose();
    _kilometrajeFocusNode.dispose();
    _kilometrajeController.dispose();
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
            _kilometrajeFocusNode.unfocus();
          },
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
Center(
  child: Card(
    elevation: 4, // Ampliar el Card
    child: ListTile(
      leading: Icon(Icons.info), // Agregar un icono
      title: Text(
        'Defecto: ${widget.defecto.abreviatura}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      subtitle: Text('Descripción: ${widget.defecto.descripcion}'),
    ),
  ),
),

                SizedBox(height: 16),
                MultiSelectFormField(
                  chipBackGroundColor: Colors.blue,
                  chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                  dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  checkBoxActiveColor: Colors.blue,
                  checkBoxCheckColor: Colors.white,
                  dialogShapeBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  title: Text('Elige las ubicaciones'),
                  dataSource: List.generate(
                    9,
                    (index) => {
                      "display": (index + 9).toString(),
                      "value": index + 9,
                    },
                  ),
                  textField: 'display',
                  valueField: 'value',
                  okButtonLabel: 'Aceptar',
                  cancelButtonLabel: 'Cancelar',
                  hintWidget: Text('Selecciona una o varias ubicaciones'),
                  initialValue: selectedLocations,
                  onSaved: (value) {
                    if (value == null) return;
                    setState(() {
                      selectedLocations = List<int>.from(value);
                    });
                  },
                ),
                SizedBox(height: 16),
                Image.asset(
                  'assets/images/carrito.png',
                  width: 400,
                  height: 400,
                ),
                SizedBox(height: 16),
TextFormField(
  controller: _ob,
  maxLines: 3,
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Observación',
  ),
  textCapitalization: TextCapitalization.characters,
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    } else if (value.length < 10) {
      return 'Debe contener al menos 10 caracteres';
    }
    return null;
  },
   onChanged: (value) {
    setState(() {}); // Actualiza el estado para reflejar los cambios en el texto
  },
),
Text(
  'Caracteres escritos: ${_ob.text.length}/10',
  style: TextStyle(
    color: Colors.grey,
  ),
),
                SizedBox(height: 16),
                Card(
                  // Card para la calificación
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Calificación',
                            style: TextStyle(fontSize: 16)),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<int>(
                              title: Text('Tipo 1',
                                  style: TextStyle(fontSize: 13)),
                              value: 1,
                              groupValue: selectedCalification,
                              onChanged: (value) {
                                setState(() {
                                  selectedCalification = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<int>(
                              title: Text('Tipo 2',
                                  style: TextStyle(fontSize: 13)),
                              value: 2,
                              groupValue: selectedCalification,
                              onChanged: (value) {
                                setState(() {
                                  selectedCalification = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<int>(
                              title: Text('Tipo 3',
                                  style: TextStyle(fontSize: 13)),
                              value: 3,
                              groupValue: selectedCalification,
                              onChanged: (value) {
                                setState(() {
                                  selectedCalification = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<int>(
                              title: Text('Cancelar',
                                  style: TextStyle(fontSize: 13)),
                              value: 4,
                              groupValue: selectedCalification,
                              onChanged: (value) {
                                setState(() {
                                  selectedCalification = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton.icon(
                          onPressed: (selectedCalification == null || _ob.text.length < 10)
                        ? null // Desactivar el botón si no hay calificación
                        : () {
                            _controller.saveIdentificationObservation(
                              context,
                              widget.defecto.codigo,
                              widget.defecto.numero,
                              widget.defecto.abreviatura,
                              widget.defecto.descripcion,
                              widget.defecto.codigoAs400,
                              _ob.text,
                              _kilometrajeController.text,
                              selectedLocations.join(','),
                              selectedCalification,
                            );
                                                        Navigator.of(context).pop(true);
                          },
                    icon: Icon(Icons.save),
                    label: Text('Guardar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
