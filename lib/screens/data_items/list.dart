import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_project/components/custom_button.dart';
import 'package:pos_project/constants/custom_color.dart';
import 'package:pos_project/screens/data_items/detail.dart';
import 'package:pos_project/services/api_service.dart';

class DataItemsList extends StatefulWidget {
  const DataItemsList({super.key, required this.category});

  final String category;

  @override
  State<DataItemsList> createState() => _DataItemsListState();
}

class _DataItemsListState extends State<DataItemsList> {
  List items = [];
  bool isLoading = true;

  Future<void> loadData({name = '', isRefresh = false}) async {
    if (!isRefresh) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      var res = await ApiService().getItems(
        category: widget.category == 'ALL' ? '' : widget.category,
        name: name,
      );
      Map<String, dynamic> body = jsonDecode(res.body);
      if (body['status'] == 1) {
        setState(() {
          items = body['data'] ?? [];
        });
      }
    } catch (e) {
      print(e.toString());

      showMsg('Terjadi kesalahan pada server!');
    }
    setState(() {
      isLoading = false;
    });
  }

  showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  String searchQuery = "";

  Widget buildSearchField() {
    return TextField(
      controller: searchController,
      onSubmitted: submitSearch,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: "Search...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> buildActions() {
    if (isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (searchController.text.isEmpty) {
              loadData();
              setState(() {
                isSearching = false;
              });
              return;
            }
            clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: startSearch,
      ),
    ];
  }

  void startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  void submitSearch(value) {
    loadData(name: value);
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  void clearSearchQuery() {
    setState(() {
      searchController.clear();
      updateSearchQuery("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor().primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: isSearching
            ? buildSearchField()
            : const Text(
                "Data Items",
                style: TextStyle(color: Colors.white),
              ),
        actions: buildActions(),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: CustomColor().primary,
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () => loadData(isRefresh: true),
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        var item = items[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item['nama_item']),
                                        Text(
                                          "Rp.${NumberFormat.decimalPattern().format(item['hargajual'])}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(item['nama_kategori'])
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Stok: ${item['sisa_stok']} ${item['detail'][0]['satuan']}",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        CustomButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DataItemsDetail(data: item),
                                              ),
                                            );
                                          },
                                          label: 'Detail',
                                          size: 'sm',
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const Divider()
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
          Container(
            width: double.infinity,
            color: CustomColor().warning,
            padding: const EdgeInsets.all(12),
            child: Text(
              "Total: ${items.length} Records (${widget.category})",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
