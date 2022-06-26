import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:myasset/controllers/Auth.controller.dart';

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
        const AlertDialog(
          title: Text("Information"),
          content: Text("There are still empty, please fill all field."),
        ),
      );
    } else {
      box.write('apiAddress', apiAddressController.text);
      box.write('locationCode', locationCodeController.text);
      Get.dialog(
        const AlertDialog(
          title: Text("Information"),
          content: Text("Data has been saved."),
        ),
      );
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    apiAddressController.text = box.read('apiAddress') ?? "";
    locationCodeController.text = box.read('locationCode') ?? "";
  }

  void actionUnregisterAndLogout() async {
    final box = GetStorage();
    box.write('registered', false);
  }

  @override
  Widget build(BuildContext context) {
    // var authController = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Get.offAllNamed('/home');
          },
        ),
      ),
      body: Card(
        elevation: 4,
        margin: const EdgeInsets.all(20),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Text("API Address     :  "),
                  Expanded(
                    child: TextField(
                      controller: apiAddressController,
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
              const SizedBox(
                height: 14,
              ),
              Row(
                children: <Widget>[
                  const Text("Location Code :  "),
                  Expanded(
                    child: TextField(
                      controller: locationCodeController,
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
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: Get.width,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(44, 116, 180, 1),
                  ),
                  onPressed: () {
                    actionSave();
                  },
                  child: const Text(
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
