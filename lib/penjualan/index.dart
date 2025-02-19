
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/homePage.dart';

class PenjualanTab extends StatefulWidget {
  final Map<String, dynamic> produk;
  PenjualanTab({Key? key, required this.produk}) : super(key: key);

  @override
  _PenjualanTabState createState() => _PenjualanTabState();
}

class _PenjualanTabState extends State<PenjualanTab> {
  List<Map<String, dynamic>> pepjlList = [];

  @override
  void initState() {
    super.initState();
    fetchpenjualan();
  }

  Future<void> fetchpenjualan() async{
    final response = await Supabase.instance.client.from('penjualan').select();
    pepjlList = List<Map<String, dynamic>>.from(response);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        padding: EdgeInsets.all(10),
        itemCount: pepjlList.length,
        itemBuilder: (context, index) {
          final pjl = pepjlList[index];
          return Card(
            key: ValueKey(pjl['PenjualanID']), // Menambahkan key untuk performa
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pjl['TanggalPenjualan']?.toString() ?? 'Produk tidak tersedia', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(pjl['TotalHarga']?.toString() ?? 'Penjualan tidak tersedia', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text('Jumlah: ${pjl['PelangganID'] ?? 'Tidak tersedia'}', style: TextStyle(fontSize: 13)),
                  
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}