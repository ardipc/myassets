import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/controllers/Home.controller.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/widgets/NavDrawer.widget.dart';
import 'package:sqflite/sqlite_api.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final box = GetStorage();
  final homeController = Get.put(HomeController());
  DbHelper dbHelper = DbHelper();

  Future<void> checkMasterData() async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> rows = await db.query("periods");

    if (rows.isEmpty) {
      Get.dialog(
        const AlertDialog(
          content: Text(
              "Master data has not been downloaded.\nPlease download it in Download menu on left sidebar."),
          title: Text("Message"),
        ),
      );
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    checkMasterData();
  }

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
            // Text("Welcome ${box.read('username')}"),
            const Text("Welcome to Asset Control"),
            Text("${box.read('realName') ?? "-"}"),
            Text("${box.read('roleName') ?? "-"}"),
          ],
        ),
      ),
    );
  }
}
