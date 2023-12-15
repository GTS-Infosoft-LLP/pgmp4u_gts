import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pgmp4u/components/applSupportRow.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:pgmp4u/provider/profileProvider.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../provider/Subscription/subscriptionPage.dart';
import '../../provider/Subscription/subscriptionProvider.dart';
import '../../tool/ShapeClipper.dart';
import '../chat/screen/discussionGoupList.dart';

class ApplicationSupportPage extends StatefulWidget {
  @override
  _ApplicationSupportPageState createState() => _ApplicationSupportPageState();
}

class _ApplicationSupportPageState extends State<ApplicationSupportPage> {
  String text1 =
      "Part of this Application service you will receive the following support. These will assist to draft your application. Once your application is ready, you will send it to us for our review.";

  String appbarTxt;
  Color _darkText = Color(0xff424b53);
  Color _lightText = Color(0xff424b53);
  var currentIndex;
  int colorIndex;
  PageController pageController;
  ScrollController scrollController;

  @override
  void initState() {
    pageController = PageController();
    scrollController = ScrollController();
    colorIndex = 0;
    currentIndex = 0;
    CourseProvider cp = Provider.of(context, listen: false);
    print("p.selectedPlanType == ${cp.selectedPlanType}");
    if (cp.selectedPlanType == 0 || cp.selectedPlanType == 1 || cp.selectedPlanType == 4) {
      appbarTxt = "Silver and Free";
    } else if (cp.selectedPlanType == 2) {
      appbarTxt = "Gold";
    } else {
      appbarTxt = "Platinum";
    }

    cp.changeonTap(0);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(builder: (context, cp, child) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Stack(
              children: <Widget>[
                ClipPath(
                    clipper: ShapeClipper(),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xff5468ff), Color(0xff3643a3)]),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                              border: Border.all(color: Colors.white, width: 1)),
                          child: Center(
                              child: IconButton(
                                  icon: Icon(Icons.arrow_back, color: Colors.white),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }))),
                      SizedBox(width: 30),
                      Center(
                          child: Container(
                        width: MediaQuery.of(context).size.width * .75,
                        child: RichText(
                            // maxLines: 2,
                            // textAlign: TextAlign.left,
                            text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: "Application Support\n" + appbarTxt,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontFamily: "Raleway",

                              // height: 1.7
                              fontWeight: FontWeight.bold,
                              // letterSpacing: 0.3,
                            ),
                          ),
                        ])),
                      )),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              // color: Colors.amber,s
              height: MediaQuery.of(context).size.height * .8,
              // width: 330,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, left: 10, right: 10),
                    child: PageView.builder(
                        controller: pageController,
                        itemCount: 1,
                        onPageChanged: (index) {
                          setState(() {
                            colorIndex = index;
                            currentIndex = index;
                          });

                          if (colorIndex % 10 == 0) {
                            double maxWidth = MediaQuery.of(context).size.width - 10;
                            double eachTileWidth = MediaQuery.of(context).size.width * .08 + 4;
                            scrollController.animateTo(eachTileWidth * colorIndex,
                                curve: Curves.easeInCubic, duration: Duration(seconds: 1));
                          }
                        },
                        itemBuilder: (context, index) {
                          return index == 0
                              ? fechrList()
                              : Container(
                                  height: MediaQuery.of(context).size.height * .5,
                                  width: 200,
                                  color: index % 2 == 0 ? Colors.deepOrange : Colors.deepPurpleAccent,
                                );
                        }),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
                  //   child: Container(
                  //     margin: const EdgeInsets.only(left: 10.0),
                  //     height: 12,
                  //     child: ListView.builder(
                  //         // itemCount: 15,
                  //         controller: scrollController,
                  //         scrollDirection: Axis.horizontal,
                  //         itemBuilder: (context, index) {
                  //           return Padding(
                  //             padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  //             child: Container(
                  //               decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.all(Radius.circular(20)),
                  //                   gradient: index <= colorIndex
                  //                       ? LinearGradient(
                  //                           colors: [Color(0xff3A47AD), Color(0xff5163F3)],
                  //                           begin: const FractionalOffset(0.0, 0.0),
                  //                           end: const FractionalOffset(1.0, 0.0),
                  //                           stops: [0.0, 1.0],
                  //                           tileMode: TileMode.clamp)
                  //                       : LinearGradient(
                  //                           colors: [
                  //                             Colors.grey,
                  //                             Colors.grey,
                  //                           ],
                  //                         )),
                  //               height: 10,
                  //               width: MediaQuery.of(context).size.width * .08,
                  //             ),
                  //           );
                  //         }),
                  //   ),
                  // )
                ],
              ),
            ),
          ]),
        ),
      );
    });
  }

  Future checkInternetConn() async {
    bool result = await InternetConnectionChecker().hasConnection;
    print("result while call fun $result");
    if (result == false) {
      Future.delayed(Duration(seconds: 1), () async {});
      return result;
    } else {}
    return result;
  }

  Widget fechrList() {
    CourseProvider cp = Provider.of(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        children: [
          cp.selectedPlanType == 0 || cp.selectedPlanType == 1 || cp.selectedPlanType == 4
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Center(
                    child: RichText(
                        // maxLines: 2,
                        // textAlign: TextAlign.left,
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: "Currently, Application Support is part of only Gold and Platinum Plans",
                        style: TextStyle(
                          color: _lightText,
                          fontSize: 15,
                          fontFamily: "NunitoSans",

                          // height: 1.7
                          fontWeight: FontWeight.w600,
                          // letterSpacing: 0.3,
                        ),
                      ),
                    ])),
                  ),
                )
              : SizedBox(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 22, 22, 22),
                child: RichText(
                    maxLines: 1000,
                    overflow: TextOverflow.ellipsis,
                    // textAlign: TextAlign.left,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: text1,
                        style: TextStyle(
                          color: _lightText,
                          fontSize: 15,
                          fontFamily: "NunitoSans",

                          // height: 1.7
                          // fontWeight: FontWeight.w600,
                          // letterSpacing: 0.3,
                        ),
                      ),
                    ])),
              ),
              AppSupportRow("A video - How to complete your application in your first attempt.", context),
              AppSupportRow("Application Support Handbook", context),
              AppSupportRow("Two examples", context),
              AppSupportRow("Writable sample application", context),
              AppSupportRow("Experience Calculator", context),
              cp.selectedPlanType == 0 ||
                      cp.selectedPlanType == 1 ||
                      cp.selectedPlanType == 3 ||
                      cp.selectedPlanType == 4
                  ? AppSupportRow("Session with Mentor", context)
                  : SizedBox(),
              SizedBox(
                height: 20,
              ),
              cp.selectedPlanType == 2
                  ? RichText(
                      // maxLines: 1000,
                      // overflow: TextOverflow.ellipsis,
                      // textAlign: TextAlign.left,
                      text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: "Upgrade to Platinum for Session with Mentor",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          // fontFamily: "NunitoSans",

                          // height: 1.7
                          fontWeight: FontWeight.w600,
                          // letterSpacing: 0.3,
                        ),
                      ),
                    ]))
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cp.selectedPlanType == 0 ||
                          cp.selectedPlanType == 1 ||
                          cp.selectedPlanType == 2 ||
                          cp.selectedPlanType == 4
                      ? Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * .4,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all<double>(4.0),
                                side: MaterialStateProperty.all(BorderSide(width: 2, color: Colors.indigo.shade500)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo.shade500),
                              ),
                              onPressed: () async {
                                ProfileProvider pp = Provider.of(context, listen: false);
                                CourseProvider cp = Provider.of(context, listen: false);

                                pp.updateLoader(false);
                                pp.setSelectedContainer(2);
                                SubscriptionProvider sp = Provider.of(context, listen: false);
                                sp.SelectedPlanType = 3;
                                await sp.setSelectedDurTimeQt(0, 0, isFirtTime: 1);
                                sp.setSelectedIval(2);
                                if (sp.durationPackData.isNotEmpty) {
                                  sp.setSelectedRadioVal(0);
                                }

                                pp.getReminder(cp.selectedCourseId).then((value) {
                                  print("thissss is callinggg");
                                  pp.setSelectedContainer(pp.planDetail.type - 1);
                                  print("this is calllllllllll");
                                  if (pp.planDetail.durationQuantity == 1) {
                                    print("000000");
                                    sp.setSelectedRadioVal(0);
                                  } else if (pp.planDetail.durationQuantity == 3) {
                                    print("111111");
                                    sp.setSelectedRadioVal(1);
                                  } else if (pp.planDetail.durationQuantity == 6) {
                                    print("2222222");
                                    sp.setSelectedRadioVal(2);
                                  }

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Subscriptionpg(
                                                showDrpDown: 0,
                                                showFreeTrial: 0,
                                                isFromUpgrdePlan: 1,
                                                title:pp.planDetail.title ,
                                                quntity: pp.planDetail.durationQuantity,
                                              )));
                                });
                              },
                              child: RichText(
                           
                                  text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                  text: "Upgrade",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                  
                                  ),
                                ),
                              ])
                              )),
                        )
                      : SizedBox(),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .4,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(4.0),
                          side: MaterialStateProperty.all(BorderSide(width: 2, color: Colors.indigo.shade500)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo.shade500),
                        ),
                        onPressed: () async {
                          bool result = await checkInternetConn();
                          print("result internet  $result");
                          if (result) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => GroupListPage()));
                          } else {
                            EasyLoading.showInfo("Please check your Internet Connection");
                          }
                        },
                        child: RichText(
                            text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: "Chat",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ]))),
                  ),
                ],
              ),
            ]),
          )
        ],
      ),
    );
  }
}
