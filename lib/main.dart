import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/screens/Clear.screen.dart';
import 'package:myasset/screens/Download.screen.dart';
import 'package:myasset/screens/HomePage.screen.dart';
import 'package:myasset/screens/Login.screen.dart';
import 'package:myasset/screens/MyApp.screen.dart';
import 'package:myasset/screens/Otp.screen.dart';
import 'package:myasset/screens/Password.screen.dart';
import 'package:myasset/screens/Register.screen.dart';
import 'package:myasset/screens/Settings.screen.dart';
import 'package:myasset/screens/StockOpname.screen.dart';
import 'package:myasset/screens/StockOpnameItem.screen.dart';
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

  // development purpose
  box.write('apiAddress', "https://api.sariroti.com");
  // box.write('registered', true);
  // box.write('locationId', 1798);
  // box.write('locationCode', "D70001990");
  // box.write('locationName', "PT ESSEI PERBAMA BEKASI UTARA");
  // box.write('plantId', 11);
  // box.write('plantName', "CIKARANG");
  // box.write('roleId', 2);
  // box.write('userId', 286);
  // end development purpose

  final registered = box.read('registered');

  // print(registered);
  // print(registered.runtimeType);
  // print((registered == null || registered == false) ? "ok" : "not");

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
      home: (registered == false || registered == null)
          ? const RegisterScreen()
          : MyApp(),
      getPages: [
        GetPage(
          name: '/',
          page: () => MyApp(),
        ),
        GetPage(
          name: '/home',
          page: () => const MyHomePage(title: "Asset Control"),
        ),
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterScreen(),
        ),
        GetPage(
          name: '/otp',
          page: () => const OtpScreen(),
        ),
        GetPage(
          name: '/stockopname',
          page: () => StockOpnameScreen(),
        ),
        GetPage(
          name: '/stockopnameitem',
          page: () => const StockOpnameItemScreen(),
        ),
        GetPage(
          name: '/transferin',
          page: () => const TransferInScreen(),
        ),
        GetPage(
          name: '/transferinitem',
          page: () => const TransferInItemScreen(),
        ),
        GetPage(
          name: '/transferinitemlist',
          page: () => const TransferInItemListScreen(),
        ),
        GetPage(
          name: '/transferinitemform',
          page: () => const TransferInItemFormScreen(),
        ),
        GetPage(
          name: '/transferout',
          page: () => const TransferOutScreen(),
        ),
        GetPage(
          name: '/transferoutitem',
          page: () => const TransferOutItemScreen(),
        ),
        GetPage(
          name: '/transferoutitemlist',
          page: () => const TransferOutItemListScreen(),
        ),
        GetPage(
          name: '/transferoutitemform',
          page: () => const TransferOutItemFormScreen(),
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
          page: () => const ClearScreen(),
        ),
        GetPage(
          name: '/settings',
          page: () => const SettingsScreen(),
        ),
        GetPage(
          name: '/password',
          page: () => const PasswordScreen(),
        ),
      ],
    ),
  );
}
