import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_kasir/homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Input tidak boleh kosong')),
      );
      return;
    }

    try {
      final response = await supabase
          .from('user')
          .select('username, password')
          .eq('username', username)
          .maybeSingle();

      if (response != null && response['password'] == password) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Homepage()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil Login!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Input kosong salah satu')),
        );
      }
    } catch (error) {
      // Menangani error jika terjadi kesalahan pada query
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username atau Password Salah')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Icon(Icons.arrow_back_rounded, color: Colors.black, size: 20),
        title: Text(
          'Admin Administrator',
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              "Selamat Datang di Donut's Shop Lembut Donut's nya Bikin Nagih...!",
              style: TextStyle(
                fontSize: 23,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 100),
            TextFormField(
              key: _formKey,
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'UserName',
                icon: Icon(
                  Icons.person_2_sharp,
                  color: Colors.black,
                  size: 30,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Username tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                icon: Icon(
                  Icons.key,
                  color: Colors.black,
                  size: 30,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text(
                "Login",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                fixedSize: Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 248, 173, 198),
    );
  }
}
