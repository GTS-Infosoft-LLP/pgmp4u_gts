import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pgmp4u/Models/constants.dart';
import 'package:pgmp4u/Screens/Profile/paymentstripe2.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:pgmp4u/provider/profileProvider.dart';
import 'package:pgmp4u/provider/purchase_provider.dart';
import 'package:pgmp4u/Screens/Profile/PaymentStatus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    print("perice value is===>> ${widget.price}");
    print("category idddd======${widget.categoryId}");
    print("categoryyy typeee======${widget.categoryType}");

    CourseProvider cp = Provider.of(context, listen: false);
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
      child: Scaffold(
          body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
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
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 30, bottom: 25),
                            child: Image.asset('assets/premium.png'),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Center(
                            child: widget.index == 1
                                ? Text(
                                    'Get Unlimited Access to Flash Card',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Roboto Bold',
                                        fontSize: width * (30 / 420),
                                        color: _colorfromhex("#3D4AB4"),
                                        letterSpacing: 0.3),
                                  )
                                : widget.index == 2
                                    ? Text(
                                        'Get Unlimited Access to Video Library',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Roboto Bold',
                                            fontSize: width * (30 / 420),
                                            color: _colorfromhex("#3D4AB4"),
                                            letterSpacing: 0.3),
                                      )
                                    : widget.index == 3
                                        ? Text(
                                            'Get Unlimited Access to Mock Tests',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: 'Roboto Bold',
                                                fontSize: width * (30 / 420),
                                                color: _colorfromhex("#3D4AB4"),
                                                letterSpacing: 0.3),
                                          )
                                        : widget.index == 4
                                            ? Text(
                                                'Get Unlimited Access to Chats',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontFamily: 'Roboto Bold',
                                                    fontSize: width * (30 / 420),
                                                    color: _colorfromhex("#3D4AB4"),
                                                    letterSpacing: 0.3),
                                              )
                                            : Text(
                                                'Get Unlimited Access to Pgmp Question of the day',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Roboto Bold',
                                                  fontSize: width * (30 / 420),
                                                  color: _colorfromhex("#3D4AB4"),
                                                ),
                                              )),
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(top: 20),
                      //   child: Center(
                      //     child: Text(
                      //       buttonPress == true
                      //           ? '${(data["mock_test_price"] - ((mapResponse["discount"] / 100) * data["mock_test_price"])).toInt()} \$'
                      //           : '${data["mock_test_price"]} \$',
                      //       textAlign: TextAlign.center,
                      //       style: TextStyle(
                      //           fontFamily: 'Roboto Bold',
                      //           fontSize: width * (44 / 420),
                      //           color: _colorfromhex("#3D4AB4"),
                      //           letterSpacing: 0.3),
                      //     ),
                      //   ),
                      // ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Center(
                            child:
                                // widget.index == 1
                                //     ?
                                Text(
                          'Lifetime Access On \n \$${widget.price}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Roboto Bold',
                              fontSize: 24,
                              color: _colorfromhex("#3D4AB4"),
                              letterSpacing: 0.3),
                        )
                            // : Text(
                            //     'Lifetime Access On \n \$${widget.price}',
                            //     textAlign: TextAlign.center,
                            //     style: TextStyle(
                            //         fontFamily: 'Roboto Bold',
                            //         fontSize: 24,
                            //         color: _colorfromhex("#3D4AB4"),
                            //         letterSpacing: 0.3),
                            //   ),
                            ),
                      ),
                      // mapResponse != null && buttonPress == false
                      //     ? Center(
                      //         child: Container(
                      //           margin: EdgeInsets.only(top: 20),
                      //           padding: EdgeInsets.only(
                      //               left: 15, right: 15),
                      //           height: 40,
                      //           // alignment: Alignment.center,
                      //           decoration: BoxDecoration(
                      //               color: _colorfromhex("#3A47AD"),
                      //               borderRadius:
                      //                   BorderRadius.circular(30.0)),
                      //           child: OutlinedButton(
                      //             onPressed: () => {
                      //               // setState(() => {buttonPress = true}),
                      //               print(mapResponse["discount"]),
                      //               if (mapResponse["discount"] == 100)
                      //                 {paymentStatus("success")}
                      //               else
                      //                 {
                      //                   setState(
                      //                       () => {buttonPress = true})
                      //                 }
                      //             },
                      //             style: ButtonStyle(
                      //               shape: MaterialStateProperty.all(
                      //                   RoundedRectangleBorder(
                      //                       borderRadius:
                      //                           BorderRadius.circular(
                      //                               30.0))),
                      //             ),
                      //             child: Text(
                      //               'Apply Coupon',
                      //               style: TextStyle(
                      //                   fontFamily: 'Roboto Medium',
                      //                   fontSize: 20,
                      //                   color: Colors.white,
                      //                   letterSpacing: 0.3),
                      //             ),
                      //           ),
                      //         ),
                      //       )
                      //     : Container(),
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
                          return BuyButton2(context, value, widget.index, cp.selectedMasterType, widget.categoryId);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
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

Widget BuyButton2(
    BuildContext context, PurchaseProvider purchaseProvider, int index1forFlash2forvideoLib, String type, int IdValue) {
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
              color: Colors.indigo.shade600,
              borderRadius: BorderRadius.circular(30.0)),
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

                String urll = "https://apivcarestage.vcareprojectmanagement.com/api/createOrder/$IdValue/$type";

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
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
            ),
            child: Text(
              'Buy Now',
              style: TextStyle(fontFamily: 'Roboto Medium', fontSize: 20, color: Colors.white, letterSpacing: 0.3),
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
        height: 32,
      ),
      context.watch<PurchaseProvider>().loaderStatus ? CircularProgressIndicator() : SizedBox(),
      Platform.isIOS
          ? Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Purchased previously? "),
                  InkWell(
                    child: Text(
                      "Restore purchase",
                      style: TextStyle(color: Colors.blue),
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
