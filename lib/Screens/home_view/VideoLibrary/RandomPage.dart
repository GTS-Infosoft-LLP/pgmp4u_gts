import 'dart:io';
import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:pgmp4u/Models/constants.dart';
import 'package:pgmp4u/Screens/Profile/paymentstripe2.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:pgmp4u/provider/profileProvider.dart';
import 'package:pgmp4u/provider/purchase_provider.dart';
import 'package:pgmp4u/Screens/Profile/PaymentStatus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../provider/Subscription/subscriptionProvider.dart';
import '../../../subscriptionModel.dart';

///   1> flash
///   2> video
///   3> mock
///   4> chat
///   5> PPT
///   6> domain
class RandomPage extends StatefulWidget {
  int index;
  String price;
  int categoryId;
  String categoryType;

  RandomPage({this.index = 0, this.price = "\$199", this.categoryId, this.categoryType});
  @override
  _RandomPageState createState() => _RandomPageState();
}

class _RandomPageState extends State<RandomPage> {
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  String mntVal;
  String mnth;
  String mnths = "Months";
  Color clr;
  LinearGradient liGrdint;

  @override
  void initState() {
    ProfileProvider pp = Provider.of(context, listen: false);
    CourseProvider cp = Provider.of(context, listen: false);
    SubscriptionProvider sp = Provider.of(context, listen: false);

    if (cp.crsDropList.isEmpty) {
      sp.getSubscritionData(cp.course[0].id);
    } else {
      sp.getSubscritionData(cp.selectedCourseId);
    }

    print("widget category typeee====${widget.categoryType}");

    print("perice value is===>> ${widget.price}");
    print("category idddd======${widget.categoryId}");
    print("categoryyy typeee======${widget.categoryType}");
    pp.setSelectedContainer(13);
    // CourseProvider cp = Provider.of(context, listen: false);
    print("cp.selectedMasterType==============${cp.selectedMasterType}");

    if (widget.price == null) {
      widget.price = "\$199";
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      top: false,
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
          child: InkWell(
            onTap: () async {
              SubscriptionProvider sp = Provider.of(context, listen: false);
              sp.createSubscritionOrder(sp.selectedSubsId);
              var token = await getToken();

              if (sp.selectedSubsId > permiumbutton.length) {
                GFToast.showToast(
                  'Please select Plan',
                  context,
                  toastPosition: GFToastPosition.BOTTOM,
                );
              } else {
                bool status = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PaymentAndroid(token: token, statusFlash1videoLibrary2: 1, urlll: sp.finUrl),
                    ));
                print("statueeess====>>>$status");

                if (status) {
                  Navigator.pop(context);
                  _handlePaymentSuccess2(context);
                } else {
                  _handlePaymentError2(context);
                }
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width * .9,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Center(
                  child: Text(
                "Subscribe Now",
                style: TextStyle(color: Colors.white, fontFamily: 'Roboto Bold', fontSize: 20),
              )),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                      borderRadius: BorderRadius.all(Radius.circular(28)),
                    ),
                    // color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .04,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                                // color: Colors.white,
                                width: width,
                                // height: height,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 20, top: 15),
                                        child: GestureDetector(
                                          onTap: () => {Navigator.of(context).pop()},
                                          child: Icon(
                                            Icons.arrow_back_ios,
                                            size: 27,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.center,
                                      //   children: [
                                      //     Container(
                                      //       margin: EdgeInsets.only(top: 30, bottom: 25),
                                      //       child: Image.asset('assets/premium.png'),
                                      //     ),
                                      //   ],
                                      // ),
                                      Container(
                                        margin: EdgeInsets.only(left: 20, right: 20),
                                        child: Center(
                                            child: widget.index == 1
                                                ? Text(
                                                    'Get 1 year Access to Flash Card',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto Bold',
                                                        fontSize: width * (30 / 420),
                                                        color: Colors.white,
                                                        letterSpacing: 0.3),
                                                  )
                                                : widget.index == 2
                                                    ? Text(
                                                        'Get 1 year Access to Video Library',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            fontFamily: 'Roboto Bold',
                                                            fontSize: width * (30 / 420),
                                                            color: Colors.white,
                                                            letterSpacing: 0.3),
                                                      )
                                                    : widget.index == 3
                                                        ? Text(
                                                            'Get 1 year Access to Mock Tests',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                                fontFamily: 'Roboto Bold',
                                                                fontSize: width * (30 / 420),
                                                                color: Colors.white,
                                                                letterSpacing: 0.3),
                                                          )
                                                        : widget.index == 4
                                                            ? Text(
                                                                'Get 1 year Access to Chats',
                                                                textAlign: TextAlign.center,
                                                                style: TextStyle(
                                                                    fontFamily: 'Roboto Bold',
                                                                    fontSize: width * (30 / 420),
                                                                    color: Colors.white,
                                                                    letterSpacing: 0.3),
                                                              )
                                                            : widget.index == 5
                                                                ? Text(
                                                                    'Get 1 year Access to PTT',
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontFamily: 'Roboto Bold',
                                                                        fontSize: width * (30 / 420),
                                                                        color: Colors.white,
                                                                        letterSpacing: 0.3),
                                                                  )
                                                                : widget.index == 6
                                                                    ? Text(
                                                                        'Get 1 year Access to Domains',
                                                                        textAlign: TextAlign.center,
                                                                        style: TextStyle(
                                                                            fontFamily: 'Roboto Bold',
                                                                            fontSize: width * (30 / 420),
                                                                            color: Colors.white,
                                                                            letterSpacing: 0.3),
                                                                      )
                                                                    : Text(
                                                                        'Get 1 year Access to Pgmp Question of the day',
                                                                        textAlign: TextAlign.center,
                                                                        style: TextStyle(
                                                                          fontFamily: 'Roboto Bold',
                                                                          fontSize: width * (30 / 420),
                                                                          color: Colors.white,
                                                                        ),
                                                                      )),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 20),
                                        child: Center(
                                            child: Text(
                                          ' On \n \$ ${widget.price}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'Roboto Bold',
                                              fontSize: 24,
                                              color: Colors.white,
                                              letterSpacing: 0.3),
                                        )),
                                      ),
                                      Consumer2<PurchaseProvider, CourseProvider>(
                                        builder: (context, value, cp, child) {
                                          var latestState = value.serverResponse.getContent();
                                          if (latestState is Loading) {
                                            return Center(child: CircularProgressIndicator());
                                          }

                                          if (latestState is Default) {
                                            value.showToast(context, latestState.message);
                                          }

                                          print("value.serverResponse = ${latestState is Success}");
                                          if (latestState is Success) {
                                            print("Pop called");
                                            Future.delayed(Duration.zero, () async {
                                              Navigator.pop(context, true);
                                            });
                                          }
                                          return BuyButton2(context, value, widget.index, cp.selectedMasterType,
                                              widget.categoryId, widget.index);
                                        },
                                      ),
                                    ])),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    left: MediaQuery.of(context).size.width * .4,
                    // top: MediaQuery.of(context).size.height * .35,
                    // top: 300,

                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: Center(
                            child: Text(
                          "OR",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontFamily: 'Roboto Bold',
                          ),
                        )),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Center(
                  child: Text(
                "Select a plan",
                style: TextStyle(
                  fontFamily: 'Roboto Bold',
                  fontSize: 22,
                ),
              )),
              SizedBox(
                height: 25,
              ),
              Consumer2<ProfileProvider, SubscriptionProvider>(builder: (context, pp, sp, child) {
                return sp.getSubsPackApiCall
                    ? Center(child: CircularProgressIndicator.adaptive())
                    : SingleChildScrollView(
                        child: Container(
                          // color: Colors.amber,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 15),
                              child: Column(
                                children: [
                                  Center(
                                      child: Text(
                                    "Select a Reading Plan",
                                    style: TextStyle(fontFamily: 'Roboto Bold', fontSize: 22, color: Color(0xff3643a3)),
                                  )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(permiumbutton.length, (i) {
                                        if (i == 0) {
                                          mntVal = "1";
                                          mnth = "Month";
                                          clr = Colors.green[400];
                                          liGrdint = LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [Color(0xff099773), Color(0xff43B692)]);
                                        } else if (i == 1) {
                                          mntVal = "3";
                                          mnth = "Months";
                                          clr = Colors.red[400];
                                          liGrdint = LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [Color(0xffEF709B), Color(0xffF68080)]);
                                        } else {
                                          mntVal = "12";
                                          mnth = "Months";
                                          clr = Colors.amber[400];
                                          liGrdint = LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [Color(0xffF28E54), Color(0xffDFB668)]);
                                        }

                                        return Expanded(
                                            child: Padding(
                                          padding: permiumbutton.length == 1
                                              ? EdgeInsets.symmetric(horizontal: 114)
                                              : EdgeInsets.symmetric(horizontal: 4),
                                          child: InkWell(
                                            onTap: () {
                                              print("permiumbutton iddd===${permiumbutton[i].id}");
                                              print("permiumbutton tye===${permiumbutton[i].type}");

                                              sp.setSelectedSubsId(permiumbutton[i].id);
                                              sp.setSelectedSubsType(permiumbutton[i].type);

                                              print("index val===$i");
                                              pp.setSelectedContainer(i);
                                            },
                                            child: Container(
                                              height: 160,
                                              // color: Colors.amber,
                                              // padding: EdgeInsets.only(top: 0),
                                              child: Center(
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(top: 15, bottom: 10),
                                                      // height: 120,
                                                      height: pp.selectedSubsBox == i ? 148 : 138,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: pp.selectedSubsBox == i
                                                              ? Colors.black
                                                              : Color(0xff3643a3),
                                                          width: pp.selectedSubsBox == i ? 2.5 : 0,
                                                        ),
                                                        gradient: liGrdint,
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Container(
                                                            child: Center(child: Image.asset("assets/diamond.png")),
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              RichText(
                                                                text: TextSpan(children: <TextSpan>[
                                                                  TextSpan(
                                                                    text: mntVal + " " + mnth,
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 20.0,
                                                                        fontWeight: FontWeight.w600),
                                                                  )
                                                                ]),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                                                                child: Container(
                                                                  // color: Colors.amber,
                                                                  width: MediaQuery.of(context).size.width * .5,
                                                                  child: RichText(
                                                                    textAlign: TextAlign.center,
                                                                    text: TextSpan(children: <TextSpan>[
                                                                      TextSpan(
                                                                        text: "Subscription",
                                                                        style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: 15.0,
                                                                            fontWeight: FontWeight.w600),
                                                                      )
                                                                    ]),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              new Spacer(),
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(color: Colors.transparent),
                                                                  borderRadius: BorderRadius.only(
                                                                    bottomRight: Radius.circular(9.5),
                                                                    bottomLeft: Radius.circular(9.5),
                                                                  ),
                                                                  color: Colors.white,
                                                                ),
                                                                height: 40,
                                                                child: Center(
                                                                  child: RichText(
                                                                    text: TextSpan(children: <TextSpan>[
                                                                      TextSpan(
                                                                        text: "\$" + permiumbutton[i].amount,
                                                                        style: TextStyle(
                                                                            color: Color(0xff3643a3),
                                                                            fontSize: 18.0,
                                                                            
                                                                            fontWeight: FontWeight.w600),
                                                                      )
                                                                    ]),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    i == 2
                                                        ? Positioned(
                                                            top: 0,
                                                            right: 10,
                                                            left: 10,
                                                            // bottom: 100,
                                                            child: Container(
                                                              height: 28,
                                                              decoration: BoxDecoration(
                                                                gradient: LinearGradient(
                                                                    colors: [
                                                                      _colorfromhex('#3846A9'),
                                                                      _colorfromhex('#5265F8')
                                                                    ],
                                                                    begin: const FractionalOffset(0.0, 0.0),
                                                                    end: const FractionalOffset(1.0, 0.0),
                                                                    stops: [0.0, 1.0],
                                                                    tileMode: TileMode.clamp),
                                                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                                              ),
                                                              child: Center(
                                                                child: Text(
                                                                  "20% OFF",
                                                                  style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight.w400),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : SizedBox()
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ));
                                      })),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              "In each of the plan you will be have complete Access to Mock Tests, PathFinders, Video Library, Domains and Flash Cards to Duration selected in Reading plan",
                                          style: TextStyle(
                                              color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w400),
                                        )
                                      ]),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget ButtonRow2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          height: 40,
          decoration: BoxDecoration(color: Colors.indigo.shade600, borderRadius: BorderRadius.circular(30.0)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Buy Monthly Plan",
                style: TextStyle(fontFamily: 'Roboto Medium', fontSize: 16, color: Colors.white, letterSpacing: 0.3),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          height: 40,
          decoration: BoxDecoration(color: Colors.indigo.shade600, borderRadius: BorderRadius.circular(30.0)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Buy Yearly Plan",
                style: TextStyle(fontFamily: 'Roboto Medium', fontSize: 16, color: Colors.white, letterSpacing: 0.3),
              ),
            ),
          ),
        )
      ],
    );
  }
}

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<void> _handlePaymentSuccess2(BuildContext context) async {
  PurchaseProvider provider = Provider.of(context, listen: false);
  provider.updateStatusNew(isnav: true);

  /// success payment handle from backend side, after amount deduct from card
  // await paymentStatus("success");
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentStatus2(status: "success"),
      ));
}

