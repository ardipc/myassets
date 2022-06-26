import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/controllers/Auth.controller.dart';
import 'package:myasset/screens/HomePage.screen.dart';
import 'package:myasset/screens/Login.screen.dart';

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final box = GetStorage();
  AuthController appController = Get.put(AuthController());

  MyApp({Key? key}) : super(key: key);

  Future<void> initializeSettings() async {
    appController.checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    AuthController _authController = Get.find();

    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return WaitingView();
        } else {
          if (snapshot.hasError) {
            return ErrorView(snapshot);
          } else {
            return _authController.isLogged.value
                ? const MyHomePage(title: "Asset Control")
                : const LoginScreen();
          }
        }
      },
      future: initializeSettings(),
    );
  }

  // ignore: non_constant_identifier_names
  Scaffold WaitingView() {
    return Scaffold(
        body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
          Text('Loading...'),
        ],
      ),
    ));
  }

  // ignore: non_constant_identifier_names
  Scaffold ErrorView(AsyncSnapshot<Object?> snapshot) {
    return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
  }
}
