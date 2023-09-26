import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:rtv/class/ListProcedureVisualInspection.dart';
import 'package:rtv/controllers/VisualInspectionController.dart';

class CalificationVisualWidget extends StatefulWidget {
  final Defecto defecto;

  CalificationVisualWidget({required this.defecto});

  @override
  _CalificationVisualInspectionWidgetState createState() => _CalificationVisualInspectionWidgetState();
}

class _CalificationVisualInspectionWidgetState extends State<CalificationVisualWidget> {
    final VisualInspectionController _controller = VisualInspectionController();

  List<int> selectedLocations = [];
 int? selectedCalification = null;  

  @override
  void dispose() {

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
                  width: 250,
                  height: 250,
                ),
                    SizedBox(height: 16),
Card(
  // Card para la calificación
  child: Column(
    children: [
      ListTile(
        title: Text('Calificación', style: TextStyle(fontSize: 16)),
      ),
      Row(
        children: [
          Expanded(
            child: RadioListTile<int>(
              title: Text('Tipo 1', style: TextStyle(fontSize: 13)),
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
              title: Text('Tipo 2', style: TextStyle(fontSize: 13)),
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
              title: Text('Tipo 3', style: TextStyle(fontSize: 13)),
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
              title: Text('Cancelar', style: TextStyle(fontSize: 13)),
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
    onPressed: () {
      _controller.saveVisualInspection(
        context,
        widget.defecto.codigo,
        widget.defecto.numero,
        widget.defecto.abreviatura,
        widget.defecto.descripcion,
        widget.defecto.codigoAs400,
        selectedLocations.join(','),
        selectedCalification,
      );
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