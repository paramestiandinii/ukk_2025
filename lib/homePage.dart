import 'package:flutter/material.dart';
import 'package:ukk_kasir/DetailPenjualan/index.dart';
import 'package:ukk_kasir/login.dart';
import 'package:ukk_kasir/pelanggan/index.dart';
import 'package:ukk_kasir/produk/index.dart';
import 'package:ukk_kasir/user.dart';

void main() {
  runApp(Homepage());
}

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  List<Widget> _pages = [
    Indexdetail(),
    indexPelanggan(),
    produkIndex(),
    Center(child: Text('Penjualan content')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Donuts Shop',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 250, 189, 209),
          leading: Builder(builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
        ),
        drawer: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            DrawerHeader(
              decoration:
                  BoxDecoration(color: Color.fromARGB(255, 250, 189, 209)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person_2_sharp,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('paramesti andini',
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ]),
            ),
            ListTile(
              leading: Icon(Icons.app_registration_outlined),
              title: Text('Registrasi'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserRegistrasi()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_sharp),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ]),
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
            

            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                backgroundColor: Color.fromARGB(255, 250, 189, 209),
                  icon: Icon(Icons.drafts), label: 'Detail Penjualan'),
              BottomNavigationBarItem(
                backgroundColor: Color.fromARGB(255, 250, 189, 209),
                  icon: Icon(Icons.person), label: 'Pelanggan'),
              BottomNavigationBarItem(
                backgroundColor: Color.fromARGB(255, 250, 189, 209),
                  icon: Icon(Icons.shopping_bag_sharp), label: 'Produk'),
              BottomNavigationBarItem(
                backgroundColor: Color.fromARGB(255, 250, 189, 209),
                  icon: Icon(Icons.shopping_cart_checkout_sharp),
                  label: 'Penjualan'),

            ]),
      ),
    );
  }
}
