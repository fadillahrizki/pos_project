import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/screens/report/invoice/detail.dart';
import 'package:pos_project/services/api_service.dart';

class ReportInvoiceList extends StatefulWidget {
  const ReportInvoiceList({super.key});

  @override
  State<ReportInvoiceList> createState() => _ReportInvoiceListState();
}

class _ReportInvoiceListState extends State<ReportInvoiceList> {
  late List invoices;

  loadData() async {
    try {
      var res = await ApiService().getReportInvoice();
      Map<String, dynamic> body = jsonDecode(res.body);

      if (body['status'] == 1) {
        setState(() {
          invoices = body['data'] ?? [];
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

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor().primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Report Invoice",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
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
                          Text("INV-123455"),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ReportInvoiceDetail(),
                                ),
                              );
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
