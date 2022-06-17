import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/services/Period.service.dart';
import 'package:myasset/services/Stockopname.service.dart';
import 'package:responsive_table/responsive_table.dart';
import 'package:sqflite/sqlite_api.dart';

class StockOpnameScreen extends StatefulWidget {
  StockOpnameScreen({Key? key}) : super(key: key);

  @override
  State<StockOpnameScreen> createState() => _StockOpnameScreenState();
}

class _StockOpnameScreenState extends State<StockOpnameScreen> {
  DbHelper dbHelper = DbHelper();

  int? selectedValue = null;
  List _dropdownPeriods = [];

  late List<DatatableHeader> _headers;

  List<Map<String, dynamic>> _sources = [];
  List<DataRow> _rows = [];

  int _currentPage = 1;
  bool _isLoading = true;

  Future<List<DataRow>> genData(var periodId) async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> maps = await db.rawQuery(
      "SELECT s.*, i.tagNo, i.assetName, e.genName AS existence, t.genName AS tag, u.genName AS usagename, c.genName AS con, o.genName AS own FROM stockopnames s LEFT JOIN faitems i ON i.faId = s.faId LEFT JOIN statuses e ON e.genCode = s.existStatCode LEFT JOIN statuses t ON t.genCode = s.tagStatCode LEFT JOIN statuses u ON u.genCode = s.usageStatCode LEFT JOIN statuses c ON c.genCode = s.conStatCode LEFT JOIN statuses o ON o.genCode = s.ownStatCode",
    );

