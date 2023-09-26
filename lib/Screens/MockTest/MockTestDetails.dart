import 'package:flutter/material.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:pgmp4u/utils/app_color.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../Models/afterAteemptModel.dart';
import 'ReviewMockTest.dart';

class MockTestDetails extends StatefulWidget {
  final int selectedId;
  int atmptCount;

  final attempt;
  MockTestDetails({this.selectedId, this.attempt, this.atmptCount});

  @override
  _MockTestDetailsState createState() =>
      _MockTestDetailsState(selectedIdNew: this.selectedId, attemptNew: this.attempt);
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
  IconData icon1;
  Color color1;
  @override
  void initState() {
    print("atmptCountatmptCountatmptCo==========${widget.attempt}");
    super.initState();
    apiCall();
  }

  List<Color> clr = [AppColor.green, AppColor.purpule];
  List<domainListModel> domainList = [];
  List<domainListModel> dList = [];

  Map responseData;
  Map mocktestDetails;
  List listResponse;
  Future apiCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    http.Response response;
    print(MOCK_TEST_DETAILS + '/' + selectedIdNew.toString() + '/' + widget.attempt.toString());
    response = await http.get(
        Uri.parse(MOCK_TEST_DETAILS + '/' + selectedIdNew.toString() + '/' + widget.attempt.toString()),
        headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
    print("authorization $stringValue");
    Map getit;
    print("response.statusCode========${response.statusCode}");
    if (response.statusCode == 200) {
      domainList = [];
      print(convert.jsonDecode(response.body));
      getit = convert.jsonDecode(response.body);
      print("getit==============================================$getit");
      setState(() {
        responseData = getit["data"];
        listResponse = getit["data"]["categories"];
        domainList = listResponse.map((e) => domainListModel.fromJson(e)).toList();
     
        print("listResponse==========$listResponse");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    dList = domainList.where((element) => element.category != null).toList();
    //  print("dList::::;${dList}");
    for (int i = 0; i < dList.length; i++) {
      print("dlisttttt${dList[i].category}");
    }
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
                margin: EdgeInsets.only(left: width * (20 / 420), right: width * (20 / 420), top: height * (16 / 800)),
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
                        child: Consumer<CourseProvider>(builder: (context, cp, child) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cp.selectedTestName,
                                style: TextStyle(
                                    fontFamily: 'Roboto Bold',
                                    fontSize: width * (20 / 420),
                                    color: Colors.black,
                                    letterSpacing: 0.3),
                              ),
                              Text(
                                "Attempt Number : ${widget.attempt}",
                                style: TextStyle(
                                    fontFamily: 'Roboto Bold',
                                    fontSize: width * (20 / 420),
                                    color: Colors.black,
                                    letterSpacing: 0.3),
                              ),
                              Text(
                                '${responseData["correct"]}/${responseData["all"]} Correct Answers ',
                                style: TextStyle(
                                    fontFamily: 'Roboto Bold',
                                    fontSize: width * (20 / 420),
                                    color: Colors.black,
                                    letterSpacing: 0.3),
                              ),

                              Container(
                                height: MediaQuery.of(context).size.height * .65,
                                child: ListView.builder(
                                    itemCount: domainList.length,
                                    itemBuilder: (context, index) {
                                      return domainList[index].category == null
                                          ? SizedBox()
                                          : Padding(
                                              padding: const EdgeInsets.only(bottom: 10.0),
                                              child: InkWell(
                                                onTap: () {
                                                  // print("category=======$category");
                                                  print("mock test count===${widget.attempt}");
                                                  print("mock id=====${widget.selectedId}");
                                                  print("domainList[index].category=====${domainList[index].category}");

                                                  CourseProvider cp = Provider.of(context, listen: false);

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => ReviewMockTest(
                                                                AttemptCount: widget.attempt,
                                                                domainName: domainList[index].category,
                                                                fromDetails: 1,
                                                                selectedId: widget.selectedId,
                                                              )));
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.only(top: 20),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      // color: Colors.amberAccent,
                                                      borderRadius: BorderRadius.circular(10)),
                                                  padding: EdgeInsets.only(top: 15, bottom: 15, left: 14),
                                                  child: Row(children: [
//  Container(
//                                                                       width: 60,
//                                                                       height: 60,
//                                                                       padding: EdgeInsets.all(17),
//                                                                       decoration: BoxDecoration(
//                                                                           color: Color(0xff72A258),
//                                                                           borderRadius: BorderRadius.circular(10)),
//                                                                       child: Container(
//                                                                         decoration: BoxDecoration(
//                                                                           color: Colors.white,
//                                                                           borderRadius: BorderRadius.circular(100),
//                                                                         ),
//                                                                         child: Center(
//                                                                           child: Text('${index + 1}'),
//                                                                         ),
//                                                                       ),
//                                                                     ),

                                                    Container(
                                                      width: 60,
                                                      // MediaQuery.of(context).size.width * .09,
                                                      height: 60,
                                                      // MediaQuery.of(context).size.height * .07,
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
                                                          child: Text(
                                                            '${index + 1}',
                                                            style: TextStyle(
                                                              fontFamily: 'Roboto Medium',
                                                              fontSize: 18,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      flex: 8,
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(context).size.width * .8,
                                                            // color: Colors.blue,
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: MediaQuery.of(context).size.width * .6,
                                                                  margin: EdgeInsets.only(
                                                                    bottom: height * (15 / 800),
                                                                  ),
                                                                  child: Text(
                                                                    domainList[index].category ?? "",
                                                                    maxLines: 3,
                                                                    style: TextStyle(
                                                                        fontFamily: 'Roboto Medium',
                                                                        fontSize: width * (18 / 420),
                                                                        color: Colors.black,
                                                                        letterSpacing: 0.3),
                                                                  ),
                                                                ),
                                                                Spacer(),
                                                                Padding(
                                                                  padding: const EdgeInsets.only(right: 5, bottom: 15),
                                                                  child: Icon(Icons.east),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets.only(
                                                                  right: width * (15 / 420),
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      domainList[index].totAns.toString(),
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
                                                                      domainList[index].correctAns.toString(),
                                                                      style: TextStyle(
                                                                          fontFamily: 'Roboto Bold',
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: width * (20 / 420),
                                                                          color: Colors.green,
                                                                          letterSpacing: 0.3),
                                                                    ),
                                                                    Text(
                                                                      'Right',
                                                                      style: TextStyle(
                                                                          fontFamily: 'Roboto Regular',
                                                                          fontSize: width * (18 / 420),
                                                                          color: Colors.green,
                                                                          fontWeight: FontWeight.w600,
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
                                                                      domainList[index].wrongAns.toString(),
                                                                      style: TextStyle(
                                                                          fontFamily: 'Roboto Bold',
                                                                          fontSize: width * (20 / 420),
                                                                          color: Colors.red,
                                                                          fontWeight: FontWeight.w600,
                                                                          letterSpacing: 0.3),
                                                                    ),
                                                                    Text(
                                                                      'Wrong',
                                                                      style: TextStyle(
                                                                          fontFamily: 'Roboto Regular',
                                                                          fontSize: width * (18 / 420),
                                                                          fontWeight: FontWeight.w600,
                                                                          color: Colors.red,
                                                                          letterSpacing: 0.3),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Column(children: [
                                                                  Text(
                                                                    domainList[index].skipAns.toString(),
                                                                    style: TextStyle(
                                                                        fontFamily: 'Roboto Bold',
                                                                        fontSize: width * (20 / 420),
                                                                        color: Colors.black,
                                                                        letterSpacing: 0.3),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(right: 14.0),
                                                                    child: Text(
                                                                      'Skipped',
                                                                      style: TextStyle(
                                                                          fontFamily: 'Roboto Regular',
                                                                          fontSize: width * (18 / 420),
                                                                          color: _colorfromhex("#ABAFD1"),
                                                                          letterSpacing: 0.3),
                                                                    ),
                                                                  ),
                                                                ]),
                                                              ),
                                                            ],
                                                          ),
                                                          // Row(
                                                          //   // mainAxisAlignment: MainAxisAlignment.end,
                                                          //   children: [Text("More Details")],
                                                          // )
                                                        ],
                                                      ),
                                                    )
                                                  ]),
                                                ),
                                              ),
                                            );
                                    }),
                              ),

