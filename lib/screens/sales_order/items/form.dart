import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/components/custom_text_field.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/services/api_service.dart';

class SalesOrderItemsForm extends StatefulWidget {
  const SalesOrderItemsForm(
      {super.key, required this.data, this.item = const {}});

  final Map data, item;

  @override
  State<SalesOrderItemsForm> createState() => _SalesOrderItemsFormState();
}

class _SalesOrderItemsFormState extends State<SalesOrderItemsForm> {
  String selectedItem = "";

  List<DropdownMenuItem<String>> items = [
    const DropdownMenuItem(
        value: "", child: Text("Select Item", style: TextStyle(fontSize: 14))),
  ];

  TextEditingController barcodeNumberController = TextEditingController();
  TextEditingController satuanController = TextEditingController();
  TextEditingController qtyOrderController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController jumlahOrderController = TextEditingController();

  loadItems() async {
    var res =
        await ApiService().getReportSalesOrderDetail(widget.data['no_order']);
    Map<String, dynamic> body = jsonDecode(res.body);

    if (body['status'] == 1) {
      setState(() {
        for (var value in body['data']) {
          items.add(DropdownMenuItem(
              value: "${value['kode_item']} - ${value['nama_item']}",
              child: Text("${value['kode_item']} - ${value['nama_item']}",
                  style: const TextStyle(fontSize: 14))));
        }
      });
    }

    if (widget.item != const {}) {
      changeItem("${widget.item['kode_item']} - ${widget.item['nama_item']}");

      barcodeNumberController.text = widget.item['barcode_number'];
      satuanController.text = widget.item['harga_satuan'].toString();
      qtyOrderController.text = widget.item['qty_order'].toString();
      discountController.text = widget.item['nominal_diskon'].toString();
      jumlahOrderController.text = widget.item['jumlah'].toString();
    }
  }

  changeItem(String? value) async {
    setState(() {
      selectedItem = value!;
    });
  }

  @override
  void initState() {
    super.initState();

    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor().primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Add/Edit Items Sales Order",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Kode Items"),
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
                    value: selectedItem,
                    onChanged: changeItem,
                    items: items,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: "Barcode Number",
                    controller: barcodeNumberController,
                    enabled: false,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: "Harga Satuan",
                    controller: satuanController,
                    enabled: false,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: "Qty Order",
                    controller: qtyOrderController,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: "Nominal Diskon %",
                    controller: discountController,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    label: "Jumlah Order",
                    controller: jumlahOrderController,
                    enabled: false,
                  ),
                  const SizedBox(height: 12),
                  CustomButton(onPressed: () {}, label: "Submit")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
