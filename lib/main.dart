import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
/* import 'package:rtv/views/LoginView.dart'; */
import 'package:rtv/views/LoginView.dart';
import 'package:rtv/views/BluetoohView.dart';
import 'package:rtv/views/MenuView.dart';
import 'package:rtv/views/UsersView.dart';
import 'package:rtv/views/IdentificationView.dart';
import 'package:rtv/redux/reducer.dart';
void main() {
   final store = Store<AppState>(
    appReducer, // Esto es el reducer principal de tu aplicación
    initialState: AppState(rtvCode:0), // Estado inicial
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'RTV';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: _title, home:  LoginView(), routes: {
      '/login': (context) => const LoginView(),
      '/bluetooh': (context) => BluetoothView(),
      '/menu': (context) => TabBarViewExample(),
      '/users': (context) => UsersView(),
      '/identification': (context) => IdentificationView(),
    });
  }
}
