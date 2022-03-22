import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myasset/screens/Table.screen.dart';

class StockOpnameItemScreen extends StatefulWidget {
  StockOpnameItemScreen({Key? key}) : super(key: key);

  @override
  State<StockOpnameItemScreen> createState() => _StockOpnameItemScreenState();
}

class _StockOpnameItemScreenState extends State<StockOpnameItemScreen> {
  String selectedValue = "USA";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Opname Item'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                const Text("Period"),
                const SizedBox(
                  width: 40,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.62,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
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
                TextButton.icon(
                  onPressed: () {
                    Get.toNamed('/table');
                  },
                  icon: Icon(Icons.download),
                  label: Text("Download"),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                  height: 50,
                  width: 600,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 62, 81, 255),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Scan / Entry Asset",
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
                      backgroundColor: Color.fromARGB(255, 85, 189, 90),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 6.0, right: 6.0, bottom: 6.0, top: 3.0),
                  height: 50,
                  width: 600,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 108, 47, 207),
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
