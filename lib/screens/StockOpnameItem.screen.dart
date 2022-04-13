import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myasset/controllers/Stockopname.controller.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/screens/Table.screen.dart';
import 'package:sqflite/sqlite_api.dart';

class StockOpnameItemScreen extends StatefulWidget {
  StockOpnameItemScreen({Key? key}) : super(key: key);

  @override
  State<StockOpnameItemScreen> createState() => _StockOpnameItemScreenState();
}

class _StockOpnameItemScreenState extends State<StockOpnameItemScreen> {
  StockOpnameController stockOpnameController = StockOpnameController();
  final box = GetStorage();
  DbHelper dbHelper = DbHelper();

  List _optionsPeriods = [];
  int? selectedValue = null;

  String barcode = "";

  int idStockOpname = 0;

  TextEditingController tagNoController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController faNoController = TextEditingController();

  int? selectedExistence = null;
  List _optionsExistence = [];

  int? selectedTagging = null;
  List _optionsTagging = [];

  int? selectedUsage = null;
  List _optionsUsage = [];

  int? selectedCondition = null;
  List _optionsCondition = [];

  int? selectedOwnership = null;
  List _optionsOwnership = [];

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
      _optionsPeriods = items;
    });
  }

  void confirmDownloadTag() {
    Get.dialog(
      AlertDialog(
        title: Text("Confirmation"),
        content: Text("Are you sure to sync now ?"),
        actions: [
          TextButton(
            onPressed: () {
              // please add action in here
              // ex. actionUploadToServer();
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

  Future<void> fetchData(int id) async {
    Database db = await dbHelper.initDb();

    List<Map<String, dynamic>> maps = await db.query(
      "stockopnames",
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.length == 1) {
      List<Map<String, dynamic>> mapsItem = await db.query(
        "faitems",
        where: "faId = ?",
        whereArgs: [maps[0]['faId']],
      );

      setState(() {
        idStockOpname = id;
        tagNoController.text =
            mapsItem.length != 0 ? mapsItem[0]['tagNo'].toString() : "0";
        selectedExistence = int.parse(maps[0]['existStatCode']);
        selectedTagging = int.parse(maps[0]['tagStatCode']);
        selectedUsage = int.parse(maps[0]['usageStatCode']);
        selectedCondition = int.parse(maps[0]['conStatCode']);
        selectedOwnership = int.parse(maps[0]['ownStatCode']);
      });
    }
  }

  void fetchAllOptions() async {
    Database db = await dbHelper.initDb();

    List<Map<String, dynamic>> existMaps = await db.query(
      "statuses",
      where: 'genGroup = ?',
      whereArgs: ['EXISTSTAT'],
    );

    List<Map<String, dynamic>> tagMaps = await db.query(
      "statuses",
      where: 'genGroup = ?',
      whereArgs: ['TAGSTAT'],
    );
    List<Map<String, dynamic>> usageMaps = await db.query(
      "statuses",
      where: 'genGroup = ?',
      whereArgs: ['USAGESTAT'],
    );
    List<Map<String, dynamic>> conMaps = await db.query(
      "statuses",
      where: 'genGroup = ?',
      whereArgs: ['CONSTAT'],
    );
    List<Map<String, dynamic>> ownMaps = await db.query(
      "statuses",
      where: 'genGroup = ?',
      whereArgs: ['OWNSTAT'],
    );

    setState(() {
      _optionsExistence = existMaps;
      _optionsTagging = tagMaps;
      _optionsUsage = usageMaps;
      _optionsCondition = conMaps;
      _optionsOwnership = ownMaps;
    });
  }

  void actionConfirm() {
    Get.dialog(
      AlertDialog(
        title: Text("Confirmation"),
        content: Text("Are you sure to delete data ?"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              actionDelete();
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

  Future<void> actionDelete() async {
    Database db = await dbHelper.initDb();
    int exec = await db
        .delete("stockopnames", where: "id = ?", whereArgs: [idStockOpname]);
    Get.back();
  }

  Future<void> actionSave() async {
    if (tagNoController.text.isEmpty &&
        selectedExistence == null &&
        selectedTagging == null &&
        selectedUsage == null &&
        selectedCondition == null &&
        selectedOwnership == null) {
      Get.dialog(
        AlertDialog(
          title: Text("Information"),
          content: Text("Please fill all the field."),
        ),
      );
    } else {
      Database db = await dbHelper.initDb();

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(now);

      Map<String, dynamic> map = Map();
      if (idStockOpname == 0) {
        map['stockOpnameId'] = 0;
        map['periodId'] = 0;
        map['faId'] = faNoController.text;
        map['locationId'] = 0;
        map['qty'] = 0;
        map['existStatCode'] = selectedExistence;
        map['tagStatCode'] = selectedTagging;
        map['usageStatCode'] = selectedUsage;
        map['conStatCode'] = selectedCondition;
        map['ownStatCode'] = selectedOwnership;
        map['syncDate'] = formattedDate;
        map['syncBy'] = box.read('userId');
        map['uploadDate'] = formattedDate;
        map['uploadBy'] = box.read('userId');
        map['uploadMessage'] = "";

        int exec = await db.insert("stockopnames", map,
            conflictAlgorithm: ConflictAlgorithm.replace);

        setState(() {
          idStockOpname = exec;
        });

        Get.dialog(AlertDialog(
          title: Text("Information"),
          content: Text("Data has been saved."),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Close"),
            ),
          ],
        ));
      } else {
        map['existStatCode'] = selectedExistence;
        map['tagStatCode'] = selectedTagging;
        map['usageStatCode'] = selectedUsage;
        map['conStatCode'] = selectedCondition;
        map['ownStatCode'] = selectedOwnership;

        int exec = await db.update("stockopnames", map,
            where: "id = ?", whereArgs: [idStockOpname]);

        Get.dialog(AlertDialog(
          title: Text("Information"),
          content: Text("Data has been updated."),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Close"),
            ),
          ],
        ));
      }
    }
  }

  Future<void> getInfoItem(String value) async {
    Database db = await dbHelper.initDb();
    int parseToInt = int.parse(value == '' ? '0' : value);
    List<Map<String, dynamic>> maps =
        await db.query("faitems", where: "tagNo = ?", whereArgs: [parseToInt]);
    if (maps.length == 1) {
      setState(() {
        tagNoController.text = value;
        descriptionController.text = maps[0]['assetName'];
        faNoController.text = maps[0]['faId'].toString();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllOptions();
    tagNoController.addListener(() {
      getInfoItem(tagNoController.text);
    });
    fetchPeriod();
    if (Get.arguments != 0) {
      fetchData(Get.arguments[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Opname Item'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Text("Period"),
                  const SizedBox(
                    width: 40,
                  ),
                  SizedBox(
                    width: Get.width * 0.8,
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
                          items: _optionsPeriods.map((item) {
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
                ],
              ),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.all(12.0),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3),
                borderSide: BorderSide(color: Colors.grey, width: 1),
              ),
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Text("Tag No : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
                          child: TextField(
                            controller: tagNoController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blueAccent),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              String barcode = await BarcodeScanner.scan();
                              getInfoItem(barcode);
                              setState(() {
                                barcode = barcode;
                                tagNoController.text = barcode;
                              });
                            } on PlatformException catch (error) {
                              if (error.code ==
                                  BarcodeScanner.CameraAccessDenied) {
                                setState(() {
                                  barcode =
                                      'Izin kamera tidak diizinkan oleh si pengguna';
                                });
                              } else {
                                setState(() {
                                  barcode = 'Error: $error';
                                });
                              }
                            }
                          },
                          child: Icon(Icons.qr_code),
                        ),
                        TextButton(
                          onPressed: () {
                            confirmDownloadTag();
                          },
                          child: Icon(Icons.download),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text("Description : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
                          child: TextField(
                            enabled: false,
                            readOnly: true,
                            controller: descriptionController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text("FA No : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
                          child: TextFormField(
                            enabled: false,
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            controller: faNoController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text("Existence : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
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
                                hint: const Text("Select Existence"),
                                items: _optionsExistence.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(item['genName']),
                                    value: item['genId'],
                                  );
                                }).toList(),
                                value: selectedExistence,
                                onChanged: (value) {
                                  setState(() {
                                    selectedExistence =
                                        int.parse(value.toString());
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text("Tagging : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
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
                                hint: const Text("Select Tagging"),
                                items: _optionsTagging.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(item['genName']),
                                    value: item['genId'],
                                  );
                                }).toList(),
                                value: selectedTagging,
                                onChanged: (value) {
                                  setState(() {
                                    selectedTagging =
                                        int.parse(value.toString());
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text("Usage : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
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
                                hint: const Text("Select Usage"),
                                items: _optionsUsage.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(item['genName']),
                                    value: item['genId'],
                                  );
                                }).toList(),
                                value: selectedUsage,
                                onChanged: (value) {
                                  setState(() {
                                    selectedUsage = int.parse(value.toString());
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text("Condition : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
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
                                hint: const Text("Select Condition"),
                                items: _optionsCondition.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(item['genName']),
                                    value: item['genId'],
                                  );
                                }).toList(),
                                value: selectedCondition,
                                onChanged: (value) {
                                  setState(() {
                                    selectedCondition =
                                        int.parse(value.toString());
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text("Ownership : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
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
                                hint: const Text("Select Ownership"),
                                items: _optionsOwnership.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(item['genName']),
                                    value: item['genId'],
                                  );
                                }).toList(),
                                value: selectedOwnership,
                                onChanged: (value) {
                                  setState(() {
                                    selectedOwnership =
                                        int.parse(value.toString());
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                        actionSave();
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  if (idStockOpname != 0) ...[
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                      height: 50,
                      width: 600,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 228, 11, 29),
                        ),
                        onPressed: () {
                          actionConfirm();
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
