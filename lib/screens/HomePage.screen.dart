import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/controllers/Home.controller.dart';
import 'package:myasset/screens/Clear.screen.dart';
import 'package:myasset/screens/Login.screen.dart';
import 'package:myasset/screens/Scan.screen.dart';
import 'package:myasset/widgets/NavDrawer.widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final box = GetStorage();
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: NavDrawerWidget(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome ${box.read('realName')}"),
            Text("${box.read('roleName')}"),
          ],
        ),
      ),
    );
  }
}
