import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myasset/controllers/App.controller.dart';
import 'package:myasset/screens/Login.screen.dart';
import 'package:myasset/screens/Register.screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppController appController = Get.put(AppController());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RegisterScreen();
  }
}
