import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/screens/report/stock_items/list.dart';
import 'package:pos_project/services/api_service.dart';

class ReportStockItems extends StatefulWidget {
  const ReportStockItems({super.key});

  @override
  State<ReportStockItems> createState() => _ReportStockItemsState();
}

class _ReportStockItemsState extends State<ReportStockItems> {
  String selectedCategory = "ALL";
  List<DropdownMenuItem<String>> categoryItems = [
    const DropdownMenuItem(
        value: "ALL", child: Text("ALL", style: TextStyle(fontSize: 14))),
  ];

  loadCategories() async {
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
          "Report Stok Items",
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
                              ReportStockItemsList(category: selectedCategory),
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
