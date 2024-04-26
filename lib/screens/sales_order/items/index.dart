import 'package:flutter/material.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/constants/custom_color.dart';

class SalesOrderItems extends StatefulWidget {
  const SalesOrderItems({super.key});

  @override
  State<SalesOrderItems> createState() => _SalesOrderItemsState();
}

class _SalesOrderItemsState extends State<SalesOrderItems> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor().primary,
        title: const Text("Items Sales Order"),
      ),
      body: Column(
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
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("SO-123455"),
                          Text(
                            "Total Order: Rp.35.500,-",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text("Qty Order : 12")
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              CustomButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/sales_order/items');
                                },
                                label: 'Edit',
                                size: 'sm',
                              ),
                              const SizedBox(width: 6),
                              CustomButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/sales_order/items');
                                },
                                label: 'Delete',
                                type: 'danger',
                                size: 'sm',
                              ),
                            ],
                          ),
                          const Text("Nominal Diskon ?"),
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
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Items: 5"),
                Text(
                  "Total Order: 200.000",
                  style: TextStyle(fontWeight: FontWeight.bold),
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
          onPressed: () {
            Navigator.pushNamed(context, '/sales_order/items/form');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
