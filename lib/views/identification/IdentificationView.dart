import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rtv/controllers/IdentificationController.dart';
import 'package:rtv/views/ExitView.dart';
import 'package:rtv/views/identification/CalificationIdentificationView.dart';
import 'package:rtv/views/identification/CalificationOtrosIdentificationView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../class/Image.dart';
import '../../class/ListProcedure.dart';
import '../../class/Trama.dart';
import '../../controllers/HolgurasBluetoohController.dart';
import 'dart:convert';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';

class IdentificationView extends StatefulWidget {
  @override
  _IdentificationViewState createState() => _IdentificationViewState();
}

class _IdentificationViewState extends State<IdentificationView> {
  final IdentificationController _controller = IdentificationController();
  List<List<ListProcedure>> _procedures = [];
  final HolgurasBluetoothController _sendBluetooh =
      HolgurasBluetoothController();
  Defecto? selectedDefecto;
  DefectoEncontrado? defectoEncontrado;
  bool isLoading = false;
  bool hasSearched = false;
  bool _saving = false; // variable para controlar el estado del ProgressBar
  List<XFile> _photos = [];
  late Future<void> _initializeControllerFuture;
  late CameraController _controller2;
  final ImageStorage imageStorage = ImageStorage(); // Instancia de ImageStorage
  final TextEditingController _kilometrajeController = TextEditingController();

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller2 = CameraController(firstCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller2.initialize();
  }

  @override
  void initState() {
    super.initState();
    clearCodeTVFromSharedPreferences();
    _sendBluetooh.sendTrama(TramaType.Apagar);
    _initializeCamera();
  }

