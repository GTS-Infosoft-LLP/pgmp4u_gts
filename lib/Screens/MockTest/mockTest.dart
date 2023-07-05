import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:pgmp4u/Screens/Tests/provider/category_provider.dart';
import 'package:pgmp4u/Screens/testScreen.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/mocktestmodel.dart';
import '../../provider/courseProvider.dart';
import '../../utils/app_color.dart';
import '../PracticeTests/practiceNew.dart';
import '../PracticeTests/practiceTextProvider.dart';
import '../Tests/local_handler/hive_handler.dart';
import '../home_view/VideoLibrary/RandomPage.dart';
import 'model/testDataModel.dart';

class MockTest extends StatefulWidget {
  String testName;
  String testType;
  MockTest({Key key, this.testName, this.testType}) : super(key: key);

  @override
  _MockTestState createState() => _MockTestState();
}

class _MockTestState extends State<MockTest> {
  MockTestModel mockTextList;
  List listResponse;
  Map mapResponse;
  CategoryProvider categoryProvider;

  List<TestDataDetails> tempList = [];
  var sucval;
  @override
  void initState() {
    sucval = true;
    print("in this screeen nnnnn====");
    print("testtyesppppp=====${widget.testType}");
    categoryProvider = Provider.of(context, listen: false);
    super.initState();

    CourseProvider cp = Provider.of(context, listen: false);

    if (tempList.isEmpty) {
      tempList = HiveHandler.getTestDataList(key: cp.selectedMasterId.toString());
      print("*************************************************");

      print("tempList==========$tempList");
    }

    print("widget name====>${widget.testName}");

    // apiCall();
  }

