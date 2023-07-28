import 'dart:convert';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'package:pgmp4u/Screens/chat/screen/discussionGoupList.dart';
import 'package:pgmp4u/Screens/home_view/VideoLibrary/RandomPage.dart';
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
    print("cp.crsDropList.=====${cp.crsDropList.length}");
    if (cp.crsDropList.isNotEmpty) {
      print("cp.course[0].id===========${cp.crsDropList[0].id}");
      cp.setSelectedCourseId(cp.crsDropList[0].id);
      cp.setSelectedCourseName(cp.crsDropList[0].course);
      cp.setSelectedCourseLable(cp.crsDropList[0].lable);
      print("cp.course[0].lable===========${cp.crsDropList[0].lable}");

      // pp.getReminder(cp.course[0].id);
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
      // print(convert.jsonDecode(response.body));
    }
  }

  // Future apiCall() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String stringValue = prefs.getString('token');
  //   http.Response response;
  //   response = await http.get(Uri.parse(USER_DETAILS), headers: {
  //     'Content-Type': 'application/json',
  //     'Authorization': stringValue
  //   });

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       mapResponse = convert.jsonDecode(response.body);
  //       dataResponse = mapResponse["data"];
  //     });
  //     // print(convert.jsonDecode(response.body));
  //   }
  // }

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
                  bool isSub = context.read<ProfileProvider>().isChatSubscribed;

                  print("isChatSubscribed in profile ======= $isSub");

                  if (isSub == null) {
                    GFToast.showToast(
                      "Something went wrong,please try again",
                      context,
                      toastPosition: GFToastPosition.BOTTOM,
                    );
                  }

                  if (!isSub) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RandomPage(
                                  index: 4,
                                  price: context.read<ProfileProvider>().subsPrice.toString(),
                                  categoryType: context.read<CourseProvider>().selectedMasterType,
                                  categoryId: 0,
                                )));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => GroupListPage()));
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
                        children: [
                          /*  Row(
                                       children: [
                                         Icon(
                                           Icons.menu,
                                           size: width * (24 / 420),
                                           color: Colors.white,
                                         ),
                                         Text(
                                           '  Profile',
                                           style: TextStyle(
                                               fontFamily: 'Roboto Medium',
                                               fontSize: width * (16 / 420),
                                               color: Colors.white,
                                               letterSpacing: 0.3),
                                         ),
                                       ],
                                     ),
                                     Row(
                                       children: [
                                         Container(
                                           margin: EdgeInsets.only(
                                               right: width * (16 / 420)),
                                           child: Icon(
                                             Icons.search,
                                             size: width * (24 / 420),
                                             color: Colors.white,
                                           ),
                                         ),
                                         Icon(
                                           Icons.notifications,
                                           size: width * (24 / 420),
                                           color: Colors.white,
                                         ),
                                       ],
                                     ),*/
                        ],
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
                                child: Text(
                                  "${_user.name}",
                                  style: TextStyle(
                                    fontFamily: 'Roboto Medium',
                                    fontSize: width * (18 / 420),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                "${_user.email ?? ""}",
                                style: TextStyle(
                                  fontFamily: 'Roboto Medium',
                                  fontSize: width * (12 / 420),
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),

                          InkWell(
                            onTap: () {
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
                                Container(
                                  alignment: Alignment.centerRight,
                                  width: MediaQuery.of(context).size.width * .35,
                                  child: CustomDropDown<CourseDetails>(
                                    selectText: cp.selectedCourseLable ?? "Select",
                                    itemList: cp.crsDropList ?? [],
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
                                                height: 120,
                                                width: MediaQuery.of(context).size.width * .35,
                                                decoration: BoxDecoration(
                                                  // color: AppColor.green,
                                                  gradient: AppColor.greenGradient,
                                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text(
                                                      "Mock Test",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto Medium',
                                                          color: Colors.white,
                                                          fontSize: 18),
                                                    ),
                                                    Text(
                                                      pp.dayDiff == "NaN" ? "0.0%" : pp.dayDiff + "%",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto Medium',
                                                          color: Colors.white,
                                                          fontSize: 25),
                                                    ),
                                                    Text(
                                                      "Average Score",
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto Medium',
                                                          color: Colors.white,
                                                          fontSize: 18),
                                                    ),
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
                                                  height: 120,
                                                  width: MediaQuery.of(context).size.width * .35,
                                                  decoration: BoxDecoration(
                                                    color: AppColor.purpule,
                                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                                  ),
                                                  child: pp.avgScore == '0'
                                                      ? Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Center(
                                                            child: Text(
                                                              pp.avgScore == '0'
                                                                  ? "Tap to select exam date"
                                                                  : "Exam Date",
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  fontFamily: 'Roboto Medium',
                                                                  color: Colors.white,
                                                                  fontSize: 18),
                                                            ),
                                                          ),
                                                        )
                                                      : Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            Text(
                                                              "Exam Date",
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                  fontFamily: 'Roboto Medium',
                                                                  color: Colors.white,
                                                                  fontSize: 18),
                                                            ),
                                                            Text(
                                                              pp.avgScore.toString(),
                                                              style: TextStyle(
                                                                  fontFamily: 'Roboto Medium',
                                                                  color: Colors.white,
                                                                  fontSize: 25),
                                                            ),
                                                            Text(
                                                              "Days Left",
                                                              style: TextStyle(
                                                                  fontFamily: 'Roboto Medium',
                                                                  color: Colors.white,
                                                                  fontSize: 18),
                                                            ),
                                                            Text(
                                                              "(Tap to Change)",
                                                              style: TextStyle(
                                                                  fontFamily: 'Roboto Medium',
                                                                  color: Colors.white,
                                                                  fontSize: 10),
                                                            ),
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
                                  // margin: EdgeInsets.only(bottom: 6),
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
                                          Text(
                                            '   Notifications',
                                            style: TextStyle(
                                              fontFamily: 'Roboto Medium',
                                              fontSize: width * (18 / 420),
                                              color: Colors.black,
                                            ),
                                          ),
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

                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                                //   children: [
                                //     Text(
                                //       'Notifications',
                                //       style: TextStyle(
                                //         fontFamily: 'Roboto Medium',
                                //         fontSize: 16,
                                //         color: Colors.black,
                                //       ),
                                //     ),
                                //     Switch(
                                //       onChanged: (val) {
                                //         print("object val===$val");
                                //         setState(() {
                                //           isSwitched = val;
                                //           showNotifyOnOffPopup(val);
                                //         });
                                //       },
                                //       value: isSwitched,
                                //       activeColor: AppColor.green,
                                //       activeTrackColor: _colorfromhex("#3A47AD"),
                                //       inactiveThumbColor: AppColor.purpule,
                                //       inactiveTrackColor: Color.fromARGB(255, 197, 181, 181),
                                //     ),
                                //   ],
                                // ),

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
                                                    Text(
                                                      pp.isStudyRemAdded == 0
                                                          ? '    Set Study Time'
                                                          : '    Study timer set at: ',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto Medium',
                                                        fontSize: 16,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 18.0),
                                                      child: Text(
                                                        pp.isStudyRemAdded == 0 ? "" : pp.studyTime,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto Medium',
                                                          fontSize: width * (18 / 420),
                                                          color: Colors.black,
                                                        ),
                                                      ),
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
                                  onTap: () {
                                    // ProfileProvider profileProvider = Provider.of(context, listen: false);
                                    // profileProvider.getQuesDay(1);  //QuesListCourse

                                    Navigator.push(context, MaterialPageRoute(builder: (context) => QuesListCourse()));
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
                                            Text(
                                              '   Question of the day',
                                              style: TextStyle(
                                                fontFamily: 'Roboto Medium',
                                                fontSize: width * (18 / 420),
                                                color: Colors.black,
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
                                ),

                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => NotificationTabs()));
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
                                            Text(
                                              '   Announcements',
                                              style: TextStyle(
                                                fontFamily: 'Roboto Medium',
                                                fontSize: width * (18 / 420),
                                                color: Colors.black,
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
                                            Text(
                                              '   Delete Account',
                                              style: TextStyle(
                                                fontFamily: 'Roboto Medium',
                                                fontSize: width * (18 / 420),
                                                color: Colors.black,
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

                                      // barrierColor: Colors.amber,
                                      builder: (context) {
                                        return cancelSubsBottomSheet();
                                      },
                                    );
                                    // Navigator.push(
                                    // context, MaterialPageRoute(builder: (context) => NotificationTabs()));
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
                                            Text(
                                              '   Cancel Subscription',
                                              style: TextStyle(
                                                fontFamily: 'Roboto Medium',
                                                fontSize: width * (18 / 420),
                                                color: Colors.black,
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
                                            Text(
                                              '   Log Out',
                                              style: TextStyle(
                                                fontFamily: 'Roboto Medium',
                                                fontSize: width * (18 / 420),
                                                color: Colors.black,
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
                                ),

                                // GestureDetector(
                                //   onTap: context.watch<ProfileProvider>().subscriptionApiCalling
                                //       ? null
                                //       : () async {
                                //           bool isSub = context.read<ProfileProvider>().isChatSubscribed;

                                //           print("isChatSubscribed ======= $isSub");

                                //           if (isSub == null) {
                                //             GFToast.showToast(
                                //               "Something went wrong,please try again",
                                //               context,
                                //               toastPosition: GFToastPosition.BOTTOM,
                                //             );
                                //           }

                                //           if (!isSub) {
                                //             Navigator.push(
                                //                 context,
                                //                 MaterialPageRoute(
                                //                     builder: (context) => RandomPage(
                                //                           index: 4,
                                //                           price: context.read<ProfileProvider>().subsPrice.toString(),
                                //                           categoryType:
                                //                               context.read<CourseProvider>().selectedMasterType,
                                //                           categoryId: 0,
                                //                         )));
                                //           } else {
                                //             Navigator.push(
                                //                 context, MaterialPageRoute(builder: (context) => GroupListPage()));
                                //           }
                                //         },
                                //   child: Container(
                                //     margin: EdgeInsets.only(bottom: 6),
                                //     padding: EdgeInsets.only(
                                //         top: 13, bottom: 13, left: width * (18 / 420), right: width * (18 / 420)),
                                //     color: Colors.white,
                                //     child: Row(
                                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //       children: [
                                //         Row(
                                //           children: [
                                //             Icon(
                                //               Icons.chat,
                                //               size: width * (26 / 420),
                                //               color: _colorfromhex("#ABAFD1"),
                                //             ),
                                //             Text(
                                //               '   Chat',
                                //               style: TextStyle(
                                //                 fontFamily: 'Roboto Medium',
                                //                 fontSize: width * (18 / 420),
                                //                 color: context.watch<ProfileProvider>().subscriptionApiCalling
                                //                     ? Colors.black54
                                //                     : Colors.black,
                                //               ),
                                //             ),
                                //           ],
                                //         ),
                                //         Icon(
                                //           Icons.arrow_forward_ios,
                                //           size: 20,
                                //           color: _colorfromhex("#ABAFD1"),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                // ),
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
        context: context,
        builder: (context) => AlertDialog(
              elevation: 20,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              title:
                  Text(!val ? "Are you sure you want to disable notifications?" : "notifications enabled successfully",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Roboto Medium',
                        fontWeight: FontWeight.w200,
                        color: Colors.black,
                      )),
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
                                    child: Text(
                                      "No",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
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
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
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
                        child: Container(
                          height: 35,
                          width: MediaQuery.of(context).size.width * .75,
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
                            child: Text(
                              "Dismiss",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
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
                  Text("Are you sure you want to delete this account?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Roboto Medium',
                        fontWeight: FontWeight.w200,
                        color: Colors.black,
                      )),
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
                              child: Text(
                                "No",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
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
                          child: Text(
                            "Yes",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
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

class cancelSubsBottomSheet extends StatelessWidget {
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CourseProvider cp = Provider.of(context, listen: false);
    return Card(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Text(
                  'Cancel Subscription',
                  style: TextStyle(fontSize: 18, fontFamily: 'Roboto Medium', color: Colors.black),
                ),
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
          cp.crsDropList.length > 1
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: Text(
                        'Select Course for which you want to cancel the Subscription pack',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      child: Text(
                        'No course is purchased yet',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                ),

          cp.crsDropList.length > 1
              ? Consumer<CourseProvider>(builder: (context, cp, child) {
                  return Container(
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width * .35,
                    child: CustomDropDown<CourseDetails>(
                      selectText: cp.selectedCancelSubsLable ?? "Select",
                      itemList: cp.crsDropList ?? [],
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
                showCancelSubsPopup(context);
                SubscriptionProvider sp = Provider.of(context, listen: false);
                sp.cancelSubscription(cp.selectedCancelSubsId);
              }
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
                child: Text(
                  'CANCEL NOW',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto Medium',
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),

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
                  Text("Are you sure you want to cancel the subscription for this course?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Roboto Medium',
                        fontWeight: FontWeight.w200,
                        color: Colors.black,
                      )),
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
                              child: Text(
                                "No",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
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
                          child: Text(
                            "Yes",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
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