  Future<void> _getProcedures() async {
    try {
      List<ListProcedure> procedures = await _controller.lisProcedure();

      if (procedures.isNotEmpty) {
        for (int i = 0; i < 500; i++) {
          _procedures.add(
              procedures.where((procedure) => procedure.numero == i).toList());
        }
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  void _showMaxPhotosAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Límite de fotos alcanzado'),
          content: Text('Puedes tomar un máximo de 1 a 5 fotos.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
  }

  void clearCodeTVFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('codeTV');
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Intercepta el evento de retroceso y realiza la acción que desees,
        // en este caso, puedes no hacer nada para desactivar el botón de retroceso nativo.
        return false; // Cambia esto a true si deseas permitir la navegación de retroceso nativa.
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Identificación'),
          actions: [
            Visibility(
              visible: _procedures.isNotEmpty && _controller.carData != null,
              child: FloatingActionButton(
                onPressed: () async {
                  setState(() {
                    _saving =
                        true; // cambiamos el estado del ProgressBar a true
                  });
                  _controller.placaController.clear();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('vehi_kilometraje');

                  setState(() {
                    _controller.carData = null;
                    _controller.searchCompleted = false;
                    hasSearched = false;
                    //limpiar el inpur de kilometraje
                    _kilometrajeController.clear();
                  });
                  openModal();
                  await Future.delayed(
                      Duration(seconds: 3)); // esperamos 3 segundos
                  Navigator.of(context).pop(); // cerramos el AlertDialog
                  Fluttertoast.showToast(
                    msg: "Identificación guardada con exito",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.greenAccent,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  setState(() {
                    _saving =
                        false; // cambiamos el estado del ProgressBar a false
                  });
                },
                child: _saving ? CircularProgressIndicator() : Icon(Icons.save),
                mini: true,
              ),
            ),
            IconButton(
              icon: Icon(
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
            ),
          ],
          automaticallyImplyLeading: false,
        ),
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
                        hasSearched = false;
                        _kilometrajeController.clear();
                        setState(() {
                          _controller.carData =
                              null; // Limpiamos la información del vehículo
                          _controller.searchCompleted = false;
                          //limpiar procedures
                          _procedures.clear();
                          hasSearched = false;
                        });
                      },
                    ),
                  ),
                  textCapitalization: TextCapitalization.characters),
              SizedBox(height: 16.0),
              Stack(
                children: [
                  SizedBox(
                    width: 580.0,
                    child: ElevatedButton(
                      onPressed: hasSearched
                          ? null
                          : () async {
                              setState(() {
                                isLoading = true;
                              });

                              await _controller.searchVehicle(
                                  context, _controller.placaController.text);
                              await _getProcedures();
                              setState(() {
                                isLoading = false;
                                hasSearched = true;
                              });
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isLoading)
                            SizedBox(
                              width: 24.0,
                              height: 24.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 3.0,
                              ),
                            ),
                          SizedBox(width: isLoading ? 8.0 : 0.0),
                          Text(
                            isLoading
                                ? 'Cargando RTV, por favor espere...'
                                : 'Buscar',
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.white.withOpacity(0.5),
                        child: Center(
                          child: SizedBox(
                            width: 48.0,
                            height: 48.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 4.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
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
                            SizedBox(height: 16),
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
                              _controller.carData = null;
                              _controller.searchCompleted = false;
                              hasSearched = false;
                            });
                          },
                          child: Text('Realizar una nueva consulta'),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_procedures.isNotEmpty && _controller.carData != null)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // Alinea al centro verticalmente
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons
                                            .info_outline), // Icono del título
                                        title: Text(
                                            'Items a considerar'), // Título del Card
                                      ),
                                      SizedBox(height: 16),
                                      TextFormField(
                                        controller: _kilometrajeController,
                                        decoration: InputDecoration(
                                          labelText: 'Kilometraje',
                                          prefixIcon: Icon(Icons
                                              .directions_car), // Icono de carro
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly, // Permite solo números
                                        ],
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          _controller.updateKilometraje(value);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment
                                      .center, // Alinea el botón al centro verticalmente
                                  child: FloatingActionButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Cámara'),
                                            content: FutureBuilder<void>(
                                              future:
                                                  _initializeControllerFuture,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  return CameraPreview(
                                                      _controller2); // Muestra la vista previa de la cámara
                                                } else {
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }
                                              },
                                            ),
                                            contentPadding: EdgeInsets.only(
                                                left:
                                                    16), // Alinea el contenido a la izquierda
                                            actions: [
                                              Align(
                                                alignment: Alignment
                                                    .topLeft, // Alinea el icono a la izquierda
                                                child: IconButton(
                                                  icon:
                                                      Icon(Icons.photo_camera),
                                                  onPressed: () async {
                                                    if (_photos.length >= 5) {
                                                      _showMaxPhotosAlert();
                                                    } else {
                                                      if (_controller2.value
                                                          .isInitialized) {
                                                        try {

final XFile photo = await _controller2.takePicture();

// Read the image as bytes
final File imageFile = File(photo.path);
final List<int> imageBytes = await imageFile.readAsBytes();

// Convert the image to JPEG format
final img.Image? image = img.decodeImage(Uint8List.fromList(imageBytes));
final List<int> jpegBytes = img.encodeJpg(image!);

// Convert the bytes to a base64 string and add the filename
final String base64Image = base64Encode(jpegBytes);
imageStorage.addBase64Image(base64Image);

setState(() {
  _photos.add(photo);
});
                                                        } catch (e) {
                                                          print(
                                                              'Error al tomar la foto: $e');
                                                        }
                                                      }
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Icon(Icons.camera_alt),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        if (_photos.isNotEmpty)
                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text('Fotos Tomadas',
                                      style: TextStyle(fontSize: 16)),
                                ),
                               SizedBox(
  height: 100, // Altura de la lista horizontal
  child: ListView.builder(
    scrollDirection: Axis.horizontal, // Dirección horizontal
    itemCount: _photos.length,
    itemBuilder: (context, index) {
      final photo = _photos[index];
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Image.file(
              File(photo.path),
              width: 100, // Ancho de cada imagen
              height: 100, // Altura de cada imagen
              fit: BoxFit.cover, // Ajuste de la imagen
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _removePhoto(index);
                  });
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      );
    },
  ),
),
                              ],
                            ),
                          ),
                        TypeAheadField(
                          textFieldConfiguration: TextFieldConfiguration(
                              decoration: InputDecoration(
                                hintText: 'Buscar por codigo',
                              ),
                              textCapitalization:
                                  TextCapitalization.characters),
                          suggestionsCallback: (pattern) async {
                            final suggestions = _procedures
                                .expand((procedures) => procedures)
                                .where((procedure) =>
                                    "${procedure.familia}${procedure.subfamilia}${procedure.categoria}"
                                        .toLowerCase()
                                        .contains(pattern.toLowerCase()))
                                .toList();
                            return suggestions;
                          },
                          itemBuilder: (context, suggestion) {
                            return Card(
                              child: ListTile(
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
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            _showDefectsModal(context, suggestion.defectos,
                                suggestion.procedimiento);
                          },
                        ),
                        SizedBox(height: 16),
                        Card(
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var procedures in _procedures)
                                for (var procedure in procedures)
                                  GestureDetector(
                                    onTap: () {
                                      _showDefectsModal(
                                          context,
                                          procedure.defectos,
                                          procedure.procedimiento);
                                    },
                                    child: Card(
                                      elevation: 4,
                                      color: procedure.isRated
                                          ? Colors.lightBlueAccent
                                          : null,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "${procedure.familia}${procedure.subfamilia}${procedure.categoria}",
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        "${procedure.categoriaDescripcion}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(
                                                        "${procedure.procedimiento}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
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
              icon: Icon(Icons.car_crash_rounded),
              label: 'Identificación',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.remove_red_eye),
              label: 'Inspección Visual',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Holguras',
            ),
          ],
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

  void _showDefectoModal(BuildContext context, Defecto defecto) {
    if (defecto.abreviatura == "OTROS") {
      Navigator.of(context)
          .push(MaterialPageRoute(
        builder: (context) => OtrosWidget(defecto: defecto),
      ))
          .then((value) {
        // Aquí actualizas el estado de isRated cuando el usuario califica
        if (value == true) {
          setState(() {
            for (var procedures in _procedures) {
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
          builder: (context) => NewPageWidget(defecto: defecto),
        ),
      ).then((value) {
        // Aquí actualizas el estado de isRated cuando el usuario califica
        if (value == true) {
          setState(() {
            for (var procedures in _procedures) {
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
                  fontSize: 16,
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
