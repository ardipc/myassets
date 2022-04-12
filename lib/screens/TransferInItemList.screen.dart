import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:sqflite/sqlite_api.dart';

class TransferInItemListScreen extends StatefulWidget {
  const TransferInItemListScreen({Key? key}) : super(key: key);

  @override
  State<TransferInItemListScreen> createState() => _TransferInItemListScreen();
}

class _TransferInItemListScreen extends State<TransferInItemListScreen> {
  final box = GetStorage();
  DbHelper dbHelper = DbHelper();

  String selectedValue = "USA";

  int idFaTrans = 0;
  final transNo = TextEditingController();

  late List<DatatableHeader> _headers;

  List<Map<String, dynamic>> _sources = [];
  List<DataRow> _rows = [];

  int _currentPage = 1;
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idFaTrans = Get.arguments[0];
    transNo.text = Get.arguments[1];
    fetchData();
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

  Future<List<DataRow>> genData() async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> maps = await db.query(
      "fatransitem",
      where: "faId = ?",
      whereArgs: [Get.arguments[0]],
    );

    List<DataRow> temps = [];
    var i = 1;
    for (var data in maps) {
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
            child: Text(data['tagNo']),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.25,
            child: Text(data['remarks']),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.1,
            child: Text("1"),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.1,
            child: Text(data['conStatCode']),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.1,
            child: TextButton(
              onPressed: () {
                Get.toNamed(
                  '/transferinitemform',
                  arguments: [Get.arguments[0], Get.arguments[1], data['id']],
                )?.whenComplete(() => fetchData());
              },
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
    _rows = await genData();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer In Item List'),
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
                    controller: transNo,
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
                    Get.toNamed(
                      '/transferinitemform',
                      arguments: [Get.arguments[0], Get.arguments[1], 0],
                    )?.whenComplete(() => fetchData());
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
}
