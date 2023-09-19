import 'package:flutter/material.dart';
import 'package:rtv/views/identification/IdentificationView.dart';
import 'package:rtv/views/VisualInspection/VisualInspectionView.dart';
import 'package:rtv/views/Holguras/HolgurasView.dart';
import 'package:rtv/views/ExitView.dart';

class TabBarViewNoRolesExample extends StatefulWidget {
  @override
  _TabBarViewNoRolesExampleState createState() => _TabBarViewNoRolesExampleState();
}

class _TabBarViewNoRolesExampleState extends State<TabBarViewNoRolesExample> {
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
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          IdentificationView(),
          VisualInspectionView(),
          HolgurasView(),
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
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.car_crash_rounded,
              color: Colors.black,
            ),
            label: 'Identificación',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.remove_red_eye,
              color: Colors.black,
            ),
            label: 'Inspección Visual',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            label: 'Holguras',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
            label: 'Salir',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(color: Colors.black),
        unselectedLabelStyle: TextStyle(color: Colors.black),
      ),
    );
  }
}
