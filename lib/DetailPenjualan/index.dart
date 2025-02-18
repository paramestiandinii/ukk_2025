import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/homePage.dart';

class DetailPenjualan extends StatefulWidget {
  final Map<String, dynamic> produk;
  DetailPenjualan({Key? key, required this.produk}) : super(key: key);

  @override
  State<DetailPenjualan> createState() => _DetailPenjualanState();
}

class _DetailPenjualanState extends State<DetailPenjualan> {
  int jumlahPesanan = 0;
  int totalHarga = 0;
  int? selectedDetlid;
  List<Map<String, dynamic>> detlList = [];

  @override
  void initState() {
    super.initState();
    fetchDetl();
  }

  Future<void> fetchDetl() async {
    final supabase = Supabase.instance.client;
    try {
      final response =
          await supabase.from('pelanggan').select('PelangganID, NamaPelanggan');
      if (response != null && response.isNotEmpty) {
        setState(() {
          detlList = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      print('error fetching pelanggan data: $e');
    }
  }

  void updateJumlahPesanan(int harga, int delta) {
    setState(() {
      jumlahPesanan += delta;
      if (jumlahPesanan < 0) jumlahPesanan = 0;
      totalHarga = jumlahPesanan * harga;
    });
  }

  Future<void> simpanPesanan() async {
    final supabase = Supabase.instance.client;
    final produkid = widget.produk['ProdukID'];

    if (produkid == null || selectedDetlid == null || jumlahPesanan <= 0) {
      print('Gagal menyimpan, pastikan semua data sudah lengkap');
      return;
    }
    try {
      final penjualan = await supabase
          .from('penjualan')
          .insert({
            'totalHarga': totalHarga,
            'penjualan': detlList,
          })
          .select()
          .single();

      if (penjualan.isNotEmpty) {
        final penjualanid = penjualan['penjualanID'];

        await supabase.from('detailPenjualan').insert({
          'PenjualanID': penjualanid,
          'ProdukID': produkid,
          'JumlahProduk': jumlahPesanan,
          'Subtotal': totalHarga,
        });

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Homepage()));
      }
    } catch (e) {
      print('erorr saving data: $e');
    }
  }

  Widget build(BuildContext context) {
    final produk = widget.produk;
    final Harga = produk['Harga'] ?? 0;
    final NamaProduk = produk['NamaProduk'] ?? 'Tidak Tersedia';
    final Stok = produk['Stok'] ?? 'Tidak Tersedia';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Detail Produk', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.pink.shade300,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nama Produk: $NamaProduk', style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              Text('Harga: $Harga', style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              Text('Stok: $Stok', style: TextStyle(fontSize: 20)),
              SizedBox(height: 16),
              DropdownButtonFormField(
                value: selectedDetlid,
                items: detlList.map((detl) {
                  return DropdownMenuItem<int>(
                    value: detl['PelangganID'],
                    child: Text(detl['NamaPelanggan'] ?? 'Tidak Tersedia'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDetlid = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Pilih Pelanggan',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () => updateJumlahPesanan(Harga, -1),
                      icon: Icon(Icons.remove_circle)),
                  Text('$jumlahPesanan', style: TextStyle(fontSize: 20)),
                  IconButton(
                      onPressed: () => updateJumlahPesanan(Harga, 1),
                      icon: Icon(Icons.add_circle)),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Tutup', style: TextStyle(fontSize: 20))),
                  Spacer(),
                  ElevatedButton(
                      onPressed: jumlahPesanan > 0
                          ? () {
                              simpanPesanan();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink.shade300),
                      child: Text('pesan ($totalHarga)',
                          style: TextStyle(fontSize: 20))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================== DETAIL INDEX ========================

class Indexdetail extends StatefulWidget {
  Indexdetail({super.key});

  @override
  State<Indexdetail> createState() => _IndexdetailState();
}

class _IndexdetailState extends State<Indexdetail> {
  List<Map<String, dynamic>> detail = [];

  @override
  void initState() {
    super.initState();
    fetchDetl();
  }

  Future<void> fetchDetl() async {
    try {
      final response =
          await Supabase.instance.client.from('detailpenjualan').select();
      setState(() {
        detail = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Gagal mengambil data: $e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: detail.isEmpty
          ? Center(
              child: Text(
                'Data Tidak Tersedia',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              padding: EdgeInsets.all(16),
              itemCount:
                  detail.length, // Pastikan detail tidak null atau kosong
              itemBuilder: (context, index) {
                final Detl = detail[index];
                return Card(
                  key: ValueKey(Detl['ProdukID']),
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            Detl['ProdukID']?.toString() ??
                                'produk tidak tersedia',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(
                            Detl['PenjualanID']?.toString() ??
                                'penjualan tidak tersedia',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(
                            'Jumlah: ${Detl['JumlahProduk'] ?? 'tidak tersedia'}',
                            style: TextStyle(fontSize: 13)),
                        SizedBox(height: 8),
                        Text(
                            'Subtotal: ${Detl['Subtotal'] ?? 'Tidak tersedia'}',
                            style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                );
              },
            ),
            backgroundColor: Color.fromARGB(255, 250, 189, 209),
    );
  }
}
