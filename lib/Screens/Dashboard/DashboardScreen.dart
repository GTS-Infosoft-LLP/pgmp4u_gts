import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pgmp4u/Screens/Profile/paymentScreen.dart';
import 'package:pgmp4u/Screens/Tests/testsScreen.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/utils/appimage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class DashboardScreen extends StatefulWidget {
  final Function selectedId;

  DashboardScreen({
    this.selectedId,
  });

  @override
  _DashboardScreenState createState() =>
      _DashboardScreenState(selectedIdNew: this.selectedId);
}

class _DashboardScreenState extends State<DashboardScreen> {
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  static const platform = const MethodChannel("razorpay_flutter");

  // Razorpay _razorpay;
  final Function selectedIdNew;

  _DashboardScreenState({
    this.selectedIdNew,
  });
  final databaseRef = FirebaseDatabase.instance.reference();

  void addData() {
    databaseRef.push().set({'name': 'data', 'comment': 'A good season'});
  }

  void printFirebase() {
    print("object");
    databaseRef.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
  }

  String photoUrl;
  String displayName;
  Future<bool> _onWillPop() async {
    // return (await showDialog(
    //       context: context,
    //       builder: (context) => new AlertDialog(
    //         title: new Text('Are you sure?'),
    //         content: new Text('Do you want to exit an App'),
    //         actions: <Widget>[
    //           TextButton(
    //             onPressed: () => Navigator.of(context).pop(false),
    //             child: new Text('No'),
    //           ),
    //           TextButton(
    //             onPressed: () =>
    //                 SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
    //             child: new Text('Yes'),
    //           ),
    //         ],
    //       ),
    //     )) ??
    //     false;
  }

  getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('photo');

    print(stringValue);
    setState(() {
      photoUrl = stringValue;
      displayName = prefs.getString('name');
    });
  }

  @override
  void initState() {
    super.initState();
    // _razorpay = Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getValue();
    addData();
    apiCall();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('data new come success');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('data new come');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}
  // void openCheckout() async {
  //   var options = {
  //     'key': 'rzp_test_cjT5SUSriGCr6a',
  //     'amount': 1 * 100,
  //     'name': 'Acme Corp.',
  //     'description': 'Fine T-Shirt',
  //     'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
  //     'external': {
  //       'wallets': ['paytm']
  //     }
  //   };

  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     debugPrint('Error: e');
  //   }
  // }

  Map mapResponse;
  Future apiCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print(stringValue);
    http.Response response;
    response = await http.get(Uri.parse(CHECK_USER_PAYMENT_STATUS), headers: {
      'Content-Type': 'application/json',
      'Authorization': stringValue
    });

    //response i.e {success: true, cnt: 0, data: {paid_status: 0}}
    if (response.statusCode == 200) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        setState(() {
          mapResponse = convert.jsonDecode(response.body);
        });
      });
      // print(convert.jsonDecode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
      var isPremium = mapResponse != null && mapResponse.containsKey("data")
        ? mapResponse["data"]["paid_status"] == 1
        : false;
    print(MediaQuery.of(context).padding.top);
    return Scaffold(
      
      body:
      // WillPopScope(
        //  onWillPop: _onWillPop,
          //child:
           Sizer(builder: (context, orientation, deviceType) {
            return Container(
              color: _colorfromhex("#F7F7FA"),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height:  180,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(40.0)),
                      gradient: LinearGradient(
                          colors: [
                            _colorfromhex('#3846A9'),
                            _colorfromhex('#5265F8')
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: width * (20 / 420),
                              right: width * (20 / 420),
                              top: height * (16 / 800)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /* Icon(
                            Icons.menu,
                            size: width * (24 / 420),
                            color: Colors.white,
                          ),
                          Row(
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.only(right: width * (16 / 420)),
                                child: Icon(
                                  Icons.search,
                                  size: width * (24 / 420),
                                  color: Colors.white,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => {},
                                child: Icon(
                                  Icons.notifications,
                                  size: width * (24 / 420),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),*/
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: height * (30 / 800),
                              left: width * (28 / 420),
                              right: width * (34 / 420)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 7),
                                    child: Row(
                                      children: [
                                       InkWell(
                                         onTap: (){Navigator.pop(context);},
                                       child: Icon(Icons.arrow_back_ios,color: Colors.white,)),
                                        Text(
                                          'Hello, ',
                                          style: TextStyle(
                                            fontFamily: 'Roboto Regular',
                                            fontSize: width * (16 / 420),
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          displayName != null ? displayName : '',
                                          style: TextStyle(
                                            fontFamily: 'Roboto Bold',
                                            fontSize: width * (16 / 420),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Find a test you',
                                        style: TextStyle(
                                          fontFamily: 'Roboto Bold',
                                          fontSize: width * (20 / 420),
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'want to learn',
                                        style: TextStyle(
                                          fontFamily: 'Roboto Bold',
                                          fontSize: width * (20 / 420),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              photoUrl != null && photoUrl != ""
                                  ? Container(
                                      width: width * (80 / 420),
                                      height: width * (80 / 420),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(photoUrl),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(80),
                                      ),
                                    )
                                  : Container(
                                      width: width * (80 / 420),
                                      height: width * (80 / 420),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(80),
                                      ),
                                    )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  mapResponse != null ? TestsScreen(
                    isPremium: isPremium,
                  ) : Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.35)
                    ,child: Center(child: CircularProgressIndicator.adaptive()))
                ],
              ),
            );
            
          
          }
          //)
          ),

    );
  }
}
