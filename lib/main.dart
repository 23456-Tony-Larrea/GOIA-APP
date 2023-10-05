import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rtv/views/LoginView.dart';
import 'package:rtv/views/identification/IdentificationView.dart';
import 'package:rtv/views/VisualInspection/VisualInspectionView.dart';
import 'package:rtv/views/Holguras/HolgurasView.dart';
import 'package:rtv/views/BluetoohSerialView.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'RTV';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
   _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
  if (result == ConnectivityResult.none) {
    Fluttertoast.showToast(
      msg: "No hay conexión a Internet",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 10,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
});
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
  title: MyApp._title,
  home: LoginView(),
  routes: {
    '/login': (context) => LoginView(),
    '/identification': (context) => IdentificationView(),
    '/visual_inspection': (context) => VisualInspectionView(),
    '/holguras': (context) => HolgurasView(),
    '/bluetooh_serial': (context) => BluetoothScreen(),
  },
);
  }
}