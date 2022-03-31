import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/screens/Table.screen.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:sqflite/sqlite_api.dart';

class StockOpnameScreen extends StatefulWidget {
  StockOpnameScreen({Key? key}) : super(key: key);

  @override
  State<StockOpnameScreen> createState() => _StockOpnameScreenState();
}

class _StockOpnameScreenState extends State<StockOpnameScreen> {
  DbHelper dbHelper = DbHelper();

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
    print("initState");
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    fetchData();
    print("didChangeDependencies");
  }

  @override
  void didUpdateWidget(covariant StockOpnameScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    fetchData();
    print("didUpdateWidget");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Opname'),
        actions: [
          TextButton(
            onPressed: () {
              fetchData();
            },
            child: Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
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
                        items: dropdownItems,
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value.toString();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Get.toNamed('/table');
                  },
                  icon: Icon(Icons.download),
                  label: Text("Download"),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: Get.height * 0.6,
                ),
                child: Card(
                  elevation: 1,
                  shadowColor: Colors.black,
                  clipBehavior: Clip.none,
                  child: ListView(
                    children: [
                      DataTable(
                        columnSpacing: 0.5,
                        dataRowHeight: 110,
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
                              'Closing Result',
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Stock Opname',
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
          Container(
            width: Get.width,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                  height: 50,
                  width: 600,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 62, 81, 255),
                    ),
                    onPressed: () {
                      Get.toNamed('/stockopnameitem')
                          ?.whenComplete(() => fetchData());
                    },
                    child: Text(
                      "Scan / Entry Asset",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                  height: 50,
                  width: 600,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 85, 189, 90),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 6.0, right: 6.0, bottom: 6.0, top: 3.0),
                  height: 50,
                  width: 600,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 108, 47, 207),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Upload to Server",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
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

  Future<List<DataRow>> genData() async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> maps = await db.query("stockopnames");

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
            child: Text(data['faId'].toString()),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.2,
            child: Text(data['locationId'].toString()),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.2,
            child: Text(
                "qty = ${data['qty'].toString()}\ncondition = condition = ${data['conStatCode'].toString()}"),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.3,
            child: InkWell(
              onTap: () => Get.toNamed(
                '/stockopnameitem',
                arguments: [data['id']],
              )?.whenComplete(() => fetchData()),
              child: Text(
                  "qty = ${data['qty'].toString()}\nexistence = ${data['existStatCode'].toString()}\ntagging = ${data['tagStatCode'].toString()}\nusage = ${data['usageStatCode'].toString()}\ncondition = ${data['conStatCode'].toString()}\nowner = ${data['ownStatCode'].toString()}"),
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
    _headers = [
      DatatableHeader(text: "No.", value: "no", show: true),
      DatatableHeader(text: "Tag No", value: "tagNo", show: true),
      DatatableHeader(text: "Description", value: "description", show: true),
      DatatableHeader(
          text: "Closing Result", value: "closingResult", show: true),
      DatatableHeader(text: "Stock Opname", value: "stockOpname", show: true)
    ];
    _rows = await genData();
    setState(() => _isLoading = false);
  }
}
