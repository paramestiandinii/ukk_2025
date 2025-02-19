import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateUser extends StatefulWidget {
  final Map<String, dynamic> user;
  final Function refreshUser;
  UpdateUser({required this.user, required this.refreshUser});

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final SupabaseClient supabase = Supabase.instance.client;
  late TextEditingController usernameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.user['username']);
    passwordController = TextEditingController(text: widget.user['password']);
  }

  Future<void> updateUser() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Input tidak boleh kosong')),
      );
      return;
    }

    final editingUser = await supabase
        .from('user')
        .select()
        .eq('username', username)
        .neq('id', widget.user['id']);

    if (editingUser.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User sudah ada')),
      );
      return;
    }

    await supabase.from('user').update({
      'username': username,
      'password': password,
    }).eq('id', widget.user['id']);

    widget.refreshUser();
    Navigator.pop(context);
  }
   
    
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 250, 189, 209),
        centerTitle: true,
        title: Text(
          'Edit User',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(padding: EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              labelText: 'Username',
              hintText: 'Masukkan username anda',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              labelText: 'Password',
              hintText: 'Masukkan password anda',
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: updateUser,
            child: Text('Tambah'))
        ],
      ),
      ),
      backgroundColor: Color.fromARGB(255, 250, 189, 209),
    );
  }
}
