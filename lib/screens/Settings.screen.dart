import 'package:flutter/material.dart';
import 'package:myasset/widgets/NavDrawer.widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text('Screen Settings'),
      ),
      drawer: NavDrawerWidget(),
      body: new Card(
        elevation: 4,
        margin: EdgeInsets.all(20),
        shape:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
        color: Colors.white70,
        child: new Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Text("API Address     :  "),
                  new Expanded(child: new TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent)
                      ),
                    ),
                  )),
                ],
              ),
              new Row(
                children: [
                  new Text("\n", 
                    style: TextStyle(
                      fontSize: 2
                    ),
                  ),
                ],
              ),
              new Row(
                children: <Widget>[
                  new Text("Location Code :  "),
                  new Expanded(child: new TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent)
                      ),
                    ),
                  )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                child: Container(
                  height: 35,
                  width: 600,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromRGBO(44, 116, 180, 1),
                    ),
                    onPressed: () {
                      
                    },
                    child: Text(
                      "Save Setting",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
