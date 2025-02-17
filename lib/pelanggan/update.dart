import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Updatepelanggan extends StatefulWidget {
  final int PelangganID;
  Updatepelanggan({super.key, required this.PelangganID});

  @override
  State<Updatepelanggan> createState() => _UpdatepelangganState();
}

class _UpdatepelangganState extends State<Updatepelanggan> {
  final _NamaPelanggan = TextEditingController();
  final _NomorTelepon = TextEditingController();
  final _Alamat = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadpelanggan();
  }

  Future<void> _loadpelanggan() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await Supabase.instance.client
          .from('pelanggan')
          .select()
          .eq('PelangganID', widget.PelangganID)
          .single();

      if (data == null) {
        throw Exception('data tidak ditemukan');
      }

      setState(() {
        _NamaPelanggan.text = data['NamaPelanggan'] ?? '';
        _Alamat.text = data['Alamat'] ?? '';
        _NomorTelepon.text = data['NomorTelepon'] ?? '';
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('gagal memuat data pelanggan: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updatePelanggan() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        await Supabase.instance.client.from('pelanggan').update({
          'NamaPelanggan': _NamaPelanggan.text,
          'Alamat': _Alamat.text,
          'NomorTelepon': _NomorTelepon.text,
        }).eq('PelangganID', widget.PelangganID);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('data pelanggan berhasil ditambhakan')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('update pelanggan'),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
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
                          return 'Nama Pelanggan wajib diisi';
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
                          return 'Alamat wajib diisi';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _NomorTelepon,
                      decoration: InputDecoration(
                        labelText: 'Nomor Telepon',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor Telepon wajib diisi';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return 'Nomor Telepon hanya boleh berisi angka';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: updatePelanggan,
                      child: Text('Update'),
                    ),
                  ],
                )),
              ));
  }
}
