import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/services/Period.service.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:sqflite/sqlite_api.dart';

class TransferInScreen extends StatefulWidget {
  const TransferInScreen({Key? key}) : super(key: key);

  @override
  State<TransferInScreen> createState() => _TransferInScreen();
}

class _TransferInScreen extends State<TransferInScreen> {
  final box = GetStorage();
  DbHelper dbHelper = DbHelper();
  late List<DatatableHeader> _headers;

  List<Map<String, dynamic>> _sources = [];
  List<DataRow> _rows = [];

  int _currentPage = 1;
  bool _isLoading = true;

  int? selectedValue = null;
  List _dropdownPeriods = [];

  void fetchSinglePeriod() async {
    final periodService = PeriodService();
    periodService.getNow().then((value) {
      setState(() {
        selectedValue = value.body['periodId'];
      });
    });
  }

  Future<List<DataRow>> genData() async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> maps = await db.query(
      "fatrans",
      where: "transferTypeCode = ? AND isVoid = ?",
      whereArgs: ["TI", 0],
    );

    List<DataRow> temps = [];
    var i = 1;
    for (var data in maps) {
      DataRow row = DataRow(cells: [
        DataCell(
          Container(
            width: Get.width * 0.075,
            child: Text("$i"),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.2,
            child: Text(data['transDate']),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.20,
            child: Text(data['transNo']),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.25,
            child: Text(data['manualRef']),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.1,
            child: Text(
              data['isApproved'] == 0 ? "Not Yet" : "Approved",
              style: TextStyle(
                color: data['isApproved'] == 0 ? Colors.red : Colors.green,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.1,
            child: TextButton(
              onPressed: () {
                Get.toNamed('/transferinitem', arguments: [data['id']])
                    ?.whenComplete(() => fetchData());
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

  void fetchPeriod() async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> maps = await db.query(
      "periods",
      columns: ["periodId", "periodName"],
    );
    List items = [];

    for (var row in maps) {
      items.add(row);
    }

    setState(() {
      _dropdownPeriods = items;
    });
  }

  void confirmDownload() {
    Get.dialog(
      AlertDialog(
        title: Text("Confirmation"),
        content: Text("Are you sure to sync data period now ?"),
        actions: [
          TextButton(
            onPressed: () {
              actionDownload();
              Get.back();
            },
            child: Text("YES"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("NO"),
          ),
        ],
      ),
    );
  }

  void actionDownload() async {
    Database db = await dbHelper.initDb();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    Map<String, dynamic> map = Map();
    map['transId'] = 1;
    map['plantId'] = 1;
    map['transTypeCode'] = "T";
    map['transDate'] = "2022-04-04";
    map['transNo'] = "TR02";
    map['manualRef'] = "MR002";
    map['otherRef'] = "";
    map['transferTypeCode'] = "TI";
    map['oldLocId'] = 0;
    map['newLocId'] = 0;
    map['isApproved'] = 0;
    map['isVoid'] = 0;
    map['saveDate'] = formattedDate;
    map['savedBy'] = box.read('userId');
    map['uploadDate'] = "";
    map['uploadBy'] = "";
    map['uploadMessage'] = "";
    map['syncDate'] = "";
    map['syncBy'] = 0;

    int insertId = await db.insert("fatrans", map,
        conflictAlgorithm: ConflictAlgorithm.replace);
    Get.snackbar("Information", insertId.toString());

    fetchData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    fetchPeriod();
    fetchSinglePeriod();
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
                    confirmDownload();
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
                    Get.toNamed('/transferinitem')
                        ?.whenComplete(() => fetchData());
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