                              SizedBox(
                                height: 15,
                              )

                              // Column(
                              //   children: listResponse.map<Widget>((title) {
                              //     // print("title[id]=========${title["id"]}");
                              //     String category = "";
                              //     if (title["category"] != null) {
                              //       category = title["category"];
                              //       // print("category=======>>>>????+++$category");
                              //     }
                              //     if (title['id'] == null) {
                              //       icon1 = FontAwesomeIcons.renren;
                              //       color1 = AppColor.purpule;
                              //     } else {
                              //       if (title['id'] % 5 == 0) {
                              //         icon1 = FontAwesomeIcons.book;
                              //       } else if (title['id'] % 4 == 0) {
                              //         icon1 = FontAwesomeIcons.cloud;
                              //       } else if (title['id'] % 3 == 0) {
                              //         icon1 = FontAwesomeIcons.coins;
                              //       } else if (title['id'] % 2 == 0) {
                              //         icon1 = FontAwesomeIcons.deezer;
                              //       } else {
                              //         icon1 = FontAwesomeIcons.airbnb;
                              //       }
                              //     }
                              //     if (title['id'] != null) {
                              //       if (title['id'] % 2 == 0) {
                              //         color1 = _colorfromhex("#72A258");
                              //       } else {
                              //         color1 = AppColor.purpule;
                              //       }
                              //     }

