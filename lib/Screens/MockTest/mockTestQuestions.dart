import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:pgmp4u/Models/mockTest.dart';

import 'package:getwidget/getwidget.dart';
import 'package:pgmp4u/Screens/MockTest/mockTestResult.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockTestQuestions extends StatefulWidget {
  final int selectedId;
  final String mockName;
  MockTestQuestions({
    this.selectedId,
    this.mockName,
  });

  @override
  _MockTestQuestionsState createState() => new _MockTestQuestionsState(
      selectedIdNew: this.selectedId, mockNameNew: this.mockName);
}

class _MockTestQuestionsState extends State<MockTestQuestions> {
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  final selectedIdNew;
  final mockNameNew;
  _MockTestQuestionsState({
    this.selectedIdNew,
    this.mockNameNew,
  });
  List submitData = [];
  bool _show = true;
  int _quetionNo = 0;
  int selectedAnswer = null;
  String stringResponse;
  List listResponse;
  Map mapResponse;
  int selectedId;
  Map currentData;
  @override
  void initState() {
    super.initState();
    print(selectedIdNew);
    print("selectedId");
    apiCall(selectedIdNew);
  }

  Future submitMockTest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    http.Response response;
    response = await http.post(
      Uri.parse('http://3.144.99.71:1010/api/SubmitMockTest'),
      headers: {
        "Content-Type": "application/json",
        'Authorization': stringValue
      },
      body: json.encode({
        "mock_test_id": selectedIdNew,
        "attempt_type": 1,
        "questons": submitData
      }),
    );

