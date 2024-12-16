import 'package:flutter/material.dart';
import 'admin/home-Admin.dart';
import 'admin/profile-Admin.dart';

void main() {
  runApp(BottomNavbarA());
}

class BottomNavbarA extends StatefulWidget {
  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbarA> {
  int _currentIndex = 0; // To keep track of the selected tab

  // Define your pages here (you can replace these with your actual pages)
  final List<Widget> _pages = [
    HomeAdmin(),
    ProfileAdmin(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _pages[_currentIndex], // Display the selected page
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
            // Handle tab selection
            setState(() {
              _currentIndex = index;
            });
          },
          // Change color when selected
          selectedItemColor: Colors.blue, // Selected tab color
          unselectedItemColor: Colors.grey, // Unselected tab color
        ),
      ),
    );
  }
}
