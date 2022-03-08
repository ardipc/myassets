import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myasset/screens/HomePage.screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 62),
              child: const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 62, vertical: 16),
              child: const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 62, vertical: 6),
              child: Container(
                height: 60,
                width: 600,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 62, 81, 255),
                  ),
                  onPressed: () {
                    Get.off(
                      MyHomePage(title: "Asset Control"),
                    );
                  },
                  child: Text(
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
