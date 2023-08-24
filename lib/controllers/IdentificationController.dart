import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rtv/class/Cars.dart';
import 'package:rtv/constants/url2.dart';
import 'package:rtv/class/ListProcedure.dart';

class IdentificationController {
  String? vehiCodigo;
  List<dynamic> listProcedure = [];
  List<dynamic> listDefects = [];
  final TextEditingController placaController = TextEditingController();
  bool codeRTV = true;
  Cars? carData;

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
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
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
          print('Código RTV: $rtvCode'); // Imprimir el código RTV
        await lisProcedure();
        } else {
          print('No se encontró código RTV en la respuesta');
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
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw Exception('Vehicle has no RTV');
    }
  } catch (e) {
    print(e);
    throw Exception('An error occurred');
  }
}
}
