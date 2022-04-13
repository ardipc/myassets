import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/screens/Table.screen.dart';
import 'package:sqflite/sqlite_api.dart';

class TransferOutItemScreen extends StatefulWidget {
  TransferOutItemScreen({Key? key}) : super(key: key);

  @override
  State<TransferOutItemScreen> createState() => _TransferOutItemScreenState();
}

class _TransferOutItemScreenState extends State<TransferOutItemScreen> {
  final box = GetStorage();
  DbHelper dbHelper = DbHelper();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  int? idFaTrans = 0;
  int? plantId = 0;
  String? transTypeCode = "T";
  String? transferTypeCode = "TO";

  final transNo = TextEditingController();
  final dateTime = TextEditingController();
  final manualRef = TextEditingController();
  final otherRef = TextEditingController();
  final oldLocFrom = TextEditingController();
  final newLocFrom = TextEditingController();

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
      map['transferTypeCode'] = 'TO';
      map['oldLocId'] = int.parse(oldLocFrom.text);
      map['newLocId'] = int.parse(newLocFrom.text);
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
      map['transDate'] = dateTime.text;
      map['transNo'] = transNo.text;
      map['manualRef'] = manualRef.text;
      map['otherRef'] = otherRef.text;
      map['oldLocId'] = int.parse(oldLocFrom.text);
      map['newLocId'] = int.parse(newLocFrom.text);

      int exec = await db
          .update("fatrans", map, where: "id = ?", whereArgs: [idFaTrans]);

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
        oldLocFrom.text = maps[0]['oldLocId'].toString();
        newLocFrom.text = maps[0]['newLocId'].toString();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Out Form'),
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
                        Container(
                          child: Text("Trans No : "),
                          width: Get.width * 0.14,
                        ),
                        Expanded(
                          child: TextField(
                            controller: transNo,
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
                            decoration: InputDecoration(
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
                        TextButton(
                          onPressed: () {
                            _selectTime(context);
                          },
                          child: Icon(Icons.timer),
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
                          decoration: InputDecoration(
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
                          child: Text("Loc. To : "),
                          width: Get.width * 0.14,
                        ),
                        Container(
                          width: Get.width * 0.2,
                          child: TextField(
                            controller: oldLocFrom,
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
                          Get.toNamed('/transferoutitemlist',
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

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("USA"), value: "USA"),
      DropdownMenuItem(child: Text("Canada"), value: "Canada"),
      DropdownMenuItem(child: Text("Brazil"), value: "Brazil"),
      DropdownMenuItem(child: Text("England"), value: "England"),
    ];
    return menuItems;
  }
}
