import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/controllers/Auth.controller.dart';
import 'package:myasset/screens/HomePage.screen.dart';
import 'package:myasset/screens/Login.screen.dart';

class MyApp extends StatelessWidget {
  final box = GetStorage();
  AuthController appController = Get.put(AuthController());

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
                ? MyHomePage(title: "Asset Control")
                : LoginScreen();
          }
        }
      },
      future: initializeSettings(),
    );
  }

  Scaffold WaitingView() {
    return Scaffold(
        body: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ),
          Text('Loading...'),
        ],
      ),
    ));
  }

  Scaffold ErrorView(AsyncSnapshot<Object?> snapshot) {
    return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
  }
}
