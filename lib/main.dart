import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myasset/screens/Clear.screen.dart';
import 'package:myasset/screens/Download.screen.dart';
import 'package:myasset/screens/Login.screen.dart';
import 'package:myasset/screens/MyApp.screen.dart';
import 'package:myasset/screens/Scan.screen.dart';
import 'package:myasset/screens/Settings.screen.dart';
import 'package:myasset/screens/StockOpname.screen.dart';
import 'package:myasset/screens/TransferIn.screen.dart';
import 'package:myasset/screens/TransferOut.screen.dart';
import 'package:myasset/screens/Upload.screen.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyApp(),
      getPages: [
        GetPage(
          name: '/',
          page: () => MyApp(),
        ),
        GetPage(
          name: '/login',
          page: () => LoginScreen(),
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
