import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myasset/controllers/Clear.controller.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:sqflite/sqlite_api.dart';

class ClearScreen extends StatefulWidget {
  const ClearScreen({Key? key}) : super(key: key);

  @override
  State<ClearScreen> createState() => _ClearScreen();
}

class _ClearScreen extends State<ClearScreen> {
  final dbHelper = DbHelper();
  String date = "";

  int? selectedPeriod = null;
  List _dropdownPeriods = [];

  final dateTime = TextEditingController();

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

  Future<void> fetchPeriod() async {
    Database db = await dbHelper.initDb();

    List<Map<String, dynamic>> maps = await db.query(
      "periods",
      columns: ["periodId", "periodName"],
    );

    setState(() {
      _dropdownPeriods = maps;
    });
  }

  void confirmClear(ClearController controller) {
    Get.dialog(
      AlertDialog(
        title: Text("Confirmation"),
        content: Text("Are you sure to clear data on period ?"),
        actions: [
          TextButton(
            onPressed: () {
              // to do action in here
              controller.clearAllData(selectedPeriod ?? 0);
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
    fetchPeriod();
  }

  @override
  Widget build(BuildContext context) {
    final clearController = Get.put(ClearController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clear'),
      ),
      body: Card(
        elevation: 4,
        margin: EdgeInsets.all(20),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text("Periode :  "),
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
                          hint: const Text("Select Period"),
                          items: _dropdownPeriods.map((item) {
                            return DropdownMenuItem(
                              child: Text(item['periodName']),
                              value: item['periodId'],
                            );
                          }).toList(),
                          value: selectedPeriod,
                          onChanged: (value) {
                            setState(() {
                              selectedPeriod = int.parse(value.toString());
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Text(" "),
                  TextButton(
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Icon(Icons.date_range),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                width: Get.width,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromRGBO(44, 116, 180, 1),
                  ),
                  onPressed: () {
                    confirmClear(clearController);
                  },
                  child: Text(
                    "Clear",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
