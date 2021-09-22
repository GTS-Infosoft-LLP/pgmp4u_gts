import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String tokenData;
  getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('token');
    return stringValue;
  }

  navigateToScreen() async {
    String value = await getValue();
    setState(() {
      tokenData = value;
    });
    Timer timer = new Timer(new Duration(seconds: 2), () {
    
      if (value != null) {
        Navigator.of(context).pushNamed('/dashboard');
      } else {
        Navigator.of(context).pushNamed('/start-screen');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    print(double.infinity);
    navigateToScreen();
  }
  // @override
  // void initState() {
  //   super.initState();
  //   // Timer timer = new Timer(new Duration(seconds: 5), () {

  //   //    Navigator.of(context).pushNamed('');
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Container(
          child: Image.asset(
            'assets/pgmp4u.png',
          ),
        ),
      ),
    );
  }
}
