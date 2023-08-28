import 'dart:convert';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rtv/class/ListProcedureVisualInspection.dart';
import 'package:rtv/constants/url2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisualInspectionController {
  Future<List<ListProcedureInspection>> listInspectionProcedure() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int codeRTV = prefs.getInt('codeTV') ?? 0;
      
      /* if (codeRTV != 0) { */
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
    /*   } else {
        _showToast("el vehiculo no tiene RTV");
        throw Exception('Vehicle has no RTV');
      } */
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
}
