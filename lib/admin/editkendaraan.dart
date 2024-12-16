import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditKendaraan extends StatefulWidget {
  final String documentId;
  final VoidCallback onUpdate; // Callback function

  EditKendaraan({required this.documentId, required this.onUpdate});

  @override
  _EditKendaraanState createState() => _EditKendaraanState();
}

class _EditKendaraanState extends State<EditKendaraan> {
  final TextEditingController _noKendaraanController = TextEditingController();
  final TextEditingController _namaPemilikController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noMesinController = TextEditingController();
  final TextEditingController _noRangkaController = TextEditingController();
  final TextEditingController _jenisController = TextEditingController();
  final TextEditingController _merkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDataAndPopulateFields();
  }

  void fetchDataAndPopulateFields() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('data_kendaraan')
        .doc(widget.documentId)
        .get();

    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;

      _noKendaraanController.text = data['no_kendaraan'] ?? '';
      _namaPemilikController.text = data['nama'] ?? '';
      _nikController.text = data['nik'] ?? '';
      _alamatController.text = data['alamat'] ?? '';
      _noMesinController.text = data['no_mesin'] ?? '';
      _noRangkaController.text = data['no_rangka'] ?? '';
      _jenisController.text = data['jenis'] ?? '';
      _merkController.text = data['merk'] ?? '';
    }
  }

  void saveEditedData() async {
    try {
      await FirebaseFirestore.instance
          .collection('data_kendaraan')
          .doc(widget.documentId)
          .update({
        'no_kendaraan': _noKendaraanController.text,
        'nama': _namaPemilikController.text,
        'nik': _nikController.text,
        'alamat': _alamatController.text,
        'no_mesin': _noMesinController.text,
        'no_rangka': _noRangkaController.text,
        'jenis': _jenisController.text,
        'merk': _merkController.text,
      });

      // Show a success message or navigate to a different screen
      // ...

      print('Data updated successfully!');

      // Navigate back to MyViewPage
      widget.onUpdate();
      // Kembali ke halaman sebelumnya (MyViewPage)
      Navigator.pop(context);
    } catch (error) {
      print('Error updating data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Kendaraan'),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'No. Kendaraan',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextFormField(controller: _noKendaraanController),
              SizedBox(height: 20.0),
              Text(
                'Nama Pemilik',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextFormField(controller: _namaPemilikController),
              SizedBox(height: 20.0),
              Text(
                'NIK',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextFormField(controller: _nikController),
              SizedBox(height: 20.0),
              Text(
                'Alamat',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextFormField(controller: _alamatController),
              SizedBox(height: 20.0),
              Text(
                'Jenis',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextFormField(controller: _jenisController),
              SizedBox(height: 20.0),
              Text(
                'Merk',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextFormField(controller: _merkController),
              SizedBox(height: 20.0),
              Text(
                'No Rangka',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextFormField(controller: _noRangkaController),
              SizedBox(height: 20.0),
              Text(
                'No Mesin',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextFormField(controller: _noMesinController),
              ElevatedButton(
                onPressed: () {
                  saveEditedData();
                },
                child: Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
