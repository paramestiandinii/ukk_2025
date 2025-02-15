import 'package:flutter/material.dart';
import 'package:ukk_kasir/login.dart';
import 'package:ukk_kasir/produk/index.dart';

void main() {
  runApp(Homepage());
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Donuts Shop',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
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
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.drafts), text: 'Detail Penjualan'),
                Tab(icon: Icon(Icons.person_3_sharp), text: 'Pelanggan'),
                Tab(icon: Icon(Icons.shopping_bag_sharp), text: 'Produk'),
                Tab(icon: Icon(Icons.shopping_cart_checkout_sharp),text: 'Penjualan'),
              ],
            ),
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
                leading: Icon(Icons.logout_sharp),
                title: Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('logout selected')));
                },
              ),
            ]),
          ),
          body: Stack(
            children: [
              TabBarView(
                children: [
                  Center(child: Text('Detail Pelanggan Content')),
                  Center(child: Text('Pelanggan Content')),
                  produkIndex(),
                  Center(child: Text('Penjualan Content')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
