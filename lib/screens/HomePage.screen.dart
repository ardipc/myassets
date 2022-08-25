import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:intl/intl.dart';
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
        AlertDialog(
          content: const Text(
              "Master data has not been downloaded.\nPlease download it in Download menu on left sidebar."),
          title: const Text("Message"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                Get.toNamed('/download');
              },
              child: const Text("Go to download"),
            ),
          ],
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

  void showIsiTabel() async {
    Database db = await dbHelper.initDb();
    // await db.update(
    //   "stockopnames",
    //   {
    //     "uploadDate": null,
    //     "saveDate": null,
    //     "savedBy": null,
    //   },
    //   where: "id = ?",
    //   whereArgs: [1],
    // );

    List<Map<String, dynamic>> soRows = await db.query(
      'stockopnames',
      columns: ['id', 'uploadDate', 'saveDate'],
      where:
          "(uploadDate < saveDate OR uploadDate is NULL) AND saveDate is NOT NULL",
      // where: 'id in (1,2)',
    );

    // ignore: avoid_print
    print("Length : ${soRows.length}");
    // print("Rows : $soRows");

    // List<Map<String, dynamic>> so = await db.query(
    //   'fatransitem',
    //   // where: 'tagNo = ?',
    //   // whereArgs: ['40000005993'],
    // );
    // // ignore: avoid_print
    // print(so);
    // // ignore: avoid_print
    // print("====================================================");

    // List<Map<String, dynamic>> maps = await db.query(
    //   'fatrans',
    //   columns: ['id', 'manualRef', 'transferTypeCode', 'transId', 'transNo'],
    // );
    // // ignore: avoid_print
    // print(maps);
    // // ignore: avoid_print
    // print("====================================================");

    // List<Map<String, dynamic>> rows = await db.query(
    //   'fatransitem',
    //   columns: ['id', 'tagNo', 'transLocalId', 'transId'],
    // );
    // // ignore: avoid_print
    // print(rows);
    // // ignore: avoid_print
    // print("====================================================");
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
            const Text(
              "Welcome to Asset Control",
              style: TextStyle(fontSize: 24),
            ),
            Text(
              "${box.read('realName') ?? "-"}",
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "${box.read('roleName') ?? "-"}",
              style: const TextStyle(fontSize: 20),
            ),
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: box.read('token')));
                Get.snackbar("Information", "Copy to Clipboard.");
                showIsiTabel();
              },
              icon: const Icon(Icons.copy),
            ),
            // IconButton(
            //   onPressed: () {
            //     showIsiTabel();
            //   },
            //   icon: const Icon(Icons.table_chart),
            // )
          ],
        ),
      ),
    );
  }
}
