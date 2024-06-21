import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/services/api_service.dart';

class ReportInvoiceDetail extends StatefulWidget {
  const ReportInvoiceDetail({super.key, required this.data});

  final Map data;

  @override
  State<ReportInvoiceDetail> createState() => _ReportInvoiceDetailState();
}

class _ReportInvoiceDetailState extends State<ReportInvoiceDetail> {
  List items = [];
  bool isLoading = true;

  loadData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var res = await ApiService()
          .getReportInvoiceDetail(widget.data['id_penjualan']);
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
          "Report Invoice (Detail)",
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
                      Text(widget.data['nomor_faktur']),
                      Text(widget.data['nama_customer']),
                      Text(widget.data['telepon']),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('dd MMMM yyyy').format(
                            DateTime.parse(widget.data['tanggal_faktur'])),
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        DateFormat('dd MMMM yyyy').format(
                            DateTime.parse(widget.data['tanggal_jtempo'])),
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(widget.data['id_gudang']),
                    ],
                  )
                ],
              ),
              const Divider(),
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: CustomColor().primary,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        var item = items[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${item['nama_item']} @${NumberFormat.decimalPattern().format(item['harga_jual_satuan'])}"),
                            Text("${item['kode_item']}"),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "${NumberFormat.decimalPattern().format(item['qty_jual'])} ${item['satuan']}"),
                                Text(
                                    "${NumberFormat.decimalPattern().format(item['nominal_diskon'])},-"),
                                Text(
                                    "${NumberFormat.decimalPattern().format(item['total_harga_jual'])},-"),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      }),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Items: ${widget.data['total_items']}"),
                  Text(
                    "Jumlah: ${NumberFormat.decimalPattern().format(widget.data['total_penjualan'])}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                        "Potongan (${widget.data['persen_potongan']}%): ${NumberFormat.decimalPattern().format(widget.data['potongan'])},-"),
                    const SizedBox(
                      width: 200,
                      child: Divider(),
                    ),
                    Text(
                        "DPP: ${NumberFormat.decimalPattern().format(widget.data['dpp'])}"),
                    Text(
                        "PPN: ${NumberFormat.decimalPattern().format(widget.data['ppn'])}"),
                    const SizedBox(
                      width: 200,
                      child: Divider(),
                    ),
                    Text(
                      "Total Transaksi: ${NumberFormat.decimalPattern().format(widget.data['total_transaksi'])}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Text(widget.data['nama_supir']),
              Text(widget.data['nama_gudang']),
            ],
          ),
        ),
      ),
    );
  }
}
