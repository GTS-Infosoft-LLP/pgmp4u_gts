import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:pgmp4u/Models/restartModel.dart';
import 'package:pgmp4u/Screens/MockTest/MockTestDetails.dart';
import 'package:pgmp4u/Screens/Tests/local_handler/hive_handler.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../Models/mockListmodel.dart';
import '../home_view/VideoLibrary/RandomPage.dart';
import 'mockTestQuestions.dart';
import 'model/testDetails.dart';

class MockTestAttempts extends StatefulWidget {
  final int selectedId;
  int startAgn;
  int attemptCnt;
  List<Attempts> attemptedPectenage;
  int attemptLength;

  MockTestAttempts({this.selectedId, this.startAgn, this.attemptCnt, this.attemptLength, this.attemptedPectenage});

  @override
  _MockTestAttemptsState createState() => _MockTestAttemptsState(selectedIdNew: this.selectedId);
}

class _MockTestAttemptsState extends State<MockTestAttempts> {
  final selectedIdNew;
  MockData mockData;
  CourseProvider cp;
  RestartModel restartModel;
  bool isNetAvailable = false;
  int percListLength;
  List<Attempts> toGetPerc = [];

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

  var body;

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
      // print("Url :=> ${Uri.parse(MOCK_TEST + "/$selectedIdNew")}");
      // print("header :=> ${{'Content-Type': 'application/json', 'Authorization': stringValue}}");
      // print("API Response MOCK_TEST ; $stringValue => ${response.request.url}; ${response.body}");
      // print("API Response ; $stringValue => ${response.request.url}; ${response.body}");

      Map getit;
      if (response.statusCode == 200) {
        getit = convert.jsonDecode(response.body);
        print("mock data==================>>>>>>attempt screen ${jsonEncode(getit["data"])}");
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

  navigateToMockTest(int index, RestartModel restartModel) async {
    cp.setSelectedAttemptNumer(cp.aviAttempts[index].attempt);
    print("cp.aviAttempts[index]======${cp.aviAttempts[index].attempted_date}");
    print("cp.aviAttempts[index]======${cp.aviAttempts[index].tobeAttempted}");

    print("index:::: $index");
    print("index setPendindIndex:::: ${cp.setPendindIndex}");

    {
      print("===== cp.selectedMokAtmptCnt: ${cp.selectedMokAtmptCnt}: widget.attemptLength ${widget.attemptLength}");
      // if (cp.selectedMokAtmptCnt <
      //     widget.attemptLength)

      if (index == cp.setPendindIndex) {
      } else if (mockData.attemptList[index].attempted_date == null && mockData.attemptList[index].tobeAttempted == 1) {
        isNetAvailable = await checkInternetConn();
        print("isNetAvailable::: $isNetAvailable");

          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MockTestQuestions(
                restartModel: restartModel,
                selectedId: selectedIdNew,
                mockName: detailsofMockAttempt.test_name,
                selectedIndex: index,
                attempt: cp.selectedMokAtmptCnt,
                connStatus: isNetAvailable,
              ),
            )
            );
      }
      //  else if (cp.aviAttempts[index].attempted_date == null && cp.aviAttempts[index].tobeAttempted == 0) {
      // }
      else {
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
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(bottom: 15),
          // color: Colors.white,
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
                              // print("direct from hive boxxxx>>>>>${jsonDecode(value.get(selectedIdNew.toString()))}");
                              mockData = MockData.fromjd(jsonDecode(value.get(selectedIdNew.toString())));
                              // print("mockData. namee>>>>${mockData.detailsofMock.num_attemptes}");
                              // print("mockData.attemptList.length>>>>${mockData.attemptList.length}");

                              detailsofMockAttempt = MockDataDetails.fromjson(mockAttempt["mocktest"]);
                              // print(" details of MockAttempt======== $detailsofMockAttempt");

                              List attempts = mockAttempt["attempts"].toList();
                              // print(" details of attempts======== ${attempts.length}");

                              cp.aviAttempts = attempts.map((e) => AvailableAttempts.fromjsons(e)).toList() ?? [];
                            } else {
                              cp.aviAttempts = [];
                            }

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
                                              detailsofMockAttempt.test_name + " Attempt Summary",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto Bold',
                                                  fontSize: width * (20 / 420),
                                                  color: Colors.black,
                                                  letterSpacing: 0.3),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              // color: Colors.amber,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: cp.aviAttempts.map<Widget>((title) {
                                                  var index = cp.aviAttempts.indexOf(title);