  Future apiCall() async {
    Map body = {"id": categoryProvider.subCategoryId, "type": categoryProvider.type};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print(stringValue);
    http.Response response;
    response = await http.post(Uri.parse(getSubCategoryDetails),
        headers: {'Content-Type': 'application/json', 'Authorization': stringValue}, body: convert.jsonEncode(body));

    print("value is ");

    if (response.statusCode == 200) {
      setState(() {
        mapResponse = convert.jsonDecode(response.body);
        if (mapResponse['status'] == 200) {
          listResponse = mapResponse["data"]['list'];
          mockTextList = MockTestModel.fromjson(mapResponse["data"]['list']);
        }
      });

      print("response body  ${convert.jsonDecode(response.body)} ");
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
              Consumer<CourseProvider>(builder: (context, cp, child) {
                return Container(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: width * (24 / 420),
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .82,
                              // color: Colors.amber,
                              child: Text(
                                cp.selectedCourseName,
                                style: TextStyle(
                                    fontFamily: 'Roboto Medium',
                                    fontSize: width * (20 / 420),
                                    color: Colors.white,
                                    letterSpacing: 0.3),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              Consumer<CourseProvider>(builder: (context, cp, child) {
                return
                    // tempList.isEmpty
                    //     ? Center(child: Container(height: 400, child: Text("No Data Found")))
                    //     :
                    Container(
                  // color: Colors.amber,
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(left: width * (18 / 420), right: width * (18 / 420)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: height * (22 / 800)),
                            child: Text(
                              '${widget.testName}',
                              style: TextStyle(
                                fontFamily: 'Roboto Bold',
                                fontSize: width * (18 / 420),
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          ValueListenableBuilder<Box<List<TestDataDetails>>>(
                              valueListenable: HiveHandler.getTestDataListener(),
                              builder: (context, value, child) {
                                CourseProvider cp = Provider.of(context, listen: false);
                                List<TestDataDetails> storedTestData = value.get(cp.selectedMasterId.toString());

                                print("storedTestData========================$storedTestData");

                                if (storedTestData == null) {
                                  storedTestData = [];
                                }

                                return Consumer<CourseProvider>(builder: (context, courseProvider, child) {
                                  return storedTestData.isEmpty
                                      ? Container(
                                          height: 200,
                                          child: Center(
                                              child: Text(
                                            "No Data Found",
                                            style: TextStyle(fontSize: 14),
                                          )))
                                      : Container(
                                          height: MediaQuery.of(context).size.height * .7,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: storedTestData.length,
                                              itemBuilder: (context, index) {
                                                print("storedTestData.length,=========${storedTestData.length}");
                                                print("${storedTestData[index].premium}");
                                                return InkWell(
                                                  onTap: () async {
                                                    await courseProvider.getTestDetails(storedTestData[index].id);

                                                    CourseProvider cp = Provider.of(context, listen: false);
                                                    sucval = await cp.valOfSuccess;
                                                    print("sucvalsakdka=======$sucval");
                                                    if (sucval == false) {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => RandomPage(
                                                                  index: 3,
                                                                  categoryId: storedTestData[index].id,
                                                                  price: storedTestData[index].price)));
                                                    }
                                                    // if (storedTestData[index].premium == 1) {
                                                    //   Navigator.push(
                                                    //       context,
                                                    //       MaterialPageRoute(
                                                    //           builder: (context) => RandomPage(
                                                    //             index: 3,
                                                    //               categoryId: storedTestData[index].id,
                                                    //               price: storedTestData[index].price)));
                                                    // }
                                                    else {
                                                      print("testData[index].id===========${storedTestData[index].id}");
                                                      if (widget.testType == "Mock Test") {
                                                        courseProvider.setMockTestPercentId(storedTestData[index].id);

                                                        // courseProvider.getTestDetails(storedTestData[index].id);

                                                        Future.delayed(Duration(milliseconds: 500), () {
                                                          Navigator.push(context,
                                                              MaterialPageRoute(builder: (context) => TextPreDetail()));
                                                        });
                                                      } else {
                                                        // courseProvider.

                                                        PracticeTextProvider pracTestProvi =
                                                            Provider.of(context, listen: false);
                                                        pracTestProvi.setSelectedPracTestId(storedTestData[index].id);

                                                        Future.delayed(const Duration(milliseconds: 400), () {
                                                          // Navigator.push(
                                                          //     context,
                                                          //     MaterialPageRoute(
                                                          //         builder: (context) =>
                                                          //             PracticeTestCopy(
                                                          //               selectedId: courseProvider
                                                          //                   .testData[index].id,
                                                          //             )));

                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) => PracticeNew(
                                                                        pracTestName: storedTestData[index].test_name,
                                                                        selectedId: storedTestData[index].id,
                                                                      )));

                                                          //PracticeNew
                                                        });
                                                      }
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                        top: 12,
                                                        bottom: 6,
                                                        // left: width * (14 / 320),
                                                        right: width * (14 / 320),
                                                      ),
                                                      decoration: const BoxDecoration(
                                                          border:
                                                              Border(bottom: BorderSide(width: 1, color: Colors.grey))),
                                                      // color: Colors.green,

                                                      child: Row(children: [
                                                        Container(
                                                          width: 60,
                                                          height: 60,
                                                          padding: EdgeInsets.all(17),
                                                          decoration: BoxDecoration(
                                                              //  index % 2 == 0 ? AppColor.purpule : AppColor.green,
                                                              color: index % 2 == 0 ? AppColor.purpule : AppColor.green,
                                                              //  _colorfromhex("#72A258"),
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
                                                          margin: EdgeInsets.only(left: width * (17 / 420)),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(context).size.width * .45,
                                                                child: Text(
                                                                  storedTestData[index].test_name,
                                                                  style: TextStyle(
                                                                    fontFamily: 'Roboto Medium',
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: width * (17 / 420),
                                                                    color: _colorfromhex("171726"),
                                                                    letterSpacing: 0.3,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        new Spacer(),
                                                        Column(
                                                          children: [
                                                            storedTestData[index].premium == 1
                                                                ? Text("Premium")
                                                                : Text(""),
                                                            Container(
                                                              child: Icon(
                                                                Icons.east,
                                                                size: 30,
                                                                color: _colorfromhex("#ABAFD1"),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ]),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        );
                                });
                              }),
                          SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              })

              // listResponse != null
              //     ? Expanded(
              //         child: SingleChildScrollView(
              //           child: Container(
              //             margin: EdgeInsets.only(
              //                 left: width * (18 / 420),
              //                 right: width * (18 / 420)),
              //             child: Column(
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Container(
              //                   margin: EdgeInsets.only(
              //                       bottom: height * (22 / 800)),
              //                   child: Text(
              //                     'Mock Tests 4U',
              //                     style: TextStyle(
              //                       fontFamily: 'Roboto Bold',
              //                       fontSize: width * (18 / 420),
              //                       color: Colors.black,
              //                       fontWeight: FontWeight.w800,
              //                       letterSpacing: 0.3,
              //                     ),
              //                   ),
              //                 ),
              //                 Column(
              //                   children:
              //                       mockTextList.mockList.map<Widget>((data) {
              //                     print("kamal  soni ${data.attempts.length}");
              //                     var index =
              //                         mockTextList.mockList.indexOf(data);
              //                     return Container(
              //                       padding: EdgeInsets.only(
              //                         top: 12,
              //                         bottom: 14,
              //                         left: width * (14 / 320),
              //                         right: width * (14 / 320),
              //                       ),
              //                       color: Colors.white,
              //                       child: Row(
              //                         mainAxisAlignment:
              //                             MainAxisAlignment.spaceBetween,
              //                         children: [
              //                           Container(
              //                             child: Row(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.start,
              //                               crossAxisAlignment:
              //                                   CrossAxisAlignment.start,
              //                               children: [
              //                                 Container(
              //                                   width: 60,
              //                                   height: 60,
              //                                   padding: EdgeInsets.all(17),
              //                                   decoration: BoxDecoration(
              //                                       color: _colorfromhex(
              //                                           "#72A258"),
              //                                       borderRadius:
              //                                           BorderRadius.circular(
              //                                               10)),
              //                                   child: Container(
              //                                     decoration: BoxDecoration(
              //                                       color: Colors.white,
              //                                       borderRadius:
              //                                           BorderRadius.circular(
              //                                               100),
              //                                     ),
              //                                     child: Center(
              //                                       child: Text('${index + 1}'),
              //                                     ),
              //                                   ),
              //                                 ),
              //                                 Container(
              //                                   margin: EdgeInsets.only(
              //                                       left: width * (17 / 420)),
              //                                   child: Column(
              //                                     mainAxisAlignment:
              //                                         MainAxisAlignment.start,
              //                                     crossAxisAlignment:
              //                                         CrossAxisAlignment.start,
              //                                     children: [
              //                                       Text(
              //                                         mockTextList
              //                                                 .mockList[index]
              //                                                 .test_name ??
              //                                             "",
              //                                         style: TextStyle(
              //                                           fontFamily:
              //                                               'Roboto Medium',
              //                                           fontWeight:
              //                                               FontWeight.w600,
              //                                           fontSize:
              //                                               width * (17 / 420),
              //                                           color: _colorfromhex(
              //                                               "171726"),
              //                                           letterSpacing: 0.3,
              //                                         ),
              //                                       ),
              //                                       Container(
              //                                         margin: EdgeInsets.only(
              //                                             top: 14),
              //                                         child: Row(
              //                                             mainAxisAlignment:
              //                                                 MainAxisAlignment
              //                                                     .start,
              //                                             crossAxisAlignment:
              //                                                 CrossAxisAlignment
              //                                                     .start,
              //                                             children: data
              //                                                 .attempts
              //                                                 .map<Widget>(
              //                                                     (attemptsData) {
              //                                               print(
              //                                                   "attemptsData.perc ${attemptsData.perc}");
              //                                               return Container(
              //                                                 width: 25,
              //                                                 height: 25,
              //                                                 margin: EdgeInsets
              //                                                     .only(
              //                                                         right: 6),
              //                                                 decoration:
              //                                                     BoxDecoration(
              //                                                   color: attemptsData
              //                                                               .perc ==
              //                                                           ''
              //                                                       ? Colors
              //                                                           .white
              //                                                       : (((double.parse(attemptsData.perc)).toInt()) >=
              //                                                                   0 &&
              //                                                               ((double.parse(attemptsData.perc)).toInt()) <=
              //                                                                   25)
              //                                                           ? _colorfromhex(
              //                                                               "#FFECEC")
              //                                                           : (((double.parse(attemptsData.perc)).toInt()) >= 26 &&
              //                                                                   ((double.parse(attemptsData.perc)).toInt()) <= 50)
              //                                                               ? _colorfromhex("#FFFAEB")
              //                                                               : (((double.parse(attemptsData.perc)).toInt()) >= 51 && ((double.parse(attemptsData.perc)).toInt()) <= 75)
              //                                                                   ? _colorfromhex("#FFEFDC")
              //                                                                   : _colorfromhex("#E4FFE6"),
              //                                                   border:
              //                                                       Border.all(
              //                                                     color: attemptsData
              //                                                                 .perc ==
              //                                                             ''
              //                                                         ? Colors
              //                                                             .grey
              //                                                         : (((double.parse(attemptsData.perc)).toInt()) >= 0 &&
              //                                                                 ((double.parse(attemptsData.perc)).toInt()) <=
              //                                                                     25)
              //                                                             ? _colorfromhex(
              //                                                                 "#FF0000")
              //                                                             : (((double.parse(attemptsData.perc)).toInt()) >= 26 && ((double.parse(attemptsData.perc)).toInt()) <= 50)
              //                                                                 ? _colorfromhex("#FFD236")
              //                                                                 : (((double.parse(attemptsData.perc)).toInt()) >= 51 && ((double.parse(attemptsData.perc)).toInt()) <= 75)
              //                                                                     ? _colorfromhex("#FE9E45")
              //                                                                     : _colorfromhex("#04AE0B"),
              //                                                   ),
              //                                                   borderRadius:
              //                                                       BorderRadius
              //                                                           .circular(
              //                                                               3.0),
              //                                                 ),
              //                                                 child: Center(
              //                                                   child: Text(
              //                                                     attemptsData.perc !=
              //                                                             ''
              //                                                         ? ((double.parse(attemptsData.perc)).toInt())
              //                                                                 .toString() +
              //                                                             '%'
              //                                                         : '--',
              //                                                     style:
              //                                                         TextStyle(
              //                                                       fontFamily:
              //                                                           'Roboto Medium',
              //                                                       fontWeight:
              //                                                           FontWeight
              //                                                               .w600,
              //                                                       fontSize: 8,
              //                                                       color: attemptsData.perc ==
              //                                                               ''
              //                                                           ? Colors
              //                                                               .grey
              //                                                           : (((double.parse(attemptsData.perc)).toInt()) >= 0 &&
              //                                                                   ((double.parse(attemptsData.perc)).toInt()) <= 25)
              //                                                               ? _colorfromhex("#FF0000")
              //                                                               : (((double.parse(attemptsData.perc)).toInt()) >= 26 && ((double.parse(attemptsData.perc)).toInt()) <= 50)
              //                                                                   ? _colorfromhex("#FFD236")
              //                                                                   : (((double.parse(attemptsData.perc)).toInt()) >= 51 && ((double.parse(attemptsData.perc)).toInt()) <= 75)
              //                                                                       ? _colorfromhex("#FE9E45")
              //                                                                       : _colorfromhex("#04AE0B"),
              //                                                       letterSpacing:
              //                                                           0.3,
              //                                                     ),
              //                                                   ),
              //                                                 ),
              //                                               );
              //                                             }).toList()),
              //                                       )
              //                                     ],
              //                                   ),
              //                                 ),
              //                               ],
              //                             ),
              //                           ),
              //                           GestureDetector(
              //                             onTap: () => {
              //                               Navigator.push(
              //                                   context,
              //                                   MaterialPageRoute(
              //                                     builder: (context) =>
              //                                         MockTestAttempts(
              //                                       selectedId: data.id,
              //                                     ),
              //                                   )),
              //                               // if (data["attempts"].length+1 < 5)
              //                               //   {
              //                               //     // Navigator.push(
              //                               //     //   context,
              //                               //     //   MaterialPageRoute(
              //                               //     //       builder: (context) =>
              //                               //     //           MockTestQuestions(
              //                               //     //               selectedId:
              //                               //     //                   data["id"],
              //                               //     //               mockName: data[
              //                               //     //                   "test_name"],
              //                               //     //               attempt: listResponse
              //                               //     //                       .length +
              //                               //     //                   1)),
              //                               //     // ),
              //                               //     Navigator.push(
              //                               //       context,
              //                               //       MaterialPageRoute(
              //                               //           builder: (context) =>
              //                               //               MockTestAttempts(
              //                               //                   selectedId:
              //                               //                       data["id"],
              //                               //                  ),)
              //                               //     ),
              //                               //   }
              //                               // else
              //                               //   {
              //                               //     GFToast.showToast(
              //                               //       "You have completed all your attempts",
              //                               //       context,
              //                               //       toastPosition:
              //                               //           GFToastPosition.BOTTOM,
              //                               //     )
              //                               //   }
              //                               // Navigator.of(context).pushNamed(
              //                               //     '/mock-test-questions',
              //                               //     arguments: {'id': data["id"]})
              //                             },
              //                             child: Icon(
              //                               Icons.east,
              //                               size: 30,
              //                               color: _colorfromhex("#ABAFD1"),
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     );
              //                   }).toList(),
              //                 )
              //               ],
              //             ),
              //           ),
              //         ),
              //       )
              //     : Container(
              //         width: width,
              //         child: Center(
              //           child: CircularProgressIndicator(
              //             valueColor: AlwaysStoppedAnimation<Color>(
              //                 _colorfromhex("#4849DF")),
              //           ),
              //         ))
            ],
          ),
        ),
      ),
    );
  }
}
