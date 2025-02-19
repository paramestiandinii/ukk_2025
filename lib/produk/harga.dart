import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/homePage.dart';

class produkDetail extends StatefulWidget {
  final Map<String, dynamic> produk;
  produkDetail({Key? key, required this.produk}) : super(key: key);

  @override
  State<produkDetail> createState() => _produkDetailState();
}

class _produkDetailState extends State<produkDetail> {
  int jumlahPesanan = 0;
  int totalHarga = 0;
  int stokakhir = 0;
  int stokawal = 0;

  void updateJumlahPesanan(int harga, int delta) {
    setState(() {
      stokakhir = stokawal - delta;
      if (stokakhir < 0) stokakhir = 0;
      jumlahPesanan += delta;
      if (jumlahPesanan < 0) jumlahPesanan = 0; //tidak boleh negatif
      totalHarga = jumlahPesanan * harga;
      if (totalHarga < 0) totalHarga = 0; //tdk blh negatif
    });
  }

  Future<void> insertDetailPenjualan(
      int ProdukID, int PenjualanID, int JumlahPesanan, int totalHarga) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase.from('detailpenjualan').insert({
        'ProdukID': ProdukID,
        'PenjualanID': PenjualanID,
        'JumlahProduk': jumlahPesanan,
        'Subtotal': totalHarga,
      });
      if (response.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pesanan berhasil di simpan')),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );
      }
    } catch (e) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;
    final Harga = produk['Harga'] ?? 0;
    final ProdukID = produk['ProdukID'] ?? 0;
    final PenjualanID = 1;

    return Scaffold(
      appBar: AppBar(title: Text('Detail Produk')),
      backgroundColor: Color.fromARGB(255, 250, 189, 209),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.pink.shade400, Colors.pink.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          ),
        ),
        child: Padding(padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Produk: ${produk['NamaProduk'] ?? 'nama produk tidak tersedia'}', style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text('Harga: $Harga', style: TextStyle(fontSize: 20)),
            Text('Stok: ${produk['Stok'] ?? 'tidak tersedia'}',style: TextStyle(fontSize: 20 )),
            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    updateJumlahPesanan(Harga, -1);
                  },
                  icon: Icon(Icons.remove_circle),
                  ),
                  Text(
                    '$jumlahPesanan',
                    style: TextStyle(fontSize: 20),
                  ),
                  IconButton(
                    onPressed: () {
                      updateJumlahPesanan(Harga, 1);
                    } ,
                    icon: Icon(Icons.add_circle),
                    ),
              ],
            ),
            SizedBox(height: 16),

            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  
                  child: Text('Tutup', style: TextStyle(fontSize: 20)),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      if (jumlahPesanan > 0) {
                        await insertDetailPenjualan(ProdukID, PenjualanID, jumlahPesanan, totalHarga);
                        
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('jumlah pesanan harus lebih dari 0')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade200,
                    ),
                    child: Text('pesan($totalHarga)', style: TextStyle(fontSize: 20)),
                  ),
              ],
            )
          ],
        ),
        ),
      ),
    );
  }
}
