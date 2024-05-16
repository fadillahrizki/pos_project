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
  TextEditingController discountNumController = TextEditingController();
  TextEditingController jumlahOrderController = TextEditingController();

  bool isLoading = false;
  bool isSubmitting = false;

  List<dynamic> listItems = [];
  dynamic foundItem = {};

  loadItems() async {
    setState(() {
      isLoading = true;
    });
    var res =
        await ApiService().getReportSalesOrderDetail(widget.data['no_order']);
    Map<String, dynamic> body = jsonDecode(res.body);

    if (body['status'] == 1) {
      setState(() {
        listItems.addAll(body['data']);
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
    }

    setState(() {
      isLoading = false;
    });
  }

  changeItem(String? value) async {
    setState(() {
      selectedItem = value!;

      foundItem = listItems.firstWhere(
          (item) =>
              "${item['kode_item']} - ${item['nama_item']}" == selectedItem,
          orElse: () => null);

      barcodeNumberController.text = foundItem['barcode_number'].toString();
      satuanController.text = foundItem['harga_satuan'].toString();
      qtyOrderController.text = foundItem['qty_order'].toString();
      discountController.text = foundItem['persen_diskon'].toString();
      discountNumController.text = foundItem['nominal_diskon'].toString();
      jumlahOrderController.text = foundItem['jumlah'].toString();
    });
  }

  submitItem(context) async {
    setState(() {
      isSubmitting = true;
    });

    try {
      var updateData =
          widget.item != const {} ? {"dtl_id": foundItem['dtl_id']} : {};

      var res = await ApiService().postSalesOrderItem(
        data: jsonEncode({
          ...updateData,
          'no_order': widget.data['no_order'],
          'barcode_number': foundItem['barcode_number'] ?? '',
          'id_item': foundItem['id_item'] ?? '',
          'id_itemdetail': foundItem['id_itemdetail'] ?? '',
          'kode_item': foundItem['kode_item'] ?? '',
          'nama_item': foundItem['nama_item'] ?? '',
          'id_kategori': foundItem['id_kategori'] ?? '',
          'nama_kategori': foundItem['nama_kategori'] ?? '',
          'harga_satuan': foundItem['harga_satuan'] ?? '',
          'qty_order': qtyOrderController.text,
          'satuan': foundItem['satuan'] ?? '',
          'disc_persen': discountController.text,
          'disc_nominal': discountNumController.text,
          'jumlah_harga': jumlahOrderController.text,
        }),
        type: widget.item != const {} ? 'update' : 'new',
      );

      Map<String, dynamic> body = jsonDecode(res.body);
      showMsg(body['message']);
      Navigator.pop(context, true);
    } catch (e) {
      if (widget.item != const {}) {
        showMsg('Gagal tambah item!');
      } else {
        showMsg('Gagal update item!');
      }
    }

    setState(() {
      isSubmitting = false;
    });
  }

  @override
  void initState() {
    super.initState();

    loadItems();

    discountController.addListener(() {
      var discount = double.tryParse(discountController.text) ?? 0;

      if (foundItem != {}) {
        var price = double.tryParse(foundItem['harga_satuan'].toString()) ?? 0;
        discountNumController.text = (discount * price / 100).toString();
      }
    });

    qtyOrderController.addListener(() {
      var qty = double.tryParse(qtyOrderController.text) ?? 0;

      if (foundItem != {}) {
        var price = double.tryParse(foundItem['harga_satuan'].toString()) ?? 0;
        jumlahOrderController.text = (qty * price).toString();
      }
    });
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
          "Add/Edit Items Sales Order",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: CustomColor().primary))
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: CustomColor().warning,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
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
                            Text(DateFormat('dd MMMM yyyy').format(
                                DateTime.parse(widget.data['tgl_order']))),
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
                              borderSide: BorderSide(
                                  color: CustomColor().primary, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: CustomColor().primary, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: CustomColor().primary, width: 2),
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
                          keyboardType: TextInputType.number,
                          label: "Qty Order",
                          controller: qtyOrderController,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          keyboardType: TextInputType.number,
                          label: "Persen Diskon %",
                          controller: discountController,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          label: "Nominal Diskon",
                          controller: discountNumController,
                          enabled: false,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          label: "Jumlah Order",
                          controller: jumlahOrderController,
                          enabled: false,
                        ),
                        const SizedBox(height: 12),
                        CustomButton(
                          enabled: !isSubmitting,
                          onPressed: () {
                            submitItem(context);
                          },
                          label: isSubmitting ? "Loading.." : "Submit",
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
