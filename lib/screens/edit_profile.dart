import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/components/custom_drawer.dart';
import 'package:pos_project/components/custom_text_field.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  late Map<String, dynamic> user;

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    setState(() {
      user = jsonDecode(localStorage.getString('userData')!);
      nameController.text = user['nama_pengguna'];
      usernameController.text = user['username'];
      passwordController.text = user['password'];
      phoneController.text = user['nohp'];
    });
  }

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

  _editProfile() async {
    try {
      Map<String, dynamic> data = {
        "username": usernameController.text,
        "nama_pengguna": nameController.text,
        "nohp": phoneController.text
      };

      var res = await ApiService().editProfile(jsonEncode({
        ...data,
        "password_lama": user['password'],
        "password_baru": passwordController.text,
      }));

      Map<String, dynamic> body = jsonDecode(res.body);

      if (body['status'] == 1) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('userData',
            jsonEncode({...data, 'password': passwordController.text}));
      }
      showMsg(body['message']);
    } catch (e) {
      print(e.toString());
      showMsg('Terjadi kesalahan pada server!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor().primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: CustomDrawer(
        name: user['nama_pengguna'],
        username: user['username'],
        active: 'Edit Profile',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
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
              CustomTextField(
                label: "Nama Pengguna",
                controller: nameController,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "No Handphone (HP)",
                controller: phoneController,
              ),
              const SizedBox(height: 12),
              CustomButton(
                  onPressed: () {
                    _editProfile();
                  },
                  label: "Submit")
            ],
          ),
        ),
      ),
    );
  }
}
