import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  bool isLoading = false;
  bool hasSearched = false;
    bool _saving = false; // variable para controlar el estado del ProgressBar
      bool isTextFieldEnabled = true; // Add this variable to track the TextField's enabled state
    bool isClearIconEnabled = false; // Initialize the variable to false





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
        for (int i = 0; i < 500; i++) {
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
            for (var procedures in _procedureLists) {
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
          builder: (context) => CalificationVisualWidget(defecto: defecto),
        ),
      ).then((value) {
        // Aquí actualizas el estado de isRated cuando el usuario califica
        if (value == true) {
          setState(() {
            for (var procedures in _procedureLists) {
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
        title: Text('Inspección Visual'),
        actions: [
          Visibility(
  visible: _procedureLists.isNotEmpty && _controller.carData != null,
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
      await Future.delayed(Duration(seconds: 3)); // esperamos 3 segundos
      Navigator.of(context).pop(); // cerramos el AlertDialog
              Fluttertoast.showToast(
          msg: "Inspección visual guardada con exito ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      setState(() {
        _saving = false; // cambiamos el estado del ProgressBar a false
      });
    },
    child: _saving ? CircularProgressIndicator() : Icon(Icons.save),
    mini: true,
     backgroundColor: Colors.greenAccent,
  ),
),
         FloatingActionButton(
              child: Icon(
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
                            mini: true,
                                              backgroundColor: Colors.redAccent,


            ),
            
        ],
        automaticallyImplyLeading: false,
        
      ),
      body:
       Stack(  // Utilizamos un Stack para colocar la imagen de fondo
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondo.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),  // Ajusta la opacidad aquí
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
      Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
Row(
  children: [
    Expanded(
      child: TextField(
        controller: _controller.placaController,
        decoration: InputDecoration(
          labelText: 'Digite la placa', // Add the label text
        ),
        textCapitalization: TextCapitalization.characters,
        enabled: isTextFieldEnabled, // Use the variable to enable or disable the TextField
        onChanged: (value) {
          setState(() {
            if (value.isEmpty) {
              isClearIconEnabled = false; // Disable the clear icon if the TextField is empty
            } else {
              isClearIconEnabled = true; // Enable the clear icon if the TextField is not empty
            }
          });
        },
      ),
    ),
    SizedBox(width: 16),
    FloatingActionButton(
      onPressed: () async {
        if (hasSearched) { // Check if a search has been performed
          _controller.placaController.clear();
          hasSearched = false;
          setState(() {
            _controller.carData = null;
            _procedureLists.clear();
            isTextFieldEnabled = true; // Enable the TextField after clear
          });
        } else {
          showDialog(
            context: context,
            barrierDismissible: false, // Prevent the user from dismissing the dialog
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Cargando RTV, Por favor espere...'),
              );
            },
          );

          await _controller.searchVehicle(
            context,
            _controller.placaController.text,
          );
          await _loadProcedures();
          Navigator.pop(context); // Close the dialog
          setState(() {
            hasSearched = true;
            isTextFieldEnabled = false; // Disable the TextField after search
          });
        }
      },
      child: hasSearched // Use the variable to change the icon
          ? Icon(Icons.clear)
          : Icon(Icons.search),
                                backgroundColor: Colors.orangeAccent,

    ),
  ],
),
              SizedBox(height: 2),
              if (_controller.carData != null)
              Card(
                    elevation: 4,
                     color: Color(0xFFF0F0F0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Card(
                          color: Colors.blue,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.info,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  'Información del vehículo',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoFieldWithIcon(
                                      'Marca',
                                      _controller.carData!.marca,
                                      Icons
                                          .directions_car, // Icono para la marca
                                    ),
                                    _buildInfoFieldWithIcon(
                                      'Modelo',
                                      _controller.carData!.modelo,
                                      Icons.car_rental, // Icono para el modelo
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoFieldWithIcon(
                                      'Nombre',
                                      _controller.carData!.cliente,
                                      Icons.person, // Icono para el cliente
                                    ),
                                    _buildInfoFieldWithIcon(
                                      'Cédula',
                                      _controller.carData!.cedula,
                                      Icons.credit_card, // Icono para la cédula
                                    ),
                                  ],
                                ),
                              ),
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
                              hasSearched = false;
                              isTextFieldEnabled = true;

                            });
                          },
                          child: Text('Realizar una nueva consulta'),
                        ),
                      ],
                    ),
                  ),
                ),
                                  if (_procedureLists.isNotEmpty &&
                            _controller.carData != null)
      
Row(
  children: [

    Icon(Icons.list), // Reemplaza "Icons.list" con el icono que desees
    Text(
      'Lista de Defectos',
      style: TextStyle(
        fontSize: 16, // Ajusta el tamaño de fuente según tus preferencias
        fontWeight: FontWeight.bold,
      ),
    ),
      SizedBox(
      width: 10, // Ancho del SizedBox
    ),

            Flexible(
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          decoration: InputDecoration(
            hintText: 'Buscar por código',
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          keyboardType: TextInputType.number,
        ),
        suggestionsCallback: (pattern) async {
          final suggestions = _procedureLists
              .expand((procedures) => procedures)
              .where((procedure) =>
                  "${procedure.familia}${procedure.subfamilia}${procedure.categoria}"
                      .toLowerCase()
                      .contains(pattern.toLowerCase()))
              .toList();
          return suggestions;
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Row(
              children: [
                Row(
                  children: [
                    Text(
                      "${suggestion.familia}${suggestion.subfamilia}${suggestion.categoria}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
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
          );
        },
        onSuggestionSelected: (suggestion) {
          _showDefectsModal(context, suggestion.defectos, suggestion.procedimiento);
        },
      ),
    ),
  ],
),
              SizedBox(height: 8.0),
             if (_procedureLists.isNotEmpty && _controller.carData != null)
  Expanded(
    child: SingleChildScrollView(
      child: Column(
        children: [
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
                ],
          ),
bottomNavigationBar: BottomNavigationBar(
  currentIndex: 1,
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
      icon: ClipRRect(
        borderRadius: BorderRadius.circular(20), // Personaliza el radio de curvatura aquí
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.blue, // Color de fondo
          child: Icon(Icons.car_crash_rounded, color: Colors.white), // Icono
        ),
      ),
      label: 'Identificación',
    ),
    BottomNavigationBarItem(
      icon: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.blue, 
          child: Icon(Icons.remove_red_eye, color: Colors.white),
        ),
      ),
      label: 'Inspección Visual',
    ),
    BottomNavigationBarItem(
      icon: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.blue,
          child: Icon(Icons.settings, color: Colors.white),
        ),
      ),
      label: 'Holguras',
    ),
  ],
)
    ),
    );
  }

  Widget _buildInfoFieldWithIcon(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon, // Aquí se muestra el icono
            color: Colors
                .black, // Puedes ajustar el color del icono según tus preferencias
            size:
                24, // Puedes ajustar el tamaño del icono según tus preferencias
          ),
          SizedBox(width: 8), // Espacio entre el icono y el texto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4), // Espacio entre el label y el TextField
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  enabled: false, // Deshabilitamos el campo de texto
                  controller: TextEditingController(text: value),
                ),
              ],
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
