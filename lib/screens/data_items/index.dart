import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/screens/data_items/list.dart';
import 'package:pos_project/services/api_service.dart';

class DataItems extends StatefulWidget {
  const DataItems({super.key});

  @override
  State<DataItems> createState() => _DataItemsState();
}

class _DataItemsState extends State<DataItems> {
  String selectedCategory = "ALL";

  List<DropdownMenuItem<String>> categoryItems = [
    const DropdownMenuItem(
        value: "ALL", child: Text("ALL", style: TextStyle(fontSize: 14)))
  ];

  loadCategories() async {
    try {
      var res = await ApiService().getCategories();
      Map<String, dynamic> body = jsonDecode(res.body);

      if (body['status'] == 1) {
        setState(() {
          for (var value in body['data']) {
            categoryItems.add(DropdownMenuItem(
                value: value['nama_kategori'],
                child: Text(
                    "(${value['kode_kategori']}) ${value['nama_kategori']}",
                    style: const TextStyle(fontSize: 14))));
          }
        });
      }
    } catch (e) {
      print(e.toString());
      showMsg('Terjadi kesalahan pada server!');
    }
  }

  showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();

    loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor().primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Data Items",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Kategori Items"),
                const SizedBox(height: 12),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: CustomColor().primary, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: CustomColor().primary, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: CustomColor().primary, width: 2),
                    ),
                  ),
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  items: categoryItems,
                ),
                const SizedBox(height: 12),
                CustomButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DataItemsList(category: selectedCategory),
                        ),
                      );
                    },
                    label: 'Submit')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
