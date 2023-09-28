import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
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
  bool canPop = false;

  @override
  void dispose() {
    _obFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
 return WillPopScope(
    onWillPop: () async {
      // Evita que el usuario retroceda si no ha calificado.
       if (!canPop) {
      // Mostrar un diálogo o mensaje que indique que debe calificar y guardar.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Calificación obligatoria'),
            content: Text('Debes calificar antes de salir.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
    // Impide retroceder si canPop es false.
    return canPop;
    },
    child:Scaffold(
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
                  TextField(
                    controller: _ob,
                    focusNode: _obFocusNode,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Observación',
                    ),
                    textCapitalization: TextCapitalization.characters
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
      onPressed:selectedCalification == null
        ? null // Desactivar el botón si no hay calificación
        : () {
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
         setState(() {
    canPop = true;
  });
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
    )
    );
  }
}