import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rtv/constants/url2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigHostController {
  final TextEditingController configController = TextEditingController();
  final TextEditingController hostController = TextEditingController();

  Future<void> addConfig(BuildContext context) async {
    final response = await http.post(
      Uri.parse('${url}/datoEstacion'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'host': configController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Guardar los valores en SharedPreferences

      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse is List && jsonResponse.isNotEmpty) {
        final firstObject = jsonResponse[0];

        if (firstObject.containsKey('esta_ip') &&
            firstObject.containsKey('esta_host') &&
            firstObject.containsKey('esta_codigo')) {
          final estaIp = firstObject['esta_ip'];
          final estaHost = firstObject['esta_host'];
          final estaCodigo = firstObject['esta_codigo'];
          final hostIp = "http://${hostController.text}";
          await saveHostToSharedPreferences('esta_ip', estaIp);
          await saveHostToSharedPreferences('esta_host', estaHost);
          await saveHostToSharedPreferences('host_ip', hostIp);
          await saveEstaCodeToSharedPreferences('esta_codigo', estaCodigo);
        }
      }
      Fluttertoast.showToast(
          msg: "el host ha sido guardado con éxito",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "el host no se pudo guardar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  // Función para guardar el valor en SharedPreferences
  Future<void> saveHostToSharedPreferences(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getHostFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('esta_ip');
  }

  //usa int para guardar esta_codigo en SharedPreferences
  Future<void> saveEstaCodeToSharedPreferences(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }
}
