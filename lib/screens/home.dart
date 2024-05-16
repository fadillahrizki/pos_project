import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pos_project/components/custom_drawer.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/screens/auth/login.dart';
import 'package:pos_project/screens/data_items/index.dart';
import 'package:pos_project/screens/report/invoice/index.dart';
import 'package:pos_project/screens/report/sales_order/index.dart';
import 'package:pos_project/screens/report/stock_items/index.dart';
import 'package:pos_project/screens/sales_order/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = '';
  String username = '';

  loadUserData(context) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('userData')!);

    if (user != null) {
      setState(() {
        name = user['nama_pengguna'];
        username = user['username'];
      });
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor().primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: CustomDrawer(
        name: name,
        username: username,
        active: 'Home',
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          Card(
            color: CustomColor().warning,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DataItems(),
                  ),
                );
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.dashboard_outlined,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text("Data Items"),
                ],
              ),
            ),
          ),
          Card(
            color: CustomColor().warning,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportStockItems(),
                  ),
                );
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text("Report Stock Items"),
                ],
              ),
            ),
          ),
          Card(
            color: CustomColor().warning,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SalesOrder(),
                  ),
                );
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.payments_outlined,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text("Sales Order"),
                ],
              ),
            ),
          ),
          Card(
            color: CustomColor().warning,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportSalesOrder(),
                  ),
                );
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.request_quote_outlined,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text("Report Sales Order"),
                ],
              ),
            ),
          ),
          Card(
            color: CustomColor().warning,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportInvoice(),
                  ),
                );
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text("Report Invoice"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
