import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pgmp4u/api/apis.dart';
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class TestsScreen extends StatefulWidget {
  const TestsScreen({Key key}) : super(key: key);

  @override
  _TestsScreenState createState() {
    print("TestsScreen createState");
    return _TestsScreenState();
  }
}

class _TestsScreenState extends State<TestsScreen> {
  Map mapResponse;

  @override
  void initState() {
    super.initState();
    apiCall();
    // if (selectedIdNew == "result") {
    //   apiCall2();
    // } else {
    //   apiCall();
    // }
  }

  Future apiCall() async {
    print("Build_TestScreen Api Called ${mapResponse}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print(stringValue);
    http.Response response;
    response = await http.get(Uri.parse(CHECK_USER_PAYMENT_STATUS), headers: {
      'Content-Type': 'application/json',
      'Authorization': stringValue
    });

    if (response.statusCode == 200) {
      print(convert.jsonDecode(response.body));
      setState(() {
        mapResponse = convert.jsonDecode(response.body);
      });
      // print(convert.jsonDecode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Build_TestScreen render  ${mapResponse}");
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    Color _colorfromhex(String hexColor) {
      final hexCode = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    }

    print("width => $width ; Height => $height");

    var isPremium = mapResponse != null && mapResponse.containsKey("data")
        ? mapResponse["data"]["paid_status"] == 1
        : false;
    //var isPremium = true;
    //print("mapResponse => $mapResponse; Status => ${mapResponse["data"]["paid_status"] == 1}");

    return Expanded(
      flex: 1,
      child: mapResponse != null
          ? Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: width * (18 / 420), right: width * (18 / 420)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        // Text(
                        //   'Tests4U',
                        //   style: TextStyle(
                        //       fontFamily: 'Roboto Bold',
                        //       fontSize: width * (18 / 420),
                        //       color: Colors.black,
                        //       letterSpacing: 0.3),
                        // ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.of(context).pushNamed('/practice-test'),
                          child: Container(
                            margin: EdgeInsets.only(
                                // top: height * (22 / 800),
                                bottom: height * (32 / 800)),
                            width: width,
                            padding: EdgeInsets.only(
                                top: height * (25 / 800),
                                bottom: height * (47 / 800)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: height * (12 / 800)),
                                  padding: EdgeInsets.all(width * (14 / 420)),
                                  decoration: BoxDecoration(
                                    color: _colorfromhex("#72A258"),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Image.asset('assets/Vector-2.png'),
                                ),
                                Text(
                                  'Test your Knowledge',
                                  style: TextStyle(
                                      fontFamily: 'Roboto Medium',
                                      fontSize: width * (12 / 420),
                                      color: _colorfromhex("#ABAFD1"),
                                      letterSpacing: 0.3),
                                ),
                                Container(
                                  height: height * (2 / 800),
                                ),
                                Text(
                                  'Practice Test',
                                  style: TextStyle(
                                      fontFamily: 'Roboto Medium',
                                      fontSize: width * (22 / 420),
                                      color: Colors.black,
                                      letterSpacing: 0.3),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            print("IsPremium => $isPremium");
                            if (!isPremium) {
                              Navigator.of(context).pushNamed('/mock-test');
                            } else {
                              var result = await Navigator.of(context)
                                  .pushNamed('/payment');
                              print("Result from Payment => $result");
                              apiCall();
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                top: height * (22 / 800),
                                bottom: height * (32 / 800)),
                            width: width,
                            padding: EdgeInsets.only(top: height * (25 / 800)),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: height * (12 / 800)),
                                  padding: EdgeInsets.all(width * (14 / 420)),
                                  decoration: BoxDecoration(
                                    color: _colorfromhex("#463B97"),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Image.asset('assets/Vector-3.png'),
                                ),
                                Text(
                                  'Test your Exam Readiness',
                                  style: TextStyle(
                                      fontFamily: 'Roboto Medium',
                                      fontSize: width * (12 / 420),
                                      color: _colorfromhex("#ABAFD1"),
                                      letterSpacing: 0.3),
                                ),
                                Container(
                                  height: height * (2 / 800),
                                ),
                                Text(
                                  'Mock Test',
                                  style: TextStyle(
                                      fontFamily: 'Roboto Medium',
                                      fontSize: width * (22 / 420),
                                      color: Colors.black,
                                      letterSpacing: 0.3),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    isPremium
                                        ? SizedBox()
                                        : Expanded(
                                            flex: 1,
                                            child: Text(
                                              "Premium",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                    SizedBox(
                                      width: 18,
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 18,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
              ],
            )
          : Container(
              width: width,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(_colorfromhex("#4849DF")),
                ),
              )),
    );
  }
}
