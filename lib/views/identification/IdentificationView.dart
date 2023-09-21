import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rtv/controllers/IdentificationController.dart';
import 'package:rtv/views/identification/CalificationIdentificationView.dart';
import 'package:rtv/views/identification/CalificationOtrosIdentificationView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../class/ListProcedure.dart';

class IdentificationView extends StatefulWidget {
  @override
  _IdentificationViewState createState() => _IdentificationViewState();
}

class _IdentificationViewState extends State<IdentificationView> {
  final IdentificationController _controller = IdentificationController();
  List<List<ListProcedure>> _procedures = [];

  Defecto? selectedDefecto;
  DefectoEncontrado? defectoEncontrado;

  @override
  void initState() {
    super.initState();
    clearCodeTVFromSharedPreferences();
  }
 Future<void> _getProcedures() async {
    
    try {
      List<ListProcedure> procedures = await _controller.lisProcedure();

      if (procedures.isNotEmpty) {
        for (int i = 0; i < 265; i++) {
          _procedures.add(procedures
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

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Identificación'), // Cambia el título del AppBar
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
if (_procedures.isNotEmpty)
  Card(
    elevation: 4,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var procedures in _procedures)
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                ), // Espacio entre el título y el subtítulo
                                Text(
                                  "${procedure.procedimiento}", // Agrega el subtítulo aquí
                                  overflow: TextOverflow.ellipsis, // Manejo del desbordamiento
                                  maxLines: 2, // Número máximo de líneas antes de mostrar el desbordamiento
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: Colors.grey, // Puedes personalizar el color y estilo según tus necesidades
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
  )

            ],
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
            // Usar un ListView con physics para permitir el desplazamiento
            ListView.builder(
              shrinkWrap: true,
              itemCount: defectos.length,
              physics: BouncingScrollPhysics(), // O AlwaysScrollableScrollPhysics()
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
    builder: (context) => OtrosWidget(defecto: defecto),
  ),
);
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewPageWidget(defecto: defecto),
      ),
    );
  }
}
