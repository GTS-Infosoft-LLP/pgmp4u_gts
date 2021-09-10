import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  Map mapResponse;
  Map dataResponse;
  String photoUrl;
  getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('photo');
    print('stringValue');
    setState(() {
      photoUrl = stringValue;
    });
  }

  @override
  void initState() {
    super.initState();
    apiCall();
    getValue();
  }

  Future apiCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    http.Response response;
    response = await http
        .get(Uri.parse("http://3.144.99.71:1010/api/UserDetails"), headers: {
      'Content-Type': 'application/json',
      'Authorization': stringValue
    });

    if (response.statusCode == 200) {
      setState(() {
        mapResponse = convert.jsonDecode(response.body);
        dataResponse = mapResponse["data"];
      });
      // print(convert.jsonDecode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        color: _colorfromhex("#FCFCFF"),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: width,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(40.0)),
                gradient: LinearGradient(
                    colors: [
                      _colorfromhex('#3846A9'),
                      _colorfromhex('#5265F8')
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: width * (20 / 420),
                        right: width * (20 / 420),
                        top: height * (16 / 800)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.menu,
                              size: width * (24 / 420),
                              color: Colors.white,
                            ),
                            Text(
                              '  Profile',
                              style: TextStyle(
                                  fontFamily: 'Roboto Medium',
                                  fontSize: width * (16 / 420),
                                  color: Colors.white,
                                  letterSpacing: 0.3),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(right: width * (16 / 420)),
                              child: Icon(
                                Icons.search,
                                size: width * (24 / 420),
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.notifications,
                              size: width * (24 / 420),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: height * (30 / 800),
                        left: width * (28 / 420),
                        right: width * (34 / 420)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 6),
                              child: Text(
                                mapResponse != null ? dataResponse["name"] : '',
                                style: TextStyle(
                                  fontFamily: 'Roboto Medium',
                                  fontSize: width * (18 / 420),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              mapResponse != null ? dataResponse["email"] : '',
                              style: TextStyle(
                                fontFamily: 'Roboto Medium',
                                fontSize: width * (12 / 420),
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        photoUrl != null
                            ? Container(
                                width: width * (80 / 420),
                                height: width * (80 / 420),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(photoUrl),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(80),
                                ),
                              )
                            : Container(
                                width: width * (80 / 420),
                                height: width * (80 / 420),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(80),
                                ),
                              )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: height * (28 / 800)),
              height: height - 255,
              width: width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: width * (150 / 420),
                          height: height * (112 / 800),
                          margin: EdgeInsets.only(right: width * (23 / 420)),
                          decoration: BoxDecoration(
                            color: _colorfromhex("#72A258"),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Mock Test',
                                style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  fontSize: width * (18 / 420),
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                height: 5,
                              ),
                              Text(
                                '00.00',
                                style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  fontSize: width * (20 / 420),
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                height: 5,
                              ),
                              Text(
                                'Average Score',
                                style: TextStyle(
                                  fontFamily: 'Roboto Medium',
                                  fontSize: width * (14 / 420),
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: width * (150 / 420),
                          height: height * (112 / 800),
                          decoration: BoxDecoration(
                            color: _colorfromhex("#463B97"),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Exam Date',
                                style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  fontSize: width * (18 / 420),
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                height: 5,
                              ),
                              Text(
                                '0',
                                style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  fontSize: width * (20 / 420),
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                height: 5,
                              ),
                              Text(
                                'Days Left',
                                style: TextStyle(
                                  fontFamily: 'Roboto Medium',
                                  fontSize: width * (14 / 420),
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: width * (50 / 800)),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => {},
                            child: Container(
                              margin: EdgeInsets.only(bottom: 6),
                              padding: EdgeInsets.only(
                                  top: 13,
                                  bottom: 13,
                                  left: width * (18 / 420),
                                  right: width * (18 / 420)),
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.home,
                                        size: width * (26 / 420),
                                        color: _colorfromhex("#ABAFD1"),
                                      ),
                                      Text(
                                        '   Question of the day',
                                        style: TextStyle(
                                          fontFamily: 'Roboto Medium',
                                          fontSize: width * (18 / 420),
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                    color: _colorfromhex("#ABAFD1"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => {},
                            child: Container(
                              margin: EdgeInsets.only(bottom: 6),
                              padding: EdgeInsets.only(
                                  top: 13,
                                  bottom: 13,
                                  left: width * (18 / 420),
                                  right: width * (18 / 420)),
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.settings,
                                        size: width * (26 / 420),
                                        color: _colorfromhex("#ABAFD1"),
                                      ),
                                      Text(
                                        '   Settings',
                                        style: TextStyle(
                                          fontFamily: 'Roboto Medium',
                                          fontSize: width * (18 / 420),
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                    color: _colorfromhex("#ABAFD1"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.clear();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/start-screen',
                                  (Route<dynamic> route) => false);
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 6),
                              padding: EdgeInsets.only(
                                  top: 13,
                                  bottom: 13,
                                  left: width * (18 / 420),
                                  right: width * (18 / 420)),
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.logout,
                                        size: width * (26 / 420),
                                        color: _colorfromhex("#ABAFD1"),
                                      ),
                                      Text(
                                        '   Log Out',
                                        style: TextStyle(
                                          fontFamily: 'Roboto Medium',
                                          fontSize: width * (18 / 420),
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                    color: _colorfromhex("#ABAFD1"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
