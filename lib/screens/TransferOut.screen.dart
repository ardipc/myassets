import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/services/FATrans.service.dart';
import 'package:myasset/services/FATransItem.service.dart';
import 'package:sqflite/sqlite_api.dart';

class TransferOutScreen extends StatefulWidget {
  const TransferOutScreen({Key? key}) : super(key: key);

  @override
  State<TransferOutScreen> createState() => _TransferOutScreen();
}

class _TransferOutScreen extends State<TransferOutScreen> {
  final box = GetStorage();
  DbHelper dbHelper = DbHelper();
  // late List<DatatableHeader> _headers;

  // List<Map<String, dynamic>> _sources = [];
  List<DataRow> _rows = [];

  // int _currentPage = 1;
  // bool _isLoading = true;

  int page = 1;
  int pageCount = 1;
  int itemsPerPage = 1;

  int selectedValue = 0;
  Map<String, dynamic> selectedMap = {};
  String? sDate, eDate;
  List<Map<String, dynamic>> _dropdownPeriods = [];

  Future<List<DataRow>> genData(var startDate, var endDate, var page) async {
    Database db = await dbHelper.initDb();
    // List<Map<String, dynamic>> maps = await db.query(
    //   "fatrans",
    //   where: "transferTypeCode = ? AND isVoid = ? AND periodId = ?",
    //   whereArgs: ["TO", 0, periodId],
    // );

    List<Map<String, dynamic>> rows = [];
    // if (periodId == 0) {
    //   rows = await db.query(
    //     "fatrans",
    //     where: "transferTypeCode = ? AND isVoid = ?",
    //     whereArgs: ["TO", 0],
    //   );
    // } else {
    rows = await db.query(
      "fatrans",
      where:
          "transferTypeCode = ? AND isVoid = ? AND transDate BETWEEN ? AND ?",
      whereArgs: ["TO", 0, startDate, endDate],
    );
    // }

    // int offset = (page - 1) * itemsPerPage;
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

    // List<Map<String, dynamic>> maps = [];
    // if (periodId == 0) {
    //   maps = await db.query(
    //     "fatrans",
    //     where:
    //         "transferTypeCode = ? AND isVoid = ? LIMIT $offset, $itemsPerPage",
    //     whereArgs: ["TO", 0],
    //   );
    // } else {
    // maps = await db.query(
    //   "fatrans",
    //   where:
    //       "transferTypeCode = ? AND isVoid = ? AND transDate BETWEEN ? AND ? LIMIT $offset, $itemsPerPage",
    //   whereArgs: ["TO", 0, startDate, endDate],
    // );
    // }

    List<DataRow> temps = [];
    var i = 1;
    for (var data in rows) {
      DataRow row = DataRow(cells: [
        DataCell(
          SizedBox(
            width: Get.width * 0.075,
            child: Text("$i"),
          ),
        ),
        DataCell(
          SizedBox(
            width: Get.width * 0.2,
            child: Text(data['transDate']),
          ),
        ),
        DataCell(
          SizedBox(
            width: Get.width * 0.20,
            child: Text(data['transNo']),
          ),
        ),
        DataCell(
          SizedBox(
            width: Get.width * 0.25,
            child: Text(data['manualRef']),
          ),
        ),
        DataCell(
          SizedBox(
            width: Get.width * 0.1,
            child: Text(
              data['isApproved'] == 0 ? "Not Yet" : "Approved",
              style: TextStyle(
                fontSize: 12,
                color: data['isApproved'] == 0 ? Colors.red : Colors.green,
              ),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: Get.width * 0.1,
            child: TextButton(
              onPressed: () {
                Get.toNamed('/transferoutitem',
                        arguments: [data['id'], selectedValue])
                    ?.whenComplete(() => fetchData(selectedMap));
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

  void fetchData(Map<String, dynamic> p) async {
    // print(getFirst);
    var sDateClean = p['startDate'].toString().substring(0, 10) + " 00:00";
    var eDateClean = p['endDate'].toString().substring(0, 10) + " 23:59";
    var results = await genData(sDateClean, eDateClean, page);
    setState(() {
      selectedValue = p['periodId'];
      sDate = sDateClean;
      eDate = eDateClean;
      _rows = results;
    });
  }

  void fetchPeriod() async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> maps = await db.query("periods",
        columns: ["periodId", "periodName", "startDate", "endDate"],
        orderBy: "periodId DESC");
    // List<Map<String, dynamic>> maps = await db.rawQuery(
    //     "SELECT p.periodId, p.periodName, p.startDate, p.endDate FROM periods p JOIN fasohead f ON f.periodId = p.periodId ORDER BY p.periodId DESC");

    setState(() {
      selectedValue = maps.isNotEmpty ? maps.first['periodId'] : null;
      selectedMap = maps.first;
      _dropdownPeriods = maps;
    });

    fetchData(maps.first);
  }

  void confirmDownload() {
    Get.dialog(
      AlertDialog(
        title: const Text("Confirmation"),
        content: const Text("Are you sure to sync data now ?"),
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

    // DateTime now = DateTime.now();
    // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    var transService = FATransService();
    var transItemService = FATransItemService();
    // var response = await transItemService.getAll();
    // var responseBody = response.body;
    // await db.delete("fatrans", where: null);
    await transService.getAll().then((value) async {
      List periods = value.body['fatrans'];
      for (var i = 0; i < periods.length; i++) {
        List<Map<String, dynamic>> sFa = await db.query(
          'fatrans',
          where: "transId = ?",
          whereArgs: [periods[i]['transId']],
        );

        Map<String, dynamic> map = {
          "transId": periods[i]['transId'],
          "plantId": periods[i]['plantId'],
          "transTypeCode": periods[i]['transTypeCode'],
          "transDate": periods[i]['transDate'].toString().replaceAll('T', ' '),
          "transNo": periods[i]['transNo'],
          "manualRef": periods[i]['manualRef'],
          "otherRef": periods[i]['otherRef'],
          "transferTypeCode": periods[i]['transferTypeCode'],
          "oldLocId": periods[i]['oldLocId'],
          "oldLocCode": "",
          "oldLocName": "",
          "newLocId": periods[i]['newLocId'],
          "newLocCode": "",
          "newLocName": "",
          "isApproved": periods[i]['isApproved'] ? 1 : 0,
          "isVoid": periods[i]['isVoid'] ? 1 : 0,
          "syncDate": DateFormat("yyyy-MM-dd kk:mm").format(DateTime.now()),
          "syncBy": box.read('userId')
        };

        if (sFa.isNotEmpty) {
          // action update
          // var getTransId = sFa.first['transId'];
          await db.update(
            'fatrans',
            map,
            where: 'transId = ?',
            whereArgs: [periods[i]['transId']],
          );
        } else {
          // var getTransId =
          await db.insert(
            "fatrans",
            map,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    });
    // await db.delete("fatransitem", where: null);
    await transItemService.getAll().then((value) async {
      List periods = value.body['transitems'];
      for (var i = 0; i < periods.length; i++) {
        List<Map<String, dynamic>> lenRows = await db.query(
          'fatransitem',
          where: "transItemId = ?",
          whereArgs: [periods[i]['transItemId']],
        );

        Map<String, dynamic> map = {
          "transItemId": periods[i]['transItemId'],
          "transId": periods[i]['transId'],
          "qty": periods[i]['qty'],
          // "faItemId": INTEGER,
          "faId": periods[i]['faId'],
          // "faNo": INTEGER,
          // "description": TEXT,
          "remarks": periods[i]['remarks'],
          "conStatCode": periods[i]['conStatCode'],
          "tagNo": periods[i]['oldTagNo'],
          "syncDate": DateFormat("yyyy-MM-dd kk:mm").format(DateTime.now()),
          "syncBy": box.read('userId')
        };

        if (lenRows.isNotEmpty) {
          await db.update(
            "fatransitem",
            map,
            where: "transItemId = ?",
            whereArgs: [periods[i]['transItemId']],
          );
        } else {
          await db.insert(
            "fatransitem",
            map,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    });

    fetchPeriod();

    Get.dialog(
      const AlertDialog(
        title: Text("Information"),
        content: Text("Download is completed."),
      ),
    );
  }

  void setPeriodAndFind(var value) async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> rows = await db.query(
      'periods',
      columns: ['periodId', 'periodName', 'startDate, endDate'],
      where: 'periodId = ?',
      whereArgs: [value],
    );

    if (rows.isNotEmpty) {
      var getFirst = rows.first;
      var sDateClean =
          getFirst['startDate'].toString().substring(0, 10) + " 00:00";
      var eDateClean =
          getFirst['endDate'].toString().substring(0, 10) + " 23:59";
      var results = await genData(sDateClean, eDateClean, page);
      setState(() {
        _rows = results;
        sDate = sDateClean;
        eDate = eDateClean;
        selectedValue = int.parse(value.toString());
        selectedMap = rows.first;
      });
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    fetchPeriod();
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
                            setPeriodAndFind(value);
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
                      Get.toNamed('/transferoutitem', arguments: [
                        0,
                        selectedValue,
                        sDate,
                        eDate,
                      ])?.whenComplete(() => fetchData(selectedMap));
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
                          columns: const [
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
