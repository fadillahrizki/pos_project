import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/components/custom_text_field.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/screens/auth/login.dart';
import 'package:pos_project/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Configuration extends StatefulWidget {
  const Configuration({super.key});

  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  TextEditingController ipController = TextEditingController();
  TextEditingController databaseController = TextEditingController();
  TextEditingController serverController = TextEditingController();
  TextEditingController endpointController = TextEditingController();

  loadData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (localStorage.getString('configuration') != null) {
      var configuration = jsonDecode(localStorage.getString('configuration')!);
      ipController.text = configuration['alamat_ippublic'];
      databaseController.text = configuration['nama_database'];
      serverController.text = configuration['lokasi_server'];
      endpointController.text = configuration['alamat_endpoint'];
    }
  }

  showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  editConfiguration(context) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    Map<String, dynamic> data = {
      "alamat_ippublic": ipController.text,
      "nama_database": databaseController.text,
      "lokasi_server": serverController.text,
      "alamat_endpoint": endpointController.text
    };

    localStorage.setString('configuration', jsonEncode(data));

    showMsg('Configuration saved!');

    if (localStorage.getString("userData") != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: CustomColor().primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Configuration",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "Isikan data setting awal yaitu IP Public, Server, Database dan Alamat End Point",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CustomTextField(
                    label: "IP Public",
                    controller: ipController,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: "Database",
                    controller: databaseController,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: "Server",
                    controller: serverController,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: "Alamat End Point",
                    controller: endpointController,
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    onPressed: () {
                      editConfiguration(context);
                    },
                    label: "Submit",
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
