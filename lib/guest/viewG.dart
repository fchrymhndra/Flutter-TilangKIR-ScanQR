import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tilangkir/bottomnavbar.dart';
import 'package:tilangkir/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ViewDataApp());
}

class ViewDataApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyViewPage(
        documentId: '',
      ),
    );
  }
}

class MyViewPage extends StatefulWidget {
  final String documentId;

  MyViewPage({required this.documentId, Object? data, Object? documentData});

  @override
  _MyViewPageState createState() => _MyViewPageState();
}

class _MyViewPageState extends State<MyViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Data'),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BottomNavbar()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: fetchData(widget.documentId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.exists) {
              var data = snapshot.data!.data() as Map<String, dynamic>;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'DATA KENDARAAN',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.all(7.0),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(13.0),
                      leading: Icon(Icons.directions_car, size: 48.0),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nama: ${data['nama']}'),
                          Text('NIK: ${data['nik']}'),
                          Text('Alamat: ${data['alamat']}'),
                          Text('Jenis: ${data['jenis']}'),
                          Text('Merk: ${data['merk']}'),
                          Text('No. Kendaraan: ${data['no_kendaraan']}'),
                          Text('No. Rangka: ${data['no_rangka']}'),
                          Text('No. Mesin: ${data['no_mesin']}'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Data Riwayat Tilang',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('data_kendaraan')
                        .doc(widget.documentId)
                        .collection('tilang')
                        .orderBy("tanggal")
                        .snapshots(),
                    builder: (context, tilangSnapshot) {
                      if (tilangSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (tilangSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${tilangSnapshot.error}'));
                      } else if (tilangSnapshot.hasData &&
                          tilangSnapshot.data!.docs.isNotEmpty) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('No')),
                              DataColumn(label: Text('Tanggal')),
                              DataColumn(label: Text('Pelanggaran')),
                              DataColumn(label: Text('Keterangan')),
                            ],
                            rows: tilangSnapshot.data!.docs
                                .asMap()
                                .entries
                                .map<DataRow>((entry) {
                              var index = entry.key;
                              var tilangDoc = entry.value;
                              var tilangData =
                                  tilangDoc.data() as Map<String, dynamic>;

                              Timestamp tilangTimestamp = tilangData['tanggal'];
                              DateTime tilangDateTime =
                                  tilangTimestamp.toDate();

                              String formattedTilangDate =
                                  DateFormat('dd/MM/yyyy')
                                      .format(tilangDateTime);

                              return DataRow(cells: [
                                DataCell(Text(
                                    '${index + 1}')), // Nomor otomatis urut
                                DataCell(Text('$formattedTilangDate')),
                                DataCell(Text('${tilangData['pelanggaran']}')),
                                DataCell(Text('${tilangData['keterangan']}')),
                              ]);
                            }).toList(),
                          ),
                        );
                      } else {
                        return Center(child: Text('Data Tilang not found'));
                      }
                    },
                  ),
                ],
              );
            } else {
              return Center(child: Text('Document not found'));
            }
          },
        ),
      ),
    );
  }

  Future<DocumentSnapshot> fetchData(String documentId) async {
    return FirebaseFirestore.instance
        .collection('data_kendaraan')
        .doc(documentId)
        .get();
  }
}
