import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tilangkir/bottomnavbarA.dart';

void main() {
  runApp(TambahDataPage());
}

class TambahDataPage extends StatefulWidget {
  @override
  _TambahDataPageState createState() => _TambahDataPageState();
}

class _TambahDataPageState extends State<TambahDataPage> {
  final _formKey = GlobalKey<FormState>();
  final _noKendaraanController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _pelanggaranController = TextEditingController();
  final _keteranganController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tambah Data Kendaraan'),
          backgroundColor: Colors.blue[900],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BottomNavbarA()),
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _noKendaraanController,
                  decoration: InputDecoration(labelText: 'Nomor Kendaraan'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nomor Kendaraan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  readOnly: true,
                  controller: _tanggalController,
                  decoration: InputDecoration(labelText: 'Pilih Tanggal'),
                  onTap: () {
                    _selectDate(context);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Tanggal tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _pelanggaranController,
                  decoration: InputDecoration(labelText: 'Pelanggaran'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Pelanggaran tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _keteranganController,
                  decoration: InputDecoration(labelText: 'Keterangan'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Keterangan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      tambahDataKendaraan();
                    }
                  },
                  child: Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      _tanggalController.text = picked.toString().substring(0, 10);
    }
  }

  void tambahDataKendaraan() async {
    String noKendaraan = _noKendaraanController.text;
    _tanggalController.text;
    String pelanggaran = _pelanggaranController.text;
    String keterangan = _keteranganController.text;

    // Gunakan noKendaraan sebagai documentId
    String documentId = noKendaraan;

    // Set data pada collection data_kendaraan
    await FirebaseFirestore.instance
        .collection('data_kendaraan')
        .doc(documentId)
        .set({
      'no_kendaraan': noKendaraan,
    });

    // Set data pada subkoleksi tilang
    await FirebaseFirestore.instance
        .collection('data_kendaraan')
        .doc(documentId)
        .collection('tilang')
        .add({
      'tanggal': DateTime.parse(_tanggalController.text),
      'pelanggaran': pelanggaran,
      'keterangan': keterangan,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data berhasil disimpan'),
      ),
    );
    // Kembali ke halaman sebelumnya
    Navigator.pop(context);
  }
}
