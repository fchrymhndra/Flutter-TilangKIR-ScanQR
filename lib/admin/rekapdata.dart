import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tilangkir/bottomnavbarA.dart';
import 'pdf_generator.dart' as pdfGenerator;

void main() {
  runApp(const RekapData());
}

class RekapData extends StatelessWidget {
  const RekapData({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RekapDataPage(),
    );
  }
}

class RekapDataPage extends StatefulWidget {
  const RekapDataPage({Key? key});

  @override
  _RekapDataPageState createState() => _RekapDataPageState();
}

class _RekapDataPageState extends State<RekapDataPage> {
  final CollectionReference dataKendaraanCollection =
      FirebaseFirestore.instance.collection('data_kendaraan');

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  Future<List<DataRow>> _buildDataRows(
      DateTime startDate, DateTime endDate) async {
    List<DataRow> allDataRows = [];
    var snapshot = await dataKendaraanCollection.get();
    var dataKendaraanDocs = snapshot.docs;

    List<Map<String, dynamic>> sortedData = [];

    for (var i = 0; i < dataKendaraanDocs.length; i++) {
      var dataKendaraanDoc = dataKendaraanDocs[i];
      var tilangCollection = dataKendaraanDoc.reference.collection('tilang');

      var tilangSnapshot = await tilangCollection.get();
      var tilangDocs = tilangSnapshot.docs;

      for (var index = 0; index < tilangDocs.length; index++) {
        var tilangDoc = tilangDocs[index];
        var tilangData = tilangDoc.data() as Map<String, dynamic>;

        DateTime tilangDate = tilangData['tanggal'].toDate();

        // Check if the tilangDate is within the selected date range
        if (tilangDate.isAfter(startDate.subtract(Duration(days: 1))) &&
            tilangDate.isBefore(endDate.add(Duration(days: 1)))) {
          sortedData.add({
            'noKendaraan': dataKendaraanDoc.id,
            'tanggal': tilangData['tanggal'],
            'pelanggaran': tilangData['pelanggaran'],
            'keterangan': tilangData['keterangan'],
          });
        }
      }
    }

    // Sort the data based on the 'tanggal' field
    sortedData.sort((a, b) {
      DateTime dateA = (a['tanggal'] as Timestamp).toDate();
      DateTime dateB = (b['tanggal'] as Timestamp).toDate();
      return dateA.compareTo(dateB);
    });

    // Create DataRows with assigned row numbers
    for (var i = 0; i < sortedData.length; i++) {
      var rowData = sortedData[i];
      allDataRows.add(DataRow(
        cells: [
          DataCell(Text((i + 1).toString())),
          DataCell(Text(rowData['noKendaraan'])),
          DataCell(Text(_formatTanggal(rowData['tanggal']))),
          DataCell(Text(rowData['pelanggaran'])),
          DataCell(Text(rowData['keterangan'])),
        ],
      ));
    }

    return allDataRows;
  }

  String _formatTanggal(Timestamp timestamp) {
    var dateTime = timestamp.toDate();
    var formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(dateTime);
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> _printPdf(List<DataRow> dataRows) async {
    final Future<void> pdfBytes =
        pdfGenerator.generatePDF(dataRows, _startDate);

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;

    final String pdfPath = '$appDocPath/rekap_data_tilang.pdf';

    final File file = File(pdfPath);
    await file.writeAsBytes(pdfBytes as List<int>);

    // Use your preferred method to open the PDF file (e.g., share or print)
    // For example, you can use the 'open_file' package to open the PDF:
    // await OpenFile.open(pdfPath, type: 'application/pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Tilang'),
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BottomNavbarA()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          IconButton(
            onPressed: () => _selectDateRange(context),
            icon: const Icon(Icons.calendar_today),
            tooltip: 'Pilih Tanggal',
          ),
          const Text('Pilih Tanggal'),
          Expanded(
            child: FutureBuilder<List<DataRow>>(
              future: _buildDataRows(_startDate, _endDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Custom loading widget
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LinearProgressIndicator(),
                        SizedBox(height: 16.0),
                        Text('Loading...'),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('No')),
                          DataColumn(label: Text('No Kendaraan')),
                          DataColumn(label: Text('Tanggal')),
                          DataColumn(label: Text('Pelanggaran')),
                          DataColumn(label: Text('Keterangan')),
                        ],
                        rows: snapshot.data ?? [],
                      ),
                    ));
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async => _printPdf(
              await _buildDataRows(_startDate, _endDate),
            ),
            child: Text('Cetak PDF'),
          ),
        ],
      ),
    );
  }
}
