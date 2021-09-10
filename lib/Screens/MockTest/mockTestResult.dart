import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pgmp4u/Models/mockTest.dart';
import 'package:intl/intl.dart';
import 'package:getwidget/getwidget.dart';

class MockTestResult extends StatefulWidget {
  final Map resultsData;

  MockTestResult({
    this.resultsData,
  });

  @override
  _MockTestResultState createState() =>
      new _MockTestResultState(results: this.resultsData);
}

class _MockTestResultState extends State<MockTestResult> {
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  final results;
  _MockTestResultState({this.results});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: _colorfromhex("#494AE2").withOpacity(0.04),
          child: Column(
            children: [
              Container(
                height: 149,
                width: width,
                decoration: BoxDecoration(
                  color: _colorfromhex("#FCFCFF"),
                  image: DecorationImage(
                    image: AssetImage("assets/vector1d.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.only(
                      left: width * (20 / 420),
                      right: width * (20 / 420),
                      top: height * (16 / 800)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/dashboard', (Route<dynamic> route) => false)
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: width * (24 / 420),
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Results Overview',
                            style: TextStyle(
                              fontFamily: 'Roboto Medium',
                              fontSize: width * (17 / 420),
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      margin: EdgeInsets.only(bottom: 10, top: 10),
                      padding: EdgeInsets.only(
                          top: height * (21 / 800),
                          bottom: height * (25 / 800)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            ((double.parse(results["percentage"]) * 100)
                                            .toInt() >=
                                        0) &&
                                    ((double.parse(results["percentage"]) * 100)
                                            .toInt() <=
                                        25)
                                ? 'assets/cross.png'
                                : 'assets/right.png',
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 3),
                            child: Text(
                              'Your are Awesome!',
                              style: TextStyle(
                                fontFamily: 'Roboto Bold',
                                fontSize: width * (19 / 420),
                                color: ((double.parse(results["percentage"]) *
                                                    100)
                                                .toInt() >=
                                            0) &&
                                        ((double.parse(results["percentage"]) *
                                                    100)
                                                .toInt() <=
                                            25)
                                    ? Colors.red
                                    : _colorfromhex("#04AE0B"),
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          Container(
                            width: width / 1.6,
                            margin: EdgeInsets.only(top: 3),
                            child: Text(
                              'Congratulations for getting ${results["correct"]} out of ${results["total"]} Answers Correctly',
                              style: TextStyle(
                                fontFamily: 'Roboto Medium',
                                fontSize: width * (16 / 420),
                                color: _colorfromhex("#ABAFD1"),
                                letterSpacing: 0.3,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: EdgeInsets.only(
                        top: height * (21 / 800),
                        bottom: height * (25 / 800),
                      ),
                      child: Column(
                        children: [
                          new CircularPercentIndicator(
                            radius: 110.0,
                            lineWidth: 10.0,
                            percent: double.parse(results["percentage"]),
                            center: Text(
                              '${((double.parse(results["percentage"]) * 100).toInt())}%',
                              style: TextStyle(
                                fontFamily: 'Roboto Bold',
                                fontSize: width * (20 / 420),
                                color: Colors.black,
                                letterSpacing: 0.3,
                              ),
                            ),
                            progressColor: _colorfromhex("#3846A9"),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: height * (35 / 800)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: width * (34 / 420),
                                        right: width * (24 / 420)),
                                    child: Column(
                                      children: [
                                        Text(
                                          '${results["correct"]}',
                                          style: TextStyle(
                                            fontFamily: 'Roboto Bold',
                                            fontSize: width * (22 / 420),
                                            color: _colorfromhex("#00C925"),
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        Text(
                                          'Correct',
                                          style: TextStyle(
                                            fontFamily: 'Roboto Bold',
                                            fontSize: width * (17 / 420),
                                            color: _colorfromhex("#ABAFD1"),
                                            letterSpacing: 0.3,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: width * (24 / 420),
                                        right: width * (24 / 420)),
                                    child: Column(
                                      children: [
                                        Text(
                                          '${results["wrong"]}',
                                          style: TextStyle(
                                            fontFamily: 'Roboto Bold',
                                            fontSize: width * (22 / 420),
                                            color: _colorfromhex("#FF0000"),
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        Text(
                                          'Wrong',
                                          style: TextStyle(
                                            fontFamily: 'Roboto Bold',
                                            fontSize: width * (17 / 420),
                                            color: _colorfromhex("#ABAFD1"),
                                            letterSpacing: 0.3,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: width * (24 / 420),
                                        right: width * (34 / 420)),
                                    child: Column(
                                      children: [
                                        Text(
                                          '${results["skip"]}',
                                          style: TextStyle(
                                            fontFamily: 'Roboto Bold',
                                            fontSize: width * (20 / 420),
                                            color: _colorfromhex("#FFC107"),
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        Text(
                                          'Skipped',
                                          style: TextStyle(
                                            fontFamily: 'Roboto Bold',
                                            fontSize: width * (17 / 420),
                                            color: _colorfromhex("#ABAFD1"),
                                            letterSpacing: 0.3,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.only(
                          top: width * (25 / 420),
                          bottom: width * (25 / 420),
                          left: 10,
                          right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/timer.png'),
                              Container(width: 2),
                              Text(
                                'Time Spent',
                                style: TextStyle(
                                  fontFamily: 'Roboto Medium',
                                  fontSize: width * (20 / 420),
                                  color: _colorfromhex("#171726"),
                                  letterSpacing: 0.3,
                                ),
                              )
                            ],
                          ),
                          Text(
                            '01:30',
                            style: TextStyle(
                              fontFamily: 'Roboto Bold',
                              fontSize: width * (20 / 420),
                              color: _colorfromhex("#00C925"),
                              letterSpacing: 0.3,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
