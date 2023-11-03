import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:pgmp4u/Screens/MockTest/model/courseModel.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/provider/profileProvider.dart';
import 'package:pgmp4u/provider/purchase_provider.dart';
import 'package:provider/provider.dart';
import '../../Models/hideshowmodal.dart';
import '../../provider/Subscription/subscriptionPage.dart';
import '../../provider/Subscription/subscriptionProvider.dart';
import '../../provider/courseProvider.dart';
import '../../tool/ShapeClipper2.dart';
import '../../utils/user_object.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Tests/local_handler/hive_handler.dart';
import '../masterPage.dart';

//import 'home_view/flashcardbuttn.dart';
class HomeView extends StatefulWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Map mapResponse;

//ModelStatus maintainStatus;
  @override
  Color clr;
  String body;

  List<CourseDetails> tempList = [];
  List<CourseDetails> storedCourse = [];

  initState() {
    print("0======call init");
    PurchaseProvider purchaseProvider = Provider.of(context, listen: false);
    CourseProvider courseProvider = Provider.of(context, listen: false);
    purchaseProvider.updateStatusNew();
    // courseProvider.getCourse();

    callApi();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> callApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    CourseProvider courseProvider = Provider.of(context, listen: false);

    body = HiveHandler.getNotSubmittedMock(keyName: courseProvider.notSubmitedMockID);
    print("object......${ConnectivityResult.values}");
    if (body == null) {
      body = "";
    }
    print("body::::::::: $body");
    if (body.isNotEmpty && ConnectivityResult != ConnectivityResult.none) {
      print("api is going to callllllll");
      Response response = await http.post(
        Uri.parse(SUBMIT_MOCK_TEST),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: body,
      );
      print("response statuscode:::: ${response.statusCode}");

      if (response.statusCode == 200) {
        HiveHandler.removeFromSubmitMockBox(courseProvider.notSubmitedMockID);
        courseProvider.setnotSubmitedMockID("");
        courseProvider.setToBeSubmitIndex(1000);
      }
    } else {
      print("we will not call the api");
    }

    // print(" Map mp Map mp $mp");

    courseProvider.getCourse();
    Future<void>.delayed(Duration(seconds: 3), () {
      print("courseProvider.crsDropList.length:::${courseProvider.crsDropList.length}");
      if (courseProvider.crsDropList.length == 0) {
        courseProvider.setFloatButton(1);
      } else {
        courseProvider.setFloatButton(0);
      }
    });
  }

  HideShowResponse hideShowRes = HideShowResponse();
  Future callFlashCardHideShowApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response;

    try {
      response = await http.get(Uri.parse(getHideShowStatus), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        print(convert.jsonDecode(response.body));
        await prefs.setString('useStatus', response.body);
        _getData();
      }
    } catch (e) {
      _getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = UserObject().getUser;

    final double topHeight = 150;

    return Consumer<CourseProvider>(builder: (context, crp, child) {
      return Scaffold(
        body: Stack(
          children: [
            crp.showFloatButton == 1
                ? Container(
                    height: 40,
                    color: Color.fromARGB(255, 50, 4, 58),
                  )
                : ClipPath(
                    clipper: ShapeClipperMirrored(),
                    child: Container(
                      height: topHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                      ),
                    ),
                  ),
            Consumer<CourseProvider>(builder: (context, cp, child) {
              return Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: topHeight - topHeight / 1.4,
                      ),
                      crp.showFloatButton == 1 && crp.masterTemp.length == 0
                          ? Container(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                    child: Container(
                                      child: Row(
                                        children: [
                                          CircularCachedNetworkImage(
                                            imageUrl: user.image,
                                            size: 50,
                                            borderColor: Colors.white,
                                            borderWidth: 0,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                              width: MediaQuery.of(context).size.width * .75,
                                              child: RichText(
                                                  // overflow: TextOverflow.ellipsis,
                                                  // maxLines: 2,
                                                  // textAlign: TextAlign.center,
                                                  text: TextSpan(children: <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      "Over 95% of app users reported High Scores. Be one of them ! Get Started Now to boost your Knowledge!",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17,
                                                    fontFamily: 'Roboto Medium',
                                                    // fontWeight: FontWeight.bold

                                                    // fontFamily: AppFont.poppinsRegular,
                                                  ),
                                                ),
                                              ]))),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          crp.setFloatButton(0);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(255, 221, 221, 221),
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                          height: 45.2,
                                          width: MediaQuery.of(context).size.width * .46,
                                          child: Center(
                                              child:

                                                  //     Text(
                                                  //   "Close",
                                                  //   style: TextStyle(fontSize: 17),
                                                  // )

                                                  RichText(
                                                      // overflow: TextOverflow.ellipsis,
                                                      // maxLines: 2,
                                                      // textAlign: TextAlign.left,
                                                      text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                              text: "Close",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                // fontFamily: 'Roboto Regular',
                                                // fontWeight: FontWeight.bold

                                                // fontFamily: AppFont.poppinsRegular,
                                              ),
                                            ),
                                          ]))),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          CourseProvider crs = Provider.of(context, listen: false);

                                          ProfileProvider pp = Provider.of(context, listen: false);
                                          pp.setSelectedContainer(2);
                                          SubscriptionProvider sp = Provider.of(context, listen: false);
                                          sp.SelectedPlanType = 3;
                                          await sp.setSelectedDurTimeQt(0, 0, isFirtTime: 1);
                                          sp.setSelectedIval(2);
                                          if (sp.durationPackData.isNotEmpty) {
                                            sp.setSelectedRadioVal(0);
                                          }
                                          sp.selectedIval = 2;
                                          if (crs.course.isNotEmpty) {
                                            crs.setSelectedCourseId(crs.course[0].id);
                                            crs.setSelectedCourseLable(storedCourse[0].lable);
                                          }
                                          Future.delayed(Duration(microseconds: 300), () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Subscriptionpg(
                                                          showDrpDown: 1,
                                                          showFreeTrial: 0,
                                                        )));
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(255, 221, 221, 221),
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                          height: 45.2,
                                          width: MediaQuery.of(context).size.width * .46,
                                          child: Center(
                                              child: RichText(
                                                  // overflow: TextOverflow.ellipsis,
                                                  // maxLines: 2,
                                                  // textAlign: TextAlign.left,
                                                  text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                              text: "See Plans",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                // fontFamily: 'Roboto Regular',
                                                // fontWeight: FontWeight.bold

                                                // fontFamily: AppFont.poppinsRegular,
                                              ),
                                            ),
                                          ]))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4.6,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      ProfileProvider pp = Provider.of(context, listen: false);

                                      CourseProvider crs = Provider.of(context, listen: false);
                                      pp.setSelectedContainer(2);
                                      SubscriptionProvider sp = Provider.of(context, listen: false);
                                      sp.SelectedPlanType = 3;
                                      await sp.setSelectedDurTimeQt(0, 0, isFirtTime: 1);
                                      sp.setSelectedIval(2);
                                      if (sp.durationPackData.isNotEmpty) {
                                        // sp.setSelectedRadioVal(0);
                                      }
                                      sp.selectedIval = 2;
                                      if (crs.course.isNotEmpty) {
                                        crs.setSelectedCourseId(crs.course[0].id);
                                        crs.setSelectedCourseLable(storedCourse[0].lable);
                                      }
                                      pp.updateLoader(true);

                                      Future.delayed(Duration(milliseconds: 300), () {
                                        pp.updateLoader(false);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Subscriptionpg(
                                                      showDrpDown: 1,
                                                      showFreeTrial: 1,
                                                    )));
                                      });
                                    },
                                    child: Container(
                                      height: 61.3,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 5, 0, 0),
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      width: MediaQuery.of(context).size.width * .95,
                                      child: Row(children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                          height: 34,
                                          child: Image.asset(
                                            "assets/flagIcon.png",
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                            width: MediaQuery.of(context).size.width * .63,
                                            child: RichText(
                                                // overflow: TextOverflow.ellipsis,
                                                // maxLines: 2,
                                                // textAlign: TextAlign.center,
                                                text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                text: "Start with free trial for 3 days",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontFamily: 'Roboto Medium',
                                                  // fontWeight: FontWeight.bold

                                                  // fontFamily: AppFont.poppinsRegular,
                                                ),
                                              ),
                                            ]))),
                                        new Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 15.0),
                                          child: Icon(
                                            Icons.east,
                                            size: 26,
                                            color: Colors.white,
                                          ),
                                        )
                                      ]),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(40.0),
                                  // bottomLeft: Radius.circular(40.0)
                                ),
                                gradient: LinearGradient(
                                    colors: [_colorfromhex('#3846A9'), _colorfromhex('#5265F8')],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(1.0, 0.0),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      RichText(
                                          // overflow: TextOverflow.ellipsis,
                                          // maxLines: 2,
                                          // textAlign: TextAlign.left,
                                          text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                          text: "Hey, " + "${user.name}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              // fontFamily: 'Roboto Regular',
                                              fontWeight: FontWeight.bold

                                              // fontFamily: AppFont.poppinsRegular,
                                              ),
                                        ),
                                      ])),
                                      CircularCachedNetworkImage(
                                        imageUrl: user.image,
                                        size: (topHeight / 4) * 2,
                                        borderColor: Colors.white,
                                        borderWidth: 0,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 32.0, right: 20),
                                    child: Column(
                                      children: [
                                        RichText(
                                            // overflow: TextOverflow.ellipsis,
                                            // maxLines: 2,
                                            textAlign: TextAlign.left,
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    "Over 95% of app users reported High Scores. Be one of them ! Get Started Now to boost your Knowledge!",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontFamily: 'Roboto Bold',
                                                  // fontWeight: FontWeight.bold

                                                  // fontFamily: AppFont.poppinsRegular,
                                                ),
                                              ),
                                            ])),
                                        cp.showFloatButton == 0
                                            ? RichText(
                                                // overflow: TextOverflow.ellipsis,
                                                // maxLines: 2,
                                                textAlign: TextAlign.left,
                                                text: TextSpan(children: <TextSpan>[
                                                  TextSpan(
                                                    text: "Be one of them ! Get Started NOW to boost your Knowledge!",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontFamily: 'Roboto Regular',
                                                      // fontWeight: FontWeight.bold

                                                      // fontFamily: AppFont.poppinsRegular,
                                                    ),
                                                  ),
                                                ]))
                                            : Text(""),
                                        SizedBox(
                                          height: 15,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: Platform.isIOS ? 12 : 0,
                      ),
                      Container(
                        child: ValueListenableBuilder<Box<String>>(
                            valueListenable: HiveHandler.getCourseListener(),
                            builder: (context, value, child) {
                              if (value.containsKey(HiveHandler.CourseKey)) {
                                List masterDataList = jsonDecode(value.get(HiveHandler.CourseKey));
                                storedCourse = masterDataList.map((e) => CourseDetails.fromjson(e)).toList();
                              } else {
                                storedCourse = [];
                              }

                              // print("storedMaster========================$storedCourse");

                              if (storedCourse == null) {
                                storedCourse = [];
                              }

                              return Expanded(
                                child: Consumer<CourseProvider>(builder: (context, courseProvider, child) {
                                  return courseProvider.getCourseApiCalling && storedCourse.isEmpty
                                      ? Container(
                                          height: MediaQuery.of(context).size.height * .55,
                                          child: Center(child: CircularProgressIndicator.adaptive()))
                                      : storedCourse.isEmpty
                                          ? Center(
                                              child: Container(
                                                  height: MediaQuery.of(context).size.height * .35,
                                                  child: Center(child: Text("No Data Found"))))
                                          : Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: Container(
                                                  // color: Colors.amber,
                                                  // height: MediaQuery.of(context).size.height * .58,
                                                  child: ListView.builder(
                                                      // physics: NeverScrollableScrollPhysics(),

                                                      physics: BouncingScrollPhysics(),
                                                      itemCount: storedCourse.length,
                                                      itemBuilder: (context, index) {
                                                        if (index % 4 == 0) {
                                                          clr = Color(0xff3F9FC9);
                                                        } else if (index % 3 == 0) {
                                                          clr = Color(0xff3FC964);
                                                        } else if (index % 2 == 0) {
                                                          clr = Color(0xffDE682B);
                                                        } else {
                                                          clr = Color(0xffC93F7F);
                                                        }
                                                        return Padding(
                                                          padding: const EdgeInsets.only(bottom: 20),
                                                          child: InkWell(
                                                              onTap: () async {
                                                                print(
                                                                    "storedCourse[index]>>>is inapppurchseenable>>${storedCourse[index].inAppPurchaseEnabled}");

                                                                courseProvider.setInAppPurchaseValue(
                                                                    storedCourse[index].inAppPurchaseEnabled);

                                                                Future.delayed(const Duration(seconds: 5), () {
                                                                  if (courseProvider.crsDropList.length == 0) {
                                                                    courseProvider.setFloatButton(1);
                                                                  } else {
                                                                    courseProvider.setFloatButton(0);
                                                                  }
                                                                });
                                                                print(
                                                                    "isSubscribedd::: ${storedCourse[index].isSubscribed}");
                                                                courseProvider.setSelectedPlanType(
                                                                    storedCourse[index].subscriptionType);
                                                                ProfileProvider pp =
                                                                    Provider.of(context, listen: false);
                                                                pp.updateLoader(true);
                                                                courseProvider
                                                                    .setSelectedCourseId(storedCourse[index].id);
                                                                courseProvider
                                                                    .setSelectedCourseName(storedCourse[index].course);
                                                                courseProvider
                                                                    .setSelectedCourseLable(storedCourse[index].lable);

                                                                if (storedCourse[index].isSubscribed == 0) {
                                                                  pp.updateLoader(false);
                                                                  pp.setSelectedContainer(2);
                                                                  SubscriptionProvider sp =
                                                                      Provider.of(context, listen: false);
                                                                  sp.SelectedPlanType = 3;
                                                                  await sp.setSelectedDurTimeQt(0, 0, isFirtTime: 1);
                                                                  sp.setSelectedIval(2);
                                                                  if (sp.durationPackData.isNotEmpty) {
                                                                    sp.setSelectedRadioVal(0);
                                                                  }
                                                                  sp.selectedIval = 2;
                                                                  // await sp.getSubscritionData(storedCourse[index].id);

                                                                  Future.delayed(const Duration(milliseconds: 4), () {
                                                                    sp.setSelectedIval(2);
                                                                    pp.setSelectedContainer(2);
                                                                    if (sp.durationPackData.isNotEmpty) {
                                                                      sp.setSelectedRadioVal(0);
                                                                    }
                                                                    sp.selectedIval = 2;
                                                                    print("sp.selectedIval::${sp.selectedIval}");
                                                                    pp.updateLoader(false);
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => Subscriptionpg(
                                                                                  showDrpDown: 0,
                                                                                  showFreeTrial: 0,
                                                                                )));
                                                                  });
                                                                } else {
                                                                  pp.updateLoader(false);
                                                                  courseProvider.getMasterData(storedCourse[index].id);
                                                                  Future.delayed(const Duration(milliseconds: 100), () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => MasterListPage()));
                                                                  });
                                                                }
                                                                pp.updateLoader(false);
                                                                Future.delayed(const Duration(seconds: 5), () {
                                                                  if (courseProvider.crsDropList.length == 0) {
                                                                    courseProvider.setFloatButton(1);
                                                                  } else {
                                                                    courseProvider.setFloatButton(0);
                                                                  }
                                                                });
                                                              },
                                                              child: ListTile(
                                                                leading: Container(
                                                                    // color: Colors.blueAccent,
                                                                    height: 80,
                                                                    width: 65,
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      color: clr,
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(12),
                                                                      child: Icon(FontAwesomeIcons.graduationCap,
                                                                          color: Colors.white),
                                                                    )),
                                                                title: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    RichText(
                                                                        // overflow: TextOverflow.ellipsis,
                                                                        // maxLines: 2,
                                                                        // textAlign: TextAlign.center,
                                                                        text: TextSpan(children: <TextSpan>[
                                                                      TextSpan(
                                                                        text: storedCourse[index].lable,
                                                                        style: TextStyle(
                                                                          color: Colors.grey,
                                                                          fontSize: 14,
                                                                          // fontFamily: 'Roboto Medium',
                                                                          // fontWeight: FontWeight.bold

                                                                          // fontFamily: AppFont.poppinsRegular,
                                                                        ),
                                                                      ),
                                                                    ])),
                                                                    RichText(
                                                                        // overflow: TextOverflow.ellipsis,
                                                                        // maxLines: 2,
                                                                        // textAlign: TextAlign.center,
                                                                        text: TextSpan(children: <TextSpan>[
                                                                      TextSpan(
                                                                        text: storedCourse[index].course,
                                                                        style: TextStyle(
                                                                          color: Colors.black,
                                                                          fontSize: 18,
                                                                          // fontFamily: 'Roboto Medium',
                                                                          // fontWeight: FontWeight.bold

                                                                          // fontFamily: AppFont.poppinsRegular,
                                                                        ),
                                                                      ),
                                                                    ])),
                                                                  ],
                                                                ),
                                                                trailing: storedCourse[index].isSubscribed == 0
                                                                    ? InkWell(
                                                                        onTap: () {
                                                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => Subscriptionpg()));
                                                                        },
                                                                        child: Container(
                                                                          height: 80,
                                                                          // color: Colors.amber,
                                                                          child: Column(
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () async {
                                                                                  CourseProvider courseProvider =
                                                                                      Provider.of(context,
                                                                                          listen: false);
                                                                                  Future.delayed(
                                                                                      const Duration(seconds: 5), () {
                                                                                    if (courseProvider
                                                                                            .crsDropList.length ==
                                                                                        0) {
                                                                                      courseProvider.setFloatButton(1);
                                                                                    } else {
                                                                                      courseProvider.setFloatButton(0);
                                                                                    }
                                                                                  });
                                                                                  print(
                                                                                      "isSubscribedd::: ${storedCourse[index].isSubscribed}");
                                                                                  courseProvider.setSelectedPlanType(
                                                                                      storedCourse[index]
                                                                                          .subscriptionType);
                                                                                  ProfileProvider pp = Provider.of(
                                                                                      context,
                                                                                      listen: false);
                                                                                  pp.updateLoader(true);
                                                                                  courseProvider.setSelectedCourseId(
                                                                                      storedCourse[index].id);
                                                                                  courseProvider.setSelectedCourseName(
                                                                                      storedCourse[index].course);
                                                                                  courseProvider.setSelectedCourseLable(
                                                                                      storedCourse[index].lable);

                                                                                  if (storedCourse[index]
                                                                                          .isSubscribed ==
                                                                                      0) {
                                                                                    pp.updateLoader(false);
                                                                                    pp.setSelectedContainer(2);
                                                                                    SubscriptionProvider sp =
                                                                                        Provider.of(context,
                                                                                            listen: false);
                                                                                    sp.SelectedPlanType = 3;
                                                                                    await sp.setSelectedDurTimeQt(0, 0,
                                                                                        isFirtTime: 1);
                                                                                    sp.setSelectedIval(2);
                                                                                    if (sp
                                                                                        .durationPackData.isNotEmpty) {
                                                                                      sp.setSelectedRadioVal(0);
                                                                                    }
                                                                                    sp.selectedIval = 2;
                                                                                    // await sp.getSubscritionData(storedCourse[index].id);

                                                                                    Future.delayed(
                                                                                        const Duration(milliseconds: 4),
                                                                                        () {
                                                                                      sp.setSelectedIval(2);
                                                                                      pp.setSelectedContainer(2);
                                                                                      if (sp.durationPackData
                                                                                          .isNotEmpty) {
                                                                                        sp.setSelectedRadioVal(0);
                                                                                      }
                                                                                      sp.selectedIval = 2;
                                                                                      print(
                                                                                          "sp.selectedIval::${sp.selectedIval}");
                                                                                      Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (context) =>
                                                                                                  Subscriptionpg(
                                                                                                    showDrpDown: 0,
                                                                                                    showFreeTrial: 0,
                                                                                                  )));
                                                                                    });
                                                                                  } else {
                                                                                    pp.updateLoader(false);
                                                                                    courseProvider.getMasterData(
                                                                                        storedCourse[index].id);
                                                                                    Future.delayed(
                                                                                        const Duration(
                                                                                            milliseconds: 100), () {
                                                                                      Navigator.push(
                                                                                          context,
                                                                                          MaterialPageRoute(
                                                                                              builder: (context) =>
                                                                                                  MasterListPage()));
                                                                                    });
                                                                                  }
                                                                                  pp.updateLoader(false);
                                                                                  Future.delayed(
                                                                                      const Duration(seconds: 5), () {
                                                                                    if (courseProvider
                                                                                            .crsDropList.length ==
                                                                                        0) {
                                                                                      courseProvider.setFloatButton(1);
                                                                                    } else {
                                                                                      courseProvider.setFloatButton(0);
                                                                                    }
                                                                                  });
                                                                                },
                                                                                child: Container(
                                                                                  height: 30,
                                                                                  child: Chip(
                                                                                      label: Text(
                                                                                        storedCourse[index]
                                                                                                    .isCancelSubscription ==
                                                                                                1
                                                                                            ? "Cancelled"
                                                                                            : "Join",
                                                                                        style: TextStyle(
                                                                                            color: Colors.white,
                                                                                            fontWeight:
                                                                                                FontWeight.w600),
                                                                                      ),
                                                                                      backgroundColor:
                                                                                          Color(0xff3F9FC9)),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 4,
                                                                              ),
                                                                              // Text("Platinum")
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        height: 80,
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              height: 35,
                                                                              child: Chip(
                                                                                  label: Text(
                                                                                    storedCourse[index]
                                                                                                .isCancelSubscription ==
                                                                                            1
                                                                                        ? "Cancelled"
                                                                                        : "Enrolled",
                                                                                    style: TextStyle(
                                                                                        color: Colors.white,
                                                                                        fontWeight: FontWeight.w600),
                                                                                  ),
                                                                                  backgroundColor: Color(0xff3F9FC9)),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 4,
                                                                            ),
                                                                      
                                                                            storedCourse[index].subscriptionType == 1
                                                                                ? Text("Silver",
                                                                                    style: TextStyle(
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontSize: 13,
                                                                                    ))
                                                                                : storedCourse[index]
                                                                                            .subscriptionType ==
                                                                                        2
                                                                                    ? Text("Gold",
                                                                                        style: TextStyle(
                                                                                          fontWeight: FontWeight.w600,
                                                                                          fontSize: 13,
                                                                                        ))
                                                                                    : storedCourse[index]
                                                                                                .subscriptionType ==
                                                                                            3
                                                                                        ? Text("Platinum",
                                                                                            style: TextStyle(
                                                                                              fontWeight:
                                                                                                  FontWeight.w600,
                                                                                              fontSize: 13,
                                                                                            ))
                                                                                        : storedCourse[index]
                                                                                                    .subscriptionType ==
                                                                                                4
                                                                                            ? Text("3 Days Trial",
                                                                                                style: TextStyle(
                                                                                                  fontWeight:
                                                                                                      FontWeight.w600,
                                                                                                  fontSize: 13,
                                                                                                ))
                                                                                            : Text("")
                                                                          ],
                                                                        ),
                                                                      ),
                                                              )),
                                                        );
                                                      })),
                                            );
                                }),
                              );
                            }),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ],
              );
            })
          ],
        ),
      );
    });
  }

  Future<void> _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String action = prefs.getString('useStatus');
      print("SharedPreffffff   check   $action");

      hideShowRes = HideShowResponse.fromjson(convert.jsonDecode(action));
      print("hideShowRes====$hideShowRes");

      setState(() {});
    } catch (e) {}
  }
}

Color _colorfromhex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

class CircularCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final Color borderColor;
  final double borderWidth;

  const CircularCachedNetworkImage({
    this.imageUrl,
    this.size,
    this.borderColor = Colors.black,
    this.borderWidth = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width: size - (2 * borderWidth),
          height: size - (2 * borderWidth),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
