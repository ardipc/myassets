import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_table/responsive_table.dart';

class TransferOutItemListScreen extends StatefulWidget {
  const TransferOutItemListScreen({Key? key}) : super(key: key);

  @override
  State<TransferOutItemListScreen> createState() =>
      _TransferOutItemListScreen();
}

class _TransferOutItemListScreen extends State<TransferOutItemListScreen> {
  String selectedValue = "USA";

  late List<DatatableHeader> _headers;

  List<Map<String, dynamic>> _sources = [];
  List<DataRow> _rows = [];

  int _currentPage = 1;
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Out Item List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, right: 12, left: 12),
            child: Row(
              children: [
                const Text("Trans No"),
                const SizedBox(
                  width: 40,
                ),
                SizedBox(
                  width: Get.width * 0.76,
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: Get.width,
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    Get.toNamed('/transferinitemform');
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add"),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: Get.height * 0.732,
                ),
                child: Card(
                  elevation: 1,
                  shadowColor: Colors.black,
                  clipBehavior: Clip.none,
                  child: ListView(
                    children: [
                      DataTable(
                        columnSpacing: 0.5,
                        dataRowHeight: 40,
                        columns: [
                          DataColumn(
                            label: Text(
                              'No.',
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Tag No',
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Description',
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Qty',
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Status',
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Action',
                            ),
                          ),
                        ],
                        rows: _rows,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Icon(Icons.chevron_left),
                ),
                Text("1 / 10 pages"),
                TextButton(
                  onPressed: () {},
                  child: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("USA"), value: "USA"),
      DropdownMenuItem(child: Text("Canada"), value: "Canada"),
      DropdownMenuItem(child: Text("Brazil"), value: "Brazil"),
      DropdownMenuItem(child: Text("England"), value: "England"),
    ];
    return menuItems;
  }

  List<DataRow> genData({int n: 10}) {
    List<DataRow> temps = [];
    final List source = List.filled(n, Random.secure());
    var i = 1;
    for (var data in source) {
      DataRow row = DataRow(cells: [
        DataCell(
          Container(
            width: Get.width * 0.1,
            child: Text("$i"),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.2,
            child: Text("TN202202-000$i"),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.25,
            child: Text("Tablet #$i"),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.1,
            child: Text("10$i"),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.1,
            child: Text("RUSAK"),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.1,
            child: TextButton(
              onPressed: () {},
              child: Icon(Icons.edit_note),
            ),
          ),
        ),
      ]);
      temps.add(row);
      i++;
    }
    return temps;
  }

  void fetchData() async {
    setState(() => _isLoading = true);
    _rows = await genData(n: 5);
    setState(() => _isLoading = false);
  }
}
