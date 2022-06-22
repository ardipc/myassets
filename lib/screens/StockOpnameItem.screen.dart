import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myasset/controllers/Stockopname.controller.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/services/Period.service.dart';
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

  var isReadOnly = false;

  List _optionsPeriods = [];
  int? selectedValue;

  String barcode = "";
  int? faIdValue = 0;

  int idStockOpname = 0;
  bool isAda = false;

  TextEditingController tagNoController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController faNoController = TextEditingController();

  String? selectedExistence;
  List _optionsExistence = [];

  String? selectedTagging;
  List _optionsTagging = [];

  String? selectedUsage;
  List _optionsUsage = [];

  String? selectedCondition;
  List _optionsCondition = [];

  String? selectedOwnership;
  List _optionsOwnership = [];

  void fetchSinglePeriod() async {
    // final periodService = PeriodService();
    // periodService.getNow().then((value) {
    //   setState(() {
    //     selectedValue = value.body['periodId'] ?? 0;
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
        faIdValue = maps[0]['faId'];
        tagNoController.text =
            mapsItem.isNotEmpty ? mapsItem[0]['tagNo'].toString() : "0";
        descriptionController.text = maps[0]['description'];
        faNoController.text = maps[0]['faNo'];
        // ignore: prefer_null_aware_operators
        if (maps[0]['existStatCode'] != null) {
          selectedExistence = maps[0]['existStatCode'].toString();
        }
        if (maps[0]['tagStatCode'] != null) {
          selectedTagging = maps[0]['tagStatCode'].toString();
        }
        if (maps[0]['usageStatCode'] != null) {
          selectedUsage = maps[0]['usageStatCode'].toString();
        }
        if (maps[0]['conStatCode'] != null) {
          selectedCondition = maps[0]['conStatCode'].toString();
        }
        if (maps[0]['ownStatCode'] != null) {
          selectedOwnership = maps[0]['ownStatCode'].toString();
        }
      });
    }
  }

  Future<void> fetchDataConfirm(int id) async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> maps = await db.query(
      'soconfirms',
      where: "soConfirmId = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      var getFirst = maps.first;
      var dateRow =
          DateFormat('yyyy-MM-dd kk:mm').parse(getFirst['confirmDate']);
      var dateNow = DateTime.now();

      setState(() {
        // ignore: unrelated_type_equality_checks
        isReadOnly = dateRow.difference(dateNow).inSeconds <= 1 ? true : false;
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
        title: const Text("Confirmation"),
        content: const Text("Are you sure to delete data ?"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              actionDelete();
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

  Future<void> actionDelete() async {
    Database db = await dbHelper.initDb();
    int exec = await db
        .delete("stockopnames", where: "id = ?", whereArgs: [idStockOpname]);
    if (exec > 0) {
      Get.back();
    }
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
          title: const Text("Information"),
          content: const Text("Please fill all the field."),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      Database db = await dbHelper.initDb();

      String formattedDate =
          DateFormat('yyyy-MM-dd kk:mm').format(DateTime.now());

      Map<String, dynamic> map = {};
      if (idStockOpname == 0) {
        map['stockOpnameId'] = 0;
        map['periodId'] = selectedValue;
        map['faId'] = faIdValue;
        map['faNo'] = faNoController.text;
        map['tagNo'] = tagNoController.text;
        map['description'] = descriptionController.text;
        map['locationId'] = box.read('locationId');
        map['qty'] = selectedExistence == "ex1" ? 1 : 0;
        map['existStatCode'] = selectedExistence;
        map['tagStatCode'] = selectedTagging;
        map['usageStatCode'] = selectedUsage;
        map['conStatCode'] = selectedCondition;
        map['ownStatCode'] = selectedOwnership;
        map['syncDate'] = formattedDate;
        map['syncBy'] = box.read('username');
        map['uploadDate'] = formattedDate;
        map['uploadBy'] = box.read('username');
        map['uploadMessage'] = "";

        // print(map);

        int exec = await db.insert("stockopnames", map,
            conflictAlgorithm: ConflictAlgorithm.replace);

        if (exec != 0) {
          setState(() {
            idStockOpname = exec;
          });

          Get.dialog(AlertDialog(
            title: const Text("Information"),
            content: const Text("Data has been saved."),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Close"),
              ),
            ],
          ));
        } else {
          Get.dialog(AlertDialog(
            title: const Text("Information"),
            content: const Text("Error while saved."),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Close"),
              ),
            ],
          ));
        }

        Get.back();
      } else {
        map['tagNo'] = tagNoController.text;
        map['faId'] = faIdValue;
        map['faNo'] = faNoController.text;
        map['description'] = descriptionController.text;
        map['existStatCode'] = selectedExistence;
        map['tagStatCode'] = selectedTagging;
        map['usageStatCode'] = selectedUsage;
        map['conStatCode'] = selectedCondition;
        map['ownStatCode'] = selectedOwnership;
        map['qty'] = selectedExistence == "ex1" ? 1 : 0;

        int exec = await db.update("stockopnames", map,
            where: "id = ?", whereArgs: [idStockOpname]);

        if (exec > 0) {
          Get.dialog(
            AlertDialog(
              title: const Text("Information"),
              content: const Text("Data has been updated."),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Close"),
                ),
              ],
            ),
          );
        }

        Get.back();
      }
    }
  }

  Future<void> getInfoItem(String value) async {
    Database db = await dbHelper.initDb();
    String parseToInt = value == '' ? '0' : value;
    List<Map<String, dynamic>> maps =
        await db.query("faitems", where: "tagNo = ?", whereArgs: [parseToInt]);
    if (maps.length == 1) {
      setState(() {
        faIdValue = maps[0]['faId'];
        tagNoController.text = value;
        descriptionController.text = maps[0]['assetName'];
        faNoController.text = maps[0]['faNo'];
      });
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    fetchAllOptions();
    // tagNoController.addListener(() {
    //   getInfoItem(tagNoController.text);
    // });
    fetchSinglePeriod();
    fetchPeriod();
    if (Get.arguments != 0) {
      fetchData(Get.arguments[0]);
      fetchDataConfirm(Get.arguments[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Opname Item'),
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
                    width: 20,
                  ),
                  SizedBox(
                    width: Get.width * 0.5,
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
              margin: const EdgeInsets.all(12.0),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              color: Colors.white,
              child: Container(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          child: const Text("Tag No : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
                          child: Focus(
                            onFocusChange: (value) {
                              if (!value) {
                                getInfoItem(tagNoController.text);
                              }
                            },
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
                            } catch (e) {
                              setState(() {
                                barcode = '';
                              });
                            }
                          },
                          child: const Icon(Icons.qr_code),
                        ),
                        TextButton(
                          onPressed: () {
                            confirmDownloadTag();
                          },
                          child: const Icon(Icons.download),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          child: const Text("Description : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
                          child: TextField(
                            // enabled: false,
                            // readOnly: true,
                            controller: descriptionController,
                            decoration: const InputDecoration(
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
                        SizedBox(
                          child: const Text("FA No : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
                          child: TextFormField(
                            // enabled: false,
                            // readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            controller: faNoController,
                            decoration: const InputDecoration(
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
                        SizedBox(
                          child: const Text("Existence : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                                    value: item['genCode'],
                                  );
                                }).toList(),
                                value: selectedExistence,
                                onChanged: (value) {
                                  setState(() {
                                    selectedExistence = value.toString();
                                    isAda = value == "ex1" ? true : false;
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
                        SizedBox(
                          child: const Text("Tagging : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                                    value: item['genCode'],
                                  );
                                }).toList(),
                                value: selectedTagging,
                                onChanged: isAda
                                    ? null
                                    : (value) {
                                        setState(() {
                                          selectedTagging = value.toString();
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
                        SizedBox(
                          child: const Text("Usage : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                                    value: item['genCode'],
                                  );
                                }).toList(),
                                value: selectedUsage,
                                onChanged: isAda
                                    ? null
                                    : (value) {
                                        setState(() {
                                          selectedUsage = value.toString();
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
                        SizedBox(
                          child: const Text("Condition : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                                    value: item['genCode'],
                                  );
                                }).toList(),
                                value: selectedCondition,
                                onChanged: isAda
                                    ? null
                                    : (value) {
                                        setState(() {
                                          selectedCondition = value.toString();
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
                        SizedBox(
                          child: const Text("Ownership : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                                    value: item['genCode'],
                                  );
                                }).toList(),
                                value: selectedOwnership,
                                onChanged: isAda
                                    ? null
                                    : (value) {
                                        setState(() {
                                          selectedOwnership = value.toString();
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
            SizedBox(
              width: Get.width,
              child: isReadOnly == false
                  ? Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 3.0),
                          height: 50,
                          width: 600,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 62, 81, 255),
                            ),
                            onPressed: () {
                              actionSave();
                            },
                            child: const Text(
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
                            margin: const EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 3.0),
                            height: 50,
                            width: 600,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 228, 11, 29),
                              ),
                              onPressed: () {
                                actionConfirm();
                              },
                              child: const Text(
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
                    )
                  : const Center(
                      child: Text("Confirmed"),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
