import 'package:flutter/material.dart';
import 'guest/home-guest.dart';
import 'guest/profile-guest.dart';

void main() {
  runApp(BottomNavbar());
}

class BottomNavbar extends StatefulWidget {
  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _currentIndex = 0; // To keep track of the selected tab

  // Define your pages here (you can replace these with your actual pages)
  final List<Widget> _pages = [
    HomeGuest(),
    ProfileGuest(),
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
