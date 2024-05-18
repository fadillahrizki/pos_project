import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/services/api_service.dart';

class ReportSalesOrderDetail extends StatefulWidget {
  const ReportSalesOrderDetail({super.key, required this.data});

  final Map data;

  @override
  State<ReportSalesOrderDetail> createState() => _ReportSalesOrderDetailState();
}

class _ReportSalesOrderDetailState extends State<ReportSalesOrderDetail> {
  List items = [];

  bool isLoading = true;

  loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var res =
          await ApiService().getReportSalesOrderDetail(widget.data['no_order']);
      Map<String, dynamic> body = jsonDecode(res.body);

      if (body['status'] == 1) {
        setState(() {
          items = body['data'] ?? [];
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
          "Report Sales Order (Detail)",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.data['no_order']),
                      Text(widget.data['nama_customer']),
                      Text(widget.data['telepon']),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(DateFormat('dd MMMM yyyy')
                          .format(DateTime.parse(widget.data['tgl_order']))),
                      Text(widget.data['nama_sales']),
                    ],
                  )
                ],
              ),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (_, index) {
                  var item = items[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${item['nama_item']} @${NumberFormat.decimalPattern().format(item['harga_satuan'])}"),
                      Text("${item['barcode_number']}${item['kode_item']}"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${item['qty_order']} ${item['satuan']}"),
                          Text(
                              "Rp.${NumberFormat.decimalPattern().format(item['nominal_diskon'])}"),
                          Text(
                              "Rp.${NumberFormat.decimalPattern().format(item['jumlah'])}"),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Items: ${items.length}"),
                  Text(
                    "Total Order: Rp.${NumberFormat.decimalPattern().format(widget.data['total_order'])}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
