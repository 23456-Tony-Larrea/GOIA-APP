import 'package:flutter/material.dart';
import 'package:rtv/views/LoginView.dart';
import 'package:rtv/views/BluetoohView.dart';
import 'package:rtv/ignore/UsersView.dart';
import 'package:rtv/views/IdentificationView.dart';
import 'package:rtv/views/VisualInspectionView.dart';
import 'package:rtv/views/HolgurasView.dart';
import 'package:rtv/views/MenuNotRolesView.dart';
import 'package:rtv/views/BluetoohPlusView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'RTV';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _title,
        home: TabBarViewNoRolesExample(),
        routes: {
          '/login': (context) => const LoginView(),
          '/bluetooh': (context) => BluetoothView(),
          '/bluetooh_plus': (context) => BluetoohPlusView(),
          '/menu': (context) => TabBarViewNoRolesExample(),
          '/users': (context) => UsersView(),
          '/identification': (context) => IdentificationView(),
          '/visual_inspection': (context) => VisualInspectionView(),
          '/holguras': (context) => HolgurasView(),
        });
  }
}
