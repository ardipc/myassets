import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myasset/screens/HomePage.screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(48, 52, 156, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: Image(
                  image: AssetImage("assets/images/sariroti.png"),
                  fit: BoxFit.fill,
                  width: 280,
                  height: 300,
                ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 27), //apply padding horizontal or vertical only
              child: Text("Fixed Assets Control System\nLogin Form", 
              textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(255, 234, 169, 1),
                  fontSize: 30,
                  shadows: [
                        Shadow( // bottomLeft
                    offset: Offset(-1.2, -1.2),
                    color: Color.fromRGBO(242, 159, 5, 1)
                        ),
                        Shadow( // bottomRight
                    offset: Offset(1.2, -1.2),
                    color: Color.fromRGBO(242, 159, 5, 1)
                        ),
                        Shadow( // topRight
                    offset: Offset(1.2, 1.2),
                    color: Color.fromRGBO(242, 159, 5, 1)
                        ),
                        Shadow( // topLeft
                    offset: Offset(-1.2, 1.2),
                    color: Color.fromRGBO(242, 159, 5, 1)
                        ),
                    ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 62),
              child: const TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Username', 
                  labelStyle: TextStyle(
                      color: Colors.black 
                    ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 62, vertical: 10),
              child: const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Colors.black
                  ),
                ),
              ),
              
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 62, vertical: 15),
              child: Container(
                height: 60,
                width: 600,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 62, 81, 255),
                  ),
                  onPressed: () {
                    Get.off(
                      MyHomePage(title: "Setelah Login"),
                    );
                  },
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
