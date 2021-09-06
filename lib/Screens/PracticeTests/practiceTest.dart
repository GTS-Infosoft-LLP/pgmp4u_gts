import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  String stringResponse;

  @override
  void initState() {
    super.initState();

    apiCall();
  }

  Future apiCall() async {
        print("data");
    http.Response response;
    response = await http.get(Uri.parse("http://3.144.99.71:1010/api/PracticeTestQuestions"),headers: {'Content-Type': 'application/json','Authorization':'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjo4NjgsIm5hbWUiOiJ2ZW5rYXQiLCJtb2JpbGUiOm51bGwsImVtYWlsIjoidmVua2F0MTExQGdtYWlsLmNvbSIsInBhc3N3b3JkIjpudWxsLCJjcmVhdGVkIjoiMjAyMS0wOC0zMCIsImV4YW1fZGF0ZSI6bnVsbCwicHJvZmlsZV9pbWFnZSI6bnVsbCwibGlua2VkaW4iOm51bGwsImdvb2dsZSI6IjIxMzQ4NDY0IiwicTEiOiIiLCJxMiI6IiIsInEzIjoiIiwicTQiOiIiLCJxNSI6IiIsInE2IjoiIiwiZW1haWxfc2VudCI6MCwic3RhdHVzIjoxLCJkZWxldGVTdGF0dXMiOjF9LCJpYXQiOjE2MzAzMjQ1MDYsImV4cCI6MTYzMTE4ODUwNn0.J3bPCa4Y2_1rqTGOL5DaPRmF32s3Ut5-OMY_R8LGbow'});
              print(response);
    if (response.statusCode == 200) {
      print(response);
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
                                  onTap: () => {apiCall()},
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
                    Container(
                      width: width,
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
                                              })
                                            },
                                            child: Icon(
                                              Icons.arrow_back,
                                              size: width * (24 / 420),
                                              color: _colorfromhex("#ABAFD1"),
                                            ),
                                          )
                                        : Container(),
                                    Text(
                                      'QUESTION $_quetionNo',
                                      style: TextStyle(
                                        fontFamily: 'Roboto Regular',
                                        fontSize: width * (16 / 420),
                                        color: _colorfromhex("#ABAFD1"),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => {
                                        setState(() {
                                          _quetionNo = _quetionNo + 1;
                                        })
                                      },
                                      child: Icon(
                                        Icons.arrow_forward,
                                        size: width * (24 / 420),
                                        color: _colorfromhex("#ABAFD1"),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: height * (15 / 800)),
                                  child: Text(
                                    'Most of the projects in your program have reached the closing stage. What is the order of process you will follow to close your Program & the projects within the Program?',
                                    style: TextStyle(
                                      fontFamily: 'Roboto Regular',
                                      fontSize: width * (15 / 420),
                                      color: Colors.black,
                                      height: 1.7,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: _colorfromhex("#FAFAFA"),
                                      borderRadius: BorderRadius.circular(6)),
                                  margin:
                                      EdgeInsets.only(top: height * (38 / 800)),
                                  padding: EdgeInsets.only(
                                      top: height * (10 / 800),
                                      bottom: _show
                                          ? height * (23 / 800)
                                          : height * (12 / 800),
                                      left: width * (18 / 420),
                                      right: width * (10 / 420)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _show = !_show;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'See Solution',
                                              style: TextStyle(
                                                fontFamily: 'Roboto Regular',
                                                fontSize: width * (15 / 420),
                                                color: _colorfromhex("#ABAFD1"),
                                                height: 1.7,
                                              ),
                                            ),
                                            Icon(
                                              _show
                                                  ? Icons.expand_less
                                                  : Icons.expand_more,
                                              size: width * (30 / 420),
                                              color: _colorfromhex("#ABAFD1"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      _show
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  top: height * (9 / 800)),
                                              child: Text(
                                                'Answer C is the correct one',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto Regular',
                                                  fontSize: width * (15 / 420),
                                                  color: _colorfromhex("#04AE0B"),
                                                  height: 1.7,
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      _show
                                          ? Container(
                                              margin: EdgeInsets.only(
                                                  top: height * (9 / 800)),
                                              child: Text(
                                                'To check whether we are developing the right product according to the customer requirements are not. It is a static process',
                                                style: TextStyle(
                                                  fontFamily: 'Roboto Regular',
                                                  fontSize: width * (15 / 420),
                                                  color: Colors.black,
                                                  height: 1.6,
                                                ),
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
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
