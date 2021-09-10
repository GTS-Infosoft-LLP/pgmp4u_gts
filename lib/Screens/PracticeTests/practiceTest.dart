import 'dart:io';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

class PracticeTest extends StatefulWidget {
  const PracticeTest({Key key}) : super(key: key);

  @override
  _PracticeTestState createState() => _PracticeTestState();
}

class _PracticeTestState extends State<PracticeTest> {
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  bool _show = true;
  int _quetionNo = 0;
  int selectedAnswer = null;
  String stringResponse;
  List listResponse;
  Map mapResponse;
  @override
  void initState() {
    super.initState();
    apiCall();
  }

  Future apiCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    http.Response response;
    response = await http.get(
        Uri.parse("http://3.144.99.71:1010/api/PracticeTestQuestions"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': stringValue
        });

    if (response.statusCode == 200) {
      setState(() {
        mapResponse = convert.jsonDecode(response.body);
        listResponse = mapResponse["data"];
      });
      // print(convert.jsonDecode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: _colorfromhex("#FCFCFF"),
          child: Stack(
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      height: 195,
                      width: width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/bg_layer2.png"),
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
                                  onTap: () => {Navigator.of(context).pop()},
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: width * (24 / 420),
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '  Practice Questions',
                                  style: TextStyle(
                                      fontFamily: 'Roboto Medium',
                                      fontSize: width * (18 / 420),
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
                                            _quetionNo != 0
                                                ? GestureDetector(
                                                    onTap: () => {
                                                      setState(() {
                                                        _quetionNo--;

                                                        selectedAnswer = null;
                                                      })
                                                    },
                                                    child: Icon(
                                                      Icons.arrow_back,
                                                      size: width * (24 / 420),
                                                      color: _colorfromhex(
                                                          "#ABAFD1"),
                                                    ),
                                                  )
                                                : Container(),
                                            Text(
                                              'QUESTION ${_quetionNo + 1}',
                                              style: TextStyle(
                                                fontFamily: 'Roboto Regular',
                                                fontSize: width * (16 / 420),
                                                color: _colorfromhex("#ABAFD1"),
                                              ),
                                            ),
                                            listResponse.length - 1 > _quetionNo
                                                ? GestureDetector(
                                                    onTap: () => {
                                                      setState(() {
                                                        if (_quetionNo <
                                                            listResponse
                                                                .length) {
                                                          _quetionNo =
                                                              _quetionNo + 1;
                                                        }
                                                        selectedAnswer = null;
                                                      }),
                                                      print(_quetionNo)
                                                    },
                                                    child: Icon(
                                                      Icons.arrow_forward,
                                                      size: width * (24 / 420),
                                                      color: _colorfromhex(
                                                          "#ABAFD1"),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: height * (15 / 800)),
                                          child: Text(
                                            listResponse != null
                                                ? listResponse[_quetionNo]
                                                    ["question"]
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
                                                  ["Options"]
                                              .map<Widget>((title) {
                                            var index = listResponse[_quetionNo]
                                                    ["Options"]
                                                .indexOf(title);
                                            return GestureDetector(
                                              onTap: () => {
                                                setState(() {
                                                  selectedAnswer = index;
                                                })
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: height * (21 / 800)),
                                                padding: EdgeInsets.only(
                                                    top: 13,
                                                    bottom: 13,
                                                    left: width * (13 / 420),
                                                    right: width * (11 / 420)),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: width * (25 / 420),
                                                      height: width * 25 / 420,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            width * (25 / 420),
                                                          ),
                                                          color: _colorfromhex(
                                                              "#FF0000")),
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
                                                              color:
                                                                  Colors.white),
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
                                        selectedAnswer != null
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    color: _colorfromhex(
                                                        "#FAFAFA"),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6)),
                                                margin: EdgeInsets.only(
                                                    top: height * (38 / 800)),
                                                padding: EdgeInsets.only(
                                                    top: height * (10 / 800),
                                                    bottom: _show
                                                        ? height * (23 / 800)
                                                        : height * (12 / 800),
                                                    left: width * (18 / 420),
                                                    right: width * (10 / 420)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _show = !_show;
                                                        });
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'See Solution',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto Regular',
                                                              fontSize: width *
                                                                  (15 / 420),
                                                              color:
                                                                  _colorfromhex(
                                                                      "#ABAFD1"),
                                                              height: 1.7,
                                                            ),
                                                          ),
                                                          Icon(
                                                            _show
                                                                ? Icons
                                                                    .expand_less
                                                                : Icons
                                                                    .expand_more,
                                                            size: width *
                                                                (30 / 420),
                                                            color:
                                                                _colorfromhex(
                                                                    "#ABAFD1"),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    _show
                                                        ? Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: height *
                                                                        (9 /
                                                                            800)),
                                                            child: Text(
                                                              'Answer C is the correct one',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto Regular',
                                                                fontSize: width *
                                                                    (15 / 420),
                                                                color: _colorfromhex(
                                                                    "#04AE0B"),
                                                                height: 1.7,
                                                              ),
                                                            ),
                                                          )
                                                        : Container(),
                                                    _show
                                                        ? Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: height *
                                                                        (9 /
                                                                            800)),
                                                            child: Text(
                                                              listResponse[
                                                                      _quetionNo]
                                                                  [
                                                                  "explanation"],
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto Regular',
                                                                fontSize: width *
                                                                    (15 / 420),
                                                                color: Colors
                                                                    .black,
                                                                height: 1.6,
                                                              ),
                                                            ),
                                                          )
                                                        : Container()
                                                  ],
                                                ),
                                              )
                                            : Container()
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
              ),
              Positioned(
                top: 100,
                left: width / 2.5,
                child: Image.asset('assets/smiley-sad1.png'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
