import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:pgmp4u/Screens/MockTest/mockTestQuestions.dart';

class MockTest extends StatefulWidget {
  const MockTest({Key key}) : super(key: key);

  @override
  _MockTestState createState() => _MockTestState();
}

class _MockTestState extends State<MockTest> {
  List listResponse;
  Map mapResponse;
  @override
  void initState() {
    super.initState();
    apiCall();
  }

  Future apiCall() async {
    http.Response response;
    response = await http
        .get(Uri.parse("http://3.144.99.71:1010/api/AllMockTests"), headers: {
      'Content-Type': 'application/json',
      'Authorization':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjo3MiwibmFtZSI6IlZJU0hOVSBQUkFTQUQgTSIsIm1vYmlsZSI6bnVsbCwiZW1haWwiOiJ2cG0wNDNAZ21haWwuY29tIiwicGFzc3dvcmQiOm51bGwsImNyZWF0ZWQiOiIyMDE5LTA4LTIxIiwiZXhhbV9kYXRlIjpudWxsLCJwcm9maWxlX2ltYWdlIjpudWxsLCJsaW5rZWRpbiI6bnVsbCwiZ29vZ2xlIjoiMTAyNjc1Nzc1NjU0MzUxNDUwNTMxIiwicTEiOiIiLCJxMiI6IiIsInEzIjoiIiwicTQiOiIiLCJxNSI6IiIsInE2IjoiIiwiZW1haWxfc2VudCI6MCwic3RhdHVzIjoxLCJkZWxldGVTdGF0dXMiOjF9LCJpYXQiOjE2MzExOTk2NTQsImV4cCI6MTYzMjA2MzY1NH0.R49zGw-LZv44_MfYF__PyHYT-ZEJOaMpc8WNbrr-14s'
    });

    if (response.statusCode == 200) {
      setState(() {
        mapResponse = convert.jsonDecode(response.body);
        listResponse = mapResponse["data"];
      });

      print(convert.jsonDecode(response.body));

      // print(convert.jsonDecode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    Color _colorfromhex(String hexColor) {
      final hexCode = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            onTap:() {Navigator.of(context).pop();},
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: width * (24 / 420),
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '  Mock Test',
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
                      margin: EdgeInsets.only(
                          left: width * (18 / 420), right: width * (18 / 420)),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(bottom: height * (22 / 800)),
                              child: Text(
                                'Mock Tests 4U',
                                style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  fontSize: width * (18 / 420),
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                            Column(
                              children: listResponse.map<Widget>((data) {
                                return Container(
                                  padding: EdgeInsets.only(
                                    top: 12,
                                    bottom: 14,
                                    left: width * (14 / 320),
                                    right: width * (14 / 320),
                                  ),
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              padding: EdgeInsets.all(17),
                                              decoration: BoxDecoration(
                                                  color:
                                                      _colorfromhex("#72A258"),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                child: Center(
                                                  child: Text('1'),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: width * (17 / 420)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data["test_name"],
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Roboto Medium',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize:
                                                          width * (17 / 420),
                                                      color: _colorfromhex(
                                                          "171726"),
                                                      letterSpacing: 0.3,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 14),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: data[
                                                                "attempts"]
                                                            .map<Widget>(
                                                                (attemptsData) {
                                                          return Container(
                                                            width: 25,
                                                            height: 25,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 6),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: attemptsData[
                                                                          "perc"] ==
                                                                      ''
                                                                  ? Colors.white
                                                                  : _colorfromhex(
                                                                      "#E4FFE6"),
                                                              border:
                                                                  Border.all(
                                                                color: attemptsData[
                                                                            "perc"] ==
                                                                        ''
                                                                    ? Colors
                                                                        .grey
                                                                    : _colorfromhex(
                                                                        "#00BD08"),
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3.0),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                attemptsData[
                                                                            "perc"] !=
                                                                        ''
                                                                    ? ((double.parse(attemptsData["perc"]) * 100).toInt())
                                                                            .toString() +
                                                                        '%'
                                                                    : '--',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Roboto Medium',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 8,
                                                                  color: Colors
                                                                      .grey,
                                                                  letterSpacing:
                                                                      0.3,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }).toList()),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MockTestQuestions(
                                                        selectedId: data["id"],
                                                        mockName:
                                                            data["test_name"])),
                                          ),
                                          // Navigator.of(context).pushNamed(
                                          //     '/mock-test-questions',
                                          //     arguments: {'id': data["id"]})
                                        },
                                        child: Icon(
                                          Icons.east,
                                          size: 30,
                                          color: _colorfromhex("#ABAFD1"),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
