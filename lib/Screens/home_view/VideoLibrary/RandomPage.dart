import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:pgmp4u/Screens/Profile/paymentstripe2.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:pgmp4u/provider/profileProvider.dart';
import 'package:pgmp4u/provider/purchase_provider.dart';
import 'package:pgmp4u/Screens/Profile/PaymentStatus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../Models/constants.dart';
import '../../../provider/Subscription/subscriptionProvider.dart';
import '../../../subscriptionModel.dart';

///   1> flash
///   2> video
///   3> mock
///   4> chat
///   5> PPT
///   6> domain
/// ///   7> process
class RandomPage extends StatefulWidget {
  int index;
  String price;
  int categoryId;
  String categoryType;
  String name;

  RandomPage({this.index = 0, this.price = "\$199", this.categoryId, this.categoryType, this.name = ""});
  @override
  _RandomPageState createState() => _RandomPageState();
}

class _RandomPageState extends State<RandomPage> {
  String subsPack;

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
    print("name>>>>>>${widget.name}");
    ProfileProvider pp = Provider.of(context, listen: false);
    CourseProvider cp = Provider.of(context, listen: false);
    SubscriptionProvider sp = Provider.of(context, listen: false);
    sp.SelectedPlanType = 3;
    pp.setSelectedContainer(2);
    sp.setSelectedIval(2);
    calllApi();

    print("widget category typeee====${widget.categoryType}");

    print("perice value is===>> ${widget.price}");
    print("category idddd======${widget.categoryId}");
    print("categoryyy typeee======${widget.categoryType}");

    // CourseProvider cp = Provider.of(context, listen: false);
    print("cp.selectedMasterType==============${cp.selectedMasterType}");

    if (widget.price == null) {
      widget.price = "199";
    } else if (widget.price.contains("\$")) {
      print("widget.price.contains  \$");
      widget.price = widget.price.replaceAll("\$", "");
      print("final price:::: ${widget.price}");
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
      child: Consumer<CourseProvider>(builder: (context, cp, value) {
        return Scaffold(
          bottomNavigationBar: (cp.isInAppPurchaseOn == 1 && Platform.isIOS)
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
                  child: InkWell(
                    onTap: () async {
                      SubscriptionProvider sp = Provider.of(context, listen: false);
                      ProfileProvider pp = Provider.of(context, listen: false);
                      CourseProvider cp = Provider.of(context, listen: false);
                      sp.createSubscritionOrder(sp.selectedSubsId);
                      var token = await getToken();
                      print("sp.selectedSubsId::::${sp.selectedSubsType}");
                      print("permiumbutton.length::::${permiumbutton.length}");

                      if (sp.selectedSubsType > permiumbutton.length) {
                        GFToast.showToast(
                          'Please select Plan',
                          context,
                          toastPosition: GFToastPosition.BOTTOM,
                        );
                      } else {
                        PurchaseProvider purchaseProvider = Provider.of(context, listen: false);

                        if (Platform.isIOS) {
                          if (cp.isInAppPurchaseOn == 1) {
                            print("buttonClicked ${purchaseProvider.products[0].id}");
                            print("price ${purchaseProvider.products[0].price}");
                            purchaseProvider.products.forEach((e) {
                              print("Product id => ${e.id}");
                              print("product price>>>${e.price}");
                              // print("index1forFlash2forvideoLib>>>>>$index1forFlash2forvideoLib");
                              var index1forFlash2forvideoLib = 2;
                              if (e.id == videoLibraryLearningPrograms && index1forFlash2forvideoLib == 2) {
                                print("we are noew be calling buy function...");
                                purchaseProvider.buy(e);
                              } else if (e.id == flashCards && index1forFlash2forvideoLib == 1) {
                                purchaseProvider.buy(e);
                              }
                            });
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
                          child: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              // textAlign: TextAlign.center,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                  text: "Subscribe Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Roboto Bold',
                                    // fontWeight: FontWeight.w400
                                  ),
                                ),
                              ]))
                          //     Text(
                          //   "Subscribe Now",
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //     fontFamily: 'Roboto Bold',
                          //     fontSize: 20),
                          // )
                          ),
                    ),
                  ),
                ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .43,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(25.0),
                          bottomLeft: Radius.circular(25.0),
                        ),
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

