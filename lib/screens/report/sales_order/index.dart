import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/services/api_service.dart';

class ReportSalesOrder extends StatefulWidget {
  const ReportSalesOrder({super.key});

  @override
  State<ReportSalesOrder> createState() => _ReportSalesOrderState();
}

class _ReportSalesOrderState extends State<ReportSalesOrder> {
  String? _selectedDate;
  DateTimeRange? _selectedDateTimeRange;

  String selectedCustomer = "ALL";
  List<DropdownMenuItem<String>> customerItems = [
    const DropdownMenuItem(value: "ALL", child: Text("ALL")),
  ];

  late List salesOrders;

  _loadCustomers() async {
    var res = await ApiService().getCustomers();
    Map<String, dynamic> body = jsonDecode(res.body);
    List data = body['data'];

    setState(() {
      for (var value in data) {
        customerItems.add(DropdownMenuItem(
            value: value['nama_customer'],
            child: Text(value['nama_customer'])));
      }
    });
  }

  _loadData() async {
    var res = await ApiService().getReportSalesOrder();
    Map<String, dynamic> body = jsonDecode(res.body);
    List data = body['data'];

    setState(() {
      salesOrders = data;
    });
  }

  @override
  void initState() {
    super.initState();

    _loadCustomers();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor().primary,
        title: const Text("Report Sales Order"),
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
                const Text("Tanggal"),
                const SizedBox(height: 12),
                CustomButton(
                  type: 'secondary',
                  onPressed: () async {
                    _selectedDateTimeRange = await showDateRangePicker(
                      context: context,
                      initialDateRange: _selectedDateTimeRange,
                      firstDate: DateTime(DateTime.now().year),
                      lastDate: DateTime.now(),
                    );

                    if (_selectedDateTimeRange != null) {
                      setState(() {
                        _selectedDate =
                            "${DateFormat('dd MMMM yyyy').format(_selectedDateTimeRange!.start)} - ${DateFormat('dd MMMM yyyy').format(_selectedDateTimeRange!.end)}";
                      });
                    }
                  },
                  label: _selectedDate ?? 'Pilih tanggal',
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
                          Text("SO-123455"),
                          Text(
                            "Rp.2.500",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("Total Items : 12")
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "01 Apr 2024",
                            style: TextStyle(fontSize: 12),
                          ),
                          const Text("EDY GUNAWAN"),
                          CustomButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/report/sales_order/detail');
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
