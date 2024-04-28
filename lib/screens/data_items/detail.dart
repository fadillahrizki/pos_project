import 'package:flutter/material.dart';
import 'package:pos_project/constants/custom_color.dart';

class DataItemsDetail extends StatefulWidget {
  const DataItemsDetail({super.key, required this.data});

  final Map data;

  @override
  State<DataItemsDetail> createState() => _DataItemsDetailState();
}

class _DataItemsDetailState extends State<DataItemsDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor().primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Detail Items",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: CustomColor().warning,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.data['nama_item'],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${widget.data['kode_item']} - ${widget.data['nama_kategori']}",
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
                  TextFormField(
                      initialValue: widget.data['detail'][0]['barcode_number'],
                      enabled: false),
                  const SizedBox(height: 12),
                  const Text("Harga Jual 1-10"),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                            initialValue: widget.data['detail'][0]['hargajual1']
                                .toString(),
                            enabled: false),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: TextFormField(
                            initialValue: widget.data['detail'][0]['hargajual2']
                                .toString(),
                            enabled: false),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                            initialValue: widget.data['detail'][0]['hargajual3']
                                .toString(),
                            enabled: false),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: TextFormField(
                            initialValue: widget.data['detail'][0]['hargajual4']
                                .toString(),
                            enabled: false),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                            initialValue: widget.data['detail'][0]['hargajual5']
                                .toString(),
                            enabled: false),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: TextFormField(
                            initialValue: widget.data['detail'][0]['hargajual6']
                                .toString(),
                            enabled: false),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                            initialValue: widget.data['detail'][0]['hargajual7']
                                .toString(),
                            enabled: false),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: TextFormField(
                            initialValue: widget.data['detail'][0]['hargajual8']
                                .toString(),
                            enabled: false),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                            initialValue: widget.data['detail'][0]['hargajual9']
                                .toString(),
                            enabled: false),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: TextFormField(
                            initialValue: widget.data['detail'][0]
                                    ['hargajual10']
                                .toString(),
                            enabled: false),
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
                            TextFormField(
                                initialValue: widget.data['detail'][0]['satuan']
                                    .toString(),
                                enabled: false),
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
                                initialValue: widget.data['detail'][0]['berat']
                                    .toString(),
                                enabled: false),
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
