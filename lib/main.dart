import 'package:flutter/material.dart';

import 'package:rtv/views/LoginView.dart';

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
      home: const LoginView(),
    );
  }
}

