import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:rtv/constants/url2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rtv/class/Cars.dart';

class IdentificationController {
  String? vehiCodigo;
  List<dynamic> listProcedure = [];
  List<dynamic> listDefects = [];
  final TextEditingController placaController = TextEditingController();
  bool codeRTV = true;
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
      // If the server did return a 200 CREATED response,
      // then parse the JSON.
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      vehiCodigo = jsonResponse['vehi_codigo'][0]['vehi_codigo'];

      print(jsonResponse);

      Fluttertoast.showToast(
          msg: "el carro a sido buscado con exito",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      //alert que no se creo
      Fluttertoast.showToast(
          msg: "el usuario no se pudo crear",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<List<Cars>> getInformationCar() async {
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
      final List<dynamic> cars = jsonDecode(response.body);
      return cars.map((json) => Cars.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cars');
    }
  }

  Future<List<Cars>> getRegisterRTV() async {
    final response = await http.post(
      Uri.parse('${url}/GetRegistroRTV'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'vehi_codigo': vehiCodigo,
      }),
    );
    if (response.statusCode == 200) {
      final List<dynamic> cars = jsonDecode(response.body);
      return cars.map((json) => Cars.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cars');
    }
  }

  Future<void> lisProcedure() async {
    try {
      if (codeRTV) {
        final response = await http.post(
          Uri.parse('/listarProcedimientos'), // Replace with your API endpoint
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'tipo': 1,
            'estado': 1,
          }),
        );
        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          listProcedure = json.decode(response.body);
          listDefects = json.decode(response.body);
          print(listProcedure);
        } else {
          print('Error: ${response.statusCode}');
        }
      } else {
        Fluttertoast.showToast(
            msg: "el vehiculo no tiene RTV",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }
  
}
