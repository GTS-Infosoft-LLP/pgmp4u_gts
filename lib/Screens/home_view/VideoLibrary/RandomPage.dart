import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pgmp4u/provider/purchase_provider.dart';
import 'package:pgmp4u/Screens/Profile/PaymentStatus.dart';

class RandomPage extends StatefulWidget {
  @override
  _RandomPageState createState() => _RandomPageState();
}

class _RandomPageState extends State<RandomPage> {
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
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
                                    margin:
                                        EdgeInsets.only(top: 30, bottom: 25),
                                    child: Image.asset('assets/premium.png'),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: Center(
                                  child: Text(
                                    'Get Unlimited Access to Pgmp Success Stories',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Roboto Bold',
                                        fontSize: width * (30 / 420),
                                        color: _colorfromhex("#3D4AB4"),
                                        letterSpacing: 0.3),
                                  ),
                                ),
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
                                  child: Text(
                                    'Lifetime Access',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Roboto Bold',
                                        fontSize: 24,
                                        color: _colorfromhex("#3D4AB4"),
                                        letterSpacing: 0.3),
                                  ),
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
                              // Consumer<PurchaseProvider>(
                              //   builder: (context, value, child) {
                              //     var latestState =
                              //         value.serverResponse.getContent();
                              //     if (latestState is Loading) {
                              //       return Center(
                              //           child: CircularProgressIndicator());
                              //     }

                              //     if (latestState is Default) {
                              //       value.showToast(
                              //           context, latestState.message);
                              //     }

                              //     print(
                              //         "value.serverResponse = ${latestState is Success}");
                              //     if (latestState is Success) {
                              //       print("Pop called");
                              //       Future.delayed(Duration.zero, () async {
                              //         Navigator.pop(context, true);
                              //       });
                              //     }
                              //     return BuyButtons(data);
                              //   },
                              // )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
      ),
    );
 
  }
}