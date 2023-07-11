import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'package:pgmp4u/Screens/Pdf/screens/pdf_list.dart';
import 'package:pgmp4u/Screens/chat/screen/discussionGoupList.dart';
import 'package:pgmp4u/Screens/home_view/VideoLibrary/RandomPage.dart';
import 'package:pgmp4u/api/apis.dart';
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
import '../quesDayList.dart';
import 'notifications.dart';

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

  @override
  void initState() {
    super.initState();
    CourseProvider cp = Provider.of(context, listen: false);

    if (cp.course.isNotEmpty) {
      cp.setSelectedCourseName(cp.course[0].course);
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

                  print("isChatSubscribed ======= $isSub");

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
                  gradient: LinearGradient(
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

                          ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: photoUrl != null ? photoUrl : '',
                              fit: BoxFit.cover,
                              width: width * (80 / 420),
                              height: width * (80 / 420),
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
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
                    padding: EdgeInsets.only(top: height * (28 / 800)),
                    margin: EdgeInsets.only(bottom: 10),
                    // height: height - 180 - 25 - 110,
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Container(
                        //       width: width * (150 / 420),
                        //       height: height * (112 / 800),
                        //       margin: EdgeInsets.only(right: width * (23 / 420)),
                        //       decoration: BoxDecoration(
                        //         color: _colorfromhex("#72A258"),
                        //         borderRadius: BorderRadius.circular(10),
                        //       ),
                        //       child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Text(
                        //             'Mock Test',
                        //             style: TextStyle(
                        //               fontFamily: 'Roboto Bold',
                        //               fontSize: width * (18 / 420),
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //           Container(
                        //             height: 5,
                        //           ),
                        //           Text(
                        //             '00.00',
                        //             style: TextStyle(
                        //               fontFamily: 'Roboto Bold',
                        //               fontSize: width * (20 / 420),
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //           Container(
                        //             height: 5,
                        //           ),
                        //           Text(
                        //             'Average Score',
                        //             style: TextStyle(
                        //               fontFamily: 'Roboto Medium',
                        //               fontSize: width * (14 / 420),
                        //               color: Colors.white,
                        //             ),
                        //           )
                        //         ],
                        //       ),
                        //     ),
                        //     Container(
                        //       width: width * (150 / 420),
                        //       height: height * (112 / 800),
                        //       decoration: BoxDecoration(
                        //         color: _colorfromhex("#463B97"),
                        //         borderRadius: BorderRadius.circular(10),
                        //       ),
                        //       child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Text(
                        //             'Exam Date',
                        //             style: TextStyle(
                        //               fontFamily: 'Roboto Bold',
                        //               fontSize: width * (18 / 420),
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //           Container(
                        //             height: 5,
                        //           ),
                        //           Text(
                        //             '0',
                        //             style: TextStyle(
                        //               fontFamily: 'Roboto Bold',
                        //               fontSize: width * (20 / 420),
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //           Container(
                        //             height: 5,
                        //           ),
                        //           Text(
                        //             'Days Left',
                        //             style: TextStyle(
                        //               fontFamily: 'Roboto Medium',
                        //               fontSize: width * (14 / 420),
                        //               color: Colors.white,
                        //             ),
                        //           )
                        //         ],
                        //       ),
                        //     )
                        //   ],
                        // ),
                        Consumer<CourseProvider>(builder: (context, cp, child) {
                          return Container(
                            // color: Colors.amber,
                            margin: EdgeInsets.only(top: width * (50 / 800)),
                            child: Column(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * .73,
                                  child: CustomDropDown<CourseDetails>(
                                      selectText: cp.selectedCourseName ?? "Select",
                                      itemList: cp.course ?? [],
                                      isEnable: true,
                                      title: "",
                                      value: null,
                                      onChange: (val) {
                                        print("val.course=========>${val.course}");
                                        cp.setSelectedCourseName(val.course);
                                        cp.setSelectedCourseId(val.id);
                                      }),
                                ),

                                SizedBox(
                                  height: 15,
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 120,
                                      width: MediaQuery.of(context).size.width * .35,
                                      decoration: BoxDecoration(
                                        color: AppColor.green,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "Mock Test",
                                            style: TextStyle(
                                                fontFamily: 'Roboto Medium', color: Colors.white, fontSize: 18),
                                          ),
                                          Text(
                                            "00.00",
                                            style: TextStyle(
                                                fontFamily: 'Roboto Medium', color: Colors.white, fontSize: 25),
                                          ),
                                          Text(
                                            "Average Score",
                                            style: TextStyle(
                                                fontFamily: 'Roboto Medium', color: Colors.white, fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: (){
                                        
                                      },
                                      child: Container(
                                        height: 120,
                                        width: MediaQuery.of(context).size.width * .35,
                                        decoration: BoxDecoration(
                                          color: AppColor.purpule,
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Exam Date",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto Medium', color: Colors.white, fontSize: 18),
                                            ),
                                            Text(
                                              "0",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto Medium', color: Colors.white, fontSize: 25),
                                            ),
                                            Text(
                                              "Days Left",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto Medium', color: Colors.white, fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                                SizedBox(
                                  height: 10,
                                ),

                                GestureDetector(
                                  onTap: () {
                                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsScreen("","")));
                                    //Navigator.of(context)
                                    //   .pushNamed('/settings');
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
                                              Icons.settings,
                                              size: width * (26 / 420),
                                              color: _colorfromhex("#ABAFD1"),
                                            ),
                                            Text(
                                              '   Settings',
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
                                //   onTap: () {
                                //     Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage()));
                                //   },
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
                                //               Icons.person,
                                //               size: width * (26 / 420),
                                //               color: _colorfromhex("#ABAFD1"),
                                //             ),
                                //             Text(
                                //               '   Chat with Admin',
                                //               style: TextStyle(
                                //                 fontFamily: 'Roboto Medium',
                                //                 fontSize: width * (18 / 420),
                                //                 color: Colors.black,
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
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Notifications()));
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
}
