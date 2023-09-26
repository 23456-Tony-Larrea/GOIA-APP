import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExitView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('¿Seguro que quieres cerrar sesión y borrar la información?'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Navigator.pop(context); // Cierra el diálogo
            final prefs = await SharedPreferences.getInstance();
            prefs.remove('vehi_codigo');
            prefs.remove('codeTV');
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text('Aceptar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context,'/menu');
          },
          child: Text('Cancelar'),
        ),
      ],
    );
  }
}