    if (response.statusCode == 200) {
      Map responseData = json.decode(response.body);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MockTestResult(resultsData: responseData["data"])),
      );
      GFToast.showToast(
        'Mock test submitted successfully',
        context,
        toastPosition: GFToastPosition.BOTTOM,
      );
      print("success");
    } else {
      print(response.body);
      GFToast.showToast(
        "Something went wrong,please submit again",
        context,
        toastPosition: GFToastPosition.BOTTOM,
      );
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Please submit the test',
              style: TextStyle(
                  fontSize: 20, fontFamily: 'Roboto Bold', color: Colors.black),
            ),
            content: new Text(''),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => {submitMockTest()},
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future apiCall(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    http.Response response;
    response = await http.get(
        Uri.parse("http://3.144.99.71:1010/api/MockTestQuestions/22"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': stringValue
        });

    if (response.statusCode == 200) {
      setState(() {
        mapResponse = convert.jsonDecode(response.body);
        listResponse = mapResponse["data"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: Container(
            color: _colorfromhex("#FCFCFF"),
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 149,
                      width: width,
                      decoration: BoxDecoration(
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
                                  onTap: () => {submitMockTest()},
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: width * (24 / 420),
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  mockNameNew,
                                  style: TextStyle(
                                      fontFamily: 'Roboto Medium',
                                      fontSize: width * (16 / 420),
                                      color: Colors.white,
                                      letterSpacing: 0.3),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    listResponse != null
                        ? Container(
                            width: width,
                            height: height - 235,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: width * (29 / 420),
                                        right: width * (29 / 420),
                                        top: height * (23 / 800),
                                        bottom: height * (23 / 800)),
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // _quetionNo != 0
                                            //     ? GestureDetector(
                                            //         onTap: () => {
                                            //           setState(() {
                                            //             _quetionNo--;

                                            //             selectedAnswer = null;
                                            //           })
                                            //         },
                                            //         child: Icon(
                                            //           Icons.arrow_back,
                                            //           size: width * (24 / 420),
                                            //           color: _colorfromhex(
                                            //               "#ABAFD1"),
                                            //         ),
                                            //       )
                                            //     : Container(),
                                            Text(
                                              'QUESTION ${_quetionNo + 1}',
                                              style: TextStyle(
                                                fontFamily: 'Roboto Regular',
                                                fontSize: width * (16 / 420),
                                                color: _colorfromhex("#ABAFD1"),
                                              ),
                                            ),
                                            // listResponse.length - 1 > _quetionNo
                                            //     ? GestureDetector(
                                            //         onTap: () => {
                                            //           setState(() {
                                            //             if (_quetionNo <
                                            //                 listResponse
                                            //                     .length) {
                                            //               _quetionNo =
                                            //                   _quetionNo + 1;
                                            //             }
                                            //             selectedAnswer = null;
                                            //           }),
                                            //           print(_quetionNo)
                                            //         },
                                            //         child: Icon(
                                            //           Icons.arrow_forward,
                                            //           size: width * (24 / 420),
                                            //           color: _colorfromhex(
                                            //               "#ABAFD1"),
                                            //         ),
                                            //       )
                                            //     : Container(),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: height * (15 / 800)),
                                          child: Text(
                                            listResponse != null
                                                ? listResponse[_quetionNo]
                                                    ["Question"]["question"]
                                                : '',
                                            style: TextStyle(
                                              fontFamily: 'Roboto Regular',
                                              fontSize: width * (15 / 420),
                                              color: Colors.black,
                                              height: 1.7,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: listResponse[_quetionNo]
                                                  ["Question"]["Options"]
                                              .map<Widget>((title) {
                                            var index = listResponse[_quetionNo]
                                                    ["Question"]["Options"]
                                                .indexOf(title);
                                            return GestureDetector(
                                              onTap: () => {
                                                setState(() {
                                                  selectedAnswer = index;
                                                  currentData = {
                                                    "question":
                                                        listResponse[_quetionNo]
                                                            ["Question"]["id"],
                                                    "answer": index,
                                                    "correct": 1,
                                                    "category":
                                                        listResponse[_quetionNo]
                                                                ["Question"]
                                                            ["category"]
                                                  };
                                                })
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: height * (21 / 800)),
                                                padding: EdgeInsets.only(
                                                  top: 13,
                                                  bottom: 13,
                                                  left: width * (13 / 420),
                                                  right: width * (11 / 420),
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    color:
                                                        selectedAnswer == index
                                                            ? _colorfromhex(
                                                                "#F2F2FF")
                                                            : Colors.white),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: width * (25 / 420),
                                                      height: width * 25 / 420,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: selectedAnswer ==
                                                                    index
                                                                ? _colorfromhex(
                                                                    "#3846A9")
                                                                : _colorfromhex(
                                                                    "#F1F1FF")),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          width * (25 / 420),
                                                        ),
                                                        color: selectedAnswer ==
                                                                index
                                                            ? _colorfromhex(
                                                                "#3846A9")
                                                            : Colors.white,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          index == 0
                                                              ? 'A'
                                                              : index == 1
                                                                  ? 'B'
                                                                  : index == 2
                                                                      ? 'C'
                                                                      : index ==
                                                                              3
                                                                          ? 'D'
                                                                          : '',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto Regular',
                                                            color: selectedAnswer ==
                                                                    index
                                                                ? Colors.white
                                                                : _colorfromhex(
                                                                    "#ABAFD1"),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                            left: 8),
                                                        width: width -
                                                            (width *
                                                                (25 / 420) *
                                                                5),
                                                        child: Text(title[
                                                            "question_option"]))
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.green))
                  ],
                ),
                listResponse != null
                    ? Positioned(
                        bottom: 0,
                        child: Container(
                          width: width,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: _quetionNo == 0
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.spaceBetween,
                            children: [
                              _quetionNo != 0
                                  ? GestureDetector(
                                      onTap: () => {
                                        setState(() {
                                          _quetionNo--;
                                          selectedAnswer = null;
                                          currentData = null;
                                        })
                                      },
                                      child: Container(
                                        width: width / 2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(right: 2),
                                              child: Icon(
                                                Icons.arrow_back_ios,
                                                size: width * (20 / 420),
                                                color: _colorfromhex("#3A47AD"),
                                              ),
                                            ),
                                            Text(
                                              "Previous",
                                              style: TextStyle(
                                                fontSize: width * (18 / 420),
                                                fontFamily: 'Roboto Medium',
                                                color: _colorfromhex("#3A47AD"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                              GestureDetector(
                                onTap: () => {
                                  if (listResponse.length - 1 > _quetionNo)
                                    {
                                      setState(() {
                                        if (_quetionNo < listResponse.length) {
                                          _quetionNo = _quetionNo + 1;
                                        }
                                        selectedAnswer = null;
                                        if (currentData != null) {
                                          submitData.add({
                                            "question": currentData["question"],
                                            "answer": currentData["answer"],
                                            "correct": 1,
                                            "category": currentData["category"]
                                          });
                                          currentData = null;
                                        }
                                      }),
                                    }
                                  else
                                    {submitMockTest()}
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
                                        listResponse.length - 1 > _quetionNo
                                            ? "Next"
                                            : "Finish",
                                        style: TextStyle(
                                          fontSize: width * (18 / 420),
                                          fontFamily: 'Roboto Medium',
                                          color: Colors.white,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 2),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: width * (20 / 420),
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
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
