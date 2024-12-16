import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bottomnavbarA.dart';
import '../bottomnavbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Login());
}

class User {
  final String email;
  final String password;

  User({required this.email, required this.password});
}

class AuthManager {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<bool> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true; // Login berhasil
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
      return false; // Login gagal
    }
  }
}

class Login extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigasi ke halaman ProfileGuest
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BottomNavbar(),
                ),
              );
            },
          ),
          title: Text('Login'),
          backgroundColor: Colors.blue[900],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.blue[900],
          ),
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 380,
                  maxHeight: 355,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/logoapk.png',
                        height: 80,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          String email = _emailController.text;
                          String password = _passwordController.text;

                          bool loginSuccess =
                              await AuthManager.signInWithEmailAndPassword(
                                  email, password);

                          if (loginSuccess) {
                            // Navigate to admin page if login is successful
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNavbarA(),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Login Gagal'),
                                  content: Text('Email atau Password salah.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Text('Login'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
