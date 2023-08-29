import 'package:flutter/material.dart';

class HolgurasView extends StatefulWidget {
  @override
  _HolgurasViewState createState() => _HolgurasViewState();
}

class _HolgurasViewState extends State<HolgurasView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Holguras'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 16.0, right: 16.0),
        child: Align(
          alignment: Alignment.topRight,
          child: FloatingActionButton(
            onPressed: () {},
            child: PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'test_vehicle',
                    child: Text('Testear Vehículo'),
                  ),
                ];
              },
              onSelected: (String value) {
                if (value == 'test_vehicle') {
                  Navigator.pushNamed(context, '/bluetooh'); // Replace with your actual navigation logic
                }
              },
              child: Icon(Icons.directions_car),
            ),
          ),
        ),
      ),
    );
  }
}