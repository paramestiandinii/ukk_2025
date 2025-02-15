import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/produk/insert.dart';
import 'package:ukk_kasir/produk/update.dart';

class produkIndex extends StatefulWidget {
  produkIndex({super.key});

  @override
  State<produkIndex> createState() => _produkIndexState();
}

class _produkIndexState extends State<produkIndex> {
  List<Map<String, dynamic>> produk = [];
  bool isLoading = true;

  
  @override
  void initState() {
    super.initState();
    fetchProduk;
  }

  Future<void> fetchProduk() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('produk').select();
      setState(() {
        produk = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      print('error fetching produk: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteProduk(int ProdukID) async {
    try {
      await Supabase.instance.client
          .from('produk')
          .delete()
          .eq('ProdukID', ProdukID);
      fetchProduk();
    } catch (e) {
      print('error deleting produk: $e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: produk.isEmpty
          ? Center(
              child: Text(
                'Tidak Ada Produk',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: produk.length,
              itemBuilder: (context, index) {
                final roduk = produk[index];
                return Card(
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
                            roduk['NamaProduk']?.toString() ??
                                'Produk Tidak Tersedia',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            roduk['Harga']?.toString() ??
                                'Harga Tidak Tersedia',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            roduk['Stok']?.toString() ?? 'Stok Tidak Tersedia',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Divider(),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.edit_calendar_sharp),
                                    onPressed: () {
                                      final ProdukID = roduk['ProdukID'] ?? 0;
                                      if (ProdukID != 0) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UpdateProduk(
                                                      produkID: ProdukID)),
                                        );
                                      } else {
                                        print('Id produk tidak valid');
                                      }
                                    }),
                                IconButton(
                                    icon: Icon(
                                      Icons.delete_sharp,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Hapus Produk'),
                                              content: Text(
                                                  'Apakah anda yakin menghapus produk ini'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    deleteProduk(
                                                        roduk['ProdukID']);
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Hapus'),
                                                ),
                                              ],
                                            );
                                          });
                                    }),
                              ]),
                        ],
                      )),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InsertProduk())
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
