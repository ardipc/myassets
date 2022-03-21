import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myasset/helpers/db.helper.dart';
import 'package:myasset/screens/Clear.screen.dart';
import 'package:myasset/screens/Download.screen.dart';
import 'package:myasset/screens/HomePage.screen.dart';
import 'package:myasset/screens/Login.screen.dart';
import 'package:myasset/screens/MyApp.screen.dart';
import 'package:myasset/screens/Otp.screen.dart';
import 'package:myasset/screens/Register.screen.dart';
import 'package:myasset/screens/Settings.screen.dart';
import 'package:myasset/screens/StockOpname.screen.dart';
import 'package:myasset/screens/Table.screen.dart';
import 'package:myasset/screens/TransferIn.screen.dart';
import 'package:myasset/screens/TransferOut.screen.dart';
import 'package:myasset/screens/Upload.screen.dart';
import 'package:sqflite/sqlite_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DbHelper dbHelper = DbHelper();
  Database db = await dbHelper.initDb();
  List<Map<String, dynamic>> maps = await db.query("preferences");
  print(maps.toList());

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: maps.length == 1 && maps[0]['userId'] != 0
          ? const MyHomePage(title: "Asset Control")
          : const MyApp(),
      getPages: [
        GetPage(
          name: '/',
          page: () => MyApp(),
        ),
        GetPage(
          name: '/home',
          page: () => MyHomePage(title: "Asset Control"),
        ),
        GetPage(
          name: '/login',
          page: () => LoginScreen(),
        ),
        GetPage(
          name: '/register',
          page: () => RegisterScreen(),
        ),
        GetPage(
          name: '/otp',
          page: () => OtpScreen(),
        ),
        GetPage(
          name: '/table',
          page: () => DataPage(),
        ),
        GetPage(
          name: '/stockopname',
          page: () => StockOpnameScreen(),
        ),
        GetPage(
          name: '/transferin',
          page: () => TransferInScreen(),
        ),
        GetPage(
          name: '/transferout',
          page: () => TransferOutScreen(),
        ),
        GetPage(
          name: '/download',
          page: () => DownloadScreen(),
        ),
        GetPage(
          name: '/upload',
          page: () => UploadScreen(),
        ),
        GetPage(
          name: '/clear',
          page: () => ClearScreen(),
        ),
        GetPage(
          name: '/settings',
          page: () => SettingsScreen(),
        ),
      ],
    ),
  );
}
