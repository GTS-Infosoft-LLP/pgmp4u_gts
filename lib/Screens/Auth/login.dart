import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pgmp4u/Screens/Dashboard/dashboard.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:the_apple_sign_in/scope.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

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

  bool loading = false;
  bool signInBool = false;
  Future loginHandler(user, fromProvider) async {
    print(user);
    setState(() {
      loading = true;
    });
    http.Response response;

    var request = json.encode({
      "google_id": fromProvider == "google" ? user.id : user.uid.toString(),
      "email": user.email,
      "access_type": fromProvider
    });

    print("Request Data => $request");

    response = await http.post(
      Uri.parse(GMAIL_LOGIN),
      headers: {
        "Content-Type": "application/json",
      },
      body: request,
    );

    print("Response => ${response.body}");

    if (response.statusCode == 200) {
      Map responseData = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData["token"]);
      prefs.setString('photo', fromProvider == "google" ? user.photoUrl : '');
      prefs.setString('name', user.displayName);
      GFToast.showToast(
        'LoggedIn successfully',
        context,
        toastPosition: GFToastPosition.BOTTOM,
      );
      setState(() {
        loading = false;
      });
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Dashboard(selectedId: user)));
    } else {
      GFToast.showToast(
        "Something went wrong,please try again",
        context,
        toastPosition: GFToastPosition.BOTTOM,
      );
      setState(() {
        loading = false;
      });
    }
  }

  Future registerHandler(user, fromProvider) async {
    print(user);
    http.Response response;
    setState(() {
      loading = true;
    });
    var request = json.encode({
      "google_id": fromProvider == "google" ? user.id : user.uid.toString(),
      "email": user.email,
      "name": user.displayName,
      "access_type": fromProvider
    });

    print("Request => $request");

    response = await http.post(
      Uri.parse(GMAIL_REGISTER),
      headers: {
        "Content-Type": "application/json",
      },
      body: request,
    );

    print("Response => ${response.body}");


    if (response.statusCode == 200) {
      Map responseData = json.decode(response.body);
      print(json.decode(response.body));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData["token"]);
      prefs.setString('photo', fromProvider == "google" ? user.photoUrl : '');
      prefs.setString('name', user.displayName);
      //loginHandler(user);
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => Dashboard(selectedId: user)));
      GFToast.showToast(
        'Registered successfully',
        context,
        toastPosition: GFToastPosition.BOTTOM,
      );
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Dashboard(selectedId: user)));
      setState(() {
        loading = false;
      });
    } else {
      Map responseData = json.decode(response.body);
      GFToast.showToast(
        responseData["message"],
        context,
        toastPosition: GFToastPosition.BOTTOM,
      );
      setState(() {
        loading = false;
      });
    }
  }

  Future signIn() async {
    final googleSignIn = GoogleSignIn();
    GoogleSignInAccount user;
    // final user = await GoogleSignInApi.login();
    final googleUser = await googleSignIn.signIn();

    final googleAuth = await googleUser.authentication;

    final cred = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(cred);

    if (googleUser != null) {
      if (signInBool) {
        loginHandler(googleUser, "google");
      } else {
        registerHandler(googleUser, "google");
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

  Future signInWithApple() async {
    final result = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.fullName])
    ]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        //   final appleIdCredential = result.credential;
        //   final oAuthProvider = OAuthProvider('apple.com');
        //   final credential = oAuthProvider.credential(
        //     idToken: String.fromCharCodes(appleIdCredential.identityToken),
        //     accessToken:
        //         String.fromCharCodes(appleIdCredential.authorizationCode),
        //   );
        //   final userCredential =
        //       await FirebaseAuth.instance.signInWithCredential(credential);
        //   final firebaseUser = userCredential.user;
        //   if ([ Scope.fullName].contains(Scope.fullName) ) {
        //     final fullName = appleIdCredential.fullName;
        //     if (fullName != null &&
        //         fullName.givenName != null &&
        //         fullName.familyName != null) {
        //       final displayName = '${fullName.givenName} ${fullName.familyName}';
        //       await firebaseUser.updateDisplayName(displayName);
        //     }
        //   }

        //   if (signInBool) {
        //     loginHandler(firebaseUser, "apple");
        //   }else {
        //   registerHandler(firebaseUser,"apple");
        // }

        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final firebaseUser = userCredential.user;
        if ([Scope.fullName].contains(Scope.fullName)) {
          final fullName = appleIdCredential.fullName;
          if (fullName != null &&
              fullName.givenName != null &&
              fullName.familyName != null) {
            final displayName = '${fullName.givenName} ${fullName.familyName}';
            await firebaseUser.updateDisplayName(displayName);
           
            print('firebaseUser new');
         
          }
        }

         print(firebaseUser);
             
              if (signInBool) {
                loginHandler(firebaseUser, "apple");
              } else {
                registerHandler(firebaseUser, "apple");
              }
             
        break;
      // return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
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
                    Center(child: Image.asset('assets/login_image1.png')),
                    Container(
                      padding: EdgeInsets.only(
                          top: height * (16 / 800),
                          bottom: height * (16 / 800)),
                      margin: EdgeInsets.only(
                        left: width * (36 / 420),
                        right: width * (36 / 420),
                        bottom: height * (15 / 800),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _colorfromhex('#494AE2').withOpacity(0.12),
                      ),
                      child: loading
                          ? Center(
                              child: SizedBox(
                              width: 33,
                              height: 33,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _colorfromhex("#4849DF"),
                                ),
                              ),
                            ))
                          : GestureDetector(
                              onTap: signIn,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    !signInBool
                                        ? "Sign up with Google   "
                                        : "Sign in with Google   ",
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
                    Platform.isIOS
                        ? Container(
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
                              color: Colors.black,
                            ),
                            child: loading
                                ? Center(
                                    child: SizedBox(
                                    width: 33,
                                    height: 33,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        _colorfromhex("#4849DF"),
                                      ),
                                    ),
                                  ))
                                : GestureDetector(
                                    onTap: signInWithApple,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          !signInBool
                                              ? "Sign up with Apple   "
                                              : "Sign in with Apple   ",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: width * (20 / 420),
                                            fontFamily: 'Roboto Medium',
                                          ),
                                        ),
                                        Image.asset('assets/applelogo.png'),
                                      ],
                                    ),
                                  ),
                          )
                        : Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          signInBool
                              ? "You dont have an account? "
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

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  Future signInWithApple({List<Scope> scopes = const []}) async {
    // 1. perform the sign-in request
  }
}
