import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/controllers/Register.controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    RegisterController registerController = Get.put(RegisterController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            children: [
              if (registerController.isAt.value) ...[
                TextField(
                  controller: registerController.apiAddress,
                  onChanged: (value) =>
                      registerController.writeToGetStorage(value),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: "API Address",
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
              TextField(
                controller: registerController.email,
                onChanged: (String value) {
                  registerController.checkFirstCharacterEmail(value);
                },
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: registerController.deviceId,
                readOnly: true,
                enabled: false,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: "Device ID",
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Obx(
                  () => TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 62, 81, 255),
                    ),
                    onPressed: () {
                      registerController.toOtpScreen();
                    },
                    child: registerController.loaderButtonRegistration.value
                        ? const CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          )
                        : const Text(
                            "Submit Registration",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                  onPressed: () {
                    Get.toNamed('/login');
                  },
                  child: const Text(
                    "Have already account ? Login Here",
                    style: TextStyle(
                      color: Color.fromARGB(255, 62, 81, 255),
                      fontSize: 18,
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
