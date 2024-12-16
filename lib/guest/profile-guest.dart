import 'package:flutter/material.dart';
import '../login/login.dart';

void main() {
  runApp(ProfileGuest());
}

class ProfileGuest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(210.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue[900], // Dark blue background color
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0), // 10px radius on bottom left
                bottomRight:
                    Radius.circular(10.0), // 10px radius on bottom right
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 3), // Offset from top
                ),
              ],
            ),
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo.png', // Replace with your actual logo path
                    height: 100,
                    width: 120,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue.shade100, // Background color
                    onPrimary: Colors.blue, // Text color
                    padding: EdgeInsets.symmetric(
                        horizontal: 150, vertical: 20), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Button border radius
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
        body: Center(),
      ),
    );
  }
}
