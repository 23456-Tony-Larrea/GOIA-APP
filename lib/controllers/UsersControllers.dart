import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:rtv/constants/url.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rtv/class/Users.dart';
import 'package:rtv/class/Role.dart';

class UsersController {
  final TextEditingController nameUserController = TextEditingController();
  final TextEditingController passwordUserController = TextEditingController();

  Future<void> addUser(BuildContext context, int roleId) async {
    final response = await http.post(
      Uri.parse('${url}/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'username': nameUserController.text,
          'password':'123456',
          'role_id': roleId,
        },
      ),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 CREATED response,
      // then parse the JSON.
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      Fluttertoast.showToast(
          msg: "el usuario a sido creado con exito",
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

  //get users
  Future<List<Users>> getUsers() async {
    final response = await http.get(Uri.parse('${url}/users'));
    if (response.statusCode == 200) {
      final List<dynamic> users = jsonDecode(response.body);
      return users.map((json) => Users.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  //edit users
Future<void> updateUsers(BuildContext context, int usersId, String newUsersName, int role_id) async {
  bool success = await http
      .put(
    Uri.parse('${url}/users/$usersId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      <String, dynamic>{
        'username': newUsersName,
        'role_id': role_id,
      },
    ),
  )
      .then((response) {
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }).catchError((error) {
    print("Error updating user: $error");
    return false;
  });

  if (success) {
    Navigator.pop(context); // Close the dialog on success
    // You might want to show a success message or update the user list here
  } else {
    // Show an error message or handle the error case
  }
}
  //delete users
  Future<bool> deleteUsers(int usersId) {
    return http.put(
      Uri.parse('${url}/users/activate/$usersId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    });
  }

  // get roles
  Future<List<Role>> getRoles() async {
    final response = await http.get(Uri.parse('${url}/roles'));
    if (response.statusCode == 200) {
      final List<dynamic> roles = jsonDecode(response.body);
      return roles.map((json) => Role.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load roles');
    }
  }
}
