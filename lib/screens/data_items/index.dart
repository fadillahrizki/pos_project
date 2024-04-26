import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/services/api_service.dart';

class DataItems extends StatefulWidget {
  const DataItems({super.key});

  @override
  State<DataItems> createState() => _DataItemsState();
}

class _DataItemsState extends State<DataItems> {
  String selectedValue = "ALL";

  List<DropdownMenuItem<String>> dropdownItems = [
    const DropdownMenuItem(value: "ALL", child: Text("ALL"))
  ];

  late List items;

  _loadCategories() async {
    var res = await ApiService().getCategories();
    Map<String, dynamic> body = jsonDecode(res.body);
    List data = body['data'];

    setState(() {
      for (var value in data) {
        dropdownItems.add(DropdownMenuItem(
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
        title: const Text("Data Items"),
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
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  items: dropdownItems,
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
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("INDOMIE"),
                          Text(
                            "Rp.2.500",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("FOOD")
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Stocks: 140 pcs",
                            style: TextStyle(fontSize: 12),
                          ),
                          CustomButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/data_items/detail');
                            },
                            label: 'Detail',
                            size: 'sm',
                          )
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
              "Total: 5 Records (ALL)",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
