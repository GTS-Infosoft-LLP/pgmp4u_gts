import 'package:flutter/material.dart';

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
                          top: height * (16 / 800), bottom: height * (16 / 800)),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Sign up with Google   ",
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
                          "Already have an account? ",
                          style: TextStyle(
                            color: _colorfromhex("#76767E"),
                            fontSize: width * (14 / 420),
                            fontFamily: 'Roboto Regular',
                          ),
                        ),
                        GestureDetector(
                          onTap: () => {
                            Navigator.of(context)
                                .pushNamed('/dashboard', arguments: {})
                          },
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                              color: _colorfromhex("#494AE2"),
                              fontSize: width * (14 / 420),
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
