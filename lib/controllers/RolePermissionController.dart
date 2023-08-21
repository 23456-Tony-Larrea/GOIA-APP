import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:rtv/constants/url.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rtv/class/Role.dart';
import 'package:rtv/class/Permission.dart';


class RolePemrissionController {
  final TextEditingController nameRoleController = TextEditingController();

  Future<void> addrole(BuildContext context) async {
    final response = await http.post(
      Uri.parse('${url}/roles'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'name': nameRoleController.text,
        },
      ),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 CREATED response,
      // then parse the JSON.
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      Fluttertoast.showToast(
          msg: "el rol a sido creado con exito",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      //alert que no se creo
      Fluttertoast.showToast(
          msg: "el rol no se pudo crear",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

//get role
  Future<List<Role>> getRoles() async {
    final response = await http.get(Uri.parse('${url}/roles'));
    if (response.statusCode == 200) {
      final List<dynamic> roles = jsonDecode(response.body);
      return roles.map((json) => Role.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load roles');
    }
  }

//update role
  Future<bool> updateRole(int roleId, String newRoleName) async {
    final response = await http.put(
      Uri.parse('${url}/roles/$roleId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'name': newRoleName,
        },
      ),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteRole(int roleId) async {
    final response = await http.delete(
      Uri.parse('${url}/roles/$roleId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return true; // Deletion successful
    } else {
      return false; // Deletion failed
    }
  }

 Future<List<Permission>> getPermissionByRoleId(int roleId) async {
  final response = await http.get(Uri.parse('${url}/role_permissions/$roleId'));
  if (response.statusCode == 200) {
    final List<dynamic> permissionsData = jsonDecode(response.body)['data'];
    final List<Permission> permissions = permissionsData.map((json) => Permission.fromJson(json)).toList();
    return permissions;
  } else {
    throw Exception('Failed to load role permissions');
  }
}
Future<bool> updateRolePermissionState(int roleId, int permissionId, bool newState) async {
  final response = await http.put(
    Uri.parse('${url}/roles/$roleId/permissions/$permissionId/state'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(
      <String, dynamic>{
        'newState': newState,
      },
    ),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
}
