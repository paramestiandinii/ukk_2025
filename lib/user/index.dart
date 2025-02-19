// index.dart - Menampilkan daftar user
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/homePage.dart';
import 'package:ukk_kasir/user/insert.dart';
import 'package:ukk_kasir/user/update.dart';

class UserIndex extends StatefulWidget {
  @override
  _UserIndexState createState() => _UserIndexState();
}

class _UserIndexState extends State<UserIndex> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> user = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await supabase.from('user').select();
    setState(() {
      user = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> deleteUser(int id) async {
    await supabase.from('user').delete().eq('id', id);
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 250, 189, 209),
        centerTitle: true,
        title:
            Text('Daftar User', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Homepage()));
          },
        ),
      ),
      body: ListView.builder(
        itemCount: user.length,
        itemBuilder: (context, index) {
          final userItem = user[index];
          return ListTile(
            title: Text(userItem['username']),
            subtitle: Text('******'), // Menyembunyikan password
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UpdateUser(user: userItem, refreshUser: fetchUsers),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => deleteUser(userItem['id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InsertUser(refreshUsers: fetchUsers)),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 250, 189, 209),
    );
  }
}