    print(maps);

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
            width: Get.width * 0.12,
            child: Text(data['tagNo'].toString()),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.2,
            child: Text(data['assetName'].toString()),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.2,
            child: Text(
                "qty = ${data['qty'].toString()}\ncondition = ${data['con'].toString()}"),
          ),
        ),
        DataCell(
          Container(
            width: Get.width * 0.31,
            child: InkWell(
              onTap: () => Get.toNamed(
                '/stockopnameitem',
                arguments: [data['id']],
              )?.whenComplete(() => fetchData()),
              child: Text(
                  "qty = ${data['qty'].toString()}\nexistence = ${data['existence'].toString()}\ntagging = ${data['tag'].toString()}\nusage = ${data['usagename'].toString()}\ncondition = ${data['con'].toString()}\nowner = ${data['own'].toString()}"),
            ),
          ),
        ),
      ]);
      temps.add(row);
      i++;
    }
    return temps;
  }

  void fetchSinglePeriod() async {
    // final periodService = PeriodService();
    // periodService.getNow().then((value) {
    //   setState(() {
    //     selectedValue = value.body['periodId'];
    //   });
    // });

    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> p = await db.query('periods');
    if (p.isNotEmpty) {
      var getFirst = p.first;
      setState(() {
        selectedValue = getFirst['periodId'];
      });
    }
  }

  void fetchPeriod() async {
    Database db = await dbHelper.initDb();

    List<Map<String, dynamic>> maps = await db.query(
      "periods",
      columns: ["periodId", "periodName"],
    );

    setState(() {
      _dropdownPeriods = maps;
    });
  }

  void fetchData() async {
    Database db = await dbHelper.initDb();
    setState(() => _isLoading = true);
    _headers = [
      DatatableHeader(text: "No.", value: "no", show: true),
      DatatableHeader(text: "Tag No", value: "tagNo", show: true),
      DatatableHeader(text: "Description", value: "description", show: true),
      DatatableHeader(
          text: "Closing Result", value: "closingResult", show: true),
      DatatableHeader(text: "Stock Opname", value: "stockOpname", show: true)
    ];
    List<Map<String, dynamic>> p = await db.query('periods');
    if (p.isNotEmpty) {
      var getFirst = p.first;
      var results = await genData(getFirst['periodId'] ?? 0);
      setState(() {
        selectedValue = getFirst['periodId'];
        _rows = results;
        _isLoading = false;
      });
    }
  }

  void actionDownload() async {
    final periodService = PeriodService();
    Database db = await dbHelper.initDb();

    List<Map<String, dynamic>> maps = await db.query(
      "periods",
      columns: ["periodId", "periodName"],
    );

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

  Future<void> actionDelete(int id) async {
    Database db = await dbHelper.initDb();
    // List<Map<String, dynamic>> maps = await db.query("stockopnames");
    // print(maps);
    int exec =
        await db.delete("stockopnames", where: "id = ?", whereArgs: [id]);
    print(exec);
  }

  Future<void> actionUploadToServer() async {
    Database db = await dbHelper.initDb();
    var stockopanemService = StockopnameService();

    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT s.*, i.tagNo, i.assetName, e.genName AS existence, t.genName AS tag, u.genName AS usagename, c.genName AS con, o.genName AS own FROM stockopnames s LEFT JOIN faitems i ON i.faId = s.faId LEFT JOIN statuses e ON e.genCode = s.existStatCode LEFT JOIN statuses t ON t.genCode = s.tagStatCode LEFT JOIN statuses u ON u.genCode = s.usageStatCode LEFT JOIN statuses c ON c.genCode = s.conStatCode LEFT JOIN statuses o ON o.genCode = s.ownStatCode");
    for (var data in maps) {
      Map<String, dynamic> map = {};
      map['stockOpnameId'] = data['stockOpnameId'];
      map['periodId'] = data['periodId'];
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
        if (res['message'].toString() != "") {
          Map<String, dynamic> m = {};
          m['stockOpnameId'] = res['stockOpnameId'];
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
        title: Text("Confirmation"),
        content: Text("Are you sure to upload data to server now ?"),
        actions: [
          TextButton(
            onPressed: () {
              // please add action in here
              // ex. actionUploadToServer();
              actionUploadToServer();
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSinglePeriod();
    fetchPeriod();
    fetchData();
  }

  void confirmKonfirmasi() {
    Get.dialog(
      AlertDialog(
        title: Text("Confirmation"),
        content: Text("Are you sure to confirm data now ?"),
        actions: [
          TextButton(
            onPressed: () {
              // please add action in here
              // actionInsertToItems();
              actionConfirmAllSO();
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

  Future<void> actionConfirmAllSO() async {
    final box = GetStorage();
    Database db = await dbHelper.initDb();

    List<Map<String, dynamic>> mapsSO = await db.query("stockopnames");

    for (var row in mapsSO) {
      List<Map<String, dynamic>> checkRows = await db.query(
        "soconfirms",
        where: "soConfirmId = ?",
        whereArgs: [row['id']],
      );
      if (checkRows.isEmpty) {
        Map<String, dynamic> m = {};
        m['soConfirmId'] = row['id'];
        m['periodId'] = selectedValue;
        m['locId'] = box.read('locationId');
        m['confirmDate'] =
            DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now());
        m['confirmBy'] = box.read('username');
        m['uploadDate'] = '';
        m['uploadBy'] = 0;
        m['uploadMessage'] = '';
        await db.insert(
          'soconfirms',
          m,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }

    Get.dialog(
      const AlertDialog(
        title: Text("Message"),
        content: Text("Confirm successfully."),
      ),
    );
  }

  Future<void> actionInsertToItems() async {
    Database db = await dbHelper.initDb();
    Map<String, dynamic> map = Map();
    map['tagNo'] = 2;
    map['assetName'] = 'Keyboard';
    map['locId'] = 1;
    map['added'] = 0;
    map['disposed'] = '';
    map['syncDate'] = '';
    map['syncBy'] = 0;
    db.insert("faitems", map, conflictAlgorithm: ConflictAlgorithm.replace);

    List<Map<String, dynamic>> maps = await db.query("faitems");
    print(maps);
  }

  void setAndFindSO(value) async {
    setState(() {
      selectedValue = int.parse(value.toString());
    });
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
                  SizedBox(
                    width: Get.width * 0.5,
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
                    margin:
                        EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                    height: 50,
                    width: 600,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 62, 81, 255),
                      ),
                      onPressed: () {
                        Get.toNamed('/stockopnameitem', arguments: [0])
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
                    margin:
                        EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                    height: 50,
                    width: 600,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 85, 189, 90),
                      ),
                      onPressed: () {
                        confirmKonfirmasi();
                      },
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
                      onPressed: () {
                        confirmUploadToServer();
                      },
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
      ),
    );
  }
}
