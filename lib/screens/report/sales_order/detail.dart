import 'package:flutter/material.dart';
import 'package:pos_project/constants/custom_color.dart';

class ReportSalesOrderDetail extends StatelessWidget {
  const ReportSalesOrderDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor().primary,
        title: const Text("Report Sales Order (Detail)"),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("01 Apr 2024"),
                      Text("Nama Sales"),
                    ],
                  )
                ],
              ),
              Divider(),
              Text("INDOMIE KALDU @2.500"),
              Text("Barcode + Kode Items"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("50 pcs"),
                  Text("Nominal Diskon?"),
                  Text("125.000,-"),
                ],
              ),
              SizedBox(height: 12),
              Text("AQUA BOTOL @2.000"),
              Text("Barcode + Kode Items"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("100 pcs"),
                  Text("Nominal Diskon?"),
                  Text("200.000,-"),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total Items: 2"),
                  Text(
                    "Total Order: 325.000,-",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
