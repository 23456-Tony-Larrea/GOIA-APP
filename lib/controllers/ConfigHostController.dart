import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rtv/constants/url2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigHostController {
  final TextEditingController configController = TextEditingController();

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
      final estaIp = jsonResponse[0]['esta_ip'];
      final estaHost = jsonResponse[0]['esta_host'];
      final host = "http://192.168.2.68:8080";

      await saveHostToSharedPreferences('esta_ip', estaIp);
      await saveHostToSharedPreferences('esta_host', estaHost);
      await saveHostToSharedPreferences('host', host);

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
}