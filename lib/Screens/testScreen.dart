import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:provider/provider.dart';

import 'MockTest/MockTestAttempts.dart';
import 'MockTest/model/testDetails.dart';
import 'Tests/local_handler/hive_handler.dart';

class TextPreDetail extends StatefulWidget {
  const TextPreDetail({Key key}) : super(key: key);

  @override
  State<TextPreDetail> createState() => _TextPreDetailState();
}

class _TextPreDetailState extends State<TextPreDetail> {
  @override
  var attemptNum;

  List<TestDetails> testPercent = [];

  void initState() {
    CourseProvider cp = Provider.of(context, listen: false);

    super.initState();
  }

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
                margin: EdgeInsets.only(left: width * (20 / 420), right: width * (20 / 420), top: height * (16 / 800)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<CourseProvider>(builder: (context, cp, child) {
                      return Row(
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
                            cp.selectedCourseName,
                            style: TextStyle(
                                fontFamily: 'Roboto Medium',
                                fontSize: width * (20 / 420),
                                color: Colors.white,
                                letterSpacing: 0.3),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
            Container(
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
                          'Mock Test',
                          style: TextStyle(
                            fontFamily: 'Roboto Bold',
                            fontSize: width * (18 / 420),
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                          valueListenable: HiveHandler.getMockPercentListener(),
                          builder: (context, value, child) {
                            CourseProvider courseProv = Provider.of(context, listen: false);
                            var v1 = value.get(courseProv.selectedMockPercentId.toString());
                            print("value of v1111======>>>>>>>>>$v1");

                            if (v1 != null) {
                              List temp = jsonDecode(v1);

                              testPercent = temp.map((e) => TestDetails.fromjson(e)).toList();
                              print("testPercent===========$testPercent");
                            } else {
                              testPercent = [];
                            }

                            return Consumer<CourseProvider>(builder: (context, courseprovider, child) {
                              return testPercent.isEmpty
                                  ? Center(
                                      child: Container(
                                      child: Text("No Data Found..."),
                                    ))
                                  : Container(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: testPercent.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () async {
                                              var startval;

                                              if (testPercent[index].numAttemptes ==
                                                  testPercent[index].attempts.length) {
                                                startval = 0;
                                              } else {
                                                startval = 1;
                                              }

                                              CourseProvider courseProvider = Provider.of(context, listen: false);
                                              // print("selectedIdNew======>> $selectedIdNew");
                                              await Hive.openBox("MockAttemptsBox");
                                              courseProvider.apiCall(testPercent[index].id);

                                              Future.delayed(const Duration(milliseconds: 400), () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => MockTestAttempts(
                                                            selectedId: testPercent[index].id,
                                                            startAgn: startval,
                                                            attemptCnt: testPercent[index].noOfattempts)));
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                              child: Container(
                                                padding: EdgeInsets.only(
                                                  top: 12,
                                                  bottom: 12,
                                                  // left: width * (14 / 320),
                                                  right: width * (14 / 320),
                                                ),
                                                decoration: const BoxDecoration(
                                                    // color: Colors.amber,
                                                    border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 0.0),
                                                            child: Container(
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
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(left: width * (17 / 420)),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  testPercent[index].testName,
                                                                  style: TextStyle(
                                                                    fontFamily: 'Roboto Medium',
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: width * (17 / 420),
                                                                    color: _colorfromhex("171726"),
                                                                    letterSpacing: 0.3,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Container(
                                                                  width: MediaQuery.of(context).size.width * .5,
                                                                  height: 25,
                                                                  child: ListView.builder(
                                                                      shrinkWrap: true,
                                                                      itemCount: testPercent[index].attempts.length,
                                                                      scrollDirection: Axis.horizontal,
                                                                      itemBuilder: (context, inx) {
                                                                        return Container(
                                                                          width: 25,
                                                                          height: 25,
                                                                          margin: EdgeInsets.only(right: 6),
                                                                          decoration: BoxDecoration(
                                                                            color: testPercent[index] //testPercent
                                                                                        .attempts[inx]
                                                                                        .perc ==
                                                                                    ''
                                                                                ? Colors.white
                                                                                : (((double.parse(testPercent[index].attempts[inx].perc)).toInt()) >=
                                                                                            0 &&
                                                                                        ((double.parse(testPercent[index].attempts[inx].perc))
                                                                                                .toInt()) <=
                                                                                            25)
                                                                                    ? _colorfromhex("#FFECEC")
                                                                                    : (((double.parse(testPercent[index]
                                                                                                        .attempts[inx]
                                                                                                        .perc))
                                                                                                    .toInt()) >=
                                                                                                26 &&
                                                                                            ((double.parse(testPercent[index]
                                                                                                        .attempts[inx]
                                                                                                        .perc))
                                                                                                    .toInt()) <=
                                                                                                50)
                                                                                        ? _colorfromhex("#FFFAEB")
                                                                                        : (((double.parse(testPercent[index].attempts[inx].perc))
                                                                                                        .toInt()) >=
                                                                                                    51 &&
                                                                                                ((double.parse(testPercent[index].attempts[inx].perc))
                                                                                                        .toInt()) <=
                                                                                                    75)
                                                                                            ? _colorfromhex("#FFEFDC")
                                                                                            : _colorfromhex("#E4FFE6"),
                                                                            border: Border.all(
                                                                              color: testPercent[index]
                                                                                          .attempts[inx]
                                                                                          .perc ==
                                                                                      ''
                                                                                  ? Colors.grey
                                                                                  : (((double.parse(testPercent[index].attempts[inx].perc))
                                                                                                  .toInt()) >=
                                                                                              0 &&
                                                                                          ((double.parse(testPercent[index].attempts[inx].perc))
                                                                                                  .toInt()) <=
                                                                                              25)
                                                                                      ? _colorfromhex("#FF0000")
                                                                                      : (((double.parse(testPercent[index].attempts[inx].perc))
                                                                                                      .toInt()) >=
                                                                                                  26 &&
                                                                                              ((double.parse(testPercent[index].attempts[inx].perc))
                                                                                                      .toInt()) <=
                                                                                                  50)
                                                                                          ? _colorfromhex("#FFD236")
                                                                                          : (((double.parse(testPercent[index].attempts[inx].perc))
                                                                                                          .toInt()) >=
                                                                                                      51 &&
                                                                                                  ((double.parse(testPercent[index].attempts[inx].perc))
                                                                                                          .toInt()) <=
                                                                                                      75)
                                                                                              ? _colorfromhex("#FE9E45")
                                                                                              : _colorfromhex("#04AE0B"),
                                                                            ),
                                                                            borderRadius: BorderRadius.circular(3.0),
                                                                          ),
                                                                          child: Center(
                                                                              child: Text(
                                                                            testPercent[index].attempts[inx].perc != ''
                                                                                ? ((double.parse(testPercent[index]
                                                                                                .attempts[inx]
                                                                                                .perc))
                                                                                            .toInt())
                                                                                        .toString() +
                                                                                    '%'
                                                                                : '--',
                                                                            style: TextStyle(
                                                                              fontFamily: 'Roboto Medium',
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 8,
                                                                              color: testPercent[index]
                                                                                          .attempts[inx]
                                                                                          .perc ==
                                                                                      ''
                                                                                  ? Colors.grey
                                                                                  : (((double.parse(testPercent[index].attempts[inx].perc))
                                                                                                  .toInt()) >=
                                                                                              0 &&
                                                                                          ((double.parse(testPercent[index].attempts[inx].perc))
                                                                                                  .toInt()) <=
                                                                                              25)
                                                                                      ? _colorfromhex("#FF0000")
                                                                                      : (((double.parse(testPercent[index].attempts[inx].perc))
                                                                                                      .toInt()) >=
                                                                                                  26 &&
                                                                                              ((double.parse(testPercent[index].attempts[inx].perc))
                                                                                                      .toInt()) <=
                                                                                                  50)
                                                                                          ? _colorfromhex("#FFD236")
                                                                                          : (((double.parse(testPercent[index].attempts[inx].perc))
                                                                                                          .toInt()) >=
                                                                                                      51 &&
                                                                                                  ((double.parse(testPercent[index].attempts[inx].perc))
                                                                                                          .toInt()) <=
                                                                                                      75)
                                                                                              ? _colorfromhex("#FE9E45")
                                                                                              : _colorfromhex("#04AE0B"),
                                                                              letterSpacing: 0.3,
                                                                            ),
                                                                          )),
                                                                        );
                                                                      }),
                                                                )
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
                                                    // Container(
                                                    //   height: 25,
                                                    //   child: ListView.builder(
                                                    //       shrinkWrap: true,
                                                    //       itemCount: courseprovider
                                                    //           .testDetails[index].attempts.length,
                                                    //       scrollDirection: Axis.horizontal,
                                                    //       itemBuilder: (context, inx) {
                                                    //         return Container(
                                                    //           width: 25,
                                                    //           height: 25,
                                                    //           margin: EdgeInsets.only(right: 6),
                                                    //           decoration: BoxDecoration(
                                                    //             color: courseprovider
                                                    //                         .testDetails[index]
                                                    //                         .attempts[inx]
                                                    //                         .perc ==
                                                    //                     ''
                                                    //                 ? Colors.white
                                                    //                 : (((double.parse(courseprovider.testDetails[index].attempts[inx].perc))
                                                    //                                 .toInt()) >=
                                                    //                             0 &&
                                                    //                         ((double.parse(courseprovider.testDetails[index].attempts[inx].perc))
                                                    //                                 .toInt()) <=
                                                    //                             25)
                                                    //                     ? _colorfromhex("#FFECEC")
                                                    //                     : (((double.parse(courseprovider.testDetails[index].attempts[inx].perc))
                                                    //                                     .toInt()) >=
                                                    //                                 26 &&
                                                    //                             ((double.parse(courseprovider.testDetails[index].attempts[inx].perc))
                                                    //                                     .toInt()) <=
                                                    //                                 50)
                                                    //                         ? _colorfromhex(
                                                    //                             "#FFFAEB")
                                                    //                         : (((double.parse(courseprovider.testDetails[index].attempts[inx].perc)).toInt()) >=
                                                    //                                     51 &&
                                                    //                                 ((double.parse(courseprovider.testDetails[index].attempts[inx].perc))
                                                    //                                         .toInt()) <=
                                                    //                                     75)
                                                    //                             ? _colorfromhex("#FFEFDC")
                                                    //                             : _colorfromhex("#E4FFE6"),
                                                    //             border: Border.all(
                                                    //               color: courseprovider
                                                    //                           .testDetails[index]
                                                    //                           .attempts[inx]
                                                    //                           .perc ==
                                                    //                       ''
                                                    //                   ? Colors.grey
                                                    //                   : (((double.parse(courseprovider.testDetails[index].attempts[inx].perc))
                                                    //                                   .toInt()) >=
                                                    //                               0 &&
                                                    //                           ((double.parse(courseprovider.testDetails[index].attempts[inx].perc))
                                                    //                                   .toInt()) <=
                                                    //                               25)
                                                    //                       ? _colorfromhex(
                                                    //                           "#FF0000")
                                                    //                       : (((double.parse(courseprovider.testDetails[index].attempts[inx].perc))
                                                    //                                       .toInt()) >=
                                                    //                                   26 &&
                                                    //                               ((double.parse(courseprovider.testDetails[index].attempts[inx].perc))
                                                    //                                       .toInt()) <=
                                                    //                                   50)
                                                    //                           ? _colorfromhex(
                                                    //                               "#FFD236")
                                                    //                           : (((double.parse(courseprovider.testDetails[index].attempts[inx].perc)).toInt()) >=
                                                    //                                       51 &&
                                                    //                                   ((double.parse(courseprovider.testDetails[index].attempts[inx].perc)).toInt()) <=
                                                    //                                       75)
                                                    //                               ? _colorfromhex("#FE9E45")
                                                    //                               : _colorfromhex("#04AE0B"),
                                                    //             ),
                                                    //             borderRadius:
                                                    //                 BorderRadius.circular(3.0),
                                                    //           ),
                                                    //           child: Center(
                                                    //               child: Text(courseprovider
                                                    //                   .testDetails[index]
                                                    //                   .attempts[inx]
                                                    //                   .perc)),
                                                    //         );
                                                    //       }),
                                                    // )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                            });
                          })
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
