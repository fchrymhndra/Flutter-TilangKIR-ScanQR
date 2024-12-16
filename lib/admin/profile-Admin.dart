import 'package:flutter/material.dart';
import 'package:tilangkir/admin/rekapdata.dart';
import 'package:tilangkir/login/login.dart';

void main() {
  runApp(ProfileAdmin());
}

class ProfileAdmin extends StatelessWidget {
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
                SizedBox(height: 20), // Add spacing
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary:
                        Color.fromARGB(255, 66, 152, 209), // Background color
                    onPrimary: Color.fromARGB(255, 255, 255, 255), // Text color
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
                      MaterialPageRoute(builder: (context) => RekapData()),
                    );
                  },
                  child: Text('Rekap Data'),
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 182, 0, 0), // Background color
              onPrimary: Color.fromARGB(255, 255, 255, 255), // Text color
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
            child: Text('Logout'),
          ),
        ),
      ),
    );
  }
}
