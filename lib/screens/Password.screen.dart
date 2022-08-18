import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/controllers/Auth.controller.dart';
import 'package:myasset/services/User.service.dart';
// import 'package:myasset/controllers/Auth.controller.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final box = GetStorage();

  final oldPass = TextEditingController();
  final newPass = TextEditingController();
  final conPass = TextEditingController();

  void actionSave() async {
    final authController = AuthController();
    // ignore: avoid_print
    print("Change Password");
    final userService = UserService();
    Map<String, dynamic> m = {
      "oldPwd": oldPass.text,
      "newPwd": newPass.text,
      "confirmPwd": conPass.text
    };
    userService.changePassword(m).then((value) async {
      // ignore: avoid_print
      print(value.body);
      var body = value.body;
      if (body['status'] == true) {
        await authController.saveToken(body['token']);
        box.write('token', body['token']);

        Get.dialog(
          const AlertDialog(
            title: Text("Information"),
            content: Text("Password sukses diganti."),
          ),
        );

        setState(() {
          oldPass.text = "";
          newPass.text = "";
          conPass.text = "";
        });
      } else {
        Get.dialog(
          AlertDialog(
            title: const Text("Information"),
            content: Text(body['message']),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var authController = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
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
                  SizedBox(
                    width: Get.width * 0.3,
                    child: const Text("Old Password"),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: oldPass,
                      obscureText: true,
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
                  SizedBox(
                    width: Get.width * 0.3,
                    child: const Text("New Password :  "),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: newPass,
                      obscureText: true,
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
                  SizedBox(
                    width: Get.width * 0.3,
                    child: const Text("Confirm Password :  "),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: conPass,
                      obscureText: true,
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
                    "Save",
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
