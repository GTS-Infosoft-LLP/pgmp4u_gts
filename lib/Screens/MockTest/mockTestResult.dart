import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pgmp4u/Models/mockTest.dart';
import 'package:intl/intl.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pgmp4u/Screens/MockTest/MockTestAttempts.dart';
import 'package:pgmp4u/Screens/MockTest/ReviewMockTest.dart';

class MockTestResult extends StatefulWidget {
  final Map resultsData;
  final mocktestId;
  final attemptData;
  final activeTime;
  MockTestResult(
      {this.resultsData, this.mocktestId, this.attemptData, this.activeTime});

  @override
  _MockTestResultState createState() => new _MockTestResultState(
      results: this.resultsData,
      mocktestIdNew: this.mocktestId,
      attemptId: this.attemptData,
      activeTimeNew: this.activeTime);
}

class _MockTestResultState extends State<MockTestResult> {
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  final results;
  final mocktestIdNew;
  final attemptId;
  final activeTimeNew;
  _MockTestResultState(
      {this.results, this.mocktestIdNew, this.attemptId, this.activeTimeNew});

  @override
  void initState() {
    super.initState();
    print(activeTimeNew);
  }

  Future<bool> _onWillPop() async {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false);
    // return (await showDialog(
    //       context: context,
    //       builder: (context) => new AlertDialog(
    //         title: new Text('Are you sure?'),
    //         content: new Text('Do you want to exit an App'),
    //         actions: <Widget>[
    //           TextButton(
    //             onPressed: () => Navigator.of(context).pop(false),
    //             child: new Text('No'),
    //           ),
    //           TextButton(
    //             onPressed: () =>
    //                 SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
    //             child: new Text('Yes'),
    //           ),
    //         ],
    //       ),
    //     )) ??
    //     false;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: Stack(
            children: [
              Container(
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
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/dashboard',
                                            (Route<dynamic> route) => false)
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
                    Expanded(
                      child: SingleChildScrollView(
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
                                            ((double.parse(results[
                                                            "percentage"]) *
                                                        100)
                                                    .toInt() <=
                                                25)
                                        ? 'assets/cross.png'
                                        : 'assets/right.png',
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 3),
                                    child: Text(
                                      ((double.parse(results["percentage"]) *
                                                      100)
                                                  .toInt() <=
                                              70)
                                          ? 'Better Luck Next Time'
                                          :((double.parse(results["percentage"]) *
                                                      100)
                                                  .toInt() <=
                                              70)
                                              ? 'Needs Improvement'
                                              : 'Your are Awesome!',
                                      style: TextStyle(
                                        fontFamily: 'Roboto Bold',
                                        fontSize: width * (19 / 420),
                                        color: ((double.parse(results[
                                                                "percentage"]) *
                                                            100)
                                                        .toInt() >=
                                                    0) &&
                                                ((double.parse(results[
                                                                "percentage"]) *
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
                                  // CircularPercentIndicator(
                                  //   radius: 60.0,
                                  //   lineWidth: 5.0,
                                  //   percent:
                                  //       (double.parse(results["percentage"])) /
                                  //           100,
                                  //   center: new Text(
                                  //     '${results["percentage"]}%',
                                  //   ),
                                  //   progressColor: Colors.green,
                                  // ),
                                  new CircularPercentIndicator(
                                    radius: 110.0,
                                    lineWidth: 10.0,
                                    percent:
                                        (double.parse(results["percentage"])) /
                                            100,
                                    center: Text(
                                      '${results["percentage"]}%',
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
                                      margin: EdgeInsets.only(
                                          top: height * (35 / 800)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                    fontSize:
                                                        width * (22 / 420),
                                                    color: _colorfromhex(
                                                        "#00C925"),
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                                Text(
                                                  'Correct',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto Bold',
                                                    fontSize:
                                                        width * (17 / 420),
                                                    color: _colorfromhex(
                                                        "#ABAFD1"),
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
                                                    fontSize:
                                                        width * (22 / 420),
                                                    color: _colorfromhex(
                                                        "#FF0000"),
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                                Text(
                                                  'Wrong',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto Bold',
                                                    fontSize:
                                                        width * (17 / 420),
                                                    color: _colorfromhex(
                                                        "#ABAFD1"),
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
                                                    fontSize:
                                                        width * (20 / 420),
                                                    color: _colorfromhex(
                                                        "#FFC107"),
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                                Text(
                                                  'Skipped',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto Bold',
                                                    fontSize:
                                                        width * (17 / 420),
                                                    color: _colorfromhex(
                                                        "#ABAFD1"),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    activeTimeNew,
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
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: width,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MockTestAttempts(
                                      selectedId: mocktestIdNew)),
                            ),
                          },
                          child: Container(
                            width: width / 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Try Again",
                                  style: TextStyle(
                                    fontSize: width * (18 / 420),
                                    fontFamily: 'Roboto Medium',
                                    color: _colorfromhex("#3A47AD"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ReviewMockTest(
                                      selectedId: mocktestIdNew,
                                      attemptData: attemptId)),
                            ),
                            //  Navigator.of(context).pushNamed('/review-mock-test'),
                            // Navigator.of(context).pushNamed('/review-mock-test',
                            //     arguments: {"screen": "result"})
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                top: height * (20 / 800),
                                bottom: height * (16 / 800)),
                            width: width / 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                              ),
                              gradient: LinearGradient(
                                  colors: [
                                    _colorfromhex("#3A47AD"),
                                    _colorfromhex("#5163F3"),
                                  ],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  end: const FractionalOffset(1.0, 0.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Review Answers",
                                  style: TextStyle(
                                    fontSize: width * (18 / 420),
                                    fontFamily: 'Roboto Medium',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
