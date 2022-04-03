import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:sqflite/sqlite_api.dart';

class TransferInScreen extends StatefulWidget {
  const TransferInScreen({Key? key}) : super(key: key);

  @override
  State<TransferInScreen> createState() => _TransferInScreen();
}

class _TransferInScreen extends State<TransferInScreen> {
  DbHelper dbHelper = DbHelper();
  late List<DatatableHeader> _headers;

  List<Map<String, dynamic>> _sources = [];
  List<DataRow> _rows = [];

  int _currentPage = 1;
  bool _isLoading = true;

  int selectedValue = 0;
  List _dropdownPeriods = [];

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
            width: Get.width * 0.15,
            child: Text("27-Feb-2022"),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.25,
            child: Text("800IT202200$i"),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.25,
            child: Text("SJ/2022/II/00$i"),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.1,
            child: Text("Approved"),
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
    _rows = await genData(n: 10);
    setState(() => _isLoading = false);
  }

  void fetchPeriod() async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> maps = await db.query(
      "periods",
      columns: ["periodId", "periodName"],
    );
    List items = [];

    Map<String, dynamic> map = Map();
    map['periodId'] = 0;
    map['periodName'] = "Select";
    items.add(map);

    for (var row in maps) {
      items.add(row);
    }

    setState(() {
      _dropdownPeriods = items;
    });
  }

  void actionDownload() async {
    Database db = await dbHelper.initDb();
    Map<String, dynamic> map = Map();
    map['periodName'] = 'Februari 2022 (1 Feb 2022 - 29 Feb 2022)';
    map['startDate'] = '2022-02-01';
    map['endDate'] = '2022-02-29';
    map['closeActualDate'] = '2022-02-25';
    map['soStartDate'] = '2022-02-25';
    map['soEndDate'] = '2022-02-25';
    map['syncDate'] = '2022-04-02';
    map['syncBy'] = 0;
    int id = await db.insert("periods", map,
        conflictAlgorithm: ConflictAlgorithm.replace);
    Get.snackbar("Insert", "ID ${id.toString()}");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    fetchPeriod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer In List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, right: 12, left: 12),
            child: Row(
              children: [
                const Text("Period"),
                const SizedBox(
                  width: 40,
                ),
                SizedBox(
                  width: Get.width * 0.6,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        style: BorderStyle.solid,
                        width: 0.80,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: true,
                        hint: const Text("Select Period"),
                        items: _dropdownPeriods.map((item) {
                          return DropdownMenuItem(
                            child: Text(item['periodName']),
                            value: item['periodId'],
                          );
                        }).toList(),
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = int.parse(value.toString());
                          });
                        },
                      ),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    actionDownload();
                  },
                  icon: Icon(Icons.download),
                  label: Text("Download"),
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
                    Get.toNamed('/transferinitem');
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
                              'Date',
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Trans No',
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Manual Ref',
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
