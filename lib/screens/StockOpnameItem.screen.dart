import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myasset/screens/Table.screen.dart';

class StockOpnameItemScreen extends StatefulWidget {
  StockOpnameItemScreen({Key? key}) : super(key: key);

  @override
  State<StockOpnameItemScreen> createState() => _StockOpnameItemScreenState();
}

class _StockOpnameItemScreenState extends State<StockOpnameItemScreen> {
  String selectedValue = "USA";
  String barcode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Opname Item'),
      ),
      body: Column(
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
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
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
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
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
                        child: Text("FA No : "),
                        width: Get.width * 0.14,
                      ),
                      Expanded(
                          child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
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
                      Get.toNamed('/stockopnameitem');
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
