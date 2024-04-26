import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/components/custom_text_field.dart';
import 'package:pos_project/constants/custom_color.dart';

class SalesOrderForm extends StatefulWidget {
  const SalesOrderForm({super.key});

  @override
  State<SalesOrderForm> createState() => _SalesOrderFormState();
}

class _SalesOrderFormState extends State<SalesOrderForm> {
  String selectedCustomer = "EDY";
  List<DropdownMenuItem<String>> get customerItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "EDY", child: Text("EDY")),
      const DropdownMenuItem(value: "HAMZAH", child: Text("HAMZAH")),
      const DropdownMenuItem(value: "RIZKY", child: Text("RIZKY")),
    ];
    return menuItems;
  }

  String selectedSales = "EDY";
  List<DropdownMenuItem<String>> get salesItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "EDY", child: Text("EDY")),
      const DropdownMenuItem(value: "HAMZAH", child: Text("HAMZAH")),
      const DropdownMenuItem(value: "RIZKY", child: Text("RIZKY")),
    ];
    return menuItems;
  }

  String? _selectedDate;
  DateTime? _selectedDatePicker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor().primary,
        title: const Text("Add/Edit Sales Order"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(label: "No SO"),
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
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCustomer = newValue!;
                  });
                },
                items: customerItems,
              ),
              const SizedBox(height: 12),
              const Text("Tanggal"),
              const SizedBox(height: 12),
              CustomButton(
                type: 'secondary',
                onPressed: () async {
                  _selectedDatePicker = await showDatePicker(
                    context: context,
                    initialDate: _selectedDatePicker,
                    firstDate: DateTime(DateTime.now().year),
                    lastDate: DateTime(DateTime.now().year + 1),
                  );

                  if (_selectedDatePicker != null) {
                    setState(() {
                      _selectedDate = DateFormat('dd MMMM yyyy')
                          .format(_selectedDatePicker!);
                    });
                  }
                },
                label: _selectedDate ?? 'Pilih tanggal',
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
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSales = newValue!;
                  });
                },
                items: salesItems,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Keterangan",
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              CustomButton(onPressed: () {}, label: "Submit")
            ],
          ),
        ),
      ),
    );
  }
}
