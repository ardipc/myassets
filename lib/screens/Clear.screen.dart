import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClearScreen extends StatefulWidget {
  const ClearScreen({Key? key}) : super(key: key);

  @override
  State<ClearScreen> createState() => _ClearScreen();
}

class _ClearScreen extends State<ClearScreen> {
  String date = "";
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
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
                      child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent)),
                    ),
                  )),
                  Text(" "),
                  ElevatedButton.icon(
                    onPressed: () {
                      _selectDate(context);
                    },
                    icon: Icon(Icons.date_range),
                    label: Text("Date"),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {}, child: Text("Clear")))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }
}
