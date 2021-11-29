import 'package:flutter/material.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class MockTestDetails extends StatefulWidget {
  final int selectedId;

  final attempt;
  MockTestDetails({this.selectedId, this.attempt});

  @override
  _MockTestDetailsState createState() => _MockTestDetailsState(
      selectedIdNew: this.selectedId, attemptNew: this.attempt);
}

class _MockTestDetailsState extends State<MockTestDetails> {
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  final selectedIdNew;
  final attemptNew;

  _MockTestDetailsState({this.selectedIdNew, this.attemptNew});
  List dataList = [];

  @override
  void initState() {
    super.initState();
    apiCall();
  }

  Map responseData;
  Map mocktestDetails;
  List listResponse;
  Future apiCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    http.Response response;
    print(MOCK_TEST_DETAILS + '/' + selectedIdNew.toString() + '/' + attemptNew.toString());
    response = await http.get(
        Uri.parse(MOCK_TEST_DETAILS + '/' + selectedIdNew.toString() + '/' + attemptNew.toString()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': stringValue
        });
    Map getit;
    if (response.statusCode == 200) {
      print(convert.jsonDecode(response.body));
      getit = convert.jsonDecode(response.body);
      setState(() {
        responseData = getit["data"];
        listResponse = getit["data"]["categories"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          body: Container(
        color: _colorfromhex("#ABAFD1").withOpacity(0.13),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      'Details',
                      style: TextStyle(
                          fontFamily: 'Roboto Medium',
                          fontSize: width * (20 / 420),
                          color: Colors.white,
                          letterSpacing: 0.3),
                    ),
                  ],
                ),
              ),
            ),
            responseData != null
                ? Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(
                          left: width * (20 / 420),
                          right: width * (10 / 420),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${responseData["correct"]}/${responseData["all"]} Correct Answers ',
                              style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  fontSize: width * (20 / 420),
                                  color: Colors.black,
                                  letterSpacing: 0.3),
                            ),
                            Column(
                              children: listResponse.map<Widget>((title) {
                                return Container(
                                  margin: EdgeInsets.only(top: 20),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.only(
                                      top: 15, bottom: 15, left: 14),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                          right: width * (15 / 420),
                                        ),
                                        decoration: BoxDecoration(
                                          color: _colorfromhex("#72A258"),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: EdgeInsets.all(16),
                                        child: Image.asset(
                                            'assets/detailicon.png'),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                              bottom: height * (15 / 800),
                                            ),
                                            child: Text(
                                              title["category"],
                                              style: TextStyle(
                                                  fontFamily: 'Roboto Medium',
                                                  fontSize: width * (18 / 420),
                                                  color: Colors.black,
                                                  letterSpacing: 0.3),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                  right: width * (15 / 420),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      '${title["Tot_Ans"]}',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Roboto Bold',
                                                          fontSize: width *
                                                              (20 / 420),
                                                          color: Colors.black,
                                                          letterSpacing: 0.3),
                                                    ),
                                                    Text(
                                                      'Total',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Roboto Regular',
                                                          fontSize: width *
                                                              (18 / 420),
                                                          color: _colorfromhex(
                                                              "#ABAFD1"),
                                                          letterSpacing: 0.3),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                  right: width * (15 / 420),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      '${title["Correct_Ans"]}',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Roboto Bold',
                                                          fontSize: width *
                                                              (20 / 420),
                                                          color: Colors.black,
                                                          letterSpacing: 0.3),
                                                    ),
                                                    Text(
                                                      'Right',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Roboto Regular',
                                                          fontSize: width *
                                                              (18 / 420),
                                                          color: _colorfromhex(
                                                              "#ABAFD1"),
                                                          letterSpacing: 0.3),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                  right: width * (15 / 420),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      '${title["Wrong_Ans"]}',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Roboto Bold',
                                                          fontSize: width *
                                                              (20 / 420),
                                                          color: Colors.black,
                                                          letterSpacing: 0.3),
                                                    ),
                                                    Text(
                                                      'Wrong',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Roboto Regular',
                                                          fontSize: width *
                                                              (18 / 420),
                                                          color: _colorfromhex(
                                                              "#ABAFD1"),
                                                          letterSpacing: 0.3),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      '${title["Skip_Ans"]}',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Roboto Bold',
                                                          fontSize: width *
                                                              (20 / 420),
                                                          color: Colors.black,
                                                          letterSpacing: 0.3),
                                                    ),
                                                    Text(
                                                      'Skipped',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Roboto Regular',
                                                          fontSize: width *
                                                              (18 / 420),
                                                          color: _colorfromhex(
                                                              "#ABAFD1"),
                                                          letterSpacing: 0.3),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: width,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            _colorfromhex("#4849DF")),
                      ),
                    ))
          ],
        ),
      )),
    );
  }
}
