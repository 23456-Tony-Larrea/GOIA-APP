//create login and register using htpp
import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:rtv/constants/url.dart';

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
          'username': username,
          'password': password,
        },
      ),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 CREATED response,
      // then parse the JSON.
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      // Mostrar un AlertDialog solo si el usuario se registra correctamente
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
                  Navigator.pushNamed(context, '/menu');
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      //show dialog login incorrecto
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Inicio de sesión fallido'),
            content: const Text('El usuario o la contraseña son incorrectos.'),
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
}
