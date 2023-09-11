import 'package:flutter/material.dart';
/* import 'package:rtv/views/LoginView.dart'; */
import 'package:rtv/views/LoginView.dart';
import 'package:rtv/views/BluetoohView.dart';
import 'package:rtv/ignore/MenuView.dart';
import 'package:rtv/views/UsersView.dart';
import 'package:rtv/views/IdentificationView.dart';
import 'package:rtv/views/VisualInspectionView.dart';
import 'package:rtv/views/HolgurasView.dart';
import 'package:rtv/views/MenuNotRolesView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'RTV';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: _title, home: LoginView(), routes: {
      '/login': (context) => const LoginView(),
      '/bluetooh': (context) => BluetoothView(),
      '/menu': (context) => TabBarViewNoRolesExample(),
      '/users': (context) => UsersView(),
      '/identification': (context) => IdentificationView(),
      '/visual_inspection': (context) => VisualInspectionView(),
      '/holguras': (context) => HolgurasView(),
    });
  }
}