                              //     return InkWell(
                              //       onTap: () {
                              //         print("category=======$category");
                              //         print("mock test count===${widget.attempt}");
                              //         print("mock id=====${widget.selectedId}");

                              //         CourseProvider cp = Provider.of(context, listen: false);

                              //         Navigator.push(
                              //             context,
                              //             MaterialPageRoute(
                              //                 builder: (context) => ReviewMockTest(
                              //                       AttemptCount: widget.attempt,
                              //                       domainName: category,
                              //                       fromDetails: 1,
                              //                       selectedId: widget.selectedId,
                              //                     )));
                              //       },
                              //       child: Container(
                              //         margin: EdgeInsets.only(top: 20),
                              //         decoration: BoxDecoration(
                              //             color: Colors.white,
                              //             // color: Colors.amberAccent,
                              //             borderRadius: BorderRadius.circular(10)),
                              //         padding: EdgeInsets.only(top: 15, bottom: 15, left: 14),
                              //         child: Row(
                              //           children: [
                              //             Expanded(
                              //               flex: 2,
                              //               child: Container(
                              //                   margin: EdgeInsets.only(
                              //                     right: width * (15 / 420),
                              //                   ),
                              //                   decoration: BoxDecoration(
                              //                     color: color1,
                              //                     // clr[i],
                              //                     //  AppColor.purpule,
                              //                     // (
                              //                     // title["id"]) % 2 == 0
                              //                     //   ? _colorfromhex("#72A258")
                              //                     //   : AppColor.purpule,
                              //                     // color: _colorfromhex("#72A258"),
                              //                     borderRadius: BorderRadius.circular(10),
                              //                   ),
                              //                   padding: EdgeInsets.all(16),
                              //                   child: Icon(
                              //                     icon1,

                              //                     // index % 2 == 0
                              //                     //     ? FontAwesomeIcons.book
                              //                     //     : FontAwesomeIcons.airbnb,
                              //                     color: Colors.white,
                              //                   )

