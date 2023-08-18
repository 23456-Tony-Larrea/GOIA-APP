import 'package:flutter/material.dart';
import 'package:rtv/views/RolePermissionView.dart';
import 'package:rtv/views/UsersView.dart';
import 'package:rtv/views/IdentificationView.dart';
import 'package:rtv/views/VisualInspectionView.dart';
import 'package:rtv/views/HolgurasView.dart';
import 'package:rtv/views/LlantasView.dart';
import 'package:rtv/views/ExitView.dart';

class TabBarViewExample extends StatefulWidget {
  @override
  _TabBarViewExampleState createState() => _TabBarViewExampleState();
}

class _TabBarViewExampleState extends State<TabBarViewExample> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roles y Permisos'),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          RolesView(), // Vista de la pestaña "Roles"
          UsersView(),
          IdentificationView(),
          VisualInspectionView(),
          HolgurasView(),
          LlantasView(),
          ExitView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            );
          });
        },
        items: _buildBottomNavBarItems(),
        selectedItemColor:
            Colors.black, // Cambia el color del ícono seleccionado
        unselectedItemColor:
            Colors.black, // Cambia el color del ícono no seleccionado
        selectedLabelStyle: TextStyle(
            color:
                Colors.black), // Cambia el color del texto (label) seleccionado
        unselectedLabelStyle: TextStyle(
            color: Colors
                .black), // Cambia el color del texto (label) no seleccionado
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para el botón flotante de acción (FAB)
        },
        child: Icon(Icons.add,
            color: Colors.black), // Cambia el color del ícono del FAB a negro
        backgroundColor:
            Colors.white, // Cambia el color de fondo del FAB a blanco
      ),
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavBarItems() {
    List<BottomNavigationBarItem> items = [];
    List<String> tabTitles = [
      'Roles y permisos',
      'Usuarios',
      'Identificación',
      'Inspección Visual',
      'Holguras',
      'Llantas',
      'Salir'
    ];

    for (int i = 0; i < tabTitles.length; i++) {
      items.add(
        BottomNavigationBarItem(
          icon: Icon(
            _getTabIcon(i),
            color: Colors.black, // Cambia el color del ícono a negro
          ),
          label: tabTitles[i],
        ),
      );
    }

    return items;
  }

  // Función para obtener el ícono correspondiente a cada pestaña
  IconData _getTabIcon(int index) {
    switch (index) {
      case 0:
        return Icons
            .lock; // Icono de usuario con candado para la pestaña "Roles"
      case 1:
        return Icons.people; // Icono de personas para la pestaña "Usuarios"
      case 2:
        return Icons
            .car_crash_rounded; // Icono de identificación para la pestaña "Identificación"
      // Agrega aquí los íconos para las otras pestañas
      case 3:
        return Icons.remove_red_eye;
      case 4:
        return Icons.settings;
      case 5:
        return Icons.directions_car;
      case 6:
        return Icons.exit_to_app;
      default:
        return Icons
            .circle; // Icono por defecto (círculo) para otras pestañas no definidas
    }
  }
}
