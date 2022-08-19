import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/services/FASOHead.service.dart';
import 'package:myasset/services/Period.service.dart';
import 'package:myasset/services/Stockopname.service.dart';
import 'package:sqflite/sqlite_api.dart';

class StockOpnameScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  StockOpnameScreen({Key? key}) : super(key: key);

  @override
  State<StockOpnameScreen> createState() => _StockOpnameScreenState();
}

class _StockOpnameScreenState extends State<StockOpnameScreen> {
  DbHelper dbHelper = DbHelper();

  int? selectedValue;
  String? selectedName;
  List _dropdownPeriods = [];
  Map<String, dynamic> fasohead = {};

  List<DataRow> _rows = [];

  bool isConfirmed = false;

  int page = 1;
  int pageCount = 1;
  int itemsPerPage = 4;

  // int _currentPage = 1;
  // bool _isLoading = true;

  Future<List<DataRow>> genData(var periodId, var page) async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> rows = await db.rawQuery(
      "SELECT s.*, i.tagNo, i.assetName, e.genName AS existence, t.genName AS tag, u.genName AS usagename, c.genName AS con, o.genName AS own, cc.genName AS conBase FROM stockopnames s LEFT JOIN faitems i ON i.faId = s.faId LEFT JOIN statuses e ON e.genCode = s.existStatCode LEFT JOIN statuses t ON t.genCode = s.tagStatCode LEFT JOIN statuses u ON u.genCode = s.usageStatCode LEFT JOIN statuses c ON c.genCode = s.conStatCode LEFT JOIN statuses o ON o.genCode = s.ownStatCode LEFT JOIN statuses cc ON cc.genCode = s.baseConStatCode WHERE s.periodId = '$periodId'",
    );
    List<DataRow> temps = [];
    var i = 1;
    for (var data in rows) {
      DataRow row = DataRow(cells: [
        DataCell(
          SizedBox(
            width: Get.width * 0.06,
            child: Text(
              "$i",
              style: const TextStyle(fontSize: 11),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: Get.width * 0.16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  data['tagNo'].toString(),
                  style: const TextStyle(fontSize: 11),
                ),
                if (data['rejectNote'] != "") ...[
                  IconButton(
                    color: Colors.red[600],
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text("Reject Note"),
                          content: Text(data['rejectNote']),
                        ),
                      );
                    },
                    icon: const Icon(Icons.info_outline),
                  ),
                ],
              ],
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: Get.width * 0.2,
            child: Text(
              data['assetName'].toString(),
              style: const TextStyle(fontSize: 11),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: Get.width * 0.2,
            child: Text(
              "qty = ${data['baseQty'].toString()}\ncondition = ${data['conBase'] == null ? data['baseConStatCode'].toString() : data['conBase'].toString()}",
              style: const TextStyle(fontSize: 11),
            ),
          ),
        ),
        DataCell(
          SizedBox(
            width: Get.width * 0.31,
            child: InkWell(
              onTap: () => Get.toNamed(
                '/stockopnameitem',
                arguments: [data['id'], periodId, fasohead, selectedName],
              )?.whenComplete(() => fetchData(selectedValue)),
              child: Text(
                "qty = ${data['qty'].toString()}\nexistence = ${data['existence'].toString()}\ntagging = ${data['tag'].toString()}\nusage = ${data['usagename'].toString()}\ncondition = ${data['con'] == null ? data['conStatCode'].toString() : data['con'].toString()}\nowner = ${data['own'].toString()}",
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ),
        ),
      ]);
      temps.add(row);
      i++;
    }
    return temps;
  }

  void fetchPeriod() async {
    Database db = await dbHelper.initDb();

    // List<Map<String, dynamic>> maps = await db.query(
    //   "periods",
    //   columns: ["periodId", "periodName"],
    //   orderBy: 'periodId DESC',
    // );
    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT p.*, p.periodName, f.soHeadId, f.soStatusCode FROM periods p JOIN fasohead f ON f.periodId = p.periodId ORDER BY p.periodId DESC");
    if (maps.isNotEmpty) {
      var getFirst = maps.first;
      setState(() {
        selectedValue = getFirst['periodId'];
        selectedName = getFirst['periodName'];
        _dropdownPeriods = maps;
      });

      fetchData(getFirst['periodId']);
      fetchFASOHead(getFirst['periodId']);
    }
  }

  void fetchFASOHead(var periodId) async {
    Database db = await dbHelper.initDb();
    final box = GetStorage();
    List<Map<String, dynamic>> maps = await db.query(
      'fasohead',
      where: "periodId = ? AND locationId = ?",
      whereArgs: [periodId, box.read('locationId')],
    );
    // print(maps);
    if (maps.isNotEmpty) {
      setState(() {
        fasohead = maps.first;
        isConfirmed =
            (["0", "2"].contains(maps.first['soStatusCode'])) ? false : true;
      });
    } else {
      setState(() {
        fasohead = {"soStatusCode": "0"};
        isConfirmed = false;
      });
    }
  }

  void fetchData(var periodId) async {
    var results = await genData(periodId, page);
    setState(() {
      _rows = results;
    });
  }

  void actionDownload() async {
    final periodService = PeriodService();
    Database db = await dbHelper.initDb();

    // List<Map<String, dynamic>> maps = await db.query(
    //   "periods",
    //   columns: ["periodId", "periodName"],
    // );

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(now);

    periodService.getAll().then((value) async {
      if (value.body != null) {
        var rows = value.body['periods'];
        if (rows.length > 0) {
          for (var row in rows) {
            await db.insert(
              "periods",
              {
                "periodId": row['periodId'],
                "periodName": row['periodName'],
                "startDate": row['startDate'].toString().substring(0, 10),
                "endDate": row['endDate'].toString().substring(0, 10),
                "closeActualDate":
                    row['closeActualDate'].toString().substring(0, 10),
                "soStartDate": row['soStartDate'].toString().substring(0, 10),
                "soEndDate": row['soEndDate'],
                "syncDate": formattedDate,
                "syncBy": 0
              },
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
          fetchPeriod();
        }
      }
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

  Future<void> actionDelete(int id) async {
    Database db = await dbHelper.initDb();
    // List<Map<String, dynamic>> maps = await db.query("stockopnames");
    // print(maps);
    int exec =
        await db.delete("stockopnames", where: "id = ?", whereArgs: [id]);
    // ignore: avoid_print
    print(exec);
  }

  Future<void> actionUploadToServer() async {
    Database db = await dbHelper.initDb();
    var stockopanemService = StockopnameService();
    var fasoheadService = FASOHeadService();
    final box = GetStorage();

    List<Map<String, dynamic>> maps = await db.rawQuery(
      "SELECT s.*, i.tagNo, i.assetName, e.genName AS existence, t.genName AS tag, u.genName AS usagename, c.genName AS con, o.genName AS own FROM stockopnames s LEFT JOIN faitems i ON i.faId = s.faId LEFT JOIN statuses e ON e.genCode = s.existStatCode LEFT JOIN statuses t ON t.genCode = s.tagStatCode LEFT JOIN statuses u ON u.genCode = s.usageStatCode LEFT JOIN statuses c ON c.genCode = s.conStatCode LEFT JOIN statuses o ON o.genCode = s.ownStatCode WHERE s.periodId = '$selectedValue' AND s.uploadDate IS NULL OR s.uploadDate = '' OR s.saveDate >= uploadDate",
    );
    // print(maps);
    for (var data in maps) {
      Map<String, dynamic> map = {};
      map['stockOpnameId'] = data['stockOpnameId'];
      map['periodId'] = data['periodId'] ?? 0;
      map['faId'] = data['faId'];
      map['locationId'] = data['locationId'];
      map['qty'] = data['qty'];
      map['existStatCode'] = data['existStatCode'];
      map['tagStatCode'] = data['tagStatCode'];
      map['usageStatCode'] = data['usageStatCode'];
      map['conStatCode'] = data['conStatCode'];
      map['ownStatCode'] = data['ownStatCode'];

      stockopanemService.createStockopname(map).then((value) async {
        var res = value.body;
        // ignore: avoid_print
        // print(res);
        if (res['message'] != "") {
          Map<String, dynamic> m = {};
          m['stockOpnameId'] = res['stockOpnameId'];
          m['uploadDate'] =
              DateFormat("yyyy-MM-dd kk:mm").format(DateTime.now());
          m['uploadBy'] = box.read('userId');
          m['uploadMessage'] = res['message'];
          await db.update(
            "stockopnames",
            m,
            where: "id = ?",
            whereArgs: [
              data['id'],
            ],
          );
        }
      });
    }

    List<Map<String, dynamic>> fasoHead = await db.query(
      'fasohead',
      where: 'periodId = ? AND locationId = ?',
      whereArgs: [selectedValue, box.read('locationId')],
    );

    for (var row in fasoHead) {
      Map<String, dynamic> map = {
        "soHeadId": row['soHeadId'],
        "statusCode": row['soStatusCode'],
        "userId": box.read('userId') ?? 0
      };

      await fasoheadService.create(map);
    }

    Get.dialog(
      const AlertDialog(
        title: Text("Message"),
        content: Text("Data success uploaded."),
      ),
    );
  }

  void confirmUploadToServer() {
    Get.dialog(
      AlertDialog(
        title: const Text("Confirmation"),
        content: const Text("Are you sure to upload data to server now ?"),
        actions: [
          TextButton(
            onPressed: () {
              // please add action in here
              // ex. actionUploadToServer();
              actionUploadToServer();
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

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    fetchPeriod();
  }

  void confirmKonfirmasi() {
    Get.dialog(
      AlertDialog(
        title: const Text("Confirmation"),
        content: const Text("Are you sure to confirm data now ?"),
        actions: [
          TextButton(
            onPressed: () {
              // please add action in here
              // actionInsertToItems();
              actionConfirmAllSO();
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

  Future<void> actionConfirmAllSO() async {
    final box = GetStorage();
    Database db = await dbHelper.initDb();
    int exec = 0;
    List<Map<String, dynamic>> findFASO = await db.query(
      "fasohead",
      where: "periodId = ? AND locationId = ?",
      whereArgs: [selectedValue, box.read('locationId')],
    );
    if (findFASO.isNotEmpty) {
      Map<String, dynamic> map = {"soStatusCode": "1"};
      exec = await db.update(
        'fasohead',
        map,
        where: "periodId = ? AND locationId = ?",
        whereArgs: [selectedValue, box.read('locationId')],
      );
    } else {
      Get.dialog(
        const AlertDialog(
          title: Text("Information"),
          content: Text("soHeadId not found."),
        ),
      );
    }

    if (exec > 0) {
      Get.dialog(
        const AlertDialog(
          title: Text("Message"),
          content: Text("Confirm successfully."),
        ),
      );

      fetchFASOHead(fasohead['periodId']);
    }
  }

  Future<void> actionInsertToItems() async {
    Database db = await dbHelper.initDb();
    Map<String, dynamic> map = {};
    map['tagNo'] = 2;
    map['assetName'] = 'Keyboard';
    map['locId'] = 1;
    map['added'] = 0;
    map['disposed'] = '';
    map['syncDate'] = '';
    map['syncBy'] = 0;
    db.insert("faitems", map, conflictAlgorithm: ConflictAlgorithm.replace);

    // List<Map<String, dynamic>> maps = await db.query("faitems");
    // print(maps);
  }

  void setAndFindSO(value) async {
    var filtered = _dropdownPeriods
        .where((element) => element['periodId'] == value)
        .toList();
    // print(filtered);
    var filteredFirst = filtered.length == 1
        ? filtered.first
        : {"periodId": 0, "periodName": "Unknown"};
    setState(() {
      selectedValue = value;
      selectedName = filteredFirst['periodName'];
    });
    fetchData(value);
    fetchFASOHead(value);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print(fasohead['rejectNote']);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Opname'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  const Text("Period"),
                  const SizedBox(
                    width: 20,
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
                            setAndFindSO(value);
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
            if (fasohead['rejectNote'] != null) ...[
              Card(
                color: Colors.red[100],
                child: SizedBox(
                  width: Get.width,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Reject Note",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          fasohead['rejectNote'].toString(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],

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
                          columns: const [
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
            // Container(
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
            //             fetchData(selectedValue);
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
            //             fetchData(selectedValue);
            //           }
            //         },
            //         child: const Icon(Icons.chevron_right),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(
              width: Get.width,
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    margin: const EdgeInsets.all(6.0),
                    height: 50,
                    width: 600,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 62, 81, 255),
                      ),
                      onPressed: () {
                        Get.toNamed('/stockopnameitem', arguments: [
                          0,
                          selectedValue,
                          fasohead,
                          selectedName
                        ])?.whenComplete(() => fetchData(selectedValue));
                      },
                      child: const Text(
                        "Scan / Entry Asset",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(6.0),
                    height: 50,
                    width: 600,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: isConfirmed
                            ? const Color.fromARGB(255, 152, 159, 152)
                            : const Color.fromARGB(255, 85, 189, 90),
                      ),
                      onPressed: () {
                        if (!isConfirmed) {
                          confirmKonfirmasi();
                        }
                      },
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(6.0),
                    height: 50,
                    width: 600,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 108, 47, 207),
                      ),
                      onPressed: () {
                        confirmUploadToServer();
                      },
                      child: const Text(
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
      ),
    );
  }
}
