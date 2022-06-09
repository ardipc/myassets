import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/controllers/Auth.controller.dart';
import 'package:myasset/controllers/Login.controller.dart';

class NavDrawerWidget extends StatelessWidget {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: const ClipOval(
              child: Image(
                  image: AssetImage('assets/images/orang.png'),
                  fit: BoxFit.cover),
            ),
            accountName: Text(box.read('realName') ?? 'Anonymous'),
            accountEmail: Text(box.read('roleName') ?? 'User'),
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('Stock Opname'),
            onTap: () => {Get.toNamed('/stockopname')},
          ),
          ListTile(
            leading: Icon(Icons.inbox),
            title: Text('Transfer In'),
            onTap: () => {Get.toNamed('/transferin')},
          ),
          ListTile(
            leading: Icon(Icons.outbox),
            title: Text('Transfer Out'),
            onTap: () => {Get.toNamed('/transferout')},
          ),
          ListTile(
            leading: Icon(Icons.download),
            title: Text('Download'),
            onTap: () => {Get.toNamed('/download')},
          ),
          ListTile(
            leading: Icon(Icons.file_upload_outlined),
            title: Text('Upload'),
            onTap: () => {Get.toNamed('/upload')},
          ),
          if (box.read('roleId') == 1) ...[
            ListTile(
              leading: const Icon(Icons.delete),
              title: Text('Clear Data'),
              onTap: () => {Get.toNamed('/clear')},
            ),
          ],
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Get.toNamed('/settings')},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {authController.actionLogout()},
          ),
        ],
      ),
    );
  }
}
