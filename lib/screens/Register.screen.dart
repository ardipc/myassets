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
        child: Column(
          children: [
            TextField(
              controller: registerController.apiAddress,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                labelText: "API Address",
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              controller: registerController.locationId,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                labelText: "Location ID",
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              controller: registerController.username,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                labelText: "Username",
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              controller: registerController.email,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              controller: registerController.deviceId,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
                labelText: "Device ID",
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              height: 22,
            ),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 62, 81, 255),
                ),
                onPressed: () {
                  registerController.toOtpScreen();
                },
                child: Text(
                  "Submit Registration",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
