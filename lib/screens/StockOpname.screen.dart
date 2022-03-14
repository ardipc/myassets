import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockOpnameScreen extends StatefulWidget {
  StockOpnameScreen({Key? key}) : super(key: key);

  @override
  State<StockOpnameScreen> createState() => _StockOpnameScreenState();
}

class _StockOpnameScreenState extends State<StockOpnameScreen> {
  String selectedValue = "USA";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Opname'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text("Period"),
                const SizedBox(
                  width: 40,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
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
