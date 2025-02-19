import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertUser extends StatefulWidget {
  final Function refreshUsers;
  InsertUser({required this.refreshUsers});

  @override
  _InsertUserState createState() => _InsertUserState();
}

class _InsertUserState extends State<InsertUser> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> addUser() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Input tidak boleh kosong')));
      return;
    }
    final existingUser =
        await supabase.from('user').select().eq('username', username);

    if (existingUser.isNotEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User sudah ada')));
      return;
    }

    await supabase.from('user').insert({
      'username': username,
      'password': password,
    });
    widget.refreshUsers();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 250, 189, 209),
        centerTitle: true,
        title: Text(
          'Tambah User',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                labelText: 'Username',
                hintText: 'Masukkan username anda',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                labelText: 'Password',
                hintText: 'Masukkan password anda',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addUser,
              child: Text('Tambah'),
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 250, 189, 209),
    );
  }
}
