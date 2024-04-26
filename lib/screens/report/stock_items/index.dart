import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/services/api_service.dart';

class ReportStockItems extends StatefulWidget {
  const ReportStockItems({super.key});

  @override
  State<ReportStockItems> createState() => _ReportStockItemsState();
}

class _ReportStockItemsState extends State<ReportStockItems> {
  String selectedCategory = "ALL";
  List<DropdownMenuItem<String>> categoryItems = [
    const DropdownMenuItem(value: "ALL", child: Text("ALL")),
  ];

  late List items;

  _loadCategories() async {
    var res = await ApiService().getCategories();
    Map<String, dynamic> body = jsonDecode(res.body);
    List data = body['data'];

    setState(() {
      for (var value in data) {
        categoryItems.add(DropdownMenuItem(
            value: value['nama_kategori'],
            child:
                Text("(${value['kode_kategori']}) ${value['nama_kategori']}")));
      }
    });
  }

  _loadData() async {
    var res = await ApiService().getItems();
    Map<String, dynamic> body = jsonDecode(res.body);
    List data = body['data'];
    setState(() {
      items = data;
    });
  }

  @override
  void initState() {
    super.initState();

    _loadCategories();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor().primary,
        title: const Text("Report Stok Items"),
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
                CustomButton(onPressed: () {}, label: 'Submit')
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("INDOMIE"),
                          Text("Limit Stok: 10000 pcs"),
                          Text("Keterangan")
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "FOOD",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("Stok: 145 pcs"),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            color: CustomColor().warning,
            padding: const EdgeInsets.all(12),
            child: const Text(
              "Total: 5 Items (ALL)",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