                              //                   //  Image.asset('assets/detailicon.png'),
                              //                   ),
                              //             ),
                              //             Expanded(
                              //               flex: 8,
                              //               child: Column(
                              //                 mainAxisAlignment: MainAxisAlignment.start,
                              //                 crossAxisAlignment: CrossAxisAlignment.start,
                              //                 children: [
                              //                   Container(
                              //                     margin: EdgeInsets.only(
                              //                       bottom: height * (15 / 800),
                              //                     ),
                              //                     child: Text(
                              //                       category,
                              //                       style: TextStyle(
                              //                           fontFamily: 'Roboto Medium',
                              //                           fontSize: width * (18 / 420),
                              //                           color: Colors.black,
                              //                           letterSpacing: 0.3),
                              //                     ),
                              //                   ),
                              //                   Row(
                              //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //                     children: [
                              //                       Container(
                              //                         margin: EdgeInsets.only(
                              //                           right: width * (15 / 420),
                              //                         ),
                              //                         child: Column(
                              //                           children: [
                              //                             Text(
                              //                               '${title["Tot_Ans"]}',
                              //                               style: TextStyle(
                              //                                   fontFamily: 'Roboto Bold',
                              //                                   fontSize: width * (20 / 420),
                              //                                   color: Colors.black,
                              //                                   letterSpacing: 0.3),
                              //                             ),
                              //                             Text(
                              //                               'Total',
                              //                               style: TextStyle(
                              //                                   fontFamily: 'Roboto Regular',
                              //                                   fontSize: width * (18 / 420),
                              //                                   color: _colorfromhex("#ABAFD1"),
                              //                                   letterSpacing: 0.3),
                              //                             ),
                              //                           ],
                              //                         ),
                              //                       ),
                              //                       Container(
                              //                         margin: EdgeInsets.only(
                              //                           right: width * (15 / 420),
                              //                         ),
                              //                         child: Column(
                              //                           children: [
                              //                             Text(
                              //                               '${title["Correct_Ans"]}',
                              //                               style: TextStyle(
                              //                                   fontFamily: 'Roboto Bold',
                              //                                   fontSize: width * (20 / 420),
                              //                                   color: Colors.black,
                              //                                   letterSpacing: 0.3),
                              //                             ),
                              //                             Text(
                              //                               'Right',
                              //                               style: TextStyle(
                              //                                   fontFamily: 'Roboto Regular',
                              //                                   fontSize: width * (18 / 420),
                              //                                   color: _colorfromhex("#ABAFD1"),
                              //                                   letterSpacing: 0.3),
                              //                             ),
                              //                           ],
                              //                         ),
                              //                       ),
                              //                       Container(
                              //                         margin: EdgeInsets.only(
                              //                           right: width * (15 / 420),
                              //                         ),
                              //                         child: Column(
                              //                           children: [
                              //                             Text(
                              //                               '${title["Wrong_Ans"]}',
                              //                               style: TextStyle(
                              //                                   fontFamily: 'Roboto Bold',
                              //                                   fontSize: width * (20 / 420),
                              //                                   color: Colors.black,
                              //                                   letterSpacing: 0.3),
                              //                             ),
                              //                             Text(
                              //                               'Wrong',
                              //                               style: TextStyle(
                              //                                   fontFamily: 'Roboto Regular',
                              //                                   fontSize: width * (18 / 420),
                              //                                   color: _colorfromhex("#ABAFD1"),
                              //                                   letterSpacing: 0.3),
                              //                             ),
                              //                           ],
                              //                         ),
                              //                       ),
                              //                       Container(
                              //                         child: Column(
                              //                           children: [
                              //                             Text(
                              //                               '${title["Skip_Ans"]}',
                              //                               style: TextStyle(
                              //                                   fontFamily: 'Roboto Bold',
                              //                                   fontSize: width * (20 / 420),
                              //                                   color: Colors.black,
                              //                                   letterSpacing: 0.3),
                              //                             ),
                              //                             Padding(
                              //                               padding: const EdgeInsets.only(right: 14.0),
                              //                               child: Text(
                              //                                 'Skipped',
                              //                                 style: TextStyle(
                              //                                     fontFamily: 'Roboto Regular',
                              //                                     fontSize: width * (18 / 420),
                              //                                     color: _colorfromhex("#ABAFD1"),
                              //                                     letterSpacing: 0.3),
                              //                               ),
                              //                             ),
                              //                           ],
                              //                         ),
                              //                       ),
                              //                     ],
                              //                   )
                              //                 ],
                              //               ),
                              //             )
                              //           ],
                              //         ),
                              //       ),
                              //     );
                              //   }).toList(),
                              // )
                            ],
                          );
                        }),
                      ),
                    ),
                  )
                : Container(
                    width: width,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(_colorfromhex("#4849DF")),
                      ),
                    ))
          ],
        ),
      )),
    );
  }
}
