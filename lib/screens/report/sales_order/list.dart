import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/screens/report/sales_order/detail.dart';
import 'package:pos_project/services/api_service.dart';

class ReportSalesOrderList extends StatefulWidget {
  const ReportSalesOrderList(
      {super.key,
      required this.customer,
      required this.fromDate,
      required this.toDate});

  final String customer, fromDate, toDate;

  @override
  State<ReportSalesOrderList> createState() => _ReportSalesOrderListState();
}

class _ReportSalesOrderListState extends State<ReportSalesOrderList> {
  List salesOrders = [];

  bool isLoading = true;

  loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var res = await ApiService().getReportSalesOrder(
        nameCustomer: widget.customer == "ALL" ? "" : widget.customer,
        fromDate: widget.fromDate,
        toDate: widget.toDate,
      );
      Map<String, dynamic> body = jsonDecode(res.body);

      if (body['status'] == 1) {
        setState(() {
          salesOrders = body['data'] ?? [];
        });
      }
    } catch (e) {
      print(e.toString());
      showMsg('Terjadi kesalahan pada server!');
    }

    setState(() {
      isLoading = false;
    });
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
          "Report Sales Order",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: CustomColor().primary,
                    ),
                  )
                : ListView.builder(
                    itemCount: salesOrders.length,
                    itemBuilder: (context, index) {
                      var item = salesOrders[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item['no_order']),
                                      Text(
                                        "Rp.${NumberFormat.decimalPattern().format(item['total_order'])}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          "Total Items : ${item['total_items']}")
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        DateFormat('dd MMMM yyyy').format(
                                            DateTime.parse(item['tgl_order'])),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(item['nama_customer']),
                                      CustomButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReportSalesOrderDetail(
                                                      data: item),
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
                            ),
                            const Divider()
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
            child: Text(
              "Total: ${salesOrders.length} Records (${widget.customer})",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
