import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/screens/sales_order/items/form.dart';
import 'package:pos_project/services/api_service.dart';

class SalesOrderItems extends StatefulWidget {
  const SalesOrderItems({super.key, required this.data});

  final Map data;

  @override
  State<SalesOrderItems> createState() => _SalesOrderItemsState();
}

class _SalesOrderItemsState extends State<SalesOrderItems> {
  List items = [];

  bool isLoading = true;

  loadData() async {
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

  deleteItem(item) async {
    try {
      var res = await ApiService().deleteSalesOrderItem(
        jsonEncode({
          "no_order": item['no_order'],
          "dtl_id": item['dtl_id'],
          "id_item": item['id_item'],
          "id_itemdetail": item['id_itemdetail'],
          "kode_item": item['kode_item'],
          "nama_item": item['nama_item'],
          "qty_order": item['qty_order'],
          "satuan": item['satuan']
        }),
      );

      Map<String, dynamic> body = jsonDecode(res.body);

      if (body['status'] == 1) {
        showMsg(body['message']);
        loadData();
      } else {
        showMsg('Gagal delete item!');
      }
    } catch (e) {
      print(e.toString());
      showMsg('Terjadi kesalahan pada server!');
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor().primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Items Sales Order",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: CustomColor().warning,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
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
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child:
                        CircularProgressIndicator(color: CustomColor().primary))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['nama_item']),
                                Text(
                                  "Total Order: Rp.${NumberFormat.decimalPattern().format(item['jumlah'])}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    "Qty Order : ${item['qty_order']} ${item['satuan']}")
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    CustomButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SalesOrderItemsForm(
                                                data: widget.data,
                                                item: item,
                                              ),
                                            ));
                                      },
                                      label: 'Edit',
                                      size: 'sm',
                                    ),
                                    const SizedBox(width: 6),
                                    CustomButton(
                                      onPressed: () {
                                        deleteItem(item);
                                      },
                                      label: 'Delete',
                                      type: 'danger',
                                      size: 'sm',
                                    ),
                                  ],
                                ),
                                Text(
                                    "Rp.${NumberFormat.decimalPattern().format(item['nominal_diskon'])}"),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Item: ${widget.data['total_items']}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Total Order: Rp.${NumberFormat.decimalPattern().format(widget.data['total_order'])}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: FloatingActionButton(
          backgroundColor: CustomColor().primary,
          onPressed: () async {
            var isSuccess = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SalesOrderItemsForm(data: widget.data),
                ));

            if (isSuccess) {
              loadData();
            }
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
