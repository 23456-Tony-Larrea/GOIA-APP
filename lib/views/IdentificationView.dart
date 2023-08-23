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
                      _controller.carData = null; // Limpiamos la información del vehículo
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await _controller.searchVehicle(context, _controller.placaController.text);
                 await _getProcedures();
                setState(() {}); // Actualiza la vista después de obtener los datos
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoField('Marca', _controller.carData!.marca),
                          _buildInfoField('Modelo', _controller.carData!.modelo),
                          _buildInfoField('Cliente', _controller.carData!.cliente),
                          _buildInfoField('Cédula', _controller.carData!.cedula),
                          
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
                            _controller.carData = null; // Limpiamos la información del vehículo
                          });
                        },
                        child: Text('Realizar una nueva consulta'),
                      ),
                    ],
                  ),
                ),
              ),
    Card(
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: Text(
                  'Items',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _procedures.length,
                itemBuilder: (context, index) {
                  final procedure = _procedures[index];
                  return ListTile(
                    
                    title: Text(procedure.procedimiento),
                    subtitle: Text(procedure.abreviatura),
                    // ... otros detalles del procedimiento ...
                  );
                },
              ),
            ],
          ),
        )
    
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
        setState(() {//itera en 0 
          _procedures = procedures;

        });
      }
    } catch (error) {
      print(error);
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: IdentificationView(),
  ));
}
