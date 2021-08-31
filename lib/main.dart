import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './Screens/Auth/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: LoginScreen(),
      routes: {
        '/material': (ctx) => LoginScreen(),
      },
    );
  }
}
