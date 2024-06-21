import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/screens/sales_order/form.dart';
import 'package:pos_project/screens/sales_order/items/index.dart';
import 'package:pos_project/services/api_service.dart';

class SalesOrderList extends StatefulWidget {
  const SalesOrderList(
      {super.key,
      required this.customer,
      required this.fromDate,
      required this.toDate});

  final String customer, fromDate, toDate;

  @override
  State<SalesOrderList> createState() => _SalesOrderListState();
}

class _SalesOrderListState extends State<SalesOrderList> {
  List salesOrders = [];
  bool isLoading = true;
  bool isLoadingAction = false;
  String actionId = "";

  Future<void> loadData({isRefresh = false}) async {
    if (!isRefresh) {
      setState(() {
        isLoading = true;
      });
    }

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

  cancel(noOrder) async {
    setState(() {
      isLoadingAction = true;
      actionId = noOrder;
    });
    try {
      var res = await ApiService().cancelSalesOrder(
        jsonEncode({
          'no_order': noOrder,
        }),
      );
      Map<String, dynamic> body = jsonDecode(res.body);

      if (body['status'] == 1) {
        showMsg('Sukses cancel sales order!');
        loadData();
      } else {
        showMsg('Gagal cancel sales order!');
      }
      print(body.toString());
    } catch (e) {
      print(e.toString());
      showMsg('Terjadi kesalahan pada server!');
    }
    setState(() {
      isLoadingAction = false;
      actionId = "";
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
          "Sales Order",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: CustomColor().primary))
          : Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => loadData(isRefresh: true),
                    child: ListView.builder(
                      itemCount: salesOrders.length,
                      itemBuilder: (context, index) {
                        var item = salesOrders[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['no_order']),
                                  Text(
                                    "Rp.${NumberFormat.decimalPattern().format(item['total_order'])}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("Total Items : ${item['total_items']}")
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
                                  Row(
                                    children: [
                                      item['status_order'] != 2
                                          ? CustomButton(
                                              onPressed: () async {
                                                final value =
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SalesOrderForm(
                                                            data: item,
                                                          ),
                                                        ));

                                                if (value) {
                                                  loadData();
                                                }
                                              },
                                              label: 'Edit',
                                              size: 'sm',
                                            )
                                          : Container(),
                                      const SizedBox(width: 6),
                                      CustomButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SalesOrderItems(
                                                  data: item,
                                                ),
                                              ));
                                        },
                                        label: 'Items',
                                        size: 'sm',
                                        type: 'info',
                                      ),
                                      const SizedBox(width: 6),
                                      item['status_order'] != 2
                                          ? CustomButton(
                                              onPressed: () {
                                                cancel(item['no_order']);
                                              },
                                              label: 'Cancel',
                                              size: 'sm',
                                              type: 'danger',
                                              enabled: !(isLoadingAction &&
                                                  actionId == item['no_order']),
                                            )
                                          : Container(),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColor().primary,
        onPressed: () async {
          var isSuccess = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SalesOrderForm(),
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
    );
  }
}
