import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './Screens/Dashboard/dashboard.dart';
import './Screens/Auth/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      routes: {
        '/': (ctx) => LoginScreen(),
        '/dashboard': (ctx) => Dashboard(),
      },
    );
  }
}
