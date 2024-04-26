import 'package:flutter/material.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/components/custom_text_field.dart';
import 'package:pos_project/constants/custom_color.dart';

class SalesOrderItemsForm extends StatefulWidget {
  const SalesOrderItemsForm({super.key});

  @override
  State<SalesOrderItemsForm> createState() => _SalesOrderItemsFormState();
}

class _SalesOrderItemsFormState extends State<SalesOrderItemsForm> {
  String selectedItem = "INDOMIE";
  List<DropdownMenuItem<String>> get items {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "INDOMIE", child: Text("INDOMIE")),
      const DropdownMenuItem(value: "AQUA", child: Text("AQUA")),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor().primary,
        title: const Text("Add/Edit Items Sales Order"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: CustomColor().warning,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("SO-123456"),
                      Text("EDY GUNAWAN"),
                      Text("No Telepon Customer"),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("16 APr 2024"),
                      Text("Nama Sales"),
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
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedItem = newValue!;
                      });
                    },
                    items: items,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(label: "Barcode Number"),
                  const SizedBox(height: 12),
                  CustomTextField(label: "Harga Satuan"),
                  const SizedBox(height: 12),
                  CustomTextField(label: "Qty Order"),
                  const SizedBox(height: 12),
                  CustomTextField(label: "Nominal Diskon"),
                  const SizedBox(height: 12),
                  CustomTextField(label: "Jumlah Order"),
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
