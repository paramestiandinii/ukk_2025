import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/homePage.dart';

class Insertpelanggan extends StatefulWidget {
  const Insertpelanggan({super.key});

  @override
  State<Insertpelanggan> createState() => _InsertpelangganState();
}

class _InsertpelangganState extends State<Insertpelanggan> {
  final _NamaPelanggan = TextEditingController();
  final _NomorTelepon = TextEditingController();
  final _Alamat = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> plg() async {
    if (_formKey.currentState!.validate()) {
      final String NamaPelanggan = _NamaPelanggan.text;
      final String NomorTelepon = _NomorTelepon.text;
      final String Alamat = _Alamat.text;

      try {
        final response =
            await Supabase.instance.client.from('pelanggan').insert({
          'NamaPelanggan': NamaPelanggan,
          'NomorTelepon': NomorTelepon,
          'Alamat': Alamat,
        });
        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Gagal menambahkan pelanggan: ${response.error!.message}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pelanggan berhasil ditambhakan')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homepage()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pelanggan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _NamaPelanggan,
                decoration: InputDecoration(
                  labelText: 'Nama Pelanggan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Wajid Diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _Alamat,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat Wajid Diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                controller: _NomorTelepon,
                decoration: InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor Telepon Wajid Diisi';
                  } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Hanya boleh berisi angka';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: plg, child: Text('Tambah'))
            ],
          ),
        ),
      ),
    );
  }
}
