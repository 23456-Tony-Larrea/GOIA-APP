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
      int codeRTV =
          prefs.getInt('codeTV') ?? 0; 

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
          final List<ListProcedureInspection> visualInspection = [];
          for (final inspectionProcedure in jsonResponse) {
            final ListProcedureInspection visualProcedure =
                ListProcedureInspection.fromJson(inspectionProcedure);
            visualInspection.add(visualProcedure);
          }
          print("Lista de Procedimientos: $visualInspection");
          List<ListProcedureInspection> procedureList0 = [];
          List<ListProcedureInspection> procedureList1 = [];
          List<ListProcedureInspection> procedureList2 = [];
          List<ListProcedureInspection> procedureList3 = [];
          List<ListProcedureInspection> procedureList4 = [];
          List<ListProcedureInspection> procedureList5 = [];
          List<ListProcedureInspection> procedureList6 = [];
          List<ListProcedureInspection> procedureList7 = [];
          List<ListProcedureInspection> procedureList8 = [];
          List<ListProcedureInspection> procedureList9 = [];
          List<ListProcedureInspection> procedureList10 = [];
          List<ListProcedureInspection> procedureList11 = [];
          List<ListProcedureInspection> procedureList12 = [];
          List<ListProcedureInspection> procedureList13 = [];
          List<ListProcedureInspection> procedureList14 = [];
          List<ListProcedureInspection> procedureList15 = [];
          List<ListProcedureInspection> procedureList16 = [];
          List<ListProcedureInspection> procedureList17 = [];
          List<ListProcedureInspection> procedureList18 = [];
          if (visualInspection.isNotEmpty) {
            procedureList0.add(visualInspection[0]);
          }
          if (visualInspection.length > 1) {
            procedureList1.add(visualInspection[1]);
          }
          if (visualInspection.length > 2) {
            procedureList2.add(visualInspection[2]);
          }
          if (visualInspection.length > 3) {
            procedureList3.add(visualInspection[3]);
          }
          if (visualInspection.length > 4) {
            procedureList4.add(visualInspection[4]);
          }
          if (visualInspection.length > 5) {
            procedureList5.add(visualInspection[5]);
          }
          if (visualInspection.length > 6) {
            procedureList6.add(visualInspection[6]);
          }
          if (visualInspection.length > 7) {
            procedureList7.add(visualInspection[7]);
          }
          if (visualInspection.length > 8) {
            procedureList8.add(visualInspection[8]);
          }
          if (visualInspection.length > 9) {
            procedureList9.add(visualInspection[9]);
          }
          if (visualInspection.length > 10) {
            procedureList10.add(visualInspection[10]);
          }
          if (visualInspection.length > 11) {
            procedureList11.add(visualInspection[11]);
          }
          if (visualInspection.length > 12) {
            procedureList12.add(visualInspection[12]);
          }
          if (visualInspection.length > 13) {
            procedureList13.add(visualInspection[13]);
          }
          if (visualInspection.length > 14) {
            procedureList14.add(visualInspection[14]);
          }
          if (visualInspection.length > 15) {
            procedureList15.add(visualInspection[15]);
          }
          if (visualInspection.length > 16) {
            procedureList16.add(visualInspection[16]);
          }
          if (visualInspection.length > 17) {
            procedureList17.add(visualInspection[17]);
          }
          if (visualInspection.length > 18) {
            procedureList18.add(visualInspection[18]);
          }
          //using return
          return visualInspection;
        } else {
          //using toast
          Fluttertoast.showToast(
            msg: "Failed to load procedures",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          throw Exception('Failed to load procedures');
        }
    /*   } else {
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
      } */
    } catch (e) {
      print(e);
      throw Exception('An error occurred');
    }
  }
}
