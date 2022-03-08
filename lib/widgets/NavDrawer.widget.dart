import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const UserAccountsDrawerHeader(
            currentAccountPicture: ClipOval(
              child: Image(
                  image: AssetImage('assets/images/orang.png'),
                  fit: BoxFit.cover),
            ),
            accountName: Text('Ahmad Ardiansyah'),
            accountEmail: Text('Administrator'),
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
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Clear Data'),
            onTap: () => {Get.toNamed('/clear')},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Get.toNamed('/settings')},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Get.offAllNamed('/login')},
          ),
        ],
      ),
    );
  }
}
