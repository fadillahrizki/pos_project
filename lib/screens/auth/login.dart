import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/components/custom_text_field.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/screens/configuration.dart';
import 'package:pos_project/screens/home.dart';
import 'package:pos_project/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  showMsg(msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              msg,
              textAlign: TextAlign.center,
            ),
          );
        });
  }

  void login(context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var data = {
        'username': usernameController.text,
        'password': passwordController.text
      };

      var res = await ApiService().login(data);
      Map<String, dynamic> body = jsonDecode(res.body);
      if (body['status'] == 1) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString(
            'userData', jsonEncode({...body['data'], ...data}));

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
          (route) => false,
        );
      } else {
        showMsg(body['message']);
      }
    } catch (e) {
      showMsg("Login gagal! silahkan periksa atau update endpoint.");
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor().primary,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      width: 100,
                    ),
                    const Text(
                      "POS (Point of Sales)",
                      style: TextStyle(fontSize: 24),
                    ),
                    const Text(
                      "Apps Mobile View",
                      style: TextStyle(fontSize: 20),
                    ),
                    const Text("Versi 1.0.0"),
                  ],
                ),
                const Divider(),
                CustomTextField(
                  label: "Username",
                  controller: usernameController,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: "Password",
                  obsecureText: true,
                  controller: passwordController,
                ),
                const SizedBox(height: 12),
                CustomButton(
                  onPressed: () {
                    login(context);
                  },
                  label: _isLoading ? 'Proccessing..' : 'Login',
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 12),
                CustomButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Configuration(),
                      ),
                      (route) => false,
                    );
                  },
                  label: 'Configuration',
                  type: 'secondary',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
