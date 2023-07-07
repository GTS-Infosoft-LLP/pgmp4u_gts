import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pgmp4u/Screens/MockTest/MockTestDetails.dart';
import 'package:pgmp4u/Screens/MockTest/mockTestQuestions.dart';
import 'package:pgmp4u/Screens/Tests/local_handler/hive_handler.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../Models/mockListmodel.dart';
import '../home_view/VideoLibrary/RandomPage.dart';

class MockTestAttempts extends StatefulWidget {
  final int selectedId;
  int startAgn;
  int attemptCnt;
  int attemptLength;

  MockTestAttempts({this.selectedId, this.startAgn, this.attemptCnt, this.attemptLength});

  @override
  _MockTestAttemptsState createState() => _MockTestAttemptsState(selectedIdNew: this.selectedId);
}

class _MockTestAttemptsState extends State<MockTestAttempts> {
  final selectedIdNew;
  MockData mockData;
  CourseProvider cp;

  _MockTestAttemptsState({
    this.selectedIdNew,
  });
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  // List<AvailableAttempts> aviAttempts = [];
  Map<String, dynamic> avaiMockData = {};

  MockDataDetails detailsofMockAttempt;

  @override
  void initState() {
    print("attemppt count=========>>..${widget.attemptCnt}");
    print("widget.attemptCnt=${widget.attemptLength}");
    super.initState();

    cp = Provider.of(context, listen: false);

    apiCall();
  }

  bool apiLoader = false;
  updateLoader(bool value) {
    apiLoader = value;
    setState(() {});
  }

