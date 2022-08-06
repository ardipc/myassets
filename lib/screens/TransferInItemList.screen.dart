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

  List<DataRow> _rows = [];

  int _currentPage = 1;
  bool _isLoading = true;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    idFaTrans = Get.arguments[0];
    transNo.text = Get.arguments[1];
    // print(Get.arguments[2]);
    fetchData();
  }

  Future<List<DataRow>> genData() async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT s.*, i.assetName, c.genName AS con FROM fatransitem s LEFT JOIN faitems i ON i.faId = s.faId LEFT JOIN statuses c ON c.genCode = s.conStatCode WHERE s.transLocalId = ${Get.arguments[0]}");

    List<DataRow> temps = [];
    var i = 1;
    for (var data in maps) {
      DataRow row = DataRow(cells: [
        DataCell(
          SizedBox(
            width: Get.width * 0.1,
            child: Text("$i"),
          ),
        ),
        DataCell(
          SizedBox(
            width: Get.width * 0.2,
            child: Text(data['tagNo'].toString()),
          ),
        ),
        DataCell(
          SizedBox(
            width: Get.width * 0.25,
            child: Text(data['assetName'].toString()),
          ),
        ),
        DataCell(
          SizedBox(
            width: Get.width * 0.1,
            child: const Text("1"),
          ),
        ),
        DataCell(
          SizedBox(
            width: Get.width * 0.1,
            child: Text(data['con'].toString()),
          ),
        ),
        DataCell(
          SizedBox(
            width: Get.width * 0.1,
            child: Get.arguments[2] == 0
                ? TextButton(
                    onPressed: () {
                      Get.toNamed(
                        '/transferinitemform',
                        arguments: [
                          Get.arguments[0],
                          Get.arguments[1],
                          data['id']
                        ],
                      )?.whenComplete(() => fetchData());
                    },
                    child: const Icon(Icons.edit_note),
                  )
                : null,
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
      body: SingleChildScrollView(
        child: Column(
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
                      enabled: false,
                      controller: transNo,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[300],
                        contentPadding: const EdgeInsets.all(10),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: Get.width,
              child: Row(
                children: [
                  if (Get.arguments[2] == 0) ...[
                    TextButton.icon(
                      onPressed: () {
                        Get.toNamed(
                          '/transferinitemform',
                          arguments: [Get.arguments[0], Get.arguments[1], 0],
                        )?.whenComplete(() => fetchData());
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add"),
                    ),
                  ],
                  const SizedBox(
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
            // Container(
            //   width: Get.width,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       TextButton(
            //         onPressed: () {},
            //         child: Icon(Icons.chevron_left),
            //       ),
            //       Text("1 / 10 pages"),
            //       TextButton(
            //         onPressed: () {},
            //         child: Icon(Icons.chevron_right),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
