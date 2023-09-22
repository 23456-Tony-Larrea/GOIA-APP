import 'package:flutter/material.dart';
import 'package:rtv/views/LoginView.dart';
import 'package:rtv/views/identification/IdentificationView.dart';
import 'package:rtv/views/VisualInspection/VisualInspectionView.dart';
import 'package:rtv/views/Holguras/HolgurasView.dart';
import 'package:rtv/views/BluetoohSerialView.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'RTV';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _title,
        home: LoginView(),
        routes: {
          '/login': (context) => const LoginView(),

          '/identification': (context) => IdentificationView(),
          '/visual_inspection': (context) => VisualInspectionView(),
          '/holguras': (context) => HolgurasView(),
          '/bluetooh_serial': (context) => BluetoothScreen(),
        });
  }
}
