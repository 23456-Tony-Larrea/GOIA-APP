//create login and register using htpp
import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:rtv/constants/url2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    final String username = emailController.text;
    final String password = passwordController.text;

    final response = await http.post(
      Uri.parse('${url}/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'user': username,
          'pass': password,
          'estado': 1.toString()
        },
      ),
    );

    if (response.statusCode == 200) {
      final dynamic jsonResponse = jsonDecode(response.body);
      if (jsonResponse is List && jsonResponse.isNotEmpty) {
                  final firstObject = jsonResponse[0];

                   if (firstObject.containsKey('usua_codigo')){
                      final usuaCodigo = firstObject['usua_codigo'];
                      await usuaCodeSave('usua_codigo', usuaCodigo);
                   }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Inicio de sesión exitoso'),
              content:
                  const Text('El usuario se ha iniciado sesión exitosamente.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/identification');
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // El inicio de sesión fue fallido
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Inicio de sesión fallido'),
              content:
                  const Text('El usuario o la contraseña son incorrectos.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Ocurrió un error en la solicitud HTTP, maneja esto según tu necesidad
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error de conexión'),
            content: const Text('Hubo un error al conectar con el servidor.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
  Future<void> usuaCodeSave(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }
}
