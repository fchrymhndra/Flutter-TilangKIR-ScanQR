import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'viewG.dart';
import 'package:tilangkir/bottomnavbar.dart';

class QRScanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QRScannerPage(),
    );
  }
}

class QRScannerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  String scannedDocumentId = ''; // Untuk menampung hasil scan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        backgroundColor: Colors.blue[900], // Warna biru 900
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
      body: Column(
        children: [
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          SizedBox(height: 20),
          Text('Hasil Scan: $scannedDocumentId'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (scannedDocumentId.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MyViewPage(documentId: scannedDocumentId),
                  ),
                );
              } else {
                // Tampilkan pesan jika hasil scan kosong
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Peringatan'),
                    content: Text('Anda belum melakukan scan QR code.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: Text('Lihat Data'),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        // Dapatkan documentId dari hasil scan
        scannedDocumentId = scanData.code!;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
