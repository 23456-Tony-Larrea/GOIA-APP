import 'dart:convert';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rtv/class/ListProcedureVisualInspection.dart';
import 'package:rtv/constants/url2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../class/Cars.dart';


class VisualInspectionController {
   final TextEditingController placaController = TextEditingController();
  bool codeRTV = true;
  Cars? carData;
  int? savedRtvCode;
  int? _userRoleId;
  int? vehiCodigo;

final TextEditingController observationController = TextEditingController();

  Future<void> searchVehicle(BuildContext context, String placa) async {
    final response = await http.post(
      Uri.parse('${url}/GetCodVehiculo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'placa': placaController.text,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      final Map<String, dynamic> firstElement = jsonResponse[0];
      this.vehiCodigo = firstElement['vehi_codigo'];
      await saveVehi_code('vehi_codigo', this.vehiCodigo ?? 0);

      Fluttertoast.showToast(
        msg: "El carro ha sido buscado con éxito",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      carData = await getInformationCar(this.vehiCodigo ?? 0);
      await getRegisterRTV(this.vehiCodigo ?? 0);
    } else {
      // Alert que no se pudo encontrar el vehículo
      Fluttertoast.showToast(
        msg: "El vehículo no se pudo encontrar",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
Future<Cars> getInformationCar(int vehiCodigo) async {
    final response = await http.post(
      Uri.parse('${url}/GetDatoVehiculo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'vehi_codigo': vehiCodigo,
      }),
    );
    if (response.statusCode == 200) {
      final List<dynamic> carDataList = jsonDecode(response.body);
      final dynamic firstCarData = carDataList.first;
      return Cars.fromJson(firstCarData);
    } else {
      throw Exception('Failed to load car');
    }
  }

  Future<void> getRegisterRTV(int vehiCodigo) async {
    try {
      final response = await http.post(
        Uri.parse('${url}/ObtenerRegistroRTV'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'vehi_codigo': vehiCodigo,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> carsRTV = jsonDecode(response.body);

        if (carsRTV.isNotEmpty && carsRTV[0]['codigo'] != null) {
          int rtvCode = carsRTV[0]['codigo'];
          savedRtvCode = rtvCode;
          await saveCodeRTV('codeTV', rtvCode);
          await listInspectionProcedure();
        } else {
          codeRTV = false;
          Fluttertoast.showToast(
            msg: "el vehiculo no tiene RTV",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } else {
        throw Exception('Failed to load cars');
      }
    } catch (error) {
      print(error);
    }
  }
  Future<List<ListProcedureInspection>> listInspectionProcedure() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int codeRTV = prefs.getInt('codeTV') ?? 0;
      if (codeRTV != 0) { 
        final response = await http.post(
          Uri.parse('${url}/listarProcedimientos'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'tipo': 2,
            'estado': 1,
          }),
        );

        if (response.statusCode == 200) {
          final List<dynamic> jsonResponse = jsonDecode(response.body);
          final List<ListProcedureInspection> visualInspection =
              jsonResponse.map((data) => ListProcedureInspection.fromJson(data)).toList();

          print("Lista de Procedimientos: $visualInspection");
          
          if (visualInspection.isNotEmpty) {
            return visualInspection;
          } else {
            _showToast("Failed to load procedures");
            throw Exception('Failed to load procedures');
          }
        } else {
          _showToast("Failed to load procedures");
          throw Exception('Failed to load procedures');
        }
     } else {
        _showToast("el vehiculo no tiene RTV");
        throw Exception('Vehicle has no RTV');
      } 
    } catch (e) {
      print(e);
      throw Exception('An error occurred');
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  Future<void> saveCodeRTV(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  Future<void> saveVehi_code(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }
 Future<void> getUserRoleAndPermissions() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'helllo_token');

    if (token != null) {
      try {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        _userRoleId = decodedToken['role_id']; // Almacena el role_id
      } catch (error) {
        print('Error decoding token: $error');
      }
    }
  }
  Future<void> saveIdentificationVisualInspectionObservation(
    BuildContext build,
    int codigo,
    String numero,
    String abreviatura,
    String descripcion,
    String Codigo_as400,
    String observation,
    String KM,
    String ubicaciones,
    int calificacion, // Agrega la calificación
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? estaHost = prefs.getString('esta_host');
    DateTime now = DateTime.now();
    String formattedDate = now.toLocal().toString().split('.')[0];
    await getUserRoleAndPermissions();
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    int? codeRTVexample = prefs2.getInt('codeTV');
    int? vehiCodigo2 = prefs2.getInt('vehi_codigo');
    try {
      final response = await http.post(
        Uri.parse('${url}/GuardarInspeccionVisual'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "rete_codigo": codeRTVexample,
          "vehi_codigo": vehiCodigo2,
          "kilometraje": KM,
          "dato": jsonEncode([
            {
              "codigo": 1,
              "numero": 1,
              "familia": 1,
              "subfamilia": "1",
              "abreviatura": "IDENTIFICACION",
              "abreviatura_descripcion": "IDENTIFICACION DEL VEHICULO",
              "subfamilia_descripcion": "NUMERO DE PLACA",
              "categoria": "01",
              "categoria_abreviatura": "NUMERO DE PLACA",
              "categoria_descripcion": "NUMERO DE PLACA",
              "procedimiento":
                  "COMPROBAR EL ESTADO, FIJACION Y UBICACION DE LAS PLACAS. CONSTATAR QUE EL NUMERO DE PLACA CORRESPONDE A LA DOCUMENTACION.",
              "defectos": [
                {
                  "codigo": 10,
                  "abreviatura": "OTROS",
                  "descripcion":
                      "OTROS(A INTRODUCIR POR EL INSPECTOR DE LINEA)",
                  "numero": "01",
                  "codigo_as400": "010101"
                },
                {
                  "codigo": 11,
                  "abreviatura": "CORRESPONDE",
                  "descripcion":
                      "NÚMERO DE PLACA NO COINCIDE CON LA DOCUMENTACIÓN",
                  "numero": "02",
                  "codigo_as400": "010102"
                },
                {
                  "codigo": 12,
                  "abreviatura": "EXIST/DETERIORO",
                  "descripcion": "PLACAS INEXISTENTES O DETERIORADAS.",
                  "numero": "03",
                  "codigo_as400": "010103"
                },
                {
                  "codigo": 13,
                  "abreviatura": "ILEGIBLE",
                  "descripcion": "PLACAS ILEGIBLES",
                  "numero": "04",
                  "codigo_as400": "010104"
                },
                {
                  "codigo": 14,
                  "abreviatura": "POSICIÓN",
                  "descripcion":
                      "PLACAS SITUADAS EN POSICIÓN O LUGAR INCORRECTO.",
                  "numero": "05",
                  "codigo_as400": "010105"
                },
                {
                  "codigo": 15,
                  "abreviatura": "SUJECIÓN",
                  "descripcion": "DEFECTOS DE SUJECIÓN EN LAS PLACAS",
                  "numero": "06",
                  "codigo_as400": "010106"
                }
              ],
              "defectoEncontrado": {
                "numero": numero,
                "abreviatura": abreviatura,
                "descripcion": descripcion,
                "codigo_as400": Codigo_as400,
                "ubicacion": ubicaciones,
                "calificacion": calificacion,
                "observacion": observation
              }
            },
            {
              "codigo": 2,
              "numero": 2,
              "familia": 1,
              "subfamilia": "2",
              "abreviatura": "IDENTIFICACION",
              "abreviatura_descripcion": "IDENTIFICACION DEL VEHICULO",
              "subfamilia_descripcion": "NUMERO DE CHASIS O VIN",
              "categoria": "01",
              "categoria_abreviatura": "NUMERO DE CHASIS O VIN",
              "categoria_descripcion": "NUMERO DE CHASIS O VIN",
              "procedimiento":
                  "COMPROBAR LA COINCIDENCIA DEL NÚMERO VISUALIZADO EN EL VEHICULO CON LA DOCUMENTACION (PARTE DEL TRABAJO)",
              "defectos": [
                {
                  "codigo": 16,
                  "abreviatura": "OTROS",
                  "descripcion":
                      "OTROS (A INTRODUCIR POR EL INSPECTOR DE LÍNEA )",
                  "numero": "01",
                  "codigo_as400": "010201"
                },
                {
                  "codigo": 17,
                  "abreviatura": "NO CORRESPONDE",
                  "descripcion":
                      "NÚMERO DE CHASIS NO COINCIDE CON LA DOCUMENTACIÓN.",
                  "numero": "02",
                  "codigo_as400": "010202"
                }
              ],
              "defectoEncontrado": {
                "numero": "",
                "abreviatura": "",
                "descripcion": "",
                "codigo_as400": "",
                "ubicacion": "",
                "calificacion": "",
                "observacion": ""
              }
            }
          ]),
          "fotos": jsonEncode([
            {"f": "", "filename": "", "filepath": ""},
            {"f": "", "filename": "", "filepath": ""}
          ]),
          "fecha_inicio": formattedDate,
          "usua_codigo": _userRoleId,
          "esta_host": estaHost
        }),
      );
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "La identificación ha sido creada con éxito",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(build);
      } else {
        Fluttertoast.showToast(
          msg: "La identificación no se pudo crear",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print(e);
      throw Exception('An error occurred');
    }
  }

  Future<void> saveVisualInspection(
    BuildContext build,
    int codigoIdentification,
    String numeroIdentification,
    String abreviaturaIdentification,
    String descripcionIdentification,
    String Codigo_as400Identification,
    String kmIdentification,
    String ubicacionesIdentification,
    int calificacionIdentification, // Agrega la calificación
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? estaHost = prefs.getString('esta_host');
    DateTime now = DateTime.now();
    String formattedDate = now.toLocal().toString().split('.')[0];
    await getUserRoleAndPermissions();
    SharedPreferences prefs2 = await SharedPreferences.getInstance();
    int? codeRTVexample = prefs2.getInt('codeTV');
    int? vehiCodigo2 = prefs2.getInt('vehi_codigo');
  try {
      final response = await http.post(
        Uri.parse('${url}/GuardarInspeccionVisual'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
                  "rete_codigo": codeRTVexample,
        "vehi_codigo": vehiCodigo2,
        "kilometraje": kmIdentification,
        "dato":jsonEncode([
          {
            "codigo": 1,
            "numero": 1,
            "familia": 1,
            "subfamilia": "1",
            "abreviatura": "IDENTIFICACION",
            "abreviatura_descripcion": "IDENTIFICACION DEL VEHICULO",
            "subfamilia_descripcion": "NUMERO DE PLACA",
            "categoria": "01",
            "categoria_abreviatura": "NUMERO DE PLACA",
            "categoria_descripcion": "NUMERO DE PLACA",
            "procedimiento":
                "COMPROBAR EL ESTADO, FIJACION Y UBICACION DE LAS PLACAS. CONSTATAR QUE EL NUMERO DE PLACA CORRESPONDE A LA DOCUMENTACION.",
            "defectos": [
              {
                "codigo": 10,
                "abreviatura": "OTROS",
                "descripcion": "OTROS(A INTRODUCIR POR EL INSPECTOR DE LINEA)",
                "numero": "01",
                "codigo_as400": "010101"
              },
              {
                "codigo": 11,
                "abreviatura": "CORRESPONDE",
                "descripcion":
                    "NÚMERO DE PLACA NO COINCIDE CON LA DOCUMENTACIÓN",
                "numero": "02",
                "codigo_as400": "010102"
              },
              {
                "codigo": 12,
                "abreviatura": "EXIST/DETERIORO",
                "descripcion": "PLACAS INEXISTENTES O DETERIORADAS.",
                "numero": "03",
                "codigo_as400": "010103"
              },
              {
                "codigo": 13,
                "abreviatura": "ILEGIBLE",
                "descripcion": "PLACAS ILEGIBLES",
                "numero": "04",
                "codigo_as400": "010104"
              },
              {
                "codigo": 14,
                "abreviatura": "POSICIÓN",
                "descripcion":
                    "PLACAS SITUADAS EN POSICIÓN O LUGAR INCORRECTO.",
                "numero": "05",
                "codigo_as400": "010105"
              },
              {
                "codigo": 15,
                "abreviatura": "SUJECIÓN",
                "descripcion": "DEFECTOS DE SUJECIÓN EN LAS PLACAS",
                "numero": "06",
                "codigo_as400": "010106"
              }
            ],
            "defectoEncontrado": {
             "numero": "",
              "abreviatura": "",
              "descripcion": "",
              "codigo_as400": "",
              "ubicacion": "",
              "calificacion": "",
              "observacion": ""
            }
          },
          {
            "codigo": 2,
            "numero": 2,
            "familia": 1,
            "subfamilia": "2",
            "abreviatura": "IDENTIFICACION",
            "abreviatura_descripcion": "IDENTIFICACION DEL VEHICULO",
            "subfamilia_descripcion": "NUMERO DE CHASIS O VIN",
            "categoria": "01",
            "categoria_abreviatura": "NUMERO DE CHASIS O VIN",
            "categoria_descripcion": "NUMERO DE CHASIS O VIN",
            "procedimiento":
                "COMPROBAR LA COINCIDENCIA DEL NÚMERO VISUALIZADO EN EL VEHICULO CON LA DOCUMENTACION (PARTE DEL TRABAJO)",
            "defectos": [
              {
                "codigo": 16,
                "abreviatura": "OTROS",
                "descripcion":
                    "OTROS (A INTRODUCIR POR EL INSPECTOR DE LÍNEA )",
                "numero": "01",
                "codigo_as400": "010201"
              },
              {
                "codigo": 17,
                "abreviatura": "NO CORRESPONDE",
                "descripcion":
                    "NÚMERO DE CHASIS NO COINCIDE CON LA DOCUMENTACIÓN.",
                "numero": "02",
                "codigo_as400": "010202"
              }
            ],
            "defectoEncontrado": {
                  "numero": numeroIdentification,
              "abreviatura": abreviaturaIdentification,
              "descripcion": descripcionIdentification,
              "codigo_as400": Codigo_as400Identification,
              "ubicacion": ubicacionesIdentification,
              "calificacion": calificacionIdentification,
              "observacion":""
            }
          }
        ]),
        "fotos": jsonEncode([
          {"f": "", "filename": "", "filepath": ""},
          {"f": "", "filename": "", "filepath": ""}
         ]),
        "fecha_inicio": formattedDate,
        "usua_codigo": _userRoleId,
           "esta_host":estaHost
        }),
      );
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "La identificación ha sido creada con éxito",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(build);
      } else {
        Fluttertoast.showToast(
          msg: "La identificación no se pudo crear",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print(e);
      throw Exception('An error occurred');
    } 
  }

}
