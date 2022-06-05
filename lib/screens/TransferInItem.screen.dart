import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/services/FATrans.service.dart';
import 'package:myasset/services/FATransItem.service.dart';
import 'package:myasset/services/Location.service.dart';
import 'package:sqflite/sqlite_api.dart';

class TransferInItemScreen extends StatefulWidget {
  TransferInItemScreen({Key? key}) : super(key: key);

  @override
  State<TransferInItemScreen> createState() => _TransferInItemScreenState();
}

class _TransferInItemScreenState extends State<TransferInItemScreen> {
  final box = GetStorage();
  DbHelper dbHelper = DbHelper();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  int? idFaTrans = 0;
  int? plantId = 0;
  String? transTypeCode = "T";
  String? transferTypeCode = "TI";

  final transNo = TextEditingController();
  final dateTime = TextEditingController();
  final manualRef = TextEditingController();
  final otherRef = TextEditingController();

  final oldLocFrom = TextEditingController();
  int? oldLocId = 0;
  final detailOldLocFrom = TextEditingController();

  final newLocFrom = TextEditingController();
  final detailNewLocFrom = TextEditingController();

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
    int exec =
        await db.delete("fatrans", where: "id = ?", whereArgs: [idFaTrans]);
    Get.back();
  }

  Future<void> actionApprove() async {
    Database db = await dbHelper.initDb();
    Map<String, dynamic> map = Map();
    map['isApproved'] = 1;
    int exec = await db
        .update("fatrans", map, where: "id = ?", whereArgs: [idFaTrans]);
    Get.back();
  }

  Future<void> actionSave() async {
    if (transNo.text.isEmpty &&
        manualRef.text.isEmpty &&
        oldLocFrom.text.isEmpty &&
        newLocFrom.text.isEmpty) {
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

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(now);

      Map<String, dynamic> map = Map();
      if (idFaTrans == 0) {
        map['transId'] = 0;
        map['plantId'] = box.read('plantId');
        map['transTypeCode'] = 'T';
        map['transDate'] = dateTime.text;
        map['transNo'] = transNo.text;
        map['manualRef'] = manualRef.text;
        map['otherRef'] = otherRef.text;
        map['transferTypeCode'] = transferTypeCode;
        map['oldLocId'] = oldLocId;
        map['oldLocCode'] = oldLocFrom.text;
        map['oldLocName'] = detailOldLocFrom.text;
        map['newLocId'] = box.read('locationId');
        map['newLocCode'] = box.read('locationCode');
        map['newLocName'] = box.read('locationName');
        map['isApproved'] = 0;
        map['isVoid'] = 0;
        map['saveDate'] = formattedDate;
        map['savedBy'] = box.read('userId');
        map['uploadDate'] = '';
        map['uploadBy'] = '';
        map['uploadMessage'] = '';
        map['syncDate'] = '';
        map['syncBy'] = 0;

        int exec = await db.insert("fatrans", map,
            conflictAlgorithm: ConflictAlgorithm.replace);

        if (exec != 0) {
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
        }
      } else {
        map['transDate'] = dateTime.text;
        map['transNo'] = transNo.text;
        map['manualRef'] = manualRef.text;
        map['otherRef'] = otherRef.text;
        map['oldLocId'] = oldLocId;
        map['oldLocCode'] = oldLocFrom.text;
        map['oldLocName'] = detailOldLocFrom.text;
        map['newLocId'] = box.read('locationId');
        map['newLocCode'] = box.read('locationCode');
        map['newLocName'] = box.read('locationName');

        int exec = await db
            .update("fatrans", map, where: "id = ?", whereArgs: [idFaTrans]);

        if (exec != 0) {
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
  }

  Future<void> fetchData(int id) async {
    Database db = await dbHelper.initDb();

    List<Map<String, dynamic>> maps = await db.query(
      "fatrans",
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.length == 1) {
      setState(() {
        idFaTrans = id;
        dateTime.text = maps[0]['transDate'];
        plantId = maps[0]['plantId'];
        transTypeCode = maps[0]['transTypeCode'];
        transferTypeCode = maps[0]['transferTypeCode'];
        transNo.text = maps[0]['transNo'];
        dateTime.text = maps[0]['dateTime'];
        manualRef.text = maps[0]['manualRef'];
        otherRef.text = maps[0]['otherRef'];

        oldLocId = maps[0]['oldLocId'];
        oldLocFrom.text = maps[0]['oldLocCode'].toString();
        detailOldLocFrom.text = maps[0]['oldLocName'].toString();

        newLocFrom.text = box.read('locationCode');
        detailNewLocFrom.text = maps[0]['newLocName'].toString();
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      _selectTime(context);
      setState(() {
        dateTime.text = picked.toString().substring(0, 10);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      TimeOfDay now = picked;
      setState(() {
        dateTime.text = dateTime.text +
            " " +
            now.hour.toString().padLeft(2, "0") +
            ":" +
            now.minute.toString().padLeft(2, "0");
      });
    }
  }

  void actionUploadToServer() async {
    Database db = await dbHelper.initDb();

    Map<String, dynamic> map = {};
    map['idFaTrans'] = idFaTrans;
    map['transId'] = 0;
    map['plantId'] = box.read('plantId');
    map['transDate'] = dateTime.text;
    map['manualRef'] = manualRef.text;
    map['otherRef'] = otherRef.text;
    map['transferType'] = 'TI';
    map['oldLocId'] = box.read('intransitId');
    map['newLocId'] = box.read('locationId');
    map['isApproved'] = false;
    map['isVoid'] = false;
    map['userId'] = box.read('userId');

    final serviceFATrans = FATransService();
    final serviceFATransItem = FATransItemService();

    serviceFATrans.create(map).then((value) async {
      var res = value.body;
      if (res['message'].toString() != "") {
        Map<String, dynamic> m = {};
        m['transId'] = res['transId'];
        await db.update("fatrans", m, where: "id", whereArgs: [idFaTrans]);

        // looping fa trans item
        List<Map<String, dynamic>> rows = await db.query(
          "fatransitem",
          where: "transId = ?",
          whereArgs: [idFaTrans],
        );

        for (var row in rows) {
          Map<String, dynamic> mRow = {};
          mRow['transItemId'] = row['transItemId'];
          mRow['transId'] = row['transId'];
          mRow['faId'] = row['faId'];
          mRow['remarks'] = row['remarks'];
          mRow['conStat'] = row['conStatCode'];
          mRow['oldTag'] = '-';
          mRow['newTag'] = '-';
          mRow['userId'] = box.read('userId');

          serviceFATransItem.create(mRow).then((value) async {
            var res = value.body;
            if (res['message'].toString() != "") {
              Map<String, dynamic> mItem = {};
              mItem['transItemId'] = res['transItemId'];

              await db.update(
                "fatransitem",
                mItem,
                where: "id = ?",
                whereArgs: [
                  row['id'],
                ],
              );
            }
          });
        }
      } else {
        Get.dialog(
          AlertDialog(
            title: const Text("Message"),
            content: Text(res['message']),
          ),
        );
      }
    });
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

  void confirmApprove() {
    Get.dialog(
      AlertDialog(
        title: Text("Confirmation"),
        content: Text("Are you sure to approve this data now ?"),
        actions: [
          TextButton(
            onPressed: () {
              // please add action in here
              // ex. actionUploadToServer();
              actionApprove();
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

  Future<void> getLocationByCoce(String code) async {
    final locationService = LocationService();
    locationService.getByCode(code).then((value) {
      int locationId = value.body['locationId'];
      if (locationId != 0) {
        oldLocId = locationId;
        detailOldLocFrom.text = value.body['locationName'];
      } else {
        oldLocId = 0;
        detailOldLocFrom.text = "";
        Get.dialog(
          const AlertDialog(
            title: Text("Information"),
            content: Text("Location not found."),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.arguments != null) {
      fetchData(Get.arguments[0]);
    } else {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(now);
      dateTime.text = formattedDate;
    }
    newLocFrom.text = box.read('locationCode');
    detailNewLocFrom.text = box.read('locationName');

    oldLocId = box.read('instransitId');
    oldLocFrom.text = box.read('intransitCode');
    detailOldLocFrom.text = box.read('intransitName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer In Form'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                        SizedBox(
                          child: const Text("Trans No : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
                          child: TextField(
                            controller: transNo,
                            decoration: const InputDecoration(
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
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text("Date/Time : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
                          child: TextField(
                            controller: dateTime,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent)),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          child: Icon(Icons.date_range),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text("Manual Ref : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
                            child: TextField(
                          controller: manualRef,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blueAccent)),
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text("Other Ref : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
                          child: TextField(
                            controller: otherRef,
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
                        Container(
                          child: Text("Loc. From : "),
                          width: Get.width * 0.14,
                        ),
                        Container(
                          width: Get.width * 0.2,
                          child: Focus(
                            onFocusChange: (value) {
                              if (!value) {
                                getLocationByCoce(oldLocFrom.text);
                              }
                            },
                            child: TextField(
                              controller: oldLocFrom,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blueAccent)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: detailOldLocFrom,
                            enabled: false,
                            readOnly: true,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent)),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text("Loc. To : "),
                          width: Get.width * 0.14,
                        ),
                        Container(
                          width: Get.width * 0.2,
                          child: TextField(
                            controller: newLocFrom,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: detailNewLocFrom,
                            enabled: false,
                            readOnly: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent)),
                            ),
                          ),
                        )
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
                        "Save as Draft",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  if (idFaTrans != 0) ...[
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                      height: 50,
                      width: 600,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 131, 142, 240),
                        ),
                        onPressed: () {
                          Get.toNamed('/transferinitemlist',
                              arguments: [idFaTrans, transNo.text]);
                        },
                        child: Text(
                          "Open Item List",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                    height: 50,
                    width: 600,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 40, 165, 61),
                      ),
                      onPressed: () {
                        confirmApprove();
                      },
                      child: Text(
                        "Approve",
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
                        backgroundColor: Color.fromARGB(255, 116, 54, 173),
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
                  if (idFaTrans != 0) ...[
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
