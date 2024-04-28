import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/components/custom_text_field.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/services/api_service.dart';

class SalesOrderForm extends StatefulWidget {
  const SalesOrderForm({super.key, this.data = const {}});

  final Map data;

  @override
  State<SalesOrderForm> createState() => _SalesOrderFormState();
}

class _SalesOrderFormState extends State<SalesOrderForm> {
  String selectedCustomer = "ALL";
  List<DropdownMenuItem<String>> customerItems = [
    const DropdownMenuItem(
        value: "ALL",
        child: Text("SELECT CUSTOMER", style: TextStyle(fontSize: 14))),
  ];

  String selectedSales = "ALL";
  List<DropdownMenuItem<String>> salesItems = [
    const DropdownMenuItem(
        value: "ALL",
        child: Text("SELECT SALES", style: TextStyle(fontSize: 14))),
  ];

  String? selectedDate;
  DateTime? selectedDatePicker;

  TextEditingController nomorSoController =
      TextEditingController(text: 'Empty');
  TextEditingController keteranganController = TextEditingController();

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

  loadSales() async {
    var res = await ApiService().getKaryawan();
    Map<String, dynamic> body = jsonDecode(res.body);

    if (body['status'] == 1) {
      setState(() {
        for (var value in body['data']) {
          salesItems.add(DropdownMenuItem(
              value: value['nama_sales'],
              child: Text(value['nama_sales'],
                  style: const TextStyle(fontSize: 14))));
        }
      });
    }
  }

  changeCustomer(String? value) {
    setState(() {
      selectedCustomer = value!;
    });
  }

  changeSales(String? value) {
    setState(() {
      selectedSales = value!;
    });
  }

  loadAll() async {
    await loadCustomers();
    await loadSales();

    if (widget.data != const {}) {
      changeCustomer(widget.data['nama_customer']);
      changeSales(widget.data['nama_sales']);

      nomorSoController.text = widget.data['no_order'];
      keteranganController.text = widget.data['keterangan'];

      setState(() {
        selectedDate = widget.data['tgl_order'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor().primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Add/Edit Sales Order",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: "Nomor SO",
                enabled: false,
                controller: nomorSoController,
              ),
              const SizedBox(height: 12),
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
                onChanged: changeCustomer,
                items: customerItems,
              ),
              const SizedBox(height: 12),
              const Text("Tanggal"),
              const SizedBox(height: 12),
              CustomButton(
                type: 'secondary',
                onPressed: () async {
                  selectedDatePicker = await showDatePicker(
                    context: context,
                    initialDate: selectedDatePicker,
                    firstDate: DateTime(DateTime.now().year),
                    lastDate: DateTime(DateTime.now().year + 1),
                  );

                  if (selectedDatePicker != null) {
                    setState(() {
                      selectedDate = DateFormat('dd MMMM yyyy')
                          .format(selectedDatePicker!);
                    });
                  }
                },
                label: selectedDate ?? 'Pilih tanggal',
              ),
              const SizedBox(height: 12),
              const Text("Sales"),
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
                value: selectedSales,
                onChanged: changeSales,
                items: salesItems,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Keterangan",
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              CustomButton(
                  onPressed: () {
                    if (selectedDatePicker == null) {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return const AlertDialog(
                              content: Text(
                                  "Silahkan pilih tanggal terlebih dahulu"),
                            );
                          });
                    }
                  },
                  label: "Submit")
            ],
          ),
        ),
      ),
    );
  }
}
