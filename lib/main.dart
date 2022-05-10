import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/screens/Clear.screen.dart';
import 'package:myasset/screens/Download.screen.dart';
import 'package:myasset/screens/HomePage.screen.dart';
import 'package:myasset/screens/Login.screen.dart';
import 'package:myasset/screens/MyApp.screen.dart';
import 'package:myasset/screens/Otp.screen.dart';
import 'package:myasset/screens/Register.screen.dart';
import 'package:myasset/screens/Settings.screen.dart';
import 'package:myasset/screens/StockOpname.screen.dart';
import 'package:myasset/screens/StockOpnameItem.screen.dart';
import 'package:myasset/screens/Table.screen.dart';
import 'package:myasset/screens/TransferIn.screen.dart';
import 'package:myasset/screens/TransferInItem.screen.dart';
import 'package:myasset/screens/TransferInItemForm.screen.dart';
import 'package:myasset/screens/TransferInItemList.screen.dart';
import 'package:myasset/screens/TransferOut.screen.dart';
import 'package:myasset/screens/TransferOutItem.screen.dart';
import 'package:myasset/screens/TransferOutItemForm.screen.dart';
import 'package:myasset/screens/TransferOutItemList.screen.dart';
import 'package:myasset/screens/Upload.screen.dart';

void main() async {
  await GetStorage.init();

  final box = GetStorage();
  // box.write('registered', false);
  final registered = box.read('registered');

  runApp(
    GetMaterialApp(
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(48, 52, 156, 1),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(48, 52, 156, 1),
        ),
      ),
      enableLog: true,
      debugShowCheckedModeBanner: false,
      home: registered ? MyApp() : RegisterScreen(),
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
          name: '/stockopnameitem',
          page: () => StockOpnameItemScreen(),
        ),
        GetPage(
          name: '/transferin',
          page: () => TransferInScreen(),
        ),
        GetPage(
          name: '/transferinitem',
          page: () => TransferInItemScreen(),
        ),
        GetPage(
          name: '/transferinitemlist',
          page: () => TransferInItemListScreen(),
        ),
        GetPage(
          name: '/transferinitemform',
          page: () => TransferInItemFormScreen(),
        ),
        GetPage(
          name: '/transferout',
          page: () => TransferOutScreen(),
        ),
        GetPage(
          name: '/transferoutitem',
          page: () => TransferOutItemScreen(),
        ),
        GetPage(
          name: '/transferoutitemlist',
          page: () => TransferOutItemListScreen(),
        ),
        GetPage(
          name: '/transferoutitemform',
          page: () => TransferOutItemFormScreen(),
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
