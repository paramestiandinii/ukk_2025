import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/homePage.dart';

class InsertProduk extends StatefulWidget {
  InsertProduk({super.key});

  @override
  State<InsertProduk> createState() => _InsertProdukState();
}

class _InsertProdukState extends State<InsertProduk> {
  final _NamaProduk = TextEditingController();
  final _Harga = TextEditingController();
  final _Stok = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> produk() async {
    if (_formKey.currentState!.validate()) {
      final String NamaProduk = _NamaProduk.text;
      final String Harga = _Harga.text;
      final String Stok = _Stok.text;

      try {
        final response = await Supabase.instance.client.from('produk').insert({
          'NamaProduk': NamaProduk,
          'Harga': Harga,
          'Stok': Stok,
        });

        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Gagal menambahkan produk: ${response.error!.message}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Produk berhasil ditambahkan')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homepage()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Produk'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _NamaProduk,
                decoration: InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Produk wajid diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _Harga,
                decoration: InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga wajid diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _Stok,
                decoration: InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok wajid diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              ElevatedButton(
                onPressed: produk, 
                child: Text('Tambah'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
