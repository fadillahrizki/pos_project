import 'package:flutter/material.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/screens/auth/login.dart';
import 'package:pos_project/screens/configuration.dart';
import 'package:pos_project/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "POS Project",
      home: CheckAuth(),
    );
  }
}

class CheckAuth extends StatefulWidget {
  const CheckAuth({super.key});

  @override
  State<CheckAuth> createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  Future<int> isAuthenticated() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("configuration") != null) {
      if (sharedPreferences.getString("userData") != null) {
        return 2;
      }

      return 1;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: isAuthenticated(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            switch (snapshot.data) {
              case 1:
                return const Login();
              case 2:
                return const Home();
              default:
                return const Configuration();
            }
          }

          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: CustomColor().primary,
              ),
            ),
          );
        });
  }
}