                                        widget.name.isEmpty
                                            ? SizedBox()
                                            : Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                                                child: Center(
                                                  child: RichText(
                                                      textAlign: TextAlign.center,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(
                                                          text: widget.name,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25,
                                                            fontFamily: 'Roboto Bold',
                                                            // fontWeight: FontWeight.w600,
                                                            // letterSpacing: 0.3,
                                                          ),
                                                        ),
                                                      ])),
                                                ),
                                              ),
                                        Container(
                                          margin: EdgeInsets.only(left: 20, right: 20, top: 8),
                                          child: Center(
                                              child: widget.index == 1
                                                  ? RichText(
                                                      textAlign: TextAlign.center,
                                                      text: TextSpan(children: <TextSpan>[
                                                        TextSpan(
                                                          text: 'Get 1 year Access to Flash Card \non',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25,
                                                            fontFamily: 'Roboto Bold',
                                                            letterSpacing: 0.3,
                                                          ),
                                                        ),
                                                      ]))
                                                  : widget.index == 2
                                                      ? RichText(
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                          textAlign: TextAlign.center,
                                                          text: TextSpan(children: <TextSpan>[
                                                            TextSpan(
                                                              text: 'Get 1 year Access to Video Library \non',
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                // fontSize: width * (30 / 420),
                                                                fontSize: 25,
                                                                fontFamily: 'Roboto Bold',
                                                                // fontWeight: FontWeight.w600,
                                                                letterSpacing: 0.3,
                                                              ),
                                                            ),
                                                          ]))
                                                      : widget.index == 3
                                                          ? RichText(
                                                              textAlign: TextAlign.center,
                                                              text: TextSpan(children: <TextSpan>[
                                                                TextSpan(
                                                                  text: 'Get 1 year Access to Mock Tests \non',
                                                                  style: TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 25,
                                                                    fontFamily: 'Roboto Bold',
                                                                    // fontWeight: FontWeight.w600,
                                                                    letterSpacing: 0.3,
                                                                  ),
                                                                ),
                                                              ]))
                                                          : widget.index == 4
                                                              ? RichText(
                                                                  textAlign: TextAlign.center,
                                                                  text: TextSpan(children: <TextSpan>[
                                                                    TextSpan(
                                                                      text: 'Get 1 year Access to Chats \non',
                                                                      style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 25,
                                                                        fontFamily: 'Roboto Bold',
                                                                        // fontWeight: FontWeight.w600,
                                                                        letterSpacing: 0.3,
                                                                      ),
                                                                    ),
                                                                  ]))
                                                              : widget.index == 5
                                                                  ? RichText(
                                                                      textAlign: TextAlign.center,
                                                                      text: TextSpan(children: <TextSpan>[
                                                                        TextSpan(
                                                                          text: 'Get 1 year Access to PTT \non',
                                                                          style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: 25,
                                                                            fontFamily: 'Roboto Bold',
                                                                            // fontWeight: FontWeight.w600,
                                                                            letterSpacing: 0.3,
                                                                          ),
                                                                        ),
                                                                      ]))
                                                                  : widget.index == 6
                                                                      ? RichText(
                                                                          overflow: TextOverflow.ellipsis,
                                                                          maxLines: 2,
                                                                          textAlign: TextAlign.center,
                                                                          text: TextSpan(children: <TextSpan>[
                                                                            TextSpan(
                                                                              text: 'Get 1 year Access to Domains \non',
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 25,
                                                                                fontFamily: 'Roboto Bold',
                                                                                // fontWeight: FontWeight.w600,
                                                                                letterSpacing: 0.3,
                                                                              ),
                                                                            ),
                                                                          ]))
                                                                      : widget.index == 7
                                                                          ? RichText(
                                                                              textAlign: TextAlign.center,
                                                                              text: TextSpan(children: <TextSpan>[
                                                                                TextSpan(
                                                                                  text:
                                                                                      'Get 1 year Access to Process \non',
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 25,
                                                                                    fontFamily: 'Roboto Bold',
                                                                                    // fontWeight: FontWeight.w600,
                                                                                    letterSpacing: 0.3,
                                                                                  ),
                                                                                ),
                                                                              ]))
                                                                          : RichText(
                                                                              textAlign: TextAlign.center,
                                                                              text: TextSpan(children: <TextSpan>[
                                                                                TextSpan(
                                                                                  text:
                                                                                      'Get 1 year Access to Question of the day \non',
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 25,
                                                                                    fontFamily: 'Roboto Bold',
                                                                                    // fontWeight: FontWeight.w600,
                                                                                    letterSpacing: 0.3,
                                                                                  ),
                                                                                ),
                                                                              ]))),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Center(
                                              child: RichText(
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  // textAlign: TextAlign.center,
                                                  text: TextSpan(children: <TextSpan>[
                                                    TextSpan(
                                                      text: '\$${widget.price}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                        fontFamily: 'Roboto Bold',
                                                        // fontWeight: FontWeight.w400
                                                      ),
                                                    ),
                                                  ]))),
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
                                            return BuyButton2(context, value, widget.index, widget.categoryType,
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
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: Center(
                              child:

                                  //     Text(
                                  //   cp.isInAppPurchaseOn == 1 && Platform.isIOS ? "" : "OR",
                                  //   style: TextStyle(
                                  //     fontSize: 18,
                                  //     color: Colors.black,
                                  //     fontFamily: 'Roboto Bold',
                                  //   ),
                                  // ),
                                  RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      // textAlign: TextAlign.center,
                                      text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                          text: cp.isInAppPurchaseOn == 1 && Platform.isIOS ? "" : "OR",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Roboto Bold',
                                            // fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ]))),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                // Center(
                //     child: Text(
                //   "Select a plan",
                //   style: TextStyle(
                //     fontFamily: 'Roboto Bold',
                //     fontSize: 22,
                //   ),
                // )),
                // SizedBox(
                //   height: 25,
                // ),

                Consumer3<ProfileProvider, SubscriptionProvider, CourseProvider>(builder: (context, pp, sp, cp, child) {
                  return (cp.isInAppPurchaseOn == 1 && Platform.isIOS)
                      ? SizedBox()
                      : SingleChildScrollView(
                          child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 15),
                              child: Column(
                                children: [
                                  Center(
                                      child:
                                          //     Text(
                                          //   "Select a Subscription Plan",
                                          //   style: TextStyle(
                                          //     fontFamily: 'Roboto Bold',
                                          //     fontSize: 22,
                                          //      color: Color(0xff3643a3)),
                                          // )

                                          RichText(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              // textAlign: TextAlign.center,
                                              text: TextSpan(children: <TextSpan>[
                                                TextSpan(
                                                  text: "Select a Subscription Plan",
                                                  style: TextStyle(
                                                    color: Color(0xff3643a3),
                                                    fontSize: 22,
                                                    fontFamily: 'Roboto Bold',
                                                    // fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                              ]))),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  permiumbutton.length == 0
                                      ? Padding(
                                          padding: const EdgeInsets.only(top: 38.0),
                                          child: Center(
                                              child:
                                                  //     Text(
                                                  //   "No Plans Found....",
                                                  //   style: TextStyle(
                                                  //     fontSize: 16,
                                                  //      fontWeight: FontWeight.w500),
                                                  // )
                                                  RichText(
                                                      // overflow: TextOverflow.ellipsis,
                                                      // maxLines: 2,
                                                      // textAlign: TextAlign.center,
                                                      text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                              text: "No Plans Found....",
                                              style: TextStyle(
                                                  // color: Color(0xff3643a3),
                                                  fontSize: 16,
                                                  // fontFamily: 'Roboto Bold',
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ]))),
                                        )
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(permiumbutton.length, (i) {
                                            if (permiumbutton[i].type == 1) {
                                              subsPack = "Silver";
                                            } else if (permiumbutton[i].type == 2) {
                                              subsPack = "Gold";
                                            } else if (permiumbutton[i].type == 3) {
                                              subsPack = "Platinum";
                                            }
                                            if (i == 0) {
                                              mntVal = "1";
                                              mnth = "Month";

                                              liGrdint = LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [Color(0xff099773), Color(0xff43B692)]);
                                            } else if (i == 1) {
                                              mntVal = "3";
                                              mnth = "Months";

                                              liGrdint = LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [Color(0xffEF709B), Color(0xffF68080)]);
                                            } else {
                                              mntVal = "12";
                                              mnth = "Months";

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
                                                  sp.setSelectedIval(i);

                                                  sp.setSelectedSubsId(permiumbutton[i].id);
                                                  sp.setSelectedSubsType(permiumbutton[i].type);
                                                  sp.setSelectedPlanType(permiumbutton[i].type);

                                                  print("index val===$i");
                                                  pp.setSelectedContainer(i);
                                                },
                                                child: Container(
                                                  height: 160,
                                                  child: Center(
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(top: 15, bottom: 10),
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
                                                                        // text: mntVal + " " + mnth,
                                                                        text: subsPack,
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
                                                                    padding:
                                                                        const EdgeInsets.symmetric(horizontal: 1.0),
                                                                    child: Container(
                                                                      width: MediaQuery.of(context).size.width * .5,
                                                                      child: RichText(
                                                                        textAlign: TextAlign.center,
                                                                        text: TextSpan(children: <TextSpan>[
                                                                          TextSpan(
                                                                            text: "",
                                                                            //   text: "",
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
                                                                      child:
                                                                          // Text(
                                                                          //   "20% OFF",
                                                                          //   style: TextStyle(
                                                                          //       color: Colors.white,
                                                                          //       fontSize: 15,
                                                                          //       fontWeight: FontWeight.w400),
                                                                          // ),

                                                                          RichText(
                                                                              // overflow: TextOverflow.ellipsis,
                                                                              // maxLines: 2,
                                                                              // textAlign: TextAlign.center,
                                                                              text: TextSpan(children: <TextSpan>[
                                                                    TextSpan(
                                                                      text: "20% OFF",
                                                                      style: TextStyle(
                                                                          color: Colors.white,
                                                                          fontSize: 15,
                                                                          // fontFamily: 'Roboto Bold',
                                                                          fontWeight: FontWeight.w400),
                                                                    ),
                                                                  ]))),
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

                                  Wrap(
                                    direction: Axis.horizontal,
                                    children: [
                                      for (int i = 0;
                                          i < sp.durationPackData.length;
                                          // permiumbutton.length;

                                          i++)
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: SizedBox(
                                            height: 36,
                                            width: 81,
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(4),
                                                  )),
                                                  backgroundColor: MaterialStateProperty.all<Color>(
                                                      i == sp.radioSelected ? Color(0xff3643a3) : Colors.white)),
                                              onPressed: () async {
                                                sp.setSelectedPlanType(1);
                                                print("vaue of i::::   $i");
                                                sp.setSelectedRadioVal(i);
                                                sp.setSelectedIval(0);
                                                sp.setSelectedSubsType(permiumbutton[0].type);
                                                print("");

                                                ProfileProvider pp = Provider.of(context, listen: false);
                                                pp.setSelectedContainer(0);
                                                await sp.setSelectedDurTimeQt(sp.durationPackData[i].durationType,
                                                    sp.durationPackData[i].durationQuantity);

                                                CourseProvider cp = Provider.of(context, listen: false);
                                              },
                                              child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(children: <TextSpan>[
                                                  TextSpan(
                                                    text: (sp.durationPackData[i].durationQuantity * 30).toString() +
                                                        " Days",
                                                    style: TextStyle(
                                                        color: i == sp.radioSelected ? Colors.white : Colors.black,
                                                        fontSize: 10.0,
                                                        fontWeight: FontWeight.w800),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          ),
                                        )
                                    ],
                                    //     }
                                  ),

                                  ///**************************************
                                  // SingleChildScrollView(
                                  //   scrollDirection: Axis.horizontal,
                                  //   physics: BouncingScrollPhysics(),
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  //     child: Row(
                                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //         mainAxisSize: MainAxisSize.min,
                                  //         children: List.generate(permiumbutton.length, (i) {
                                  //           String nameVal;
                                  //           if (i == 0) {
                                  //             subsTime = "1 Month";
                                  //           } else if (i == 1) {
                                  //             subsTime = "3 Months";
                                  //           } else if (i == 2) {
                                  //             subsTime = "6 Months";
                                  //           }
                                  //           return Row(
                                  //             children: [
                                  //               Text(
                                  //                 subsTime,
                                  //                 style: TextStyle(
                                  //                     fontSize: 14,
                                  //                     fontWeight: FontWeight.w600,
                                  //                     color: sp.radioSelected == i ? Color(0xff3643a3) : Colors.black),
                                  //               ),
                                  //               Radio(
                                  //                   value: i,
                                  //                   groupValue: _value,
                                  //                   activeColor: Color(0xff3643a3),
                                  //                   onChanged: (val) {
                                  //                     print("val====$val");
                                  //                     setState(() {
                                  //                       _value = val;
                                  //                       sp.setSelectedRadioVal(val);
                                  //                     });
                                  //                   }),
                                  //             ],
                                  //           );
                                  //         })),
                                  //   ),
                                  // ),

                                  ///**************************************

                                  /// dropdown month select

                                  // Consumer<CourseProvider>(builder: (context, cp, child) {
                                  //   return Container(
                                  //     height: 40,
                                  //     // width: MediaQuery.of(context).size.width * .25,
                                  //     decoration: BoxDecoration(
                                  //         border: Border.all(color: Colors.black, width: 2),
                                  //         boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 0))],
                                  //         color: Colors.lightBlue[100],
                                  //         borderRadius: BorderRadius.circular(28)),
                                  //     child: DropdownButton(
                                  //       value: cp.selectedTimeSubs,
                                  //       items: cp.subsTime.map((String items) {
                                  //         return DropdownMenuItem(
                                  //           value: items,
                                  //           child: Container(
                                  //               margin: EdgeInsets.only(top: 8.0),
                                  //               // width: double.maxFinite,
                                  //               child: Padding(
                                  //                 padding: const EdgeInsets.only(bottom: 9.0, left: 8, right: 8),
                                  //                 child: Text(
                                  //                   items,
                                  //                   textAlign: TextAlign.left,
                                  //                   style: TextStyle(
                                  //                       // color: Colors.orange,
                                  //                       fontSize: 15,
                                  //                       fontWeight: FontWeight.bold),
                                  //                 ),
                                  //               )),
                                  //         );
                                  //       }).toList(),
                                  //       underline: const SizedBox(),
                                  //       onChanged: (val) {
                                  //         print("val==-=-=-=-=-  $val");
                                  //         cp.setSelectedSubsTime(val);
                                  //       },
                                  //       dropdownColor: Colors.white,
                                  //     ),
                                  //   );
                                  // }),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Html(
                                      // data: "",
                                      data: sp.desc1.toString(),
                                      onAnchorTap: (url, ctx, attributes, element) async {
                                        print("anchor url : $url");
                                        Uri uri = Uri.parse(url);
                                        if (await canLaunchUrlString(url)) {
                                          await launchUrlString(url, mode: LaunchMode.externalApplication);
                                        } else {
                                          GFToast.showToast(
                                            "Can not launch this url",
                                            context,
                                            toastPosition: GFToastPosition.BOTTOM,
                                          );
                                        }
                                      },
                                      style: {
                                        "body": Style(
                                          padding: EdgeInsets.only(top: 5),
                                          margin: EdgeInsets.zero,
                                          color: Color(0xff000000),
                                          textAlign: TextAlign.left,
                                          fontWeight: FontWeight.w400,
                                          fontSize: FontSize(18),
                                        )
                                      },
                                    ),
                                  ),
                                ],
                              )),
                        );
                }),

                // Consumer2<ProfileProvider, SubscriptionProvider>(builder: (context, pp, sp, child) {
                //   return sp.getSubsPackApiCall
                //       ? Center(child: CircularProgressIndicator.adaptive())
                //       : SingleChildScrollView(
                //           child: Container(
                //             // color: Colors.amber,
                //             child: Padding(
                //                 padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 15),
                //                 child: Column(
                //                   children: [
                //                     Center(
                //                         child: Text(
                //                       "Select a Reading Plan",
                //                       style: TextStyle(fontFamily: 'Roboto Bold', fontSize: 22, color: Color(0xff3643a3)),
                //                     )),
                //                     SizedBox(
                //                       height: 10,
                //                     ),
                //                     Row(
                //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                         mainAxisSize: MainAxisSize.min,
                //                         children: List.generate(permiumbutton.length, (i) {
                //                           if (i == 0) {
                //                             mntVal = "1";
                //                             mnth = "Month";
                //                             clr = Colors.green[400];
                //                             liGrdint = LinearGradient(
                //                                 begin: Alignment.topLeft,
                //                                 end: Alignment.bottomRight,
                //                                 colors: [Color(0xff099773), Color(0xff43B692)]);
                //                           } else if (i == 1) {
                //                             mntVal = "3";
                //                             mnth = "Months";
                //                             clr = Colors.red[400];
                //                             liGrdint = LinearGradient(
                //                                 begin: Alignment.topLeft,
                //                                 end: Alignment.bottomRight,
                //                                 colors: [Color(0xffEF709B), Color(0xffF68080)]);
                //                           } else {
                //                             mntVal = "12";
                //                             mnth = "Months";
                //                             clr = Colors.amber[400];
                //                             liGrdint = LinearGradient(
                //                                 begin: Alignment.topLeft,
                //                                 end: Alignment.bottomRight,
                //                                 colors: [Color(0xffF28E54), Color(0xffDFB668)]);
                //                           }

                //                           return Expanded(
                //                               child: Padding(
                //                             padding: permiumbutton.length == 1
                //                                 ? EdgeInsets.symmetric(horizontal: 114)
                //                                 : EdgeInsets.symmetric(horizontal: 4),
                //                             child: InkWell(
                //                               onTap: () {
                //                                 print("permiumbutton iddd===${permiumbutton[i].id}");
                //                                 print("permiumbutton tye===${permiumbutton[i].type}");

                //                                 sp.setSelectedSubsId(permiumbutton[i].id);
                //                                 sp.setSelectedSubsType(permiumbutton[i].type);

                //                                 print("index val===$i");
                //                                 pp.setSelectedContainer(i);
                //                               },
                //                               child: Container(
                //                                 height: 160,
                //                                 // color: Colors.amber,
                //                                 // padding: EdgeInsets.only(top: 0),
                //                                 child: Center(
                //                                   child: Stack(
                //                                     children: [
                //                                       Container(
                //                                         margin: EdgeInsets.only(top: 15, bottom: 10),
                //                                         // height: 120,
                //                                         height: pp.selectedSubsBox == i ? 148 : 138,
                //                                         decoration: BoxDecoration(
                //                                           border: Border.all(
                //                                             color: pp.selectedSubsBox == i
                //                                                 ? Colors.black
                //                                                 : Color(0xff3643a3),
                //                                             width: pp.selectedSubsBox == i ? 2.5 : 0,
                //                                           ),
                //                                           gradient: liGrdint,
                //                                           borderRadius: BorderRadius.all(Radius.circular(10)),
                //                                         ),
                //                                         child: Stack(
                //                                           children: [
                //                                             Container(
                //                                               child: Center(child: Image.asset("assets/diamond.png")),
                //                                             ),
                //                                             Column(
                //                                               mainAxisAlignment: MainAxisAlignment.start,
                //                                               children: [
                //                                                 SizedBox(
                //                                                   height: 15,
                //                                                 ),
                //                                                 RichText(
                //                                                   text: TextSpan(children: <TextSpan>[
                //                                                     TextSpan(
                //                                                       text: mntVal + " " + mnth,
                //                                                       style: TextStyle(
                //                                                           color: Colors.white,
                //                                                           fontSize: 20.0,
                //                                                           fontWeight: FontWeight.w600),
                //                                                     )
                //                                                   ]),
                //                                                 ),
                //                                                 SizedBox(
                //                                                   height: 5,
                //                                                 ),
                //                                                 Padding(
                //                                                   padding: const EdgeInsets.symmetric(horizontal: 1.0),
                //                                                   child: Container(
                //                                                     // color: Colors.amber,
                //                                                     width: MediaQuery.of(context).size.width * .5,
                //                                                     child: RichText(
                //                                                       textAlign: TextAlign.center,
                //                                                       text: TextSpan(children: <TextSpan>[
                //                                                         TextSpan(
                //                                                           text: "Subscription",
                //                                                           style: TextStyle(
                //                                                               color: Colors.white,
                //                                                               fontSize: 15.0,
                //                                                               fontWeight: FontWeight.w600),
                //                                                         )
                //                                                       ]),
                //                                                     ),
                //                                                   ),
                //                                                 ),
                //                                                 SizedBox(
                //                                                   height: 5,
                //                                                 ),
                //                                                 new Spacer(),
                //                                                 Container(
                //                                                   decoration: BoxDecoration(
                //                                                     border: Border.all(color: Colors.transparent),
                //                                                     borderRadius: BorderRadius.only(
                //                                                       bottomRight: Radius.circular(9.5),
                //                                                       bottomLeft: Radius.circular(9.5),
                //                                                     ),
                //                                                     color: Colors.white,
                //                                                   ),
                //                                                   height: 40,
                //                                                   child: Center(
                //                                                     child: RichText(
                //                                                       text: TextSpan(children: <TextSpan>[
                //                                                         TextSpan(
                //                                                           text: "\$" + permiumbutton[i].amount,
                //                                                           style: TextStyle(
                //                                                               color: Color(0xff3643a3),
                //                                                               fontSize: 18.0,

                //                                                               fontWeight: FontWeight.w600),
                //                                                         )
                //                                                       ]),
                //                                                     ),
                //                                                   ),
                //                                                 ),
                //                                               ],
                //                                             ),
                //                                           ],
                //                                         ),
                //                                       ),
                //                                       i == 2
                //                                           ? Positioned(
                //                                               top: 0,
                //                                               right: 10,
                //                                               left: 10,
                //                                               // bottom: 100,
                //                                               child: Container(
                //                                                 height: 28,
                //                                                 decoration: BoxDecoration(
                //                                                   gradient: LinearGradient(
                //                                                       colors: [
                //                                                         _colorfromhex('#3846A9'),
                //                                                         _colorfromhex('#5265F8')
                //                                                       ],
                //                                                       begin: const FractionalOffset(0.0, 0.0),
                //                                                       end: const FractionalOffset(1.0, 0.0),
                //                                                       stops: [0.0, 1.0],
                //                                                       tileMode: TileMode.clamp),
                //                                                   borderRadius: BorderRadius.all(Radius.circular(15)),
                //                                                 ),
                //                                                 child: Center(
                //                                                   child: Text(
                //                                                     "20% OFF",
                //                                                     style: TextStyle(
                //                                                         color: Colors.white,
                //                                                         fontSize: 15,
                //                                                         fontWeight: FontWeight.w400),
                //                                                   ),
                //                                                 ),
                //                                               ),
                //                                             )
                //                                           : SizedBox()
                //                                     ],
                //                                   ),
                //                                 ),
                //                               ),
                //                             ),
                //                           ));
                //                         })),
                //                     SizedBox(
                //                       height: 10,
                //                     ),
                //                     Padding(
                //                       padding: const EdgeInsets.symmetric(horizontal: 4.0),
                //                       child: RichText(
                //                         textAlign: TextAlign.center,
                //                         text: TextSpan(children: <TextSpan>[
                //                           TextSpan(
                //                             text:
                //                                 "In each of the plan you will be have complete Access to Mock Tests, PathFinders, Video Library, Domains and Flash Cards to Duration selected in Reading plan",
                //                             style: TextStyle(
                //                                 color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w400),
                //                           )
                //                         ]),
                //                       ),
                //                     ),
                //                   ],
                //                 )),
                //           ),
                //         );
                // }),
              ],
            ),
          ),
        );
      }),
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

  Future<void> calllApi() async {
    ProfileProvider pp = Provider.of(context, listen: false);
    CourseProvider cp = Provider.of(context, listen: false);
    SubscriptionProvider sp = Provider.of(context, listen: false);
    print("");

    if (cp.crsDropList.isEmpty) {
      print("inside this condition:::::::");
      if (cp.selectedCourseId.toString().isEmpty) {
        cp.setSelectedCourseId(cp.course[0].id);
      }

      print("selected iddddddd=====${cp.selectedCourseId}");
      await sp.setSelectedDurTimeQt(0, 0, isFirtTime: 1);
      if (sp.durationPackData.isNotEmpty) {
        sp.setSelectedRadioVal(0);
      }

      // sp.getSubscritionData(cp.course[0].id);
    } else {
      print("selected idddd:::::${cp.selectedCourseId}");
      await sp.setSelectedDurTimeQt(0, 0, isFirtTime: 1);
      if (sp.durationPackData.isNotEmpty) {
        sp.setSelectedRadioVal(0);
      }

      // sp.getSubscritionData(cp.selectedCourseId);
    }
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
                print("platform::::$Platform");
                if (Platform.isIOS) {
                  print("print that platform is apppleeeeee");
                }

                CourseProvider cp = Provider.of(context, listen: false);

                if (Platform.isIOS) {
                  if (cp.isInAppPurchaseOn == 1) {
                    print("buttonClicked ${purchaseProvider.products[0].id}");
                    print("price ${purchaseProvider.products[0].price}");
                    purchaseProvider.products.forEach((e) {
                      print("Product id => ${e.id}");
                      print("product price>>>${e.price}");
                      print("index1forFlash2forvideoLib>>>>>$index1forFlash2forvideoLib");
                      index1forFlash2forvideoLib = 2;
                      if (e.id == videoLibraryLearningPrograms && index1forFlash2forvideoLib == 2) {
                        print("we are noew be calling buy function...");
                        purchaseProvider.buy(e);
                      } else if (e.id == flashCards && index1forFlash2forvideoLib == 1) {
                        purchaseProvider.buy(e);
                      }
                    });
                  } else {
                    var token = await getToken();

                    ProfileProvider profProvi = Provider.of(context, listen: false);
                    await profProvi.callCreateOrder(IdValue, type);
                    type = type.replaceAll(" ", "");

                    String urll = CREATE_ORDER + "/$IdValue/$type";
                    log("create order api=====$urll");
                    // log("");

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
                  }
                } else {
                  print("platform is android so no issuesssss");
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
              child:
                  // Text(
                  //   'Buy Now',
                  //   style: TextStyle(
                  //     fontFamily: 'Roboto Medium',
                  //      fontSize: 20,
                  //       color: Color(0xff3643a3),
                  //       letterSpacing: 0.3),
                  // ),

                  RichText(
                      // overflow: TextOverflow.ellipsis,
                      // maxLines: 2,
                      // textAlign: TextAlign.center,
                      text: TextSpan(children: <TextSpan>[
                TextSpan(
                  text: 'Buy Now',
                  style: TextStyle(
                    color: Color(0xff3643a3),
                    fontSize: 20,
                    fontFamily: 'Roboto Bold',
                    // fontWeight: FontWeight.w400
                  ),
                ),
              ]))),
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
        height: 10,
      ),
      context.watch<PurchaseProvider>().loaderStatus ? CircularProgressIndicator() : SizedBox(),
      Platform.isIOS
          ? Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   "Purchased previously? ",
                    //   style: TextStyle(color: Colors.white),
                    // ),

                    RichText(
                        // overflow: TextOverflow.ellipsis,
                        // maxLines: 2,
                        // textAlign: TextAlign.center,
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: "Purchased previously? ",
                        style: TextStyle(color: Colors.white
                            // fontSize: 20,
                            // fontFamily: 'Roboto Medium',
                            // fontWeight: FontWeight.w400
                            ),
                      ),
                    ])),

                    InkWell(
                      child:
                          // Text(
                          //   "Restore purchase",
                          //   style: TextStyle(
                          //       color: Colors.lightBlueAccent),
                          // ),
                          RichText(
                              // overflow: TextOverflow.ellipsis,
                              // maxLines: 2,
                              // textAlign: TextAlign.center,
                              text: TextSpan(children: <TextSpan>[
                        TextSpan(
                          text: "Restore purchase",
                          style: TextStyle(color: Colors.lightBlueAccent
                              // fontSize: 20,
                              // fontFamily: 'Roboto Medium',
                              // fontWeight: FontWeight.w400
                              ),
                        ),
                      ])),
                      onTap: () {
                        // provider.restore();
                      },
                    )
                  ],
                ),
              ),
            )
          : Text("")
    ],
  );
}
