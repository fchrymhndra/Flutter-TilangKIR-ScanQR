import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TambahTilang extends StatefulWidget {
  final String documentId;
  final void Function() onDataAdded;

  TambahTilang({required this.documentId, required this.onDataAdded});

  @override
  _TambahTilangState createState() => _TambahTilangState();
}

class _TambahTilangState extends State<TambahTilang> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _pelanggaranController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _tanggalController.text = picked.toString().substring(0, 10);
      });
    }
  }

  void _addTilangData(BuildContext context, VoidCallback onDataAdded) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        print('Adding Tilang Data...');

        await FirebaseFirestore.instance
            .collection('data_kendaraan')
            .doc(widget.documentId)
            .collection('tilang')
            .add({
          'tanggal': DateTime.parse(_tanggalController.text),
          'pelanggaran': _pelanggaranController.text,
          'keterangan': _keteranganController.text,
        });

        print('Tilang data added successfully!');

        // Clear the input fields
        _tanggalController.clear();
        _pelanggaranController.clear();
        _keteranganController.clear();

        // Trigger the callback to notify MyViewPage to rebuild
        widget.onDataAdded();

        // Navigate back to MyViewPage
        Navigator.pop(context);
      } catch (error) {
        print('Error adding tilang data: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Tilang Data'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tanggal',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _tanggalController,
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tanggal wajib di isi';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                'Pelanggaran',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _pelanggaranController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pelanggaran wajib di isi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              Text(
                'Keterangan',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _keteranganController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Keterangan wajib di isi';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _addTilangData(context, () {
                    // Callback function to be executed after data is added
                    // You can leave it empty for now or perform any additional actions
                  });
                },
                child: Text('Add Tilang Data'),
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