Future<void> _handlePaymentError2(BuildContext context) async {
  //await paymentStatus("failed");
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentStatus(status: "failure"),
      ));
}

Widget BuyButton2(BuildContext context, PurchaseProvider purchaseProvider, int index1forFlash2forvideoLib, String type,
    int IdValue, int indexVal) {
  //index1forFlash2forvideoLib   1  for flash card and  2 for video Library
  print("type============$type");
  print("IdValue=============$IdValue");

  return Column(
    children: [
      Center(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.only(left: 0, right: 0),
          height: 40,
          // alignment: Alignment.center,
          decoration: BoxDecoration(
              // color: Colors.purple,
              // color: Colors.indigo.shade600,
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0)),
          child: OutlinedButton(
            onPressed: () async {
              //  IOS payment By Inn App Purchase
              if (Platform.isIOS) {
                print("buttonClicked ${purchaseProvider.products[0].id}");
                print("price ${purchaseProvider.products[0].price}");
                purchaseProvider.products.forEach((e) {
                  print("Product id => ${e.id}");
                  if (e.id == videoLibraryLearningPrograms && index1forFlash2forvideoLib == 2) {
                    purchaseProvider.buy(e);
                  } else if (e.id == flashCards && index1forFlash2forvideoLib == 1) {
                    purchaseProvider.buy(e);
                  }
                });
              } else {
                ////////android payment with stripe
                var token = await getToken();

                ProfileProvider profProvi = Provider.of(context, listen: false);
                await profProvi.callCreateOrder(IdValue, type);
                type = type.replaceAll(" ", "");

                String urll = CREATE_ORDER + "/$IdValue/$type";

                /// Payment implement with stripe
                bool status = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentAndroid(
                          token: token, statusFlash1videoLibrary2: index1forFlash2forvideoLib, urlll: urll),
                    ));
                print("statueeess====>>>$status");

                if (status) {
                  Navigator.pop(context);
                  _handlePaymentSuccess2(context);
                } else {
                  _handlePaymentError2(context);
                }

                /// Old implement for razorpay
                // if (mapResponse == null) {
                //   openCheckout(data["razorpay_key"], data["mock_test_price"],
                //       data["Currency"]);
                // } else {
                //   openCheckout(
                //       data["razorpay_key"],
                //       (data["mock_test_price"] -
                //               ((mapResponse["discount"] / 100) *
                //                   data["mock_test_price"]))
                //           .toInt(),
                //       data["Currency"]);
                // }
              }
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
            ),
            child: Text(
              'Buy Now',
              style: TextStyle(fontFamily: 'Roboto Medium', fontSize: 20, color: Color(0xff3643a3), letterSpacing: 0.3),
            ),
          ),
        ),
      ),

      //  Text(
      //                                           'Apply Coupon',
      //                                           style: TextStyle(
      //                                               fontFamily: 'Roboto Medium',
      //                                               fontSize: 20,
      //                                               color: Colors.indigo.shade600,
      //                                               letterSpacing: 0.3),
      //                                         ),

      SizedBox(
        height: 18,
      ),
      context.watch<PurchaseProvider>().loaderStatus ? CircularProgressIndicator() : SizedBox(),
      Platform.isIOS
          ? Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Purchased previously? ",
                    style: TextStyle(color: Colors.white),
                  ),
                  InkWell(
                    child: Text(
                      "Restore purchase",
                      style: TextStyle(
                          // color: Colors.blue
                          color: Colors.lightBlueAccent),
                    ),
                    onTap: () {
                      // provider.restore();
                    },
                  )
                ],
              ),
            )
          : Text("")
    ],
  );
}
