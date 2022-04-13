import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final box = GetStorage();

  final apiAddressController = TextEditingController();
  final locationCodeController = TextEditingController();

  void actionSave() {
    if (apiAddressController.text.isEmpty &&
        locationCodeController.text.isEmpty) {
      Get.dialog(
        AlertDialog(
          title: Text("Information"),
          content: Text("There are still empty, please fill all field."),
        ),
      );
    } else {
      box.write('apiAddress', apiAddressController.text);
      box.write('locationCode', locationCodeController.text);
      Get.dialog(
        AlertDialog(
          title: Text("Information"),
          content: Text("Data has been saved."),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiAddressController.text = box.read('apiAddress') ?? "";
    locationCodeController.text = box.read('locationCode') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
                  Text("API Address     :  "),
                  Expanded(
                    child: new TextField(
                      controller: apiAddressController,
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
              SizedBox(
                height: 14,
              ),
              Row(
                children: <Widget>[
                  new Text("Location Code :  "),
                  new Expanded(
                    child: new TextField(
                      controller: locationCodeController,
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
                    actionSave();
                  },
                  child: Text(
                    "Save Setting",
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
