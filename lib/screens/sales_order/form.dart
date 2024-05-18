import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/components/custom_text_field.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  List<dynamic> listSales = [];
  List<dynamic> listCustomer = [];

  dynamic foundSales = {};
  dynamic foundCustomer = {};

  bool isLoading = false;
  bool isSubmitting = false;

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
        listCustomer.addAll(body['data']);
        for (var value in body['data']) {
          customerItems.add(DropdownMenuItem(
              value: value['id_customer'],
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
        listSales.addAll(body['data']);
        for (var value in body['data']) {
          salesItems.add(DropdownMenuItem(
              value: value['id_sales'],
              child: Text(value['nama_sales'],
                  style: const TextStyle(fontSize: 14))));
        }
      });
    }
  }

  changeCustomer(String? value) {
    setState(() {
      selectedCustomer = value!;

      foundCustomer = listCustomer.firstWhere(
          (customer) => customer['id_customer'] == selectedCustomer,
          orElse: () => null);
    });
  }

  changeSales(String? value) {
    setState(() {
      selectedSales = value!;

      foundSales = listSales.firstWhere(
          (sales) => sales['id_sales'] == selectedSales,
          orElse: () => null);
    });
  }

  loadAll() async {
    setState(() {
      isLoading = true;
    });

    await loadCustomers();
    await loadSales();

    if (widget.data != const {}) {
      changeCustomer(widget.data['id_customer']);
      changeSales(widget.data['id_sales']);

      nomorSoController.text = widget.data['no_order'];
      keteranganController.text = widget.data['keterangan'];

      setState(() {
        selectedDate = widget.data['tgl_order'];
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  submitData(context) async {
    setState(() {
      isSubmitting = true;
    });

    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var user = jsonDecode(localStorage.getString('userData')!);

      var updateData =
          widget.data != const {} ? {'no_order': nomorSoController.text} : {};

      var res = await ApiService().postSalesOrder(
          data: jsonEncode({
            ...updateData,
            'tgl_order': selectedDate,
            'id_customer': foundCustomer['id_customer'] ?? '',
            'nama_customer': foundCustomer['nama_customer'] ?? '',
            'telepon': foundCustomer['telepon'],
            'id_sales': foundSales['id_sales'] ?? '',
            'nama_sales': foundSales['nama_sales'] ?? '',
            'keterangan': keteranganController.text,
            'username': user['username'],
          }),
          type: widget.data != const {} ? 'update' : 'new');

      Map<String, dynamic> body = jsonDecode(res.body);

      if (body['status'] == 1) {
        showMsg(body['message']);
        Navigator.pop(context, true);
      } else {
        if (widget.data != const {}) {
          showMsg('Gagal tambah order!');
        } else {
          showMsg('Gagal update order!');
        }
      }
      print(body.toString());
    } catch (e) {
      print(e.toString());
      showMsg('Terjadi kesalahan pada server!');
    }

    setState(() {
      isSubmitting = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadAll();
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
          "Add/Edit Sales Order",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: CustomColor().primary))
          : SingleChildScrollView(
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
                      value: selectedSales,
                      onChanged: changeSales,
                      items: salesItems,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: "Keterangan",
                      controller: keteranganController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      enabled: !isSubmitting,
                      onPressed: () {
                        if (selectedDate == null) {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return const AlertDialog(
                                  content: Text(
                                      "Silahkan pilih tanggal terlebih dahulu"),
                                );
                              });
                        } else if (selectedCustomer == "ALL") {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return const AlertDialog(
                                  content: Text(
                                      "Silahkan pilih customer terlebih dahulu"),
                                );
                              });
                        } else if (selectedSales == "ALL") {
                          showDialog(
                              context: context,
                              builder: (_) {
                                return const AlertDialog(
                                  content: Text(
                                      "Silahkan pilih sales terlebih dahulu"),
                                );
                              });
                        } else {
                          submitData(context);
                        }
                      },
                      label: isSubmitting ? "Loading.." : "Submit",
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
