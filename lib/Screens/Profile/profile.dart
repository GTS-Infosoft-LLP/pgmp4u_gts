import 'dart:convert';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pgmp4u/Screens/chat/screen/discussionGoupList.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/provider/Subscription/subscriptionProvider.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:pgmp4u/utils/app_color.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:convert' as convert;
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/profileProvider.dart';
import '../../utils/user_object.dart';
import '../MockTest/model/courseModel.dart';
import '../dropdown.dart';
import '../notificationTabs.dart';
import '../quesDayList.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  CollectionReference users = FirebaseFirestore.instance.collection('staticData');
  Razorpay _razorpay;

  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  Map mapResponse;
  // Map dataResponse;
  String photoUrl;
  getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('photo');
    print('stringValue');
    setState(() {
      photoUrl = stringValue;
    });
  }

  String examDate;
  String studyTime;
  bool isSwitched = false;
  var Switchcontroller = ValueNotifier<bool>(false);
  @override
  void initState() {
    Switchcontroller.value = false;

    super.initState();
    CourseProvider cp = Provider.of(context, listen: false);
    ProfileProvider pp = Provider.of(context, listen: false);
    cp.getCourse();

    checkNotificationStatus();
    print(">>>>>cp..MockcrsDropList>>>>>${cp.mockCrsDropList.length}");
    print("cp.crsDropList.=====${cp.crsDropList.length}");
    if (cp.mockCrsDropList.isNotEmpty) {
      print("cp.course[0].id===========${cp.mockCrsDropList[0].id}");
      cp.setSelectedCourseId(cp.mockCrsDropList[0].id);
      cp.setSelectedCourseName(cp.mockCrsDropList[0].course);
      cp.setSelectedCourseLable(cp.mockCrsDropList[0].lable);
      print("cp.course[0].lable===========${cp.mockCrsDropList[0].lable}");
    } else {
      cp.setSelectedCourseLable(null);
      print("seletced course lableee====${cp.selectedCourseLable}");
    }

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    getValue();

    context.read<CourseProvider>().setMasterListType("Chat");
    context.read<ProfileProvider>().subscriptionApiCalling
        ? null
        : context.read<ProfileProvider>().subscriptionStatus("Chat");
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    paymentStatus("success");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    paymentStatus("failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}
  void openCheckout(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('email');
    var options = {
      'key': key,
      'amount': 1 * 100,
      "order_id": "",
      'name': 'PgMP4U',
      'description': '',
      'prefill': {'contact': '', 'email': stringValue},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  checkNotificationStatus() async {
    ProfileProvider pp = Provider.of(context, listen: false);
    CourseProvider cp = Provider.of(context, listen: false);
    if (cp.crsDropList.isNotEmpty) {
      print("cp.crsDropList[0].id==:::${cp.crsDropList[0].id}");
      await pp.getReminder(cp.crsDropList[0].id);
      if (pp.notiValue == 0) {
        isSwitched = false;
      } else {
        isSwitched = true;
      }
    }
  }

  Future paymentStatus(status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    http.Response response;
    response = await http.post(
      Uri.parse(TAKE_PAYMENT),
      headers: {'Content-Type': 'application/json', 'Authorization': stringValue},
      body: json.encode({
        "payment_status": status,
        "price": 1,
        "payment_repsonse": "sfadfeaf",
        "client_secret": "212421424",
        "access_type": "life_time"
      }),
    );

    if (response.statusCode == 200) {
      setState(() {});
      print(convert.jsonDecode(response.body));
    }
  }

  Future getOrderId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    http.Response response;
    response = await http.post(
      Uri.parse(GET_RAZOR_PAY_ORDER_ID),
      headers: {'Content-Type': 'application/json', 'Authorization': stringValue},
      body: json.encode({"amount": 200}),
    );

    if (response.statusCode == 200) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final _user = UserObject().getUser;

    print("user name is : ${_user.name}");
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: InkWell(
          onTap: context.watch<ProfileProvider>().subscriptionApiCalling
              ? null
              : () async {
                  CourseProvider cp = Provider.of(context, listen: false);
                  print("cp.course>>>>>>>${cp.course.length}");
                  bool result = await checkInternetConn();
                  print("result internet  $result");
                  if (result) {
                    bool isSub = context.read<ProfileProvider>().isChatSubscribed;

                    print("isChatSubscribed in profile ======= $isSub");

                    if (isSub == null) {
                      GFToast.showToast(
                        "Something went wrong,please try again",
                        context,
                        toastPosition: GFToastPosition.BOTTOM,
                      );
                    }

                    if (cp.course.isEmpty) {
                      GFToast.showToast(
                        'No Course Available',
                        context,
                        toastPosition: GFToastPosition.CENTER,
                      );
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GroupListPage()));
                    }
                  } else {
                    EasyLoading.showInfo("Please check your Internet Connection");
                  }
                },
          child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: context.watch<ProfileProvider>().subscriptionApiCalling
                      ? LinearGradient(
                          colors: [Color.fromARGB(255, 171, 172, 182), Color.fromARGB(255, 133, 134, 141)],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp)
                      : LinearGradient(
                          colors: [
                            _colorfromhex("#3A47AD"),
                            _colorfromhex("#5163F3"),
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp)),
              child: Icon(
                Icons.chat,
                color: Colors.white,
              )),
        ),
      ),
      body: Sizer(builder: (context, orientation, deviceType) {
        return Container(
          color: _colorfromhex("#FCFCFF"),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: SizerUtil.deviceType == DeviceType.mobile ? 180 : 330,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(40.0)),
                  gradient: LinearGradient(
                      colors: [_colorfromhex('#3846A9'), _colorfromhex('#5265F8')],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: width * (20 / 420), right: width * (20 / 420), top: height * (16 / 800)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: height * (30 / 800), left: width * (28 / 420), right: width * (34 / 420)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 6),
                                child: RichText(
                                    // overflow: TextOverflow.ellipsis,
                                    // maxLines: 2,
                                    // textAlign: TextAlign.center,
                                    text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                    text: "${_user.name}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width * (18 / 420),
                                      fontFamily: 'Roboto Medium',
                                      // fontWeight: FontWeight.bold

                                      // fontFamily: AppFont.poppinsRegular,
                                    ),
                                  ),
                                ])),
                              ),
                              RichText(
                                  // overflow: TextOverflow.ellipsis,
                                  // maxLines: 2,
                                  // textAlign: TextAlign.center,
                                  text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                  text: "${_user.email ?? ""}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * (12 / 420),
                                    fontFamily: 'Roboto Medium',
                                    // fontWeight: FontWeight.bold

                                    // fontFamily: AppFont.poppinsRegular,
                                  ),
                                ),
                              ])),
                            ],
                          ),

                          InkWell(
                            onTap: () {
                              print("offffsettttt${DateTime.now().timeZoneOffset.inMilliseconds}");
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => Subscriptionpg()));
                            },
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: photoUrl != null ? photoUrl : '',
                                fit: BoxFit.cover,
                                width: width * (80 / 420),
                                height: width * (80 / 420),
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                          ),
                          // photoUrl != null && photoUrl != ""
                          //     ? Container(
                          //         width: width * (80 / 420),
                          //         height: width * (80 / 420),
                          //         decoration: BoxDecoration(
                          //           image: DecorationImage(
                          //             image: NetworkImage(photoUrl),
                          //             fit: BoxFit.cover,
                          //           ),
                          //           borderRadius: BorderRadius.circular(80),
                          //         ),
                          //       )
                          //     : Container(
                          //         width: width * (80 / 420),
                          //         height: width * (80 / 420),
                          //         decoration: BoxDecoration(
                          //           color: Colors.white,
                          //           borderRadius: BorderRadius.circular(80),
                          //         ),
                          //       )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(),
                    margin: EdgeInsets.only(bottom: 10),
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer<CourseProvider>(builder: (context, cp, child) {
                          return Container(
                            // color: Colors.amber,
                            // margin: EdgeInsets.only(top: width * (50 / 800)),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (cp.mockCrsDropList.isEmpty) {
                                      GFToast.showToast(
                                        // 'No Course is purchased yet...',
                                        "Subscribe to a course or attempt mock test",
                                        context,
                                        toastPosition: GFToastPosition.CENTER,
                                      );
                                    }
                                    if (cp.course.isEmpty) {
                                      print("list is empty show popup");

                                      GFToast.showToast(
                                        // 'No Course is purchased yet...',
                                        "No course available",
                                        context,
                                        toastPosition: GFToastPosition.CENTER,
                                      );
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    width: MediaQuery.of(context).size.width * .35,
                                    child: CustomDropDown<CourseDetails>(
                                      selectText: cp.selectedCourseLable ?? "Select",
                                      itemList: cp.mockCrsDropList ?? [],
                                      isEnable: true,
                                      title: "",
                                      value: null,
                                      onChange: (val) {
                                        print("val.course=========>${val.course}");
                                        print("val.course=========>${val.lable}");
                                        cp.setSelectedCourseLable(val.lable);
                                        cp.setSelectedCourseId(val.id);
                                        ProfileProvider pp = Provider.of(context, listen: false);
                                        pp.getReminder(val.id);
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Consumer<ProfileProvider>(builder: (context, pp, child) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 33.0),
                                    child: Card(
                                      elevation: 2,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                // height: 120,
                                                height: MediaQuery.of(context).size.height * .15,
                                                width: MediaQuery.of(context).size.width * .35,
                                                decoration: BoxDecoration(
                                                  // color: AppColor.green,
                                                  gradient: AppColor.greenGradient,
                                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    RichText(
                                                        text: TextSpan(children: <TextSpan>[
                                                      TextSpan(
                                                        text: "Mock Test",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontFamily: 'Roboto Medium',
                                                        ),
                                                      ),
                                                    ])),
                                                    RichText(
                                                        text: TextSpan(children: <TextSpan>[
                                                      TextSpan(
                                                        text: pp.dayDiff == "NaN" ? "0.0%" : pp.dayDiff + "%",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 28,
                                                          fontFamily: 'Roboto Medium',
                                                          // fontWeight: FontWeight.bold

                                                          // fontFamily: AppFont.poppinsRegular,
                                                        ),
                                                      ),
                                                    ])),
                                                    RichText(
                                                        text: TextSpan(children: <TextSpan>[
                                                      TextSpan(
                                                        text: "Average Score",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontFamily: 'Roboto Medium',
                                                          // fontWeight: FontWeight.bold

                                                          // fontFamily: AppFont.poppinsRegular,
                                                        ),
                                                      ),
                                                    ])),
                                                    Text(
                                                      "",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto Medium',
                                                          color: Colors.white,
                                                          fontSize: 10),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  ProfileProvider pp = Provider.of(context, listen: false);
                                                  print("pp.dayDiff========${pp.avgScore}");
                                                  // if (pp.avgScore != '0') {
                                                  // } else
                                                  {
                                                    DatePicker.showDatePicker(context, minTime: DateTime.now())
                                                        .then((value) async {
                                                      print("valueee====$value");
                                                      print("djjhdsjfh====${value.toString().split(" ")[0]}");
                                                      examDate = value.toString().split(" ")[0];

                                                      if (examDate.isNotEmpty) {
                                                        ProfileProvider pp = Provider.of(context, listen: false);
                                                        await pp.setReminder("", examDate, cp.selectedCourseId, 2);
                                                        pp.getReminder(cp.selectedCourseId);
                                                      }
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  height: MediaQuery.of(context).size.height * .15,
                                                  width: MediaQuery.of(context).size.width * .35,
                                                  decoration: BoxDecoration(
                                                    color: AppColor.purpule,
                                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                                  ),
                                                  child: pp.avgScore == '0'
                                                      ? Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Center(
                                                            child: RichText(
                                                                text: TextSpan(children: <TextSpan>[
                                                              TextSpan(
                                                                text: pp.avgScore == '0'
                                                                    ? "Tap to select exam date"
                                                                    : "Exam Date",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 18,
                                                                  fontFamily: 'Roboto Medium',
                                                                ),
                                                              ),
                                                            ])),
                                                          ),
                                                        )
                                                      : Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            RichText(
                                                                textAlign: TextAlign.center,
                                                                text: TextSpan(children: <TextSpan>[
                                                                  TextSpan(
                                                                    text: "Exam Date",
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 18,
                                                                      fontFamily: 'Roboto Medium',
                                                                    ),
                                                                  ),
                                                                ])),
                                                            RichText(
                                                                textAlign: TextAlign.center,
                                                                text: TextSpan(children: <TextSpan>[
                                                                  TextSpan(
                                                                    text: pp.avgScore.toString(),
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 25,
                                                                      fontFamily: 'Roboto Medium',
                                                                    ),
                                                                  ),
                                                                ])),
                                                            RichText(
                                                                textAlign: TextAlign.center,
                                                                text: TextSpan(children: <TextSpan>[
                                                                  TextSpan(
                                                                    text: "Days Left",
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 18,
                                                                      fontFamily: 'Roboto Medium',
                                                                    ),
                                                                  ),
                                                                ])),
                                                            RichText(
                                                                textAlign: TextAlign.center,
                                                                text: TextSpan(children: <TextSpan>[
                                                                  TextSpan(
                                                                    text: "(Tap to Change)",
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 10,
                                                                      fontFamily: 'Roboto Medium',
                                                                    ),
                                                                  ),
                                                                ])),
                                                          ],
                                                        ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding:
                                      EdgeInsets.only(top: 13, left: width * (18 / 420), right: width * (18 / 420)),
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.notifications_paused_sharp,
                                            size: width * (26 / 420),
                                            color: _colorfromhex("#ABAFD1"),
                                          ),
                                          RichText(
                                              text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                              text: '   Notifications',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: width * (18 / 420),
                                                fontFamily: 'Roboto Medium',
                                              ),
                                            ),
                                          ])),
                                        ],
                                      ),
                                      Switch(
                                        onChanged: (val) {
                                          print("object val===$val");
                                          setState(() {
                                            isSwitched = val;
                                            showNotifyOnOffPopup(val);
                                          });
                                        },
                                        value: isSwitched,
                                        activeColor: AppColor.green,
                                        activeTrackColor: _colorfromhex("#3A47AD"),
                                        inactiveThumbColor: AppColor.purpule,
                                        inactiveTrackColor: Color.fromARGB(255, 197, 181, 181),
                                      ),
                                    ],
                                  ),
                                ),
                                Consumer<ProfileProvider>(builder: (context, pp, child) {
                                  return GestureDetector(
                                    onTap: () {
                                      print("pp.isStudyRemAdded====${pp.isStudyRemAdded}");
                                      {
                                        DatePicker.showTimePicker(
                                          context,
                                          currentTime: DateTime.now(),
                                        ).then((value) async {
                                          print("value=====>$value");
                                          ProfileProvider pp = Provider.of(context, listen: false);
                                          List lst = value.toString().split(".");
                                          print("lst======$lst");
                                          var v1 = lst[0];
                                          studyTime = v1;
                                          await pp.setReminder(studyTime, "", cp.selectedCourseId, 1);
                                          pp.getReminder(cp.selectedCourseId);
                                        });
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications()));
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 6),
                                      padding: EdgeInsets.only(
                                          top: 13, bottom: 13, left: width * (18 / 420), right: width * (18 / 420)),
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.lock_clock,
                                                size: width * (26 / 420),
                                                color: _colorfromhex("#ABAFD1"),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context).size.width * .78,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    RichText(
                                                        text: TextSpan(children: <TextSpan>[
                                                      TextSpan(
                                                        text: pp.isStudyRemAdded == 0
                                                            ? '   Set Study Time'
                                                            : '   Study timer set at: ',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: width * (18 / 420),
                                                          fontFamily: 'Roboto Medium',
                                                        ),
                                                      ),
                                                    ])),
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 18.0),
                                                      child: RichText(
                                                          text: TextSpan(children: <TextSpan>[
                                                        TextSpan(
                                                          text: pp.isStudyRemAdded == 0 ? "" : pp.studyTime,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: width * (18 / 420),
                                                            fontFamily: 'Roboto Medium',
                                                          ),
                                                        ),
                                                      ])),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 20,
                                            color: _colorfromhex("#ABAFD1"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                GestureDetector(
                                  onTap: () async {
                                    CourseProvider cp = Provider.of(context, listen: false);
                                    cp.updateLoader(true);
                                    await cp.getCourse().then((value) {
                                      cp.updateLoader(false);
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => QuesListCourse()));
                                    });
                                    // ProfileProvider profileProvider = Provider.of(context, listen: false);
                                    // profileProvider.getQuesDay(1);  //QuesListCourse
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 6),
                                    padding: EdgeInsets.only(
                                        top: 13, bottom: 13, left: width * (18 / 420), right: width * (18 / 420)),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.question_mark_outlined,
                                              size: width * (26 / 420),
                                              color: _colorfromhex("#ABAFD1"),
                                            ),
                                            RichText(
                                                text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                text: '   Question of the day',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: width * (18 / 420),
                                                  fontFamily: 'Roboto Medium',
                                                ),
                                              ),
                                            ])),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                          color: _colorfromhex("#ABAFD1"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    cp.setSelectedNotiCrsLable(cp.selectedCourseLable);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NotificationTabs(
                                                  fromSplash: 0,
                                                )));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 6),
                                    padding: EdgeInsets.only(
                                        top: 13, bottom: 13, left: width * (18 / 420), right: width * (18 / 420)),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.notifications,
                                              size: width * (26 / 420),
                                              color: _colorfromhex("#ABAFD1"),
                                            ),
                                            RichText(
                                                text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                text: '   Announcements',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: width * (18 / 420),
                                                  fontFamily: 'Roboto Medium',
                                                ),
                                              ),
                                            ])),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                          color: _colorfromhex("#ABAFD1"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDeletePopup();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 6),
                                    padding: EdgeInsets.only(
                                        top: 13, bottom: 13, left: width * (18 / 420), right: width * (18 / 420)),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              size: width * (26 / 420),
                                              color: _colorfromhex("#ABAFD1"),
                                            ),
                                            RichText(
                                                text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                text: '   Delete Account',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: width * (18 / 420),
                                                  fontFamily: 'Roboto Medium',
                                                ),
                                              ),
                                            ])),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                          color: _colorfromhex("#ABAFD1"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    cp.setSelectedCancelSubsCrsLable(null);
                                    // cp.selectedCancelSubsLable = null;
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      builder: (context) {
                                        return cancelSubsBottomSheet();
                                      },
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 6),
                                    padding: EdgeInsets.only(
                                        top: 13, bottom: 13, left: width * (18 / 420), right: width * (18 / 420)),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.diamond,
                                              size: width * (26 / 420),
                                              color: _colorfromhex("#ABAFD1"),
                                            ),
                                            RichText(
                                                text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                text: '   Cancel Subscription',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: width * (18 / 420),
                                                  fontFamily: 'Roboto Medium',
                                                ),
                                              ),
                                            ])),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                          color: _colorfromhex("#ABAFD1"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    await prefs.clear();
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/start-screen', (Route<dynamic> route) => false);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 6),
                                    padding: EdgeInsets.only(
                                        top: 13, bottom: 13, left: width * (18 / 420), right: width * (18 / 420)),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.logout,
                                              size: width * (26 / 420),
                                              color: _colorfromhex("#ABAFD1"),
                                            ),
                                            RichText(
                                                text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                text: '   Log Out',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: width * (18 / 420),
                                                  fontFamily: 'Roboto Medium',
                                                ),
                                              ),
                                            ])),
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 20,
                                          color: _colorfromhex("#ABAFD1"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  void showNotifyOnOffPopup(bool val) {
    showDialog(
        barrierDismissible: false,
        //insetPadding: EdgeInsets.all(10),
        context: context,
        builder: (context) => AlertDialog(
              insetPadding: EdgeInsets.all(30),
              elevation: 20,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              title: Container(
                //color: Colors.amber,
                width: MediaQuery.of(context).size.width * .95,
                child: RichText(
                    // textAlign: TextAlign.center,
                    text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text:
                        !val ? "Are you sure you want to disable notifications?" : "Notifications enabled successfully",
                    style: TextStyle(
                        color: Colors.black, fontSize: 18, fontFamily: 'Roboto Medium', fontWeight: FontWeight.w200),
                  ),
                ])),
              ),
              actions: [
                !val
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                setState(() {
                                  isSwitched = true;
                                });
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
                              ProfileProvider pp = Provider.of(context, listen: false);
                              pp.updateNotification();
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
                      )
                    : InkWell(
                        onTap: () {
                          ProfileProvider pp = Provider.of(context, listen: false);
                          pp.updateNotification();
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 35,
                            width: MediaQuery.of(context).size.width * .80,
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
                                  text: "Dismiss",
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
                      ),
              ],
            ));
  }

  void showDeletePopup() {
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
                          text:
                              "Are you sure you want to delete this account?\n Deleting the account will remove all the plans and your data will be lost",
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
                        ProfileProvider pp = Provider.of(context, listen: false);

                        pp.deleteAccount();
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

class cancelSubsBottomSheet extends StatelessWidget {
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CourseProvider cp = Provider.of(context, listen: false);

    print(" cp.crsDropList>>>>>>${cp.crsDropList}");
    return Card(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                RichText(
                    text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: 'Cancel Subscription',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Roboto Medium',
                    ),
                  ),
                ])),
                Spacer(),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: Color.fromRGBO(165, 156, 180, 1),
                    )),
              ],
            ),
          ),
          Divider(
            thickness: 2,
          ),
          cp.cancelSubsList.length > 0
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: RichText(
                          text: TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: 'Select Course for which you want to cancel the Subscription pack',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            // fontFamily: 'Roboto Medium',
                          ),
                        ),
                      ])),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: 'No course is purchased yet',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                // fontFamily: 'Roboto Medium',
                              ),
                            ),
                          ])),
                    ),
                  ),
                ),

          cp.cancelSubsList.length > 0
              ? Consumer<CourseProvider>(builder: (context, cp, child) {
                  // for (int i = 0; i < cp.mockCrsDropList.length; i++) {
                  //   print("cp.mockCrsDropList::::::::;;;;; ${cp.mockCrsDropList[i].lable}");
                  // }

                  return Container(
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width * .35,
                    child: CustomDropDown<CourseDetails>(
                      selectText: cp.selectedCancelSubsLable ?? "Select",
                      itemList: cp.cancelSubsList ?? [],
                      isEnable: true,
                      title: "",
                      value: null,
                      onChange: (val) {
                        print("val.course=========>${val.id}");
                        print("val.course lable=========>${val.lable}");
                        cp.setSelectedCancelSubsCrsLable(val.lable);
                        cp.setSelectedCancelSubsId(val.id);
                        // cp.setSelectedCourseId(val.id);
                      },
                    ),
                  );
                })
              : SizedBox(),

          SizedBox(
            height: 20,
          ),

          cp.cancelSubsList.length > 0
              ? InkWell(
                  onTap: () {
                    showCancelSubsPopup(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: AppColor.appGradient,
                      ),
                      alignment: Alignment.center,
                      child: RichText(
                          // textAlign: TextAlign.left,
                          text: TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: 'CANCEL NOW',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Roboto Medium',
                          ),
                        ),
                      ])),
                    ),
                  ),
                )
              : SizedBox(),

          SizedBox(
            height: 20,
          )

          // _publishButton(context),
        ],
      ),
    );
  }

  void showCancelSubsPopup(BuildContext context) {
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
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: "Are you sure you want to cancel the subscription for this course?",
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
                        CourseProvider cp = Provider.of(context, listen: false);
                        print("cp sele lable===${cp.selectedCancelSubsLable}");
                        if (cp.selectedCancelSubsLable == null) {
                          GFToast.showToast(
                            'Please select Plan for which you want to cancel the subscription',
                            context,
                            toastPosition: GFToastPosition.CENTER,
                          );
                        } else {
                          Navigator.pop(context);
                          // showCancelSubsPopup(context);
                          SubscriptionProvider sp = Provider.of(context, listen: false);
                          sp.cancelSubscription(cp.selectedCancelSubsId);
                        }
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

  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