  //Map responseData;
  Map mocktestDetails;
  //List listResponse;
  Future apiCall() async {
    updateLoader(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    http.Response response;
    try {
      response = await http.get(Uri.parse(MOCK_TEST + '/$selectedIdNew'),
          headers: {'Content-Type': 'application/json', 'Authorization': stringValue});

      //     .onError((error, stackTrace) {
      //   print("errorrr=====>>>$error");
      //   // HiveHandler.addMockAttempt(, selectedIdNew.toString());
      //   CourseProvider cp = Provider.of(context, listen: false);
      //   cp.aviAttempts = [];
      //   // setState(() {});
      //   updateLoader(false);
      // });
      print("Url :=> ${Uri.parse(MOCK_TEST + "/$selectedIdNew")}");
      print("header :=> ${{'Content-Type': 'application/json', 'Authorization': stringValue}}");
      print("API Response MOCK_TEST ; $stringValue => ${response.request.url}; ${response.body}");
      print("API Response ; $stringValue => ${response.request.url}; ${response.body}");

      Map getit;
      if (response.statusCode == 200) {
        print(convert.jsonDecode(response.body));

        getit = convert.jsonDecode(response.body);
        print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
        await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), selectedIdNew.toString());
        setState(() {
          print("mock data==================>>>>>>>>>>${jsonEncode(getit["data"])}");

          mockData = MockData.fromjd(getit["data"]);
        });
        updateLoader(false);
      } else {
        updateLoader(false);
      }
    } on Exception {
      updateLoader(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(bottom: 15),
          color: Colors.white,
          // _colorfromhex("#ABAFD1").withOpacity(0.13),
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
                  margin:
                      EdgeInsets.only(left: width * (20 / 420), right: width * (20 / 420), top: height * (16 / 800)),
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
                        "Mock Attempts",
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
              apiLoader
                  ? Center(child: CircularProgressIndicator.adaptive())
                  : Consumer<CourseProvider>(builder: (context, cp, child) {
                      return ValueListenableBuilder<Box<String>>(
                          valueListenable: HiveHandler.getMockTestAttemptListener(),
                          builder: (context, value, child) {
                            Map mockAttempt = {};

                            if (value.containsKey(selectedIdNew.toString())) {
                              mockAttempt = jsonDecode(value.get(selectedIdNew.toString()));
                              mockData = MockData.fromjd(jsonDecode(value.get(selectedIdNew.toString())));
                              print(">>> mockAttempt :  $mockAttempt");
                              detailsofMockAttempt = MockDataDetails.fromjson(mockAttempt["mocktest"]);
                              print(" details of MockAttempt======== $detailsofMockAttempt");

                              List attempts = mockAttempt["attempts"].toList();
                              print(" details of attempts======== $attempts");

                              cp.aviAttempts = attempts.map((e) => AvailableAttempts.fromjsons(e)).toList() ?? [];
                            } else {
                              cp.aviAttempts = [];
                            }

                            // if (v1 != null) {
                            //   var temp = jsonDecode(v1);

                            //   print("temp listtt=====$temp");
                            //   List temp2 = temp["attempts"].toList();
                            //   print("temp2==============$temp2");
                            //   cp.aviAttempts = temp2.map((e) => AvailableAttempts.fromjsons(e)).toList() ?? [];

                            //   detailsofMockAttempt = MockDataDetails.fromjson(temp["mocktest"]);
                            //   print("detailsofMockAttempt========$detailsofMockAttempt");

                            //   print("aviAttempts==========${cp.aviAttempts}");
                            //   if (cp.aviAttempts == null) {
                            //     cp.aviAttempts = [];
                            //   }
                            // } else {
                            //   cp.aviAttempts = [];
                            // }
                            // print("cp.aviAttempts=========>>>>>>${cp.aviAttempts}");

                            return cp.aviAttempts.isEmpty
                                ? Container(width: width, child: Center(child: Text("No Data Found..")))
                                : Expanded(
                                    // height: height - 150 - 65,
                                    child: SingleChildScrollView(
                                      child: Container(
                                        // color: Colors.amber,
                                        margin: EdgeInsets.only(
                                          left: width * (20 / 420),
                                          right: width * (10 / 420),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              detailsofMockAttempt.test_name,

                                              // mockData.detailsofMock.test_name ?? "",
                                              //responseData["test_name"],
                                              style: TextStyle(
                                                  fontFamily: 'Roboto Bold',
                                                  fontSize: width * (20 / 420),
                                                  color: Colors.black,
                                                  letterSpacing: 0.3),
                                            ),
                                            Container(
                                              // color: Colors.amber,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: cp.aviAttempts.map<Widget>((title) {
                                                  var index = cp.aviAttempts.indexOf(title);
                                                  return InkWell(
                                                    onTap: () {
                                                      {
                                                        if (cp.selectedMokAtmptCnt < widget.attemptLength) {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => MockTestQuestions(
                                                                    selectedId: selectedIdNew,
                                                                    mockName: detailsofMockAttempt.test_name,
                                                                    // responseData[
                                                                    //     "test_name"],
                                                                    attempt: cp.selectedMokAtmptCnt),
                                                              ));
                                                        } else {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => MockTestDetails(
                                                                  selectedId: selectedIdNew,
                                                                  attempt: index + 1,
                                                                ),
                                                              ));
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                        margin: EdgeInsets.only(top: 20),
                                                        color: Colors.white,
                                                        padding:
                                                            EdgeInsets.only(left: 14, right: 8, top: 15, bottom: 15),
                                                        child: Column(children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    width: 60,
                                                                    height: 60,
                                                                    padding: EdgeInsets.all(17),
                                                                    decoration: BoxDecoration(
                                                                        color: _colorfromhex("#72A258"),
                                                                        borderRadius: BorderRadius.circular(10)),
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.white,
                                                                        borderRadius: BorderRadius.circular(100),
                                                                      ),
                                                                      child: Center(
                                                                        child: Text('${index + 1}'),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.only(left: 20),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          cp.aviAttempts[index].attempted_date == null
                                                                              ? 'Attempt ${cp.selectedMokAtmptCnt + 1}'
                                                                              : "Attemped",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Roboto Medium',
                                                                              fontSize: width * (18 / 420),
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w600,
                                                                              letterSpacing: 0.3),
                                                                        ),
                                                                        Text(
                                                                          // title.attempted_date ==null
                                                                          cp.selectedMokAtmptCnt < widget.attemptLength
                                                                              ? '--/--'
                                                                              : 'Result ${((double.parse(title.percentage.toString())).toInt())}%',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Roboto Regular',
                                                                              fontSize: width * (18 / 420),
                                                                              color: _colorfromhex("#ABAFD1"),
                                                                              letterSpacing: 0.3),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                children: [
                                                                  Container(
                                                                    height: 40,
                                                                    decoration: BoxDecoration(
                                                                        color: _colorfromhex("#3A47AD"),
                                                                        borderRadius: BorderRadius.circular(30.0)),
                                                                    child: OutlinedButton(
                                                                      onPressed: null,
                                                                      style: ButtonStyle(
                                                                        shape: MaterialStateProperty.all(
                                                                            RoundedRectangleBorder(
                                                                                borderRadius:
                                                                                    BorderRadius.circular(30.0))),
                                                                      ),
                                                                      child: GestureDetector(
                                                                        onTap: () => {
                                                                          {
                                                                            if (cp.selectedMokAtmptCnt <
                                                                                widget.attemptLength)
                                                                              {
                                                                                Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                      builder: (context) =>
                                                                                          MockTestQuestions(
                                                                                              selectedId: selectedIdNew,
                                                                                              mockName:
                                                                                                  detailsofMockAttempt
                                                                                                      .test_name,
                                                                                              // responseData[
                                                                                              //     "test_name"],
                                                                                              attempt: cp
                                                                                                  .selectedMokAtmptCnt),
                                                                                    )),
                                                                              }
                                                                            else
                                                                              {
                                                                                Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                      builder: (context) =>
                                                                                          MockTestDetails(
                                                                                        selectedId: selectedIdNew,
                                                                                        attempt: index + 1,
                                                                                      ),
                                                                                    )),
                                                                              }
                                                                          }
                                                                        },
                                                                        child: Text(
                                                                          // title.attempted_date  == null
                                                                          cp.aviAttempts[index].attempted_date == null
                                                                              // widget.attemptCnt < 5

                                                                              ? '     Start     '
                                                                              : "More Details",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Roboto Regular',
                                                                              fontSize: 13,
                                                                              color: Colors.white,
                                                                              letterSpacing: 0.3),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => RandomPage(
                                                                                    index: 3,
                                                                                    price: detailsofMockAttempt.price
                                                                                        .toString(),
                                                                                  )));
                                                                    },
                                                                    child: Text(
                                                                        detailsofMockAttempt.premium == 1 ? "" : ""),
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          // title.attempted_date == null
                                                          cp.selectedMokAtmptCnt < widget.attemptLength
                                                              ? Container(
                                                                  margin: EdgeInsets.only(top: 20),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        (mockData.attemptList[index].attempted_date !=
                                                                                    null &&
                                                                                mockData.attemptList[index]
                                                                                    .attempted_date.isNotEmpty)
                                                                            ? 'Date of Attempt: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(mockData.attemptList[index].attempted_date))}'
                                                                            : "",
                                                                        style: TextStyle(
                                                                            fontFamily: 'Roboto Regular',
                                                                            fontSize: width * (15 / 420),
                                                                            color: Colors.black,
                                                                            letterSpacing: 0.3),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Image.asset('assets/timer.png'),
                                                                          Container(width: 2),
                                                                          Text(
                                                                            title.start_date ?? "",
                                                                            style: TextStyle(
                                                                                fontFamily: 'Roboto Regular',
                                                                                fontSize: width * (15 / 420),
                                                                                color: Colors.black,
                                                                                letterSpacing: 0.3),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : Container(),
                                                          // title.attempted_date == null

                                                          cp.selectedMokAtmptCnt < widget.attemptLength
                                                              ? Container()
                                                              : Container(
                                                                  margin: EdgeInsets.only(top: 25),
                                                                  padding: EdgeInsets.only(
                                                                      left: width * (10 / 420),
                                                                      right: width * (10 / 420)),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.only(
                                                                          right: width * (15 / 420),
                                                                        ),
                                                                        child: Column(
                                                                          children: [
                                                                            Text(
                                                                              title.total_qns.toString(),
                                                                              style: TextStyle(
                                                                                  fontFamily: 'Roboto Bold',
                                                                                  fontSize: width * (20 / 420),
                                                                                  color: Colors.black,
                                                                                  letterSpacing: 0.3),
                                                                            ),
                                                                            Text(
                                                                              'Total',
                                                                              style: TextStyle(
                                                                                  fontFamily: 'Roboto Regular',
                                                                                  fontSize: width * (18 / 420),
                                                                                  color: _colorfromhex("#ABAFD1"),
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
                                                                              title.correct.toString(),
                                                                              style: TextStyle(
                                                                                  fontFamily: 'Roboto Bold',
                                                                                  fontSize: width * (20 / 420),
                                                                                  color: Colors.black,
                                                                                  letterSpacing: 0.3),
                                                                            ),
                                                                            Text(
                                                                              'Right',
                                                                              style: TextStyle(
                                                                                  fontFamily: 'Roboto Regular',
                                                                                  fontSize: width * (18 / 420),
                                                                                  color: _colorfromhex("#ABAFD1"),
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
                                                                              title.wrong.toString(),
                                                                              style: TextStyle(
                                                                                  fontFamily: 'Roboto Bold',
                                                                                  fontSize: width * (20 / 420),
                                                                                  color: Colors.black,
                                                                                  letterSpacing: 0.3),
                                                                            ),
                                                                            Text(
                                                                              'Wrong',
                                                                              style: TextStyle(
                                                                                  fontFamily: 'Roboto Regular',
                                                                                  fontSize: width * (18 / 420),
                                                                                  color: _colorfromhex("#ABAFD1"),
                                                                                  letterSpacing: 0.3),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child: Column(
                                                                          children: [
                                                                            Text(
                                                                              title.notanswered.toString(),
                                                                              style: TextStyle(
                                                                                  fontFamily: 'Roboto Bold',
                                                                                  fontSize: width * (20 / 420),
                                                                                  color: Colors.black,
                                                                                  letterSpacing: 0.3),
                                                                            ),
                                                                            Text(
                                                                              'Skipped',
                                                                              style: TextStyle(
                                                                                  fontFamily: 'Roboto Regular',
                                                                                  fontSize: width * (18 / 420),
                                                                                  color: _colorfromhex("#ABAFD1"),
                                                                                  letterSpacing: 0.3),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                        ])),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                          });
                    })
            ],
          ),
        ),
      ),
    );
  }
}
