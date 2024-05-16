import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/screens/sales_order/list.dart';
import 'package:pos_project/services/api_service.dart';

class SalesOrder extends StatefulWidget {
  const SalesOrder({super.key});

  @override
  State<SalesOrder> createState() => _SalesOrderState();
}

class _SalesOrderState extends State<SalesOrder> {
  String? selectedFromDate;
  DateTime? selectedFromDatePicker;

  String? selectedToDate;
  DateTime? selectedToDatePicker;

  String selectedCustomer = "ALL";
  List<DropdownMenuItem<String>> customerItems = [
    const DropdownMenuItem(
        value: "ALL", child: Text("ALL", style: TextStyle(fontSize: 14))),
  ];

  loadCustomers() async {
    var res = await ApiService().getCustomers();
    Map<String, dynamic> body = jsonDecode(res.body);

    if (body['status'] == 1) {
      setState(() {
        for (var value in body['data']) {
          customerItems.add(DropdownMenuItem(
              value: value['nama_customer'],
              child: Text(value['nama_customer'],
                  style: const TextStyle(fontSize: 14))));
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();

    loadCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor().primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Sales Order",
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
                const Text("Customer"),
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
                  value: selectedCustomer,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCustomer = newValue!;
                    });
                  },
                  items: customerItems,
                ),
                const SizedBox(height: 12),
                const Text("Dari Tanggal"),
                const SizedBox(height: 12),
                CustomButton(
                  type: 'secondary',
                  onPressed: () async {
                    selectedFromDatePicker = await showDatePicker(
                      context: context,
                      initialDate: selectedFromDatePicker,
                      firstDate: DateTime(DateTime.now().year),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );

                    if (selectedFromDatePicker != null) {
                      setState(() {
                        selectedFromDate = DateFormat('dd MMMM yyyy')
                            .format(selectedFromDatePicker!);
                      });
                    }
                  },
                  label: selectedFromDate ?? 'Pilih tanggal',
                ),
                const SizedBox(height: 12),
                const Text("Sampai Tanggal"),
                const SizedBox(height: 12),
                CustomButton(
                  type: 'secondary',
                  onPressed: () async {
                    selectedToDatePicker = await showDatePicker(
                      context: context,
                      initialDate: selectedToDatePicker,
                      firstDate: DateTime(DateTime.now().year),
                      lastDate: DateTime(DateTime.now().year + 1),
                    );

                    if (selectedToDatePicker != null) {
                      setState(() {
                        selectedToDate = DateFormat('dd MMMM yyyy')
                            .format(selectedToDatePicker!);
                      });
                    }
                  },
                  label: selectedToDate ?? 'Pilih tanggal',
                ),
                const SizedBox(height: 12),
                CustomButton(
                    onPressed: () {
                      if (selectedFromDatePicker == null ||
                          selectedToDatePicker == null) {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return const AlertDialog(
                                content: Text(
                                    "Silahkan pilih tanggal terlebih dahulu"),
                              );
                            });
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SalesOrderList(
                              customer: selectedCustomer,
                              fromDate: selectedFromDatePicker.toString(),
                              toDate: selectedToDatePicker.toString(),
                            ),
                          ),
                        );
                      }
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
