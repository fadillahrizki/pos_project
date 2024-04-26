import 'package:flutter/material.dart';
import 'package:pos_project/constants/custom_color.dart';

class DataItemsDetail extends StatelessWidget {
  const DataItemsDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor().primary,
        title: const Text("Detail Items"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: CustomColor().warning,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              width: double.infinity,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "INDOMIE KALDU AYAM",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "P000001 - FOOD",
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Barcode Number"),
                  TextFormField(initialValue: "1234567", enabled: false),
                  const SizedBox(height: 12),
                  const Text("Harga Jual 1-10"),
                  Row(
                    children: [
                      Flexible(
                        child:
                            TextFormField(initialValue: "2500", enabled: false),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: TextFormField(initialValue: "0", enabled: false),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(initialValue: "0", enabled: false),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: TextFormField(initialValue: "0", enabled: false),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(initialValue: "0", enabled: false),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: TextFormField(initialValue: "0", enabled: false),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(initialValue: "0", enabled: false),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: TextFormField(initialValue: "0", enabled: false),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(initialValue: "0", enabled: false),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: TextFormField(initialValue: "0", enabled: false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Satuan"),
                            TextFormField(initialValue: "PCS", enabled: false),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Berat (Gram)"),
                            TextFormField(
                                initialValue: "12345", enabled: false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
