import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/screens/Table.screen.dart';
import 'package:sqflite/sqlite_api.dart';

class TransferInItemScreen extends StatefulWidget {
  TransferInItemScreen({Key? key}) : super(key: key);

  @override
  State<TransferInItemScreen> createState() => _TransferInItemScreenState();
}

class _TransferInItemScreenState extends State<TransferInItemScreen> {
  DbHelper dbHelper = DbHelper();

  int? idFaTrans = 0;
  int? plantId = 0;
  String? transTypeCode = "T";
  String? transferTypeCode = "TI";

  final transNo = TextEditingController();
  final dateTime = TextEditingController();
  final manualRef = TextEditingController();
  final otherRef = TextEditingController();
  final oldLocFrom = TextEditingController();
  final newLocFrom = TextEditingController();

  Future<void> actionSave() async {
    Database db = await dbHelper.initDb();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    Map<String, dynamic> map = Map();
    if (idFaTrans == 0) {
    } else {}
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
        oldLocFrom.text = maps[0]['oldLocFrom'];
        newLocFrom.text = maps[0]['newLocFrom'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.arguments != null) {
      fetchData(Get.arguments[0]);
    } else {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
      dateTime.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer In Form'),
      ),
      body: Column(
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
                          onPressed: () {}, child: Icon(Icons.date_range)),
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
                              borderSide: BorderSide(color: Colors.blueAccent)),
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
                        child: Text("Loc. From : "),
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
                      "Save as Draft",
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
                      backgroundColor: Color.fromARGB(255, 131, 142, 240),
                    ),
                    onPressed: () {
                      Get.toNamed('/transferinitemlist');
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
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                  height: 50,
                  width: 600,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 40, 165, 61),
                    ),
                    onPressed: () {},
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
                  margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                  height: 50,
                  width: 600,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 116, 54, 173),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Upload to Server",
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
            ),
          )
        ],
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
