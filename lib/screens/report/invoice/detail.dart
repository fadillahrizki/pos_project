import 'package:flutter/material.dart';
import 'package:pos_project/constants/custom_color.dart';

class ReportInvoiceDetail extends StatelessWidget {
  const ReportInvoiceDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor().primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Report Invoice (Detail)",
          style: TextStyle(color: Colors.white),
        ),
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
                      Text("INV-123456"),
                      Text("EDY GUNAWAN"),
                      Text("No Telepon Customer"),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("01 Apr 2024"),
                      Text("Tgl Jatuh Tempo"),
                      Text("ID Gudang"),
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
                    "Jumlah: 325.000",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Potongan (0%): 0,-"),
                    SizedBox(
                      width: 200,
                      child: Divider(),
                    ),
                    Text("DPP: 325.000"),
                    Text("PPN (0%): 0"),
                    SizedBox(
                      width: 200,
                      child: Divider(),
                    ),
                    Text(
                      "Total Transaksi: 325.000",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Text("Nama Supir"),
              Text("Nama Sales"),
            ],
          ),
        ),
      ),
    );
  }
}
