import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/components/custom_text_field.dart';
import 'package:pos_project/constants/custom_color.dart';
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

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });
    var data = {
      'username': usernameController.text,
      'password': passwordController.text
    };

    var res = await ApiService().login(data);
    Map<String, dynamic> body = jsonDecode(res.body);
    if (body['status'] == 1) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(
          'userData', json.encode({...body['data'], ...data}));
      Navigator.pushReplacementNamed(context, '/');
    } else {
      _showMsg(body['message']);
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Column(
                children: [
                  FlutterLogo(
                    size: 100,
                  ),
                  Text(
                    "POS (Point of Sales)",
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    "Apps Mobile View",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text("Versi 1.0.0"),
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
                  _login();
                },
                label: _isLoading ? 'Proccessing..' : 'Login',
                enabled: !_isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
