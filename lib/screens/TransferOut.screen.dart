import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/services/Period.service.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:sqflite/sqlite_api.dart';

class TransferOutScreen extends StatefulWidget {
  const TransferOutScreen({Key? key}) : super(key: key);

  @override
  State<TransferOutScreen> createState() => _TransferOutScreen();
}

class _TransferOutScreen extends State<TransferOutScreen> {
  final box = GetStorage();
  DbHelper dbHelper = DbHelper();
  late List<DatatableHeader> _headers;

  List<Map<String, dynamic>> _sources = [];
  List<DataRow> _rows = [];

  // int _currentPage = 1;
  // bool _isLoading = true;

  int page = 1;
  int pageCount = 1;
  int itemsPerPage = 1;

  int? selectedValue;
  String? sDate, eDate;
  List _dropdownPeriods = [];

  void fetchSinglePeriod() async {
    // final periodService = PeriodService();
    // periodService.getNow().then((value) {
    //   setState(() {
    //     selectedValue = value.body['periodId'];
    //   });
    // });
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> p =
        await db.query('periods', orderBy: 'periodId DESC');
    if (p.isNotEmpty) {
      var getFirst = p.first;
      setState(() {
        selectedValue = getFirst['periodId'];
      });
    }
  }

  Future<List<DataRow>> genData(var startDate, var endDate, var page) async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> all = await db.query(
      "fatrans",
      where: "transferTypeCode = ?",
      whereArgs: ['TO'],
    );
    print(all);

    List<Map<String, dynamic>> rows = [];
    // if (periodId == 0) {
    //   rows = await db.query(
    //     "fatrans",
    //     where: "transferTypeCode = ? AND isVoid = ?",
    //     whereArgs: ["TI", 0],
    //   );
    // } else {
    rows = await db.query(
      "fatrans",
      where:
          "transferTypeCode = ? AND isVoid = ? AND transDate BETWEEN ? AND ?",
      whereArgs: ["TO", 0, startDate, endDate],
    );
    // }

    int offset = (page - 1) * itemsPerPage;
    if (rows.isEmpty) {
      setState(() {
        pageCount = 1;
      });
    } else {
      setState(() {
        pageCount = (rows.length / itemsPerPage).ceil();
      });
      if (page > pageCount) {
        setState(() {
          page = 1;
        });
      }
    }

    List<Map<String, dynamic>> maps = [];
    // if (periodId == 0) {
    //   maps = await db.query(
    //     "fatrans",
    //     where:
    //         "transferTypeCode = ? AND isVoid = ? LIMIT $offset, $itemsPerPage",
    //     whereArgs: ["TI", 0],
    //   );
    // } else {
    maps = await db.query(
      "fatrans",
      where:
          "transferTypeCode = ? AND isVoid = ? AND transDate BETWEEN ? AND ? LIMIT $offset, $itemsPerPage",
      whereArgs: ["TO", 0, startDate, endDate],
    );
    // }

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
                Get.toNamed('/transferinitem',
                        arguments: [data['id'], selectedValue])
                    ?.whenComplete(() => fetchData());
              },
              child: const Icon(Icons.edit_note),
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
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> p =
        await db.query('periods', orderBy: 'periodId DESC');
    if (p.isNotEmpty) {
      var getFirst = p.first;
      // print(getFirst);
      var sDateClean =
          getFirst['startDate'].toString().substring(0, 10) + " 00:00";
      var eDateClean =
          getFirst['endDate'].toString().substring(0, 10) + " 23:59";
      var results = await genData(sDateClean, eDateClean, page);
      // print(sDateClean);
      // print(eDateClean);
      setState(() {
        // selectedValue = selectedValue == 0 ? getFirst['periodId'] : 0;
        sDate = sDateClean;
        eDate = eDateClean;
        _rows = results;
      });
    }
  }

  void fetchPeriod() async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> maps = await db.query("periods",
        columns: ["periodId", "periodName"], orderBy: 'periodId DESC');
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
        title: const Text("Confirmation"),
        content: const Text("Are you sure to sync data period now ?"),
        actions: [
          TextButton(
            onPressed: () {
              actionDownload();
              Get.back();
            },
            child: const Text("YES"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("NO"),
          ),
        ],
      ),
    );
  }

  void actionDownload() async {
    Database db = await dbHelper.initDb();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    Map<String, dynamic> map = {};
    map['transId'] = 1;
    map['plantId'] = 1;
    map['transTypeCode'] = "T";
    map['transDate'] = "2022-04-04";
    map['transNo'] = "TR02";
    map['manualRef'] = "MR002";
    map['otherRef'] = "";
    map['transferTypeCode'] = "TO";
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
        title: const Text('Transfer Out List'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0, right: 12, left: 12),
              child: Row(
                children: [
                  const Text("Period"),
                  const SizedBox(
                    width: 40,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                    icon: const Icon(Icons.download),
                    label: const Text("Download"),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: Get.width,
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Get.toNamed('/transferoutitem',
                              arguments: [selectedValue])
                          ?.whenComplete(() => fetchData());
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add"),
                  ),
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
            // SizedBox(
            //   width: Get.width,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       TextButton(
            //         onPressed: () {
            //           if (page > 1) {
            //             setState(() {
            //               page = page - 1;
            //             });
            //             fetchData();
            //           }
            //         },
            //         child: const Icon(Icons.chevron_left),
            //       ),
            //       Text("$page / $pageCount pages"),
            //       TextButton(
            //         onPressed: () {
            //           if (page < pageCount) {
            //             setState(() {
            //               page = page + 1;
            //             });
            //             fetchData();
            //           }
            //         },
            //         child: const Icon(Icons.chevron_right),
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
