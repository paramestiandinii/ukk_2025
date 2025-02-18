import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/DetailPenjualan/index.dart';
import 'package:ukk_kasir/produk/insert.dart';
import 'package:ukk_kasir/produk/update.dart';

class produkIndex extends StatefulWidget {
  produkIndex({super.key});

  @override
  State<produkIndex> createState() => _produkIndexState();
}

class _produkIndexState extends State<produkIndex> {
  List<Map<String, dynamic>> produk = [];
  List<Map<String, dynamic>> filterProduk = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client.from('produk').select();
      setState(() {
        produk = List<Map<String, dynamic>>.from(response);
        filterProduk = produk;
        isLoading = false;
      });
    } catch (e) {
      print('error fetching produk: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchProduk(String query) {
    final hasilPencarian = produk.where((item) {
      final NamaProduk = item['NamaProduk']?.toString().toLowerCase() ?? '';
      return NamaProduk.contains(query.toLowerCase());
    }).toList();
    setState(() {
      filterProduk = hasilPencarian;
    });
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
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 250, 189, 209),
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Cari produk..',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.search_sharp),
              onPressed: () {
              searchController.clear();
              searchProduk('');
            }),
          ),
          onChanged: searchProduk,
        ),
      ),
      body: produk.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : filterProduk.isEmpty
              ? Center(
                  child: Text(
                    'Tidak Ada Produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: produk.length,
                  itemBuilder: (context, index) {
                    final roduk = filterProduk[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(
                            roduk['NamaProduk']?.toString() ??
                                'produk tidak tersedia',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Harga: ${roduk['Harga']?.toString() ?? 'tidak tersedia'}'),
                            Text(
                                'Stok: ${roduk['Stok']?.toString() ?? 'tidak tersedia'}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UpdateProduk(
                                            produkID: roduk['ProdukID'])),
                                  );
                                }),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('hapus produk'),
                                      content: Text(
                                          'Apakah anda yakin menghapus produk ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            deleteProduk(roduk['ProdukID']);
                                            Navigator.pop(context);
                                          },
                                          child: Text('Hapus'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailPenjualan(produk: roduk)),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InsertProduk()),
          );
        },
        child: Icon(Icons.add),
      ),
      backgroundColor: Color.fromARGB(255, 250, 189, 209),
    );
  }
}
