import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/MockTest/mockTest.dart';
import 'package:pgmp4u/Screens/PracticeTests/practiceTest.dart';
// import 'package:pgmp4u/Screens/test.dart';
import './Screens/Dashboard/dashboard.dart';
import './Screens/Auth/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (ctx) => LoginScreen(),
        '/dashboard': (ctx) => Dashboard(),
        '/practice-test': (ctx) => PracticeTest(),
        '/mock-test': (ctx) => MockTest()
      },
    );
  }
}
