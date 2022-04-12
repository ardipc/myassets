import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/screens/Table.screen.dart';
import 'package:sqflite/sqlite_api.dart';

class TransferInItemFormScreen extends StatefulWidget {
  TransferInItemFormScreen({Key? key}) : super(key: key);

  @override
  State<TransferInItemFormScreen> createState() =>
      _TransferInItemFormScreenState();
}

class _TransferInItemFormScreenState extends State<TransferInItemFormScreen> {
  final box = GetStorage();
  DbHelper dbHelper = DbHelper();

  String selectedValue = "USA";
  String barcode = "";

  int idFaTransItem = 0;

  final tagNo = TextEditingController();
  final description = TextEditingController();
  final faNo = TextEditingController();

  int? selectedStatus = null;
  List _optionsStatus = [];

  final remarks = TextEditingController();

  void fetchAllOptions() async {
    Database db = await dbHelper.initDb();

    List<Map<String, dynamic>> conMaps = await db.query(
      "statuses",
      where: 'genGroup = ?',
      whereArgs: ['CONSTAT'],
    );

    setState(() {
      _optionsStatus = conMaps;
    });
  }

  Future<void> fetchData(int id) async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> maps = await db.query(
      "fatransitem", 
      where: "faId = ?", 
      whereArgs: [id],
    );

    if(maps.length > 0) {
      tagNo.text = maps[0]['tagNo'];
      selectedStatus = int.parse(maps[0]['conStatCode']);
      remarks.text = maps[0]['remarks'];
    }
  }

  Future<void> getInformationByTagNo(String tag) async {
    Database db = await dbHelper.initDb();
    // for get the detail by tagNo
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
        .delete("fatransitem", where: "id = ?", whereArgs: [idFaTransItem]);
    Get.back();
  }

  Future<void> actionSave() async {
    Database db = await dbHelper.initDb();
    String dateNow = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());

    Map<String, dynamic> map = Map();

    if(idFaTransItem == 0) {
      map['transItemId'] = 0;
      map['faItemId'] = 0;
      map['faId'] = Get.arguments[0];
      map['remarks'] = remarks.text;
      map['conStatCode'] = selectedStatus;
      map['tagNo'] = tagNo.text;
      map['saveDate'] = dateNow;
      map['saveBy'] = box.read('userId'),
      map['syncDate'] = '';
      map['syncBy'] = 0;
      map['uploadDate'] = '';
      map['uploadBy'] = 0;
      map['uploadMessage'] = '';

      int exec = await db.insert("fatransitem", map,
          conflictAlgorithm: ConflictAlgorithm.replace);

      setState(() {
        idFaTrans = exec;
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
      map['remarks'] = remarks.text;
      map['conStatCode'] = selectedStatus;
      map['tagNo'] = tagNo.text;
      
      int exec = await db
          .update("fatransitem", map, where: "id = ?", whereArgs: [idFaTrans]);

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

  @override
  void initState() {
    super.initState();
    if(Get.arguments[2] != 0) {
      idFaTransItem = Get.arguments[2];
      fetchData(Get.arguments[2]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer In Item Form'),
      ),
      body: Column(
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
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
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
                          controller: tagNo,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            String barcode = await BarcodeScanner.scan();
                            setState(() {
                              this.tagNo.text = barcode;
                            });
                          } on PlatformException catch (error) {
                            if (error.code ==
                                BarcodeScanner.CameraAccessDenied) {
                              setState(() {
                                this.tagNo.text =
                                    'Izin kamera tidak diizinkan oleh si pengguna';
                              });
                            } else {
                              setState(() {
                                this.tagNo.text = 'Error: $error';
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
                          controller: description,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
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
                        child: Text("FA No : "),
                        width: Get.width * 0.14,
                      ),
                      Expanded(
                        child: TextField(
                          controller: faNo,
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
                        child: Text("Status : "),
                        width: Get.width * 0.14,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10.0),
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
                              hint: const Text("Select Status"),
                              items: _optionsStatus.map((item) {
                                return DropdownMenuItem(
                                  child: Text(item['genName']),
                                  value: item['genId'],
                                );
                              }).toList(),
                              value: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  selectedStatus = int.parse(value.toString());
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
                        child: Text("Remarks : "),
                        width: Get.width * 0.14,
                      ),
                      Expanded(
                        child: TextField(
                          controller: remarks,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
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
                  margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
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
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
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
            ),
          )
        ],
      ),
    );
  }
}