                                                  // print("cp.aviAttempts=========${cp.aviAttempts[index].percentage}");
                                                  return InkWell(
                                                    onTap: () => navigateToMockTest(index, restartModel),
                                                    child: Card(
                                                      elevation: 1,
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.circular(15)),
                                                          margin: EdgeInsets.only(top: 10),
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
                                                                          color: Color(0xff72A258),
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
                                                                            mockData.attemptList[index]
                                                                                        .attempted_date ==
                                                                                    null
                                                                                // cp.aviAttempts[index].attempted_date == null
                                                                                ? 'Attempt ${index + 1}'
                                                                                : "Attempted",
                                                                            style: TextStyle(
                                                                                fontFamily: 'Roboto Medium',
                                                                                fontSize: width * (18 / 420),
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.w600,
                                                                                letterSpacing: 0.3),
                                                                          ),
                                                                          Text(
                                                                            title.attempted_date == null
                                                                                // cp.selectedMokAtmptCnt <
                                                                                //         widget.attemptLength
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
                                                                ValueListenableBuilder<Box<RestartModel>>(
                                                                    valueListenable:
                                                                        HiveHandler.getMockRestartListener(),
                                                                    builder: (context, value, child) {
                                                                      if (value
                                                                          .containsKey(cp.selectedMockId.toString())) {
                                                                        restartModel =
                                                                            value.get(cp.selectedMockId.toString());

                                                                        // print(
                                                                        //     "==== got Key: ${cp.selectedMockId.toString()} restartModel:displayTime ${restartModel.displayTime},quesNum ${restartModel.quesNum},restartAttempNum ${restartModel.restartAttempNum}");

                                                                        Future.delayed(Duration.zero, () {
                                                                          setState(() {});
                                                                        });
                                                                      }

                                                                      return Column(
                                                                        children: [
                                                                          Container(
                                                                            height: 40,
                                                                            decoration: BoxDecoration(
                                                                                color:
                                                                                    // cp.aviAttempts[index].attempted_date == null &&
                                                                                    mockData.attemptList[index]
                                                                                                .tobeAttempted ==
                                                                                            1
                                                                                        ? _colorfromhex("#3A47AD")
                                                                                        : cp.aviAttempts[index]
                                                                                                    .attempted_date !=
                                                                                                null
                                                                                            ? Color(0xff3F9FC9)
                                                                                            : Colors.grey,
                                                                                borderRadius:
                                                                                    BorderRadius.circular(30.0)),
                                                                            child: OutlinedButton(
                                                                              onPressed: null,
                                                                              style: ButtonStyle(
                                                                                shape: MaterialStateProperty.all(
                                                                                    RoundedRectangleBorder(
                                                                                        borderRadius:
                                                                                            BorderRadius.circular(
                                                                                                30.0))),
                                                                              ),
                                                                              child: Consumer<CourseProvider>(builder:
                                                                                  (context, courseProvider, child) {
                                                                                return GestureDetector(
                                                                                  onTap: () => navigateToMockTest(
                                                                                      index, restartModel),
                                                                                  child: Text(
                                                                                    index == cp.setPendindIndex
                                                                                        ? "Result Pending"
                                                                                        : mockData.attemptList[index]
                                                                                                    .attempted_date !=
                                                                                                null
                                                                                            ? "More Details"
                                                                                            : restartModel != null &&
                                                                                                    restartModel
                                                                                                            .restartAttempNum ==
                                                                                                        mockData
                                                                                                            .attemptList[
                                                                                                                index]
                                                                                                            .attempt
                                                                                                ? "Restart"
                                                                                                : 'Start',
                                                                                    style: TextStyle(
                                                                                        fontFamily: 'Roboto Regular',
                                                                                        fontSize: 13,
                                                                                        color: Colors.white,
                                                                                        letterSpacing: 0.3),
                                                                                  ),
                                                                                );
                                                                              }),
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
                                                                                            price: detailsofMockAttempt
                                                                                                .price
                                                                                                .toString(),
                                                                                          )));
                                                                            },
                                                                            child: Text(
                                                                                detailsofMockAttempt.premium == 1
                                                                                    ? ""
                                                                                    : ""),
                                                                          )
                                                                        ],
                                                                      );
                                                                    })
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
                                                                              : restartModel != null &&
                                                                                      restartModel.restartAttempNum ==
                                                                                          mockData.attemptList[index]
                                                                                              .attempt
                                                                                  ? 'You can re-start this now! All the best'
                                                                                  : mockData.attemptList[index]
                                                                                              .tobeAttempted ==
                                                                                          1
                                                                                      ? 'You can start this now! All the best'
                                                                                      : 'On Hold Until Previous Test Concludes ',
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
                                                    ),
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

  Future checkInternetConn() async {
    bool result = await InternetConnectionChecker().hasConnection;
    print("result while call fun $result");
    if (result == false) {
      Future.delayed(Duration(seconds: 1), () async {
        //  await EasyLoading.showToast("Internet Not Connected",toastPosition: EasyLoadingToastPosition.bottom);
      });
      return result;
    } else {}
    return result;
  }
}
