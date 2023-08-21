import 'package:flutter/material.dart';

/* import 'package:rtv/views/LoginView.dart'; */
import 'package:rtv/views/LoginView.dart';
import 'package:rtv/views/BluetoohView.dart';
import 'package:rtv/views/MenuView.dart';
import 'package:rtv/views/UsersView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'RTV';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: _title, home:TabBarViewExample(), routes: {
      '/login': (context) => const LoginView(),
      '/bluetooh': (context) => BluetoothView(),
      '/menu': (context) => TabBarViewExample(),
      '/users': (context) => UsersView(),
    });
  }
}
