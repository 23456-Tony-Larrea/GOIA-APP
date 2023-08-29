import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rtv/class/Cars.dart';
import 'package:rtv/constants/url2.dart';
import 'package:rtv/class/ListProcedure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IdentificationController {
  String? vehiCodigo;
  List<dynamic> listProcedure = [];
  List<dynamic> listDefects = [];
  final TextEditingController placaController = TextEditingController();
  bool codeRTV = true;
  Cars? carData;
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

    int vehiCodigo; // Declarar vehiCodigo en este alcance
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      final Map<String, dynamic> firstElement = jsonResponse[0];
      vehiCodigo = firstElement['vehi_codigo'];

      Fluttertoast.showToast(
        msg: "El carro ha sido buscado con éxito",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      carData = await getInformationCar(vehiCodigo);
      await getRegisterRTV(vehiCodigo);
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
          await saveCodeRTV('codeTV', rtvCode);
          print('Código RTV: $rtvCode'); // Imprimir el código RTV
          await lisProcedure();
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

  Future<List<ListProcedure>> lisProcedure() async {
    try {
      if (codeRTV) { 
      final response = await http.post(
        Uri.parse('${url}/listarProcedimientos'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'tipo': 1,
          'estado': 1,
        }),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);

        final List<ListProcedure> procedures = [];
        for (final procedureJson in jsonResponse) {
          final ListProcedure procedure = ListProcedure.fromJson(procedureJson);
          procedures.add(procedure);
        }

        print("Lista de Procedimientos: $procedures");

        // Separar los procedimientos en dos listas diferentes
        List<ListProcedure> procedureList0 = [];
        List<ListProcedure> procedureList1 = [];
        if (procedures.isNotEmpty) {
          procedureList0.add(procedures[0]);
        }
        if (procedures.length > 1) {
          procedureList1.add(procedures[1]);
        }

        // Imprimir o realizar acciones con los procedimientos separados
        print("Procedimiento 0: $procedureList0");
        print("Procedimiento 1: $procedureList1");

        return procedures;
      } else {
        print('Error: ${response.statusCode}');
        throw Exception('Failed to load procedures');
      }
       } else {
      Fluttertoast.showToast(
        msg: "el vehiculo no tiene RTV",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
        webPosition: "center",
        
      );
      throw Exception('Vehicle has no RTV');
    } 
    } catch (e) {
      print(e);
      throw Exception('An error occurred');
    }
  }

  Future<void> saveCodeRTV(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  Future<void> saveIdentificationObservation(BuildContext build , String numero , String abreviatura , String descripcion ,String Codigo_as400, String observation) async {
    final data = [
      {
        "vehi_codigo":vehiCodigo,
        "codigoRTV":codeRTV
      },
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
              'numero': numero,
              'abreviatura': abreviatura,
              'descripcion': descripcion,
              'Codigo_as400': Codigo_as400,
              'observacion': observation
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
            'defectoEncontrado': {
              'numero': numero,
              'abreviatura': abreviatura,
              'descripcion': descripcion,
              'Codigo_as400': Codigo_as400,
              'observacion': observation
            }
          },
    ];
    try {
      final response = await http.post(
        Uri.parse('${url}/GuardarIdentificacion'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
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
