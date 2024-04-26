import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/components/custom_text_field.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/services/api_service.dart';

class Configuration extends StatefulWidget {
  const Configuration({super.key});

  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  TextEditingController ipController = TextEditingController();
  TextEditingController databaseController = TextEditingController();
  TextEditingController serverController = TextEditingController();
  TextEditingController endpointController = TextEditingController();

  _loadData() async {
    var res = await ApiService().getConfiguration();
    Map<String, dynamic> body = jsonDecode(res.body);
    Map<String, dynamic> data = body['data'][0];

    setState(() {
      ipController.text = data['alamat_ippublic'];
      databaseController.text = data['nama_database'];
      serverController.text = data['lokasi_server'];
      endpointController.text = data['alamat_endpoint'];
    });
  }

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _editConfiguration() async {
    Map<String, dynamic> data = {
      "alamat_ippublic": ipController.text,
      "nama_database": databaseController.text,
      "lokasi_server": serverController.text,
      "alamat_endpoint": endpointController.text
    };

    var res = await ApiService().editConfiguration(json.encode(data));

    Map<String, dynamic> body = jsonDecode(res.body);

    if (body['status'] == 1) {}

    _showMsg(body['message']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor().primary,
        title: const Text("Configuration"),
      ),
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
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "Isikan data setting awal yaitu IP Public, Server, Database dan Alamat End Point",
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
                      _editConfiguration();
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
