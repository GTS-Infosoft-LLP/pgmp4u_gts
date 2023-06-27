import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:pgmp4u/Screens/Tests/provider/category_provider.dart';
import 'package:pgmp4u/Screens/testScreen.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/mocktestmodel.dart';
import '../../provider/courseProvider.dart';
import '../PracticeTests/practiceNew.dart';

class MockTest extends StatefulWidget {
  String testName;
  MockTest({Key key, this.testName}) : super(key: key);

  @override
  _MockTestState createState() => _MockTestState();
}

class _MockTestState extends State<MockTest> {
  MockTestModel mockTextList;
  List listResponse;
  Map mapResponse;
  CategoryProvider categoryProvider;
  @override
  void initState() {
    categoryProvider = Provider.of(context, listen: false);
    super.initState();

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
                          Text(
                            widget.testName,
                            style: TextStyle(
                                fontFamily: 'Roboto Medium',
                                fontSize: width * (20 / 420),
                                color: Colors.transparent,
                                letterSpacing: 0.3),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
                            '${widget.testName}s 4U',
                            style: TextStyle(
                              fontFamily: 'Roboto Bold',
                              fontSize: width * (18 / 420),
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        Consumer<CourseProvider>(builder: (context, courseProvider, child) {
                          return courseProvider.testData.isEmpty
                              ? Container(
                                  height: 200,
                                  child: Center(
                                      child: Text(
                                    "No Data Found",
                                    style: TextStyle(fontSize: 14),
                                  )))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: courseProvider.testData.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        if (widget.testName == "Mock Test") {
                                          courseProvider.getTestDetails(courseProvider.testData[index].id);

                                          Future.delayed(Duration(milliseconds: 500), () {
                                            Navigator.push(
                                                context, MaterialPageRoute(builder: (context) => TextPreDetail()));
                                          });
                                        } else {
                                          // courseProvider.

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
                                                          selectedId: courseProvider.testData[index].id,
                                                        )));

                                            //PracticeNew
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          top: 12,
                                          bottom: 14,
                                          left: width * (14 / 320),
                                          right: width * (14 / 320),
                                        ),
                                        decoration: const BoxDecoration(
                                            border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
                                        // color: Colors.green,

                                        child: Row(children: [
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
                                            margin: EdgeInsets.only(left: width * (17 / 420)),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  courseProvider.testData[index].test_name,
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto Medium',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: width * (17 / 420),
                                                    color: _colorfromhex("171726"),
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          new Spacer(),
                                          Container(
                                            child: Icon(
                                              Icons.east,
                                              size: 30,
                                              color: _colorfromhex("#ABAFD1"),
                                            ),
                                          )
                                        ]),
                                      ),
                                    );
                                  });
                        })
                      ],
                    ),
                  ),
                ),
              )

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
