import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/pelanggan/insert.dart';
import 'package:ukk_kasir/pelanggan/update.dart';

class indexPelanggan extends StatefulWidget {
  const indexPelanggan({super.key});

  @override
  State<indexPelanggan> createState() => _indexPelangganState();
}

class _indexPelangganState extends State<indexPelanggan> {
  List<Map<String, dynamic>> pelanggan = [];
  List<Map<String, dynamic>> filterPelanggan = [];
  bool isLoading = true;
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchpelanggan();
    _searchController.addListener(_filterPelanggan);
  }

  Future<void> fetchpelanggan() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response =
          await Supabase.instance.client.from('pelanggan').select();
      setState(() {
        pelanggan = List<Map<String, dynamic>>.from(response);
        filterPelanggan = pelanggan;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error fetching pelanggan: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }
  void _filterPelanggan() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filterPelanggan = pelanggan
      .where((plg) => 
      plg['NamaPelanggan'].toLowerCase().contains(query)|| 
      plg['Alamat'].toLowerCase().contains(query)||
      plg['NomorTelepon'].toLowerCase().contains(query)
    ).toList();
    });
  }

  Future<void> deletePelanggan(int id) async {
    try {
      await Supabase.instance.client
          .from('pelanggan')
          .delete()
          .eq('PelangganID', id);
      fetchpelanggan();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('pelanggan berhasil di hapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error deleting pelanggan: $e')),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 250, 189, 209),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(8),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari Pelanggan...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),

            )
          ),
          )
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : filterPelanggan.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada pelanggan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  padding: EdgeInsets.all(10),
                  itemCount: filterPelanggan.length,
                  itemBuilder: (context, index) {
                    final plg = filterPelanggan[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plg['NamaPelanggan'] ??
                                  'pelanggan tidak tersedia',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              plg['Alamat'] ?? 'alamat tidak tersedia',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                              plg['NomorTelepon'] ??
                                  ' Nomor Telepon tidak tersedia',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit_document,
                                      color: Colors.lightBlueAccent),
                                  onPressed: () {
                                    final pelangganID = plg['PelangganID'] ?? 0;
                                    if (pelangganID != 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Updatepelanggan(
                                                    PelangganID: pelangganID)),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'ID pelanggan tidak valid')),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_rounded,
                                      color: Colors.redAccent),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Hapus Pelanggan'),
                                            content: Text(
                                                'apakah anada yakin menghapus pelanggan ini?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Batal')),
                                              TextButton(
                                                onPressed: () {
                                                  deletePelanggan(
                                                      plg['PelangganID']);
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Hapus'),
                                              )
                                            ],
                                          );
                                        });
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Insertpelanggan()),
          );
        },
        child: Icon(Icons.add),
      ),
      backgroundColor: Color.fromARGB(255, 250, 189, 209),
    );
  }
}
