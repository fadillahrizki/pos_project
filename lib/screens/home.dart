import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = '';
  String username = '';

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('userData')!);

    if (user != null) {
      setState(() {
        name = user['nama_pengguna'];
        username = user['username'];
      });
    }
  }

  _logout() async {
    var res = await ApiService().logout();
    var body = jsonDecode(res.body);
    if (body['status'] == 1) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.clear();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadUserData();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor().primary,
        title: const Text("Home"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: CustomColor().primary),
              accountName: Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                "user: $username",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              currentAccountPicture: const FlutterLogo(),
            ),
            ListTile(
              tileColor: CustomColor().primary,
              textColor: Colors.white,
              iconColor: Colors.white,
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.pushNamed(context, '/edit_profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Configuration'),
              onTap: () {
                Navigator.pushNamed(context, '/configuration');
              },
            ),
            ListTile(
              leading: const Icon(Icons.do_disturb),
              title: const Text('Logout'),
              onTap: () {
                _logout();
              },
            ),
          ],
        ),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/data_items');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.teal[200],
              child: const Text("Data Items"),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/report/stock_items');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.teal[200],
              child: const Text("Report Stock Items"),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/sales_order');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.teal[200],
              child: const Text("Sales Order"),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/report/sales_order');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.teal[200],
              child: const Text("Report Sales Order"),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/report/invoice');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.teal[200],
              child: const Text("Report Invoice"),
            ),
          ),
        ],
      ),
    );
  }
}
