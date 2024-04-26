import 'package:flutter/material.dart';
import 'package:pos_project/screens/auth/login.dart';
import 'package:pos_project/screens/configuration.dart';
import 'package:pos_project/screens/data_items/detail.dart';
import 'package:pos_project/screens/data_items/index.dart';
import 'package:pos_project/screens/edit_profile.dart';
import 'package:pos_project/screens/home.dart';
import 'package:pos_project/screens/report/invoice/detail.dart';
import 'package:pos_project/screens/report/invoice/index.dart';
import 'package:pos_project/screens/report/sales_order/detail.dart';
import 'package:pos_project/screens/report/sales_order/index.dart';
import 'package:pos_project/screens/report/stock_items/index.dart';
import 'package:pos_project/screens/sales_order/form.dart';
import 'package:pos_project/screens/sales_order/index.dart';
import 'package:pos_project/screens/sales_order/items/form.dart';
import 'package:pos_project/screens/sales_order/items/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "POS Project",
      initialRoute: '/check_auth',
      routes: {
        '/check_auth': (context) => const CheckAuth(),
        '/': (context) => const Home(),
        '/login': (context) => const Login(),
        '/configuration': (context) => const Configuration(),
        '/edit_profile': (context) => const EditProfile(),
        '/data_items': (context) => const DataItems(),
        '/data_items/detail': (context) => const DataItemsDetail(),
        '/sales_order': (context) => const SalesOrder(),
        '/sales_order/form': (context) => const SalesOrderForm(),
        '/sales_order/items': (context) => const SalesOrderItems(),
        '/sales_order/items/form': (context) => const SalesOrderItemsForm(),
        '/report/stock_items': (context) => const ReportStockItems(),
        '/report/invoice': (context) => const ReportInvoice(),
        '/report/invoice/detail': (context) => const ReportInvoiceDetail(),
        '/report/sales_order': (context) => const ReportSalesOrder(),
        '/report/sales_order/detail': (context) =>
            const ReportSalesOrderDetail(),
      },
    );
  }
}

class CheckAuth extends StatefulWidget {
  const CheckAuth({super.key});

  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userData = localStorage.getString('userData');
    if (userData != null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    }

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
