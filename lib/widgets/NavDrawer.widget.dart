import 'package:flutter/material.dart';

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
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.inbox),
            title: Text('Transfer In'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.outbox),
            title: Text('Transfer Out'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.download),
            title: Text('Download'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.file_upload_outlined),
            title: Text('Upload'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Clear Data'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
