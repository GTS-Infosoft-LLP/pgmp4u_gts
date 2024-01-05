import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pgmp4u/Screens/dropdown.dart';
import 'package:pgmp4u/provider/Subscription/subscriptionProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../Screens/MockTest/model/courseModel.dart';
import '../../Screens/Profile/PaymentStatus.dart';
import '../../Screens/Profile/paymentstripe2.dart';
import '../../Screens/masterPage.dart';
import '../../components/planDescBox.dart';
import '../../subscriptionModel.dart';
import '../courseProvider.dart';
import '../profileProvider.dart';

class Subscriptionpg extends StatefulWidget {
  int showFreeTrial;
  int showDrpDown;
  int isFromUpgrdePlan;
  String title;
  int quntity;
  Subscriptionpg(
      {Key key, this.showFreeTrial = 0, this.showDrpDown = 0, this.isFromUpgrdePlan = 0, this.title = "", this.quntity})
      : super(key: key);

  @override
  State<Subscriptionpg> createState() => _SubscriptionpgState();
}

class _SubscriptionpgState extends State<Subscriptionpg> {
  String mntVal;
  String mnth;
  String subsPack;
  String subsTime;
  String mnths = "Months";
  String subTimeDur;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _value = -1;

  LinearGradient liGrdint;
  @override
  void initState() {
    ProfileProvider pp = Provider.of(context, listen: false);
    SubscriptionProvider sp = Provider.of(context, listen: false);
    pp.updateLoader(false);
    sp.updateLoader(false);

    Future.delayed(Duration(milliseconds: 200), () {
      if (sp.durationPackData.isNotEmpty && widget.showFreeTrial == 0) {
        // sp.setSelectedRadioVal(0);
      }
      // sp.selectedIval = 2;
      // pp.setSelectedContainer(2);
    });
    // print("widget isShowDrpDown====${widget.showDrpDown}");
    // sp.setSelectedIval(2);
    if (permiumbutton.length > 2) {
      // print("permiumbutton[2].id${permiumbutton[2].id}");
      sp.setSelectedSubsId(permiumbutton[2].id);
    }

    sp.selectedIval = 2;
    if (sp.durationPackData.isNotEmpty && widget.showFreeTrial != 1) {
      // sp.setSelectedRadioVal(0);
    }
    if (permiumbutton.length == 3) {
      print("this is true");
      // pp.setSelectedContainer(2);
      sp.selectedSubsId = 3;
      sp.setSelectedSubsType(permiumbutton[2].type);
    } else {
      pp.setSelectedContainer(5);
      sp.setSelectedSubsType(permiumbutton.length + 1);
    }

    if (sp.SubscritionPackList.isEmpty) {
      sp.selectedIval = 10;
    }

    // print("sp.selectedIval:::;${sp.selectedIval}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: widget.showFreeTrial == 1
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    SubscriptionProvider sp = Provider.of(context, listen: false);
                    CourseProvider cp = Provider.of(context, listen: false);
                    sp.freeSubscription(cp.selectedCourseId).then((value) {
                      try {} catch (e) {
                        print("errror in pop statement===$e");
                      }
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color.fromARGB(255, 87, 101, 222), Color.fromARGB(255, 87, 101, 222)]),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Center(
                      child: Text(
                        "Start Free Trial",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ))
            : Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * .13,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0, left: 15, right: 15),
                        child: InkWell(
                          onTap: () async {
                            ShowSubsConfrm(context);
                          },
                          child: Consumer<SubscriptionProvider>(builder: (context, sp, child) {
                            return sp.SubscritionPackList.isNotEmpty
                                ? Container(
                                    width: MediaQuery.of(context).size.width * .9,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color.fromARGB(255, 87, 101, 222),
                                            Color.fromARGB(255, 87, 101, 222)
                                          ]),
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Center(
                                        child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                text: "Subscribe Now",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontFamily: 'Roboto Bold',
                                                ),
                                              ),
                                            ]))),
                                  )
                                : SizedBox();
                          }),
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            CourseProvider cp = Provider.of(context, listen: false);
                            cp.getMasterData(cp.selectedCourseId);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MasterListPage()));
                          },
                          child: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                  text: "OR Skip to Freemium",
                                  style: TextStyle(
                                      color: Colors.black87.withOpacity(0.8),
                                      fontSize: 18,
                                      fontFamily: 'Roboto Medium',
                                      fontWeight: FontWeight.w400),
                                ),
                              ]))),
                      SizedBox(
                        height: 1.5,
                      )
                    ],
                  ),
                ),
              ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .9,
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .30,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(28),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height * .07,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        CourseProvider courseProvider = Provider.of(context, listen: false);
                                        courseProvider.getCourse();
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 18.0),
                                        child: Icon(
                                          Icons.west,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Center(
                                        child: RichText(
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                text: "Subscriptions",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontFamily: 'Roboto Bold',
                                                ),
                                              ),
                                            ]))),
                                    Text("         ")
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                widget.isFromUpgrdePlan == 1
                                    ? Container(
                                        width: MediaQuery.of(context).size.width * .9,
                                        child: RichText(
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            text: TextSpan(children: <TextSpan>[
                                              TextSpan(
                                                text: widget.quntity == null
                                                    ? "You are not subscribed to any plan"
                                                    : "You are currently subscribed to ${widget.title}- ${widget.quntity * 30} days plan ",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ])),
                                      )
                                    : SizedBox(),
                                widget.showDrpDown == 1
                                    ? Container(
                                        width: MediaQuery.of(context).size.width * .65,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                          child: Consumer<CourseProvider>(builder: (context, crs, child) {
                                            return CustomDropDown<CourseDetails>(
                                              selectText: crs.selectedCourseLable ?? "Select",
                                              itemList: crs.course ?? [],
                                              isEnable: true,
                                              title: "",
                                              value: null,
                                              onChange: (val) {
                                                crs.setSelectedCourseLable(val.lable);
                                                crs.setSelectedCourseId(val.id);
                                                SubscriptionProvider sp = Provider.of(context, listen: false);
                                                ProfileProvider pp = Provider.of(context, listen: false);
                                                pp.updateLoader(true);
                                                sp.getSubscritionData(val.id);
                                                pp.updateLoader(false);
                                              },
                                            );
                                          }),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Expanded(
                      flex: 4,
                      child: Container(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: widget.showDrpDown == 1
                    ? const EdgeInsets.only(top: 195.0)
                    : widget.isFromUpgrdePlan == 1
                        ? const EdgeInsets.only(top: 145.0)
                        : const EdgeInsets.only(top: 105.0),
                child: Center(
                  child: Column(
                    children: [
                      Consumer<SubscriptionProvider>(builder: (context, sp, child) {
                        if (sp.SubscritionPackList.isEmpty) {
                          sp.selectedIval = 10;
                        } else {
                          sp.selectedIval = 2;
                        }

                        if (sp.selectedIval == 0) {
                          return planDescBox(
                              context, "Silver Plan", sp.ftchList, sp.ftchList.length, sp.selectedSubsType);
                        } else if (sp.selectedIval == 1) {
                          return planDescBox(
                              context, "Gold Plan", sp.ftchList, sp.ftchList.length, sp.selectedSubsType);
                        } else if (sp.selectedIval == 2) {
                          return planDescBox(
                              context, "Platinum Plan", sp.ftchList, sp.ftchList.length, sp.selectedSubsType);
                        } else {
                          return SizedBox();
                        }
                      }),

                      SizedBox(
                        height: 10,
                      ),

                      Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 15),
                          child: Column(
                            children: [
                              Consumer<SubscriptionProvider>(builder: (context, sp, child) {
                                return sp.SubscritionPackList.isNotEmpty
                                    ? Center(
                                        child: RichText(
                                            text: TextSpan(children: <TextSpan>[
                                        TextSpan(
                                          text: "Select a Subscription Plan",
                                          style: TextStyle(
                                              color: Color(0xff3643a3), fontSize: 22, fontFamily: 'Roboto Bold'),
                                        ),
                                      ])))
                                    : SizedBox();
                              }),
                              SizedBox(
                                height: 6,
                              ),
                              Consumer2<SubscriptionProvider, ProfileProvider>(builder: (context, sp, pp, child) {
                                return sp.getSubsPackApiCall
                                    ? Center(
                                        child: Container(
                                          height: MediaQuery.of(context).size.height * .6,
                                          child: Center(
                                              child: RichText(
                                                  text: TextSpan(children: <TextSpan>[
                                            TextSpan(
                                              text: "Loading..",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ]))),
                                        ),
                                      )
                                    : sp.SubscritionPackList.isEmpty
                                        ? Center(
                                            child: Container(
                                              height: MediaQuery.of(context).size.height * .6,
                                              child: Center(
                                                  child: RichText(
                                                      text: TextSpan(children: <TextSpan>[
                                                TextSpan(
                                                  text: "No Plans Available...",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ]))),
                                            ),
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
                                                mntVal = "30";
                                                mnth = "Days";

                                                liGrdint = LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [Color(0xff099773), Color(0xff43B692)]);
                                              } else if (i == 1) {
                                                mntVal = "60";
                                                mnth = "Days";

                                                liGrdint = LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [Color(0xffEF709B), Color(0xffF68080)]);
                                              } else {
                                                mntVal = "90";
                                                mnth = "Days";
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
                                                    if (widget.showFreeTrial == 1) {
                                                      pp.updateLoader(false);
                                                      sp.updateLoader(false);
                                                    } else {
                                                      sp.setSelectedIval(i);
                                                      sp.setSelectedSubsId(permiumbutton[i].id);
                                                      sp.setSelectedSubsType(permiumbutton[i].type);
                                                      sp.setSelectedPlanType(permiumbutton[i].type);
                                                      // print("index val===$i");
                                                      pp.setSelectedContainer(i);
                                                      pp.updateLoader(false);
                                                      sp.updateLoader(false);
                                                    }
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
                                                                  child:
                                                                      Center(child: Image.asset("assets/diamond.png")),
                                                                ),
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    SizedBox(
                                                                      height: 35,
                                                                    ),
                                                                    Center(
                                                                      child: RichText(
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
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(15)),
                                                                    ),
                                                                    child: Center(
                                                                        child: RichText(
                                                                            overflow: TextOverflow.ellipsis,
                                                                            maxLines: 2,
                                                                            text: TextSpan(children: <TextSpan>[
                                                                              TextSpan(
                                                                                text: "20% OFF",
                                                                                style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 15,
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
                                            }));
                              }),
                              Consumer<SubscriptionProvider>(builder: (context, sp, child) {
                                // print("sp.durationPackData lenght===${sp.durationPackData}");
                                return Wrap(
                                  direction: Axis.horizontal,
                                  children: [
                                    for (int i = 0; i < sp.durationPackData.length; i++)
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
                                              await sp.setSelectedPlanType(1);
                                              CourseProvider cp = Provider.of(context, listen: false);
                                              await sp.getSubscritionData(cp.selectedCourseId);
                                              if (widget.showFreeTrial == 1) {
                                                ProfileProvider pp = Provider.of(context, listen: false);
                                                pp.updateLoader(false);
                                              } else {
                                                sp.setSelectedRadioVal(i);
                                                sp.setSelectedIval(0);
                                                sp.setSelectedSubsType(permiumbutton[0].type);
                                                sp.setSelectedSubsType(1);
                                                print("");
                                                ProfileProvider pp = Provider.of(context, listen: false);
                                                pp.setSelectedContainer(0);
                                                await sp.setSelectedDurTimeQt(sp.durationPackData[i].durationType,
                                                    sp.durationPackData[i].durationQuantity);
                                                CourseProvider cp = Provider.of(context, listen: false);
                                                pp.updateLoader(false);
                                                sp.updateLoader(false);
                                              }
                                            },
                                            child: RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(children: <TextSpan>[
                                                TextSpan(
                                                  text: (sp.durationPackData[i].durationQuantity * 30).toString() +
                                                      " Days",
                                                  style: TextStyle(
                                                      color: i == sp.radioSelected ? Colors.white : Colors.black,
                                                      fontSize: 11.0,
                                                      fontWeight: FontWeight.w800),
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                  //     }
                                );
                              }),
                              SizedBox(
                                height: 10,
                              ),
                              Consumer<SubscriptionProvider>(builder: (context, sp, child) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Html(
                                    data: sp.desc1 ?? "",
                                    onAnchorTap: (url, ctx, attributes, element) async {
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
                                        color: Colors.black87.withOpacity(0.8),
                                        textAlign: TextAlign.left,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Roboto Medium',
                                        fontSize: FontSize(16),
                                      )
                                    },
                                  ),
                                );
                              }),
                            ],
                          ))
                      // }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        // }),
        );
  }

  Future<void> _handlePaymentSuccess2(BuildContext context) async {
    // PurchaseProvider provider = Provider.of(context, listen: false);
    CourseProvider cp = Provider.of(context, listen: false);
    // provider.updateStatusNew(isnav: true);
    // print("insidee the payment success");
    cp.getCourse().whenComplete(() {
      Navigator.pop(context);
    });

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

  Future<String> getTokenn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  void showContainer() {
// return Container(child: ,);
  }

  void ShowSubsConfrm(BuildContext context) {
    showDialog(
        context: _scaffoldKey.currentContext,
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
                          text: "Are you sure you want to purchase subscription for this course?",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Roboto Medium',
                              fontWeight: FontWeight.w200),
                        ),
                      ]))
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            height: 35,
                            width: MediaQuery.of(context).size.width * .15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                gradient: LinearGradient(
                                    colors: [Colors.grey, Colors.grey],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(1.0, 0.0),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp)),
                            child: Center(
                              child: RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                    text: "No",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                                  )
                                ]),
                              ),
                            ))),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        bool result = await checkInternetConn();
                        print("result internet  $result");
                        if (result) {
                          SubscriptionProvider sp = Provider.of(context, listen: false);

                          var token = await getTokenn();

                          print(" selectedSubsType ====${sp.selectedSubsType}");
                          print("permiumbutton.length===${permiumbutton.length}");
                          if (sp.selectedSubsType > permiumbutton.length) {
                            GFToast.showToast(
                              'Please select Plan',
                              context,
                              toastPosition: GFToastPosition.CENTER,
                            );
                          } else {
                            Navigator.pop(context);
                            await sp.createSubscritionOrder(sp.selectedSubsId);
                            print("sp.alredyPurchase::::${sp.alredyPurchase}");

                            if (sp.alredyPurchase == 0) {
                              print("final url:::::${sp.finUrl}");
                              bool status = await Navigator.push(
                                  _scaffoldKey.currentContext,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PaymentAndroid(token: token, statusFlash1videoLibrary2: 1, urlll: sp.finUrl),
                                  ));

                              print("statueeess====>>>$status");

                              if (status) {
                                _handlePaymentSuccess2(context);

                                print("sucess value is trueeeeeeee");
                                CourseProvider courseProvider = Provider.of(_scaffoldKey.currentContext, listen: false);
                                courseProvider.getCourse();
                                Navigator.pop(_scaffoldKey.currentContext);
                              } else {
                                _handlePaymentError2(context);
                              }
                            }
                          }
                        } else {
                          EasyLoading.showInfo("Please check your Internet Connection");
                        }
                      },
                      child: Container(
                        height: 35,
                        width: MediaQuery.of(context).size.width * .15,
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
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: "Yes",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
                              )
                            ]),
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

  Future checkInternetConn() async {
    bool result = await InternetConnectionChecker().hasConnection;
    print("result while call fun $result");
    if (result == false) {
      Future.delayed(Duration(seconds: 1), () async {});
      return result;
    } else {}
    return result;
  }
}
