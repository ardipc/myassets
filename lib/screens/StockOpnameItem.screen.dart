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

  String selectedValue = "USA";
  String barcode = "";

  TextEditingController tagNoController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController faNoController = TextEditingController();

  int id = 0;
  String selectedOwnership = "Select";
  String selectedCondition = "Select";
  String selectedUsage = "Select";
  String selectedTagging = "Select";
  String selectedExistence = "Select";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.arguments != null) {
      print(Get.arguments[0].runtimeType);
      fetchData(Get.arguments[0]);
    }
  }

  Future<void> fetchData(int id) async {
    Database db = await dbHelper.initDb();

    List<Map<String, dynamic>> maps = await db.query(
      "stockopnames",
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.length == 1) {
      setState(() {
        id = maps[0]['id'];
        selectedExistence = maps[0]['existStatCode'];
        selectedTagging = maps[0]['tagStatCode'];
        selectedUsage = maps[0]['usageStatCode'];
        selectedCondition = maps[0]['conStatCode'];
        selectedOwnership = maps[0]['ownStatCode'];
      });
    }

    print(maps);
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
                          child: new TextField(
                            controller: tagNoController,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent)),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              String barcode = await BarcodeScanner.scan();
                              print(barcode);
                              setState(() {
                                this.barcode = barcode;
                              });
                            } on PlatformException catch (error) {
                              if (error.code ==
                                  BarcodeScanner.CameraAccessDenied) {
                                setState(() {
                                  this.barcode =
                                      'Izin kamera tidak diizinkan oleh si pengguna';
                                });
                              } else {
                                setState(() {
                                  this.barcode = 'Error: $error';
                                });
                              }
                            }
                          },
                          child: Icon(Icons.qr_code),
                        ),
                        TextButton(
                          onPressed: () {},
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
                            controller: descriptionController,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            controller: faNoController,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
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
                                items: dropdownExistence,
                                value: selectedExistence,
                                onChanged: (value) {
                                  setState(() {
                                    selectedExistence = value.toString();
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
                                items: dropdownTagging,
                                value: selectedTagging,
                                onChanged: (value) {
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
                                items: dropdownUsage,
                                value: selectedUsage,
                                onChanged: (value) {
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
                                items: dropdownCondition,
                                value: selectedCondition,
                                onChanged: (value) {
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
                                items: dropdownOwnership,
                                value: selectedOwnership,
                                onChanged: (value) {
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
                  if (Get.arguments != null) ...[
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                      height: 50,
                      width: 600,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 228, 11, 29),
                        ),
                        onPressed: () {},
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

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("USA"), value: "USA"),
      DropdownMenuItem(child: Text("Canada"), value: "Canada"),
      DropdownMenuItem(child: Text("Brazil"), value: "Brazil"),
      DropdownMenuItem(child: Text("England"), value: "England"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownOwnership {
    List<DropdownMenuItem<String>> options = [
      DropdownMenuItem(child: Text("Select"), value: "Select"),
      DropdownMenuItem(child: Text("Dipinjam"), value: "Dipinjam"),
      DropdownMenuItem(child: Text("Permanent"), value: "Permanent"),
    ];
    return options;
  }

  List<DropdownMenuItem<String>> get dropdownCondition {
    List<DropdownMenuItem<String>> options = [
      DropdownMenuItem(child: Text("Select"), value: "Select"),
      DropdownMenuItem(child: Text("Baik"), value: "Baik"),
      DropdownMenuItem(child: Text("Rusak"), value: "Rusak"),
    ];
    return options;
  }

  List<DropdownMenuItem<String>> get dropdownUsage {
    List<DropdownMenuItem<String>> options = [
      DropdownMenuItem(child: Text("Select"), value: "Select"),
      DropdownMenuItem(child: Text("Digunakan"), value: "Digunakan"),
    ];
    return options;
  }

  List<DropdownMenuItem<String>> get dropdownTagging {
    List<DropdownMenuItem<String>> options = [
      DropdownMenuItem(child: Text("Select"), value: "Select"),
      DropdownMenuItem(child: Text("Lengkap"), value: "Lengkap"),
    ];
    return options;
  }

  List<DropdownMenuItem<String>> get dropdownExistence {
    List<DropdownMenuItem<String>> options = [
      DropdownMenuItem(child: Text("Select"), value: "Select"),
      DropdownMenuItem(child: Text("ADA"), value: "ADA"),
      DropdownMenuItem(child: Text("HILANG"), value: "HILANG"),
    ];
    return options;
  }

  Future<void> actionDelete() async {
    Database db = await dbHelper.initDb();
    int exec =
        await db.delete("stockopnames", where: "id = ?", whereArgs: [id]);
    Get.back();
  }

  Future<void> actionSave() async {
    Database db = await dbHelper.initDb();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    Map<String, dynamic> map = Map();
    if (id == 0) {
      map['stockOpnameId'] = 0;
      map['periodId'] = 0;
      map['faId'] = 0;
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

      Get.snackbar("Inserted", "ID ${exec.toString()}");
    } else {
      map['existStatCode'] = selectedExistence;
      map['tagStatCode'] = selectedTagging;
      map['usageStatCode'] = selectedUsage;
      map['conStatCode'] = selectedCondition;
      map['ownStatCode'] = selectedOwnership;
      int exec = await db
          .update("stockopnames", map, where: "id = ?", whereArgs: [id]);
      Get.snackbar("Updated", "ID ${exec.toString()}");
    }
  }
}
