import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pgmp4u/Screens/Dashboard/dashboard.dart';
import 'package:pgmp4u/api/google_signin_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  bool signInBool = false;
  Future loginHandler(user) async {
    http.Response response;

    response = await http.post(
      Uri.parse('http://3.144.99.71:1010/api/GmailLogin'),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "google_id": user.id,
        "email": user.email,
      }),
    );

    if (response.statusCode == 200) {
      Map responseData = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData["token"]);
      prefs.setString('photo', user.photoUrl);

      GFToast.showToast(
        'LoggedIn successfully',
        context,
        toastPosition: GFToastPosition.BOTTOM,
      );

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Dashboard(selectedId: user)));
    } else {
      GFToast.showToast(
        "Something went wrong,please try again",
        context,
        toastPosition: GFToastPosition.BOTTOM,
      );
    }
  }

  Future registerHandler(user) async {
    http.Response response;

    response = await http.post(
      Uri.parse('http://3.144.99.71:1010/api/GmailRegister'),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "google_id": user.id,
        "email": user.email,
        "name": user.displayName
      }),
    );

    if (response.statusCode == 200) {
      // Map responseData = json.decode(response.body);
      print(response.body);
      GFToast.showToast(
        'Registered successfully',
        context,
        toastPosition: GFToastPosition.BOTTOM,
      );

      print("success");
    } else {
      print(response.body);
      GFToast.showToast(
        "Something went wrong,please try again",
        context,
        toastPosition: GFToastPosition.BOTTOM,
      );
    }
  }

  Future signIn() async {
    final user = await GoogleSignInApi.login();
    if (user != null) {
      if (signInBool) {
        loginHandler(user);
      } else {
        registerHandler(user);
      }

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('token', "value");
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => Dashboard(selectedId: user)));
    } else {
      GFToast.showToast(
        "Something went wrong,please try again",
        context,
        toastPosition: GFToastPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              height: height,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: height * (54 / 800), left: width * (66 / 420)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hey",
                            style: TextStyle(
                              fontSize: width * (64 / 420),
                              fontFamily: 'Roboto Bold',
                            ),
                          ),
                          Text(
                            "There .",
                            style: TextStyle(
                              fontSize: width * (64 / 420),
                              fontFamily: 'Roboto Bold',
                            ),
                          )
                        ],
                      ),
                    ),
                    Image.asset('assets/login_image1.png'),
                    Container(
                      padding: EdgeInsets.only(
                          top: height * (16 / 800),
                          bottom: height * (16 / 800)),
                      margin: EdgeInsets.only(
                        left: width * (36 / 420),
                        right: width * (36 / 420),
                        bottom: height * (24 / 800),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _colorfromhex('#494AE2').withOpacity(0.12),
                      ),
                      child: GestureDetector(
                        onTap: signIn,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              !signInBool
                                  ? "Sign up with Google   "
                                  : "Sign in with Google",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: width * (20 / 420),
                                fontFamily: 'Roboto Medium',
                              ),
                            ),
                            Image.asset('assets/google.png'),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          signInBool
                              ? "You dont have an account?"
                              : "Already have an account? ",
                          style: TextStyle(
                            color: _colorfromhex("#76767E"),
                            fontSize: width * (16 / 420),
                            fontFamily: 'Roboto Regular',
                          ),
                        ),
                        GestureDetector(
                          onTap: () => {
                            setState(() {
                              signInBool = !signInBool;
                            })
                          },
                          child: Text(
                            signInBool ? "Sign Up" : "Sign In",
                            style: TextStyle(
                              color: _colorfromhex("#494AE2"),
                              fontSize: width * (16 / 420),
                              fontFamily: 'Roboto Bold',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -30,
              left: -120,
              child: Container(
                child: Image.asset('assets/vector1.png'),
              ),
            ),
            Positioned(
              bottom: 0,
              left: -10,
              child: Container(
                height: 180,
                child: Image.asset('assets/Vector3.png'),
              ),
            ),
            Positioned(
              top: -30,
              right: -10,
              child: Container(
                height: 180,
                child: Image.asset('assets/Vector2.png'),
              ),
            ),
            Positioned(
              bottom: 35,
              right: 0,
              child: Container(
                height: 200,
                child: Image.asset('assets/Vector4.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
