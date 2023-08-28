  import 'package:flutter/material.dart';
  import 'package:rtv/views/RolePermissionView.dart';
  import 'package:rtv/views/UsersView.dart';
  import 'package:rtv/views/IdentificationView.dart';
  import 'package:rtv/views/VisualInspectionView.dart';
  import 'package:rtv/views/HolgurasView.dart';
  import 'package:rtv/views/LlantasView.dart';
  import 'package:rtv/views/ExitView.dart';
  import 'package:rtv/controllers/PermissionViewController.dart';

  class TabBarViewExample extends StatefulWidget {
    @override
    _TabBarViewExampleState createState() => _TabBarViewExampleState();
  }

  class _TabBarViewExampleState extends State<TabBarViewExample> {
    int _currentIndex = 0;
    late PageController _pageController;
    late PermissionController _permissionController;

    @override
    void initState() {
      super.initState();
      _pageController = PageController(initialPage: _currentIndex);
      _permissionController = PermissionController();
      testDecodingToken();
    }

    void testDecodingToken() async {
      await _permissionController.getUserRoleAndPermissions();
      print('User role: ${_permissionController.userRole}');
      print('User role_id: ${_permissionController.userRoleId}');
      await _permissionController.getUserPermissions(_permissionController.userRoleId);
      setState(() {}); // Actualizar la vista después de obtener permisos
    }

    @override
    void dispose() {
      _pageController.dispose();
      super.dispose();
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

    int validTabCount = 0; // Contador de pestañas válidas

    for (int i = 0; i < tabTitles.length; i++) {
      if (_shouldShowTab(tabTitles[i])) {
        validTabCount++;
        items.add(
          BottomNavigationBarItem(
            icon: Icon(
              _getTabIcon(i),
              color: Colors.black,
            ),
            label: tabTitles[i],
          ),
        );
      }
    }

    // Si solo hay una pestaña válida o ninguna, agrega una pestaña vacía para evitar el error
    if (validTabCount <= 1) {
      items.add(
        BottomNavigationBarItem(
          icon: SizedBox.shrink(), // Pestaña vacía
          label: '',
        ),
      );
    }

    return items;
  }


    bool _shouldShowTab(String tabTitle) {
      if (tabTitle == 'Roles y permisos' || tabTitle == 'Usuarios') {
        return _permissionController.userRole == 'superAdministrador';
      } else {
        switch (tabTitle) {
          case 'Identificación':
            return _permissionController.isPermissionAllowed('identificacion');
          case 'Inspección Visual':
            return _permissionController.isPermissionAllowed('inspeccion visual');
          case 'Holguras':
            return _permissionController.isPermissionAllowed('holguras');
          case 'Llantas':
            return _permissionController.isPermissionAllowed('llantas');
          default:
            return true;
        }
      }
    }

    IconData _getTabIcon(int index) {
      switch (index) {
        case 0:
          return Icons.lock;
        case 1:
          return Icons.people;
        case 2:
          return Icons.car_crash_rounded;
        case 3:
          return Icons.remove_red_eye;
        case 4:
          return Icons.settings;
        case 5:
          return Icons.directions_car;
        case 6:
          return Icons.exit_to_app;
        default:
          return Icons.circle;
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            if (_shouldShowTab('Roles y permisos'))
              RolesView(), // Vista de la pestaña "Roles"
            if (_shouldShowTab('Usuarios')) UsersView(),
            if (_shouldShowTab('Identificación')) IdentificationView(),
            if (_shouldShowTab('Inspección Visual')) VisualInspectionView(),
            if (_shouldShowTab('Holguras')) HolgurasView(),
            if (_shouldShowTab('Llantas')) LlantasView(),
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
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          selectedLabelStyle: TextStyle(color: Colors.black),
          unselectedLabelStyle: TextStyle(color: Colors.black),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Lógica para el botón flotante de acción (FAB)
          },
          child: Icon(Icons.add, color: Colors.black),
          backgroundColor: Colors.white,
        ),
      );
    }
  }
