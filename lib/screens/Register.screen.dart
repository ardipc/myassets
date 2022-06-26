import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myasset/controllers/Register.controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    RegisterController registerController = Get.put(RegisterController());
    return Scaffold(
      backgroundColor: const Color.fromRGBO(48, 52, 156, 1),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(64.0),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Register Form",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(255, 234, 169, 1),
                      fontSize: 30,
                      shadows: [
                        Shadow(
                            // bottomLeft
                            offset: Offset(-1.2, -1.2),
                            color: Color.fromRGBO(242, 159, 5, 1)),
                        Shadow(
                            // bottomRight
                            offset: Offset(1.2, -1.2),
                            color: Color.fromRGBO(242, 159, 5, 1)),
                        Shadow(
                            // topRight
                            offset: Offset(1.2, 1.2),
                            color: Color.fromRGBO(242, 159, 5, 1)),
                        Shadow(
                            // topLeft
                            offset: Offset(-1.2, 1.2),
                            color: Color.fromRGBO(242, 159, 5, 1)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                  if (registerController.isAt.value) ...[
                    TextFormField(
                      controller: registerController.apiAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) =>
                          registerController.writeToGetStorage(value),
                      decoration: const InputDecoration(
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
                  TextFormField(
                    controller: registerController.email,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (v) {
                      registerController.toOtpScreen();
                    },
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
                  TextFormField(
                    controller: registerController.deviceId,
                    focusNode: focusNode,
                    readOnly: true,
                    enabled: false,
                    decoration: InputDecoration(
                      fillColor: Colors.blueGrey[200],
                      filled: true,
                      border: const OutlineInputBorder(),
                      labelText: "Device ID",
                      labelStyle: const TextStyle(color: Colors.black),
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
                          backgroundColor:
                              const Color.fromARGB(255, 62, 81, 255),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
