import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myasset/controllers/Login.controller.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/screens/HomePage.screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginController loginController = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Color.fromRGBO(48, 52, 156, 1),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 32, left: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "API : ${loginController.box.read('apiAddress') ?? "https://api.google.com"}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Location : ${loginController.box.read("locationName") ?? "-"}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Plant : ${loginController.box.read("plantName") ?? "-"}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 32),
                child: const Image(
                  image: AssetImage("assets/images/sariroti.png"),
                  fit: BoxFit.fill,
                  width: 280,
                  height: 300,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 27), //apply padding horizontal or vertical only
                child: Text(
                  "Fixed Assets Control System\nLogin Form",
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 62),
              child: TextField(
                controller: loginController.username,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 62, vertical: 10),
              child: TextField(
                controller: loginController.password,
                obscureText: true,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 62, vertical: 10),
              child: Container(
                height: 60,
                width: 600,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 62, 81, 255),
                  ),
                  onPressed: () {
                    // Get.off(
                    //   MyHomePage(title: "Asset Control"),
                    // );
                    loginController.actionLogin();
                  },
                  child: const Text(
                    "LOGIN",
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
    );
  }
}
