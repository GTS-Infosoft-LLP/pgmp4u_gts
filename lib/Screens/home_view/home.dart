import 'dart:async';
import 'dart:convert' as convert;
import 'dart:developer' as dev;
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
import 'package:text_scroll/text_scroll.dart';
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
  List<String> texts = [];
  int currentIndex = 0;
  Timer _timer;

  List<CourseDetails> tempList = [];
  List<CourseDetails> storedCourse = [];

  // get width => null;

  initState() {
    print("0======call init");
    PurchaseProvider purchaseProvider = Provider.of(context, listen: false);
    CourseProvider courseProvider = Provider.of(context, listen: false);
    courseProvider.setFloatButton(0);
    dev.log("texts====$texts");
    purchaseProvider.updateStatusNew();
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      courseProvider.chngIndex();
    });
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
    // print("object......${ConnectivityResult.values}");
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
    await courseProvider.getFreeTrial();
    courseProvider.setFloatButton(0);
    Future<void>.delayed(Duration(seconds: 5), () {
      print("courseProvider.crsDropList.length:::${courseProvider.crsDropList.length}");
      if (courseProvider.crsDropList.length == 0) {
        courseProvider.setFloatButton(1);
      } else {
        if (courseProvider.allCrsList.length != courseProvider.chatCrsDropList.length) {
          courseProvider.setFloatButton(1);
        } else if (courseProvider.allCrsList.length == courseProvider.chatCrsDropList.length &&
            courseProvider.chatCrsDropList.length > 0) {
          courseProvider.setFloatButton(0);
        }
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
                                          InkWell(
                                              onTap: () {
                                                CourseProvider courseProvider = Provider.of(context, listen: false);
                                                print(
                                                    "courseProvider.allCrsList>>>>>>${courseProvider.allCrsList.length}");
                                                print(
                                                    "courseProvider.chatCrsDropList.length>>>>>${courseProvider.chatCrsDropList.length}");
                                              },
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: user.image,
                                                  width: 50,
                                                  height: 50,
                                                  //                   width: width * (80 / 420),
                                                  // height: width * (80 / 420),
                                                  placeholder: (context, url) =>
                                                      Image.asset('assets/user_placeholder.png'),
                                                  errorWidget: (context, url, error) =>
                                                      Image.asset('assets/user_placeholder.png'),
                                                ),
                                              )
                                              //  CircularCachedNetworkImage(
                                              //   imageUrl: user.image,
                                              //   size: 50,
                                              //   borderColor: Colors.white,
                                              //   borderWidth: 0,

                                              // ),
                                              ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(
                                              width: MediaQuery.of(context).size.width * .75,
                                              child: RichText(
                                                  text: TextSpan(children: <TextSpan>[
                                                TextSpan(
                                                  text:
                                                      "Over 95% of app users reported High Scores. Be one of them ! Get Started Now to boost your Knowledge!",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17,
                                                    fontFamily: 'Roboto Medium',
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
                                              child: RichText(
                                                  text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                              text: "Close",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ]))),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          CourseProvider crs = Provider.of(context, listen: false);
                                          crs.setSelectedCourseId(crs.course[0].id);
                                          crs.setSelectedCourseLable(storedCourse[0].lable);

                                          ProfileProvider pp = Provider.of(context, listen: false);
                                          pp.setSelectedContainer(0);
                                          SubscriptionProvider sp = Provider.of(context, listen: false);
                                          await sp.setisTimeOneVal(true);
                                          sp.SelectedPlanType = 1;
                                          await sp.setSelectedDurTimeQt(0, 0, isFirtTime: 1);
                                          sp.setSelectedIval(0);
                                          if (sp.durationPackData.isNotEmpty) {
                                            sp.setSelectedRadioVal(0);
                                          }
                                          sp.selectedIval = 2;
                                          if (crs.course.isNotEmpty) {
                                            crs.setSelectedCourseId(crs.course[0].id);
                                            crs.setSelectedCourseLable(storedCourse[0].lable);
                                          }
                                          Future.delayed(Duration(microseconds: 300), () async {
                                            crs.setSelectedCourseId(crs.course[0].id);
                                            crs.setSelectedCourseLable(storedCourse[0].lable);
                                            sp.setSelectedRadioVal(100);
                                            sp.setSelectedDescType(0);
                                            pp.setSelectedContainer(100);
                                            await sp.setisTimeOneVal(true);
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
                                          decoration: BoxDecoration(
                                            color: Color.fromARGB(255, 221, 221, 221),
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                          height: 45.2,
                                          width: MediaQuery.of(context).size.width * .46,
                                          child: Center(
                                              child: RichText(
                                                  text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                              text: "See Plans",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
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
                                      pp.setSelectedContainer(0);
                                      SubscriptionProvider sp = Provider.of(context, listen: false);
                                      sp.setisTimeOneVal(true);
                                      sp.SelectedPlanType = 1;
                                      await sp.setSelectedDurTimeQt(0, 0, isFirtTime: 1);
                                      sp.setSelectedIval(0);
                                      if (sp.durationPackData.isNotEmpty) {
                                        // sp.setSelectedRadioVal(0);
                                      }
                                      sp.selectedIval = 2;
                                      if (crs.course.isNotEmpty) {
                                        crs.setSelectedCourseId(crs.course[0].id);
                                        crs.setSelectedCourseLable(storedCourse[0].lable);
                                      }
                                      pp.updateLoader(true);

                                      Future.delayed(Duration(milliseconds: 300), () async {
                                        sp.setSelectedRadioVal(-1);
                                        pp.updateLoader(false);
                                        pp.setSelectedContainer(100);
                                        sp.setSelectedDescType(0);
                                        await sp.setisTimeOneVal(true);
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
                                            child: TextScroll(
                                              "Start with free trial for ${cp.currentDaysVal} days for ${cp.currentLableVal} course.  ",
                                              mode: TextScrollMode.endless,
                                              velocity: Velocity(pixelsPerSecond: Offset(50, 20)),
                                              delayBefore: Duration(seconds: 1),
                                              // numberOfReps: 2,
                                              pauseBetween: Duration(seconds: 1),
                                              style: TextStyle(
                                                  color: Colors.white, fontFamily: 'Roboto Medium', fontSize: 16),
                                              textAlign: TextAlign.right,
                                              selectable: true,
                                            )),
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
                                          text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                          text: "Hey, " + "${user.name}",
                                          style:
                                              TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                                        ),
                                      ])),
                                      InkWell(
                                          onTap: () {
                                            CourseProvider courseProvider = Provider.of(context, listen: false);
                                            print("courseProvider.allCrsList>>>>>>${courseProvider.allCrsList.length}");
                                            print(
                                                "courseProvider.chatCrsDropList.length>>>>>${courseProvider.chatCrsDropList.length}");
                                          },
                                          child: SizedBox(
                                            child: ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: user.image,
                                                width: 50,
                                                height: 50,
                                                placeholder: (context, url) =>
                                                    Image.asset('assets/user_placeholder.png'),
                                                errorWidget: (context, url, error) =>
                                                    Image.asset('assets/user_placeholder.png'),
                                              ),
                                            ),
                                          )
                                          // CircularCachedNetworkImage(
                                          //   imageUrl: user.image,
                                          //   size: (topHeight / 4) * 1.5,
                                          //   borderColor: Colors.white,
                                          //   borderWidth: 0,
                                          // ),
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
                                            textAlign: TextAlign.left,
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    "Over 95% of app users reported High Scores. Be one of them ! Get Started Now to boost your Knowledge!",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontFamily: 'Roboto Bold',
                                                ),
                                              ),
                                            ])),
                                        cp.showFloatButton == 0
                                            ? RichText(
                                                textAlign: TextAlign.left,
                                                text: TextSpan(children: <TextSpan>[
                                                  TextSpan(
                                                    text: "Be one of them ! Get Started NOW to boost your Knowledge!",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontFamily: 'Roboto Regular',
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
                                                  child: ListView.builder(
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
                                                                courseProvider
                                                                    .setSelectedCourseLable(storedCourse[index].lable);
                                                                print("course id>>>${storedCourse[index].id}");
                                                                print(
                                                                    "storedCourse[index]>>>is inapppurchseenable>>${storedCourse[index].inAppPurchaseEnabled}");

                                                                if (storedCourse[index].isCancelSubscription == 1 &&
                                                                    storedCourse[index].isSubscribed == 1) {
                                                                  CourseProvider cp =
                                                                      Provider.of(context, listen: false);
                                                                  ProfileProvider pp =
                                                                      Provider.of(context, listen: false);
                                                                  await pp
                                                                      .getReminder(cp.selectedCourseId)
                                                                      .then((value) {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => MasterListPage()));
                                                                  });
                                                                } else {
                                                                  courseProvider.setInAppPurchaseValue(
                                                                      storedCourse[index].inAppPurchaseEnabled);

                                                                  Future.delayed(const Duration(seconds: 5), () {
                                                                    if (courseProvider.crsDropList.length == 0) {
                                                                      courseProvider.setFloatButton(1);
                                                                    } else {
                                                                      if (courseProvider.allCrsList.length !=
                                                                          courseProvider.chatCrsDropList.length) {
                                                                        courseProvider.setFloatButton(1);
                                                                      } else if (courseProvider
                                                                                  .chatCrsDropList.length ==
                                                                              courseProvider.allCrsList.length &&
                                                                          courseProvider.allCrsList.length > 0) {
                                                                        courseProvider.setFloatButton(0);
                                                                      }
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
                                                                  courseProvider.setSelectedCourseName(
                                                                      storedCourse[index].course);
                                                                  courseProvider.setSelectedCourseLable(
                                                                      storedCourse[index].lable);

                                                                  if (storedCourse[index].isSubscribed == 0) {
                                                                    pp.updateLoader(false);
                                                                    pp.setSelectedContainer(0);
                                                                    SubscriptionProvider sp =
                                                                        Provider.of(context, listen: false);
                                                                    await sp.setisTimeOneVal(true);
                                                                    sp.SelectedPlanType = 1;
                                                                    await sp.setSelectedDurTimeQt(0, 0, isFirtTime: 1);
                                                                    sp.setSelectedIval(0);
                                                                    if (sp.durationPackData.isNotEmpty) {
                                                                      sp.setSelectedRadioVal(0);
                                                                    }
                                                                    sp.selectedIval = 2;
                                                                    // await sp.getSubscritionData(storedCourse[index].id);

                                                                    Future.delayed(const Duration(milliseconds: 4),
                                                                        () async {
                                                                      sp.setSelectedIval(0);
                                                                      pp.setSelectedContainer(0);
                                                                      if (sp.durationPackData.isNotEmpty) {
                                                                        sp.setSelectedRadioVal(0);
                                                                      }
                                                                      sp.selectedIval = 2;
                                                                      print("sp.selectedIval::${sp.selectedIval}");
                                                                      pp.updateLoader(false);
                                                                      sp.setSelectedRadioVal(0);
                                                                      sp.setSelectedDescType(0);
                                                                      await sp.setisTimeOneVal(true);
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => Subscriptionpg(
                                                                                    showDrpDown: 0,
                                                                                    showFreeTrial: 0,
                                                                                  )));
                                                                    });
                                                                  } else {
                                                                    courseProvider.setSelectedCourseLable(
                                                                        storedCourse[index].lable);
                                                                    pp.updateLoader(false);
                                                                    courseProvider
                                                                        .getMasterData(storedCourse[index].id);
                                                                    Future.delayed(const Duration(milliseconds: 100),
                                                                        () async {
                                                                      CourseProvider cp =
                                                                          Provider.of(context, listen: false);
                                                                      ProfileProvider pp =
                                                                          Provider.of(context, listen: false);
                                                                      await pp
                                                                          .getReminder(cp.selectedCourseId)
                                                                          .then((value) {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (context) =>
                                                                                    MasterListPage()));
                                                                      });
                                                                    });
                                                                  }
                                                                  pp.updateLoader(false);
                                                                  Future.delayed(const Duration(seconds: 5), () {
                                                                    if (courseProvider.crsDropList.length == 0) {
                                                                      courseProvider.setFloatButton(1);
                                                                    } else {
                                                                      if (courseProvider.allCrsList.length !=
                                                                          courseProvider.chatCrsDropList.length) {
                                                                        courseProvider.setFloatButton(1);
                                                                      } else if (courseProvider.allCrsList.length ==
                                                                              courseProvider.chatCrsDropList.length &&
                                                                          courseProvider.allCrsList.length > 0) {
                                                                        courseProvider.setFloatButton(0);
                                                                      }
                                                                    }
                                                                  });
                                                                }
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
                                                                          ),
                                                                        ),
                                                                      ])),
                                                                      RichText(
                                                                          text: TextSpan(children: <TextSpan>[
                                                                        TextSpan(
                                                                          text: storedCourse[index].course,
                                                                          style: TextStyle(
                                                                            color: Colors.black,
                                                                            fontSize: 18,
                                                                          ),
                                                                        ),
                                                                      ])),
                                                                    ],
                                                                  ),
                                                                  trailing: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      Container(
                                                                        height: 28,
                                                                        child: storedCourse[index].isSubscribed == 1
                                                                            ? InkWell(
                                                                                onTap: () {
                                                                                  if (storedCourse[index]
                                                                                          .isCancelSubscription ==
                                                                                      1) {
                                                                                    showRestorePopup(index);
                                                                                  }
                                                                                },
                                                                                child: Chip(
                                                                                  label: RichText(
                                                                                      textAlign: TextAlign.center,
                                                                                      text:
                                                                                          TextSpan(children: <TextSpan>[
                                                                                        TextSpan(
                                                                                          text: storedCourse[index]
                                                                                                      .isCancelSubscription ==
                                                                                                  1
                                                                                              ? "Restore"
                                                                                              : "Enrolled",
                                                                                          style: TextStyle(
                                                                                              color: Colors.white,
                                                                                              fontSize: 15,
                                                                                              fontWeight:
                                                                                                  FontWeight.w600),
                                                                                        ),
                                                                                      ])),
                                                                                  //  Text("hello"),
                                                                                  backgroundColor: Color(0xff3F9FC9),
                                                                                ),
                                                                              )
                                                                            : Chip(
                                                                                label: RichText(
                                                                                    textAlign: TextAlign.center,
                                                                                    text: TextSpan(children: <TextSpan>[
                                                                                      TextSpan(
                                                                                        text: "Join",
                                                                                        style: TextStyle(
                                                                                            color: Colors.white,
                                                                                            fontSize: 15,
                                                                                            fontWeight:
                                                                                                FontWeight.w600),
                                                                                      ),
                                                                                    ])),
                                                                                //  Text("hello"),
                                                                                backgroundColor: Color(0xff3F9FC9),
                                                                              ),
                                                                      ),
                                                                      storedCourse[index].isSubscribed == 1 &&
                                                                              (storedCourse[index]
                                                                                          .isCancelSubscription ==
                                                                                      0 ||
                                                                                  storedCourse[index]
                                                                                          .isCancelSubscription ==
                                                                                      2)
                                                                          ? RichText(
                                                                              text: TextSpan(children: <TextSpan>[
                                                                              TextSpan(
                                                                                text: storedCourse[index]
                                                                                            .subscriptionType ==
                                                                                        1
                                                                                    ? "Silver"
                                                                                    : storedCourse[index]
                                                                                                .subscriptionType ==
                                                                                            2
                                                                                        ? "Gold"
                                                                                        : storedCourse[index]
                                                                                                    .subscriptionType ==
                                                                                                4
                                                                                            ? "Free Trial"
                                                                                            : "Platinum",
                                                                                style: TextStyle(
                                                                                    color: Colors.black,
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ]))
                                                                          : SizedBox(),
                                                                      storedCourse[index].isSubscribed == 1 &&
                                                                              (storedCourse[index]
                                                                                          .isCancelSubscription ==
                                                                                      0 ||
                                                                                  storedCourse[index]
                                                                                          .isCancelSubscription ==
                                                                                      2)
                                                                          ? RichText(
                                                                              text: TextSpan(children: <TextSpan>[
                                                                              TextSpan(
                                                                                text: storedCourse[index]
                                                                                            .subscriptionDurationType ==
                                                                                        1
                                                                                    ? storedCourse[index].isFree == 1
                                                                                        ? "${storedCourse[index].subscriptionDurationQuantity}-Days"
                                                                                        : "${storedCourse[index].subscriptionDurationQuantity}-Month"
                                                                                    : "${storedCourse[index].subscriptionDurationQuantity * 365}-Days",
                                                                                style: TextStyle(
                                                                                  color: Colors.black,
                                                                                  fontSize: 10,
                                                                                  // fontWeight: FontWeight.w500
                                                                                ),
                                                                              )
                                                                            ]))
                                                                          : SizedBox(),
                                                                    ],
                                                                  ))),
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

      // setState(() {});
    } catch (e) {}
  }

  callRestoreApi() {}

  void showRestorePopup(int index) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              elevation: 20,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              title: Column(
                children: [
                  // Text("Are you sure you want to delete this account?",
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       fontFamily: 'Roboto Medium',
                  //       fontWeight: FontWeight.w200,
                  //       color: Colors.black,
                  //     )),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: "Are you sure you want to Restore Subscription for this Course?",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Roboto Medium',
                              fontWeight: FontWeight.w200),
                        ),
                      ])),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            height: 35,
                            width: MediaQuery.of(context).size.width * .15,
                            // constraints: BoxConstraints(minWidth: 100),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                gradient: LinearGradient(
                                    colors: [
                                      _colorfromhex("#3A47AD"),
                                      _colorfromhex("#5163F3"),
                                    ],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(1.0, 0.0),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp)),
                            child: Center(
                              child: RichText(
                                  // textAlign: TextAlign.center,
                                  text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                  text: "No",
                                  style: TextStyle(
                                      color: Colors.white,
                                      // fontSize: 18,
                                      // fontFamily: 'Roboto Medium',
                                      fontWeight: FontWeight.w400),
                                ),
                              ])),
                            ))),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        CourseProvider cp = Provider.of(context, listen: false);
                        print("calling restore api");
                        cp.restoreCourse(storedCourse[index].id);
                      },
                      child: Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width * .15,
                        // constraints: BoxConstraints(minWidth: 100),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            gradient: LinearGradient(
                                colors: [
                                  _colorfromhex("#3A47AD"),
                                  _colorfromhex("#5163F3"),
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp)),
                        child: Center(
                          child: RichText(
                              // textAlign: TextAlign.center,
                              text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: "Yes",
                              style: TextStyle(
                                  color: Colors.white,
                                  // fontSize: 18,
                                  // fontFamily: 'Roboto Medium',
                                  fontWeight: FontWeight.w400),
                            ),
                          ])),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ],
            ));
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
          errorWidget: (context, url, error) => Image.asset('assets/user_placeholder.png'),
        ),
      ),
    );
  }
}
