import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/data_table.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generatePDF(List<DataRow> dataRows, DateTime? selectedDate) async {
  final pdf = pw.Document();

  // Load image from asset
  final ByteData data = await rootBundle.load('assets/logoapk.png');
  final Uint8List bytes = data.buffer.asUint8List();

  // Add content to the PDF
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header section
            pw.Row(
              children: [
                pw.Image(pw.MemoryImage(bytes), width: 100, height: 50),
                pw.SizedBox(width: 10),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'DINAS PERHUBUNGAN KABUPATEN BANYUWANGI',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Jl. K.H. Agus Salim No.83, Taman Baru, Kec. Banyuwangi, Kabupaten Banyuwangi,',
                      style: pw.TextStyle(fontSize: 10),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Jawa Timur 68416',
                      style: pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),

            // Separator line
            pw.Container(
              margin: pw.EdgeInsets.symmetric(vertical: 10),
              child: pw.DecoratedBox(
                decoration: pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(width: 1), // Use BorderSide here
                  ),
                ),
                child: pw.Container(),
              ),
            ),

            // Content section (your table or additional content goes here)
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(children: [
                  pw.Text('No'),
                  pw.Text('No Kendaraan'),
                  pw.Text('Tanggal'),
                  pw.Text('Pelanggaran'),
                  pw.Text('Keterangan'),
                ]),
                // Add your data rows here
                for (var dataRow in dataRows)
                  pw.TableRow(
                    children: dataRow.cells.map((cell) {
                      if (cell.child is Text) {
                        // Access the text value directly and convert it to a string
                        return pw.Container(
                          alignment:
                              pw.Alignment.center, // Center-align the text
                          child: pw.Text('${(cell.child as Text).data ?? ''}'),
                        );
                      } else {
                        // Handle other types of child if needed
                        return pw.Text('');
                      }
                    }).toList(),
                  ),
              ],
            ),
          ],
        );
      },
    ),
  );

  // Display the PDF
  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}
