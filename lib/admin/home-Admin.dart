import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tilangkir/admin/tambahdoc.dart';
import 'viewA.dart';
import 'qrscanA.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(HomeAdmin());
}

class HomeAdmin extends StatefulWidget {
  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  TextEditingController _searchController = TextEditingController();

  get scanner => null;

  void _searchFirestore(String documentId) async {
    try {
      if (documentId.isNotEmpty) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('data_kendaraan')
            .doc(documentId)
            .get();

        if (snapshot.exists) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyViewPage(
                documentId: documentId,
              ),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Dokumen Tidak Ditemukan'),
                content: Text('Dokumen dengan ID $documentId tidak ditemukan.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (error) {
      print('Error searching Firestore: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Terjadi kesalahan saat mencari data di Firestore.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _scanQR() async {
    try {
      String result = await scanner.scan();

      if (result.isNotEmpty) {
        _searchController.text = result;
        _searchFirestore(result);
      } else {
        // Handle empty result
      }
    } catch (error) {
      print('Error scanning QR code: $error');
      // Handle error
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(210.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue[900],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                    width: 120,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.qr_code),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QRScanner()),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 14),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      _searchFirestore(_searchController.text);
                    },
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 0, 11, 165), // Background color
              onPrimary: Color.fromARGB(255, 255, 255, 255), // Text color
              padding: EdgeInsets.symmetric(
                  horizontal: 130, vertical: 20), // Button padding
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(10.0), // Button border radius
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TambahDataPage()),
              );
            },
            child: Text('Tambah Kendaraan'),
          ),
        ),
      ),
    );
  }
}
