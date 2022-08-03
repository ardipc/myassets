import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
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

  int? faIdValue = 0;

  int idTransItem = 0;
  final transNo = TextEditingController();

  final tagNo = TextEditingController();
  final description = TextEditingController();
  final faNo = TextEditingController();

  String? selectedStatus;
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
        .delete("fatransitem", where: "id = ?", whereArgs: [idTransItem]);
    Get.back();
  }

  Future<void> actionSave() async {
    if (tagNo.text.isEmpty && selectedStatus == null && remarks.text.isEmpty) {
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
          DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());

      Map<String, dynamic> map = Map();

      if (idTransItem == 0) {
        map['transLocalId'] = Get.arguments[0];
        map['transItemId'] = "";
        map['transId'] = "";
        map['faItemId'] = 0;
        map['faId'] = faIdValue;
        map['faNo'] = faNo.text;
        map['description'] = description.text;
        map['remarks'] = remarks.text;
        map['conStatCode'] = selectedStatus;
        map['tagNo'] = tagNo.text;
        map['saveDate'] = formattedDate;
        map['saveBy'] = box.read('userId');
        map['syncDate'] = '';
        map['syncBy'] = '';
        map['uploadDate'] = '';
        map['uploadBy'] = '';
        map['uploadMessage'] = '';

        int exec = await db.insert("fatransitem", map,
            conflictAlgorithm: ConflictAlgorithm.replace);

        setState(() {
          idTransItem = exec;
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
        map['faId'] = faIdValue;
        map['faNo'] = faNo.text;
        map['description'] = description.text;
        map['remarks'] = remarks.text;
        map['conStatCode'] = selectedStatus;
        map['tagNo'] = tagNo.text;

        int exec = await db.update("fatransitem", map,
            where: "id = ?", whereArgs: [idTransItem]);

        Get.dialog(AlertDialog(
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
        ));
      }
    }
  }

  Future<void> fetchData(int id) async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> maps = await db.query(
      "fatransitem",
      where: "id = ?",
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      setState(() {
        tagNo.text = maps[0]['tagNo'];
        description.text = maps[0]['description'].toString();
        faNo.text = maps[0]['faNo'].toString();
        faIdValue = maps[0]['faId'];
        selectedStatus = maps[0]['conStatCode'];
        remarks.text = maps[0]['remarks'];
      });
    }
  }

  Future<void> getInfoItem(String value) async {
    Database db = await dbHelper.initDb();
    String parseToInt = value == '' ? '0' : value;
    List<Map<String, dynamic>> maps =
        await db.query("faitems", where: "tagNo = ?", whereArgs: [parseToInt]);
    if (maps.length == 1) {
      setState(() {
        tagNo.text = value;
        description.text = maps[0]['assetName'];
        faIdValue = maps[0]['faId'];
        faNo.text = maps[0]['faNo'].toString();
      });
    }
  }

  void confirmDownloadItems() {
    Get.dialog(
      AlertDialog(
        title: const Text("Confirmation"),
        content: const Text("Are you sure to sync data items now ?"),
        actions: [
          TextButton(
            onPressed: () {
              // please add action in here
              // ex. actionUploadToServer();
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
    // arguments
    // 0 id fatrans local
    // 1 trans no
    // 2 id local item fatrans
    super.initState();
    transNo.text = Get.arguments[1];
    // tagNo.addListener(() {
    //   getInfoItem(tagNo.text);
    // });
    fetchAllOptions();
    if (Get.arguments[2] != 0) {
      idTransItem = Get.arguments[2];
      fetchData(Get.arguments[2]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer In Item Form'),
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
                      decoration: const InputDecoration(
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
                          child: Focus(
                            onFocusChange: (value) {
                              if (!value) {
                                getInfoItem(tagNo.text);
                              }
                            },
                            child: TextField(
                              controller: tagNo,
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
                                tagNo.text = barcode;
                              });
                            } on PlatformException catch (error) {
                              if (error.code ==
                                  BarcodeScanner.CameraAccessDenied) {
                                setState(() {
                                  tagNo.text =
                                      'Izin kamera tidak diizinkan oleh si pengguna';
                                });
                              } else {
                                setState(() {
                                  tagNo.text = 'Error: $error';
                                });
                              }
                            } catch (e) {
                              setState(() {
                                barcode = '';
                              });
                            }
                          },
                          child: Icon(Icons.qr_code),
                        ),
                        TextButton(
                          onPressed: () {
                            confirmDownloadItems();
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
                            controller: description,
                            decoration: InputDecoration(
                              fillColor: Colors.blueGrey[200],
                              filled: true,
                              contentPadding: const EdgeInsets.all(10),
                              border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blueAccent),
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
                            enabled: false,
                            readOnly: true,
                            controller: faNo,
                            decoration: InputDecoration(
                              fillColor: Colors.blueGrey[200],
                              filled: true,
                              contentPadding: const EdgeInsets.all(10),
                              border: const OutlineInputBorder(
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
                                hint: const Text("Select Status"),
                                items: _optionsStatus.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(item['genName']),
                                    value: item['genCode'],
                                  );
                                }).toList(),
                                value: selectedStatus,
                                onChanged: (value) {
                                  setState(() {
                                    selectedStatus = value.toString();
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
                                borderSide:
                                    BorderSide(color: Colors.blueAccent),
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
                  if (idTransItem != 0) ...[
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
