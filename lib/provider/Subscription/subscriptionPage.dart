import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:pgmp4u/provider/Subscription/subscriptionProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Screens/Profile/PaymentStatus.dart';
import '../../Screens/Profile/paymentstripe2.dart';
import '../../Screens/masterPage.dart';
import '../../components/subscriptionGreyBox.dart';
import '../../subscriptionModel.dart';
import '../courseProvider.dart';
import '../profileProvider.dart';
import '../purchase_provider.dart';

class Subscriptionpg extends StatefulWidget {
  const Subscriptionpg({Key key}) : super(key: key);

  @override
  State<Subscriptionpg> createState() => _SubscriptionpgState();
}

class _SubscriptionpgState extends State<Subscriptionpg> {
  String mntVal;
  String mnth;
  String mnths = "Months";
  var hw;
  Color clr;
  LinearGradient liGrdint;
  @override
  void initState() {
    ProfileProvider pp = Provider.of(context, listen: false);
    SubscriptionProvider sp = Provider.of(context, listen: false);
    sp.setSelectedIval(2);
    print("sp.selectedIval====${sp.selectedIval}");
    print("sp.SubscritionPackList[2].description======${sp.SubscritionPackList[2].description}");

    print("selevted sub type===${sp.selectedSubsType}");
    // hw = MediaQuery.of(context).size;
    if (permiumbutton.length == 3) {
      print("this is true");
      pp.setSelectedContainer(2);
      sp.selectedSubsId = 3;
      sp.setSelectedSubsType(permiumbutton[2].type);
    } else {
      pp.setSelectedContainer(5);
      sp.setSelectedSubsType(permiumbutton.length + 1);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * .13,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0, left: 15, right: 15),
              child: InkWell(
                onTap: () async {
                  SubscriptionProvider sp = Provider.of(context, listen: false);
                  sp.createSubscritionOrder(sp.selectedSubsId);
                  var token = await getTokenn();
                  ProfileProvider pp = Provider.of(context, listen: false);

                  print(" selectedSubsType ====${sp.selectedSubsType}");
                  print("permiumbutton.length===${permiumbutton.length}");
                  if (sp.selectedSubsType > permiumbutton.length) {
                    GFToast.showToast(
                      'Please select Plan',
                      context,
                      toastPosition: GFToastPosition.CENTER,
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
                        colors: [Color.fromARGB(255, 87, 101, 222), Color.fromARGB(255, 87, 101, 222)]),
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
            InkWell(
              onTap: () {
                CourseProvider cp = Provider.of(context, listen: false);
                cp.getMasterData(cp.selectedCourseId);
                Navigator.push(context, MaterialPageRoute(builder: (context) => MasterListPage()));
              },
              child: Text(
                "OR Skip to Freemium",
                style: TextStyle(
                    color: Colors.black, fontSize: 20, fontFamily: 'Roboto Medium', fontWeight: FontWeight.w100),
              ),
            ),
            SizedBox(
              height: 15,
            )
          ],
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
                          height: MediaQuery.of(context).size.height * .40,
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
                                      Navigator.pop(context);
                                      CourseProvider courseProvider = Provider.of(context, listen: false);
                                      courseProvider.getCourse();
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
                                    child: Text(
                                      "Membership",
                                      style: TextStyle(color: Colors.white, fontFamily: 'Roboto Bold', fontSize: 20),
                                    ),
                                  ),
                                  Text(
                                    "      ",
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                              Center(
                                child: Container(
                                    height: MediaQuery.of(context).size.height * .30,
                                    child: Icon(
                                      Icons.diamond,
                                      color: Colors.transparent,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Container(
                            child: Center(child: Image.asset("assets/diamond.png")),
                          ),
                        )
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
              padding: const EdgeInsets.only(top: 175.0),
              child: Center(
                child: Column(
                  children: [
                    Consumer<SubscriptionProvider>(builder: (context, sp, child) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          // color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        width: MediaQuery.of(context).size.width * 0.80,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Column(children: [
                          Container(
                            // color: Colors.amber,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: 7,
                                    itemBuilder: (context, index) {
                                      return customGreyRedRow(
                                          FontAwesomeIcons.tableColumns,
                                          sp.SubscritionPackList[sp.selectedIval].description[index] ?? "",
                                          context,
                                          index);
                                    })),
                          ),
                        ]),
                      );
                    }),
                    SizedBox(height: 15),
                    Consumer2<ProfileProvider, SubscriptionProvider>(builder: (context, pp, sp, child) {
                      return sp.getSubsPackApiCall
                          ? Center(child: CircularProgressIndicator.adaptive())
                          : Padding(
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
                                              //selectedI

                                              sp.setSelectedIval(i);
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
                                                                        fontWeight: FontWeight.w600
                                                                        ),
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
                                                                            fontWeight: FontWeight.w600
                                                                            ),
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
                                                                            fontWeight: FontWeight.w600
                                                                            ),
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
                                                                      fontWeight: FontWeight.w400
                                                                      ),
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


                                  // Radio(
                                  //   value: value, 
                                  //   groupValue: groupValue,
                                  //   onChanged: (val){
                                  //   print("valuee val===${val}");
                                    
                                  //   }
                                  //   ),
                              
                             

                            

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
                              ));
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePaymentSuccess2(BuildContext context) async {
    PurchaseProvider provider = Provider.of(context, listen: false);
    CourseProvider cp = Provider.of(context, listen: false);
    provider.updateStatusNew(isnav: true);
    print("insidee the payment success");
    cp.getCourse();

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
}
