import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:pgmp4u/provider/Subscription/subscriptionProvider.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/profileProvider.dart';
import '../provider/purchase_provider.dart';
import '../subscriptionModel.dart';
import 'Profile/PaymentStatus.dart';
import 'Profile/paymentstripe2.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  String mntVal;
  String mnth;
  String mnths = "Months";

  @override
  void initState() {
    ProfileProvider pp = Provider.of(context, listen: false);
    pp.setSelectedContainer(13);
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15),
          child: InkWell(
            onTap: () async {
              SubscriptionProvider sp = Provider.of(context, listen: false);
              sp.createSubscritionOrder(sp.selectedSubsId);
              var token = await getTokenn();
              ProfileProvider pp = Provider.of(context, listen: false);

              print(" selectedSubsBox ====${sp.selectedSubsId}");
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
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: MediaQuery.of(context).size.height * .45,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xff3643a3), Color(0xff5468ff)]),
              borderRadius: BorderRadius.all(Radius.circular(28)),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
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
                SizedBox(
                  height: 25,
                ),
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height * .26,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/subsImage.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
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
                : Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 20),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(permiumbutton.length, (i) {
                              if (i == 0) {
                                mntVal = "1";
                                mnth = "Month";
                              } else if (i == 1) {
                                mntVal = "3";
                                mnth = "Months";
                              } else {
                                mntVal = "12";
                                mnth = "Months";
                              }

                              return Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: InkWell(
                                  onTap: () {
                                    print("permiumbutton tye===${permiumbutton[i].id}");
                                    sp.setSelectedSubsId(permiumbutton[i].id);

                                    print("index val===$i");
                                    pp.setSelectedContainer(i);
                                  },
                                  child: Container(
                                    height: 185,
                                    // width: MediaQuery.of(context).size.width * .40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: pp.selectedSubsBox == i ? Color(0xff3643a3) : Colors.grey[300],
                                        width: pp.selectedSubsBox == i ? 4 : 2,
                                      ),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),

                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 0,
                                          color: Color(0xff3643a3),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          mntVal,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'Roboto Bold',
                                              fontSize: 42,
                                              color: Color(0xff3643a3),
                                              // pp.selectedSubsBox == i
                                              //     ? Colors.white
                                              //     : Color.fromARGB(255, 87, 101, 222),
                                              letterSpacing: 0.3),
                                        ),
                                        Text(
                                          mnth,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              // fontFamily: 'Roboto Bold',
                                              fontSize: 22,
                                              color: Color(0xff3643a3),
                                              // pp.selectedSubsBox == i
                                              //     ? Colors.white
                                              //     : Color.fromARGB(255, 87, 101, 222),
                                              letterSpacing: 0.3),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          permiumbutton[i].name,
                                          maxLines: 2,
                                          overflow: TextOverflow.fade,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              // fontFamily: 'Roboto Bold',
                                              fontSize: 18,
                                              color: Colors.grey,
                                              letterSpacing: 0.3),
                                        ),
                                        new Spacer(),
                                        Text(
                                          "\$" + permiumbutton[i].amount,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'Roboto Bold',
                                              fontSize: 18,
                                              color: Color(0xff3643a3),
                                              // color: pp.selectedSubsBox == i
                                              //     ? Colors.white
                                              //     : Color.fromARGB(255, 87, 101, 222),
                                              letterSpacing: 0.3),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                            })),
                      ],
                    ));
          }),
          SizedBox(
            height: 10,
          )
        ])));
  }

  Future<String> getTokenn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
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
}
