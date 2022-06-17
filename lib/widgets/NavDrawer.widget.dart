import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myasset/controllers/Auth.controller.dart';

class NavDrawerWidget extends StatelessWidget {
  final box = GetStorage();

  NavDrawerWidget({Key? key}) : super(key: key);

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
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Stock Opname'),
            onTap: () => {Get.toNamed('/stockopname')},
          ),
          ListTile(
            leading: const Icon(Icons.inbox),
            title: const Text('Transfer In'),
            onTap: () => {Get.toNamed('/transferin')},
          ),
          ListTile(
            leading: const Icon(Icons.outbox),
            title: const Text('Transfer Out'),
            onTap: () => {Get.toNamed('/transferout')},
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Download'),
            onTap: () => {Get.toNamed('/download')},
          ),
          ListTile(
            leading: const Icon(Icons.file_upload_outlined),
            title: const Text('Upload'),
            onTap: () => {Get.toNamed('/upload')},
          ),
          if (box.read('roleId') == 1) ...[
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Clear Data'),
              onTap: () => {Get.toNamed('/clear')},
            ),
          ],
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => {Get.toNamed('/settings')},
          ),
          ListTile(
            leading: const Icon(Icons.extension_off),
            title: const Text('Unregister Device'),
            onTap: () => {authController.actionUnregister()},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () => {authController.actionLogout()},
          ),
        ],
      ),
    );
  }
}
