import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

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

  Razorpay _razorpay;
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
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
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
  void openCheckout() async {
    var options = {
      'key': 'rzp_test_cjT5SUSriGCr6a',
      'amount': 1 * 100,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  Map mapResponse;
  Future apiCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print(stringValue);
    http.Response response;
    response = await http.get(
        Uri.parse("http://18.119.55.81:1010/api/CheckUserPaymentStatus"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': stringValue
        });

    if (response.statusCode == 200) {
      setState(() {
        mapResponse = convert.jsonDecode(response.body);
      });
      // print(convert.jsonDecode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    print(MediaQuery.of(context).padding.top);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        color: _colorfromhex("#FCFCFF"),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
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
                        Icon(
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
                        ),
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
            mapResponse != null
                ? Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        width: width,
                        margin: EdgeInsets.only(
                          top: height * (24 / 800),
                          bottom: height * (20 / 800),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: width * (21 / 420)),
                              child: Text(
                                'Dashboard',
                                style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  fontSize: width * (18 / 420),
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 25),
                              color: Colors.white,
                              padding:
                                  EdgeInsets.only(left: width * (30 / 420)),
                              child: Column(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              padding: EdgeInsets.all(17),
                                              decoration: BoxDecoration(
                                                  color:
                                                      _colorfromhex("#72A258"),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                child: Image.asset(
                                                    'assets/aapp.png'),
                                              ),
                                            ),
                                            Container(
                                              width: width / 4 ,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Get',
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto Medium',
                                                      fontSize:
                                                          width * (15 / 420),
                                                      color: _colorfromhex(
                                                          "#ABAFD1"),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Application Support',
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto Medium',
                                                      fontWeight: FontWeight.w500,
                                                      fontSize:
                                                          width * (18 / 420),
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: 35,
                                          margin: EdgeInsets.only(right: 8),
                                          // alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: _colorfromhex("#F0F0F0"),
                                              borderRadius:
                                                  BorderRadius.circular(30.0)),
                                          child: OutlinedButton(
                                            onPressed: () => {},
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0))),
                                            ),
                                            child: Text(
                                              "Coming soon",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto Medium',
                                                  fontSize: 13,
                                                  color:
                                                      _colorfromhex("#3846A9"),
                                                  letterSpacing: 0.3),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                height: 1,
                                width: width,
                                color: _colorfromhex("#E9E9E9")),
                            Container(
                              color: Colors.white,
                              padding:
                                  EdgeInsets.only(left: width * (30 / 420)),
                              child: Column(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              padding: EdgeInsets.all(17),
                                              decoration: BoxDecoration(
                                                  color:
                                                      _colorfromhex("#463B97"),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                child: Image.asset(
                                                    'assets/vedio.png'),
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Watch',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto Medium',
                                                    fontSize:
                                                        width * (15 / 420),
                                                    color: _colorfromhex(
                                                        "#ABAFD1"),
                                                  ),
                                                ),
                                                Text(
                                                  'Video Library',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto Medium',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        width * (18 / 420),
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: 35,
                                          margin: EdgeInsets.only(right: 8),
                                          // alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: _colorfromhex("#F0F0F0"),
                                              borderRadius:
                                                  BorderRadius.circular(30.0)),
                                          child: OutlinedButton(
                                            onPressed: () => {},
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0))),
                                            ),
                                            child: Text(
                                              "Coming soon",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto Medium',
                                                  fontSize: 13,
                                                  color:
                                                      _colorfromhex("#3846A9"),
                                                  letterSpacing: 0.3),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                height: 1,
                                width: width,
                                color: _colorfromhex("#E9E9E9")),
                            Container(
                              color: Colors.white,
                              padding:
                                  EdgeInsets.only(left: width * (30 / 420)),
                              child: Column(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              padding: EdgeInsets.all(17),
                                              decoration: BoxDecoration(
                                                  color:
                                                      _colorfromhex("#72A258"),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                child: Image.asset(
                                                    'assets/per.png'),
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Read',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto Medium',
                                                    fontSize:
                                                        width * (15 / 420),
                                                    color: _colorfromhex(
                                                        "#ABAFD1"),
                                                  ),
                                                ),
                                                Text(
                                                  'Flash cards',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto Medium',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        width * (18 / 420),
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: 35,
                                          margin: EdgeInsets.only(right: 8),
                                          // alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: _colorfromhex("#F0F0F0"),
                                              borderRadius:
                                                  BorderRadius.circular(30.0)),
                                          child: OutlinedButton(
                                            onPressed: () => {},
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0))),
                                            ),
                                            child: Text(
                                              "Coming soon",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto Medium',
                                                  fontSize: 13,
                                                  color:
                                                      _colorfromhex("#3846A9"),
                                                  letterSpacing: 0.3),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                height: 1,
                                width: width,
                                color: _colorfromhex("#E9E9E9")),
                            Container(
                              color: Colors.white,
                              padding:
                                  EdgeInsets.only(left: width * (30 / 420)),
                              child: Column(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              padding: EdgeInsets.all(17),
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              decoration: BoxDecoration(
                                                  color:
                                                      _colorfromhex("#463B97"),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                child: Image.asset(
                                                    'assets/domain.png'),
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Tips',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto Medium',
                                                    fontSize:
                                                        width * (15 / 420),
                                                    color: _colorfromhex(
                                                        "#ABAFD1"),
                                                  ),
                                                ),
                                                Text(
                                                  'Domain Wise',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto Medium',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        width * (18 / 420),
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: 35,
                                          margin: EdgeInsets.only(right: 8),
                                          // alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: _colorfromhex("#F0F0F0"),
                                              borderRadius:
                                                  BorderRadius.circular(30.0)),
                                          child: OutlinedButton(
                                            onPressed: () => {},
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0))),
                                            ),
                                            child: Text(
                                              "Coming soon",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto Medium',
                                                  fontSize: 13,
                                                  color:
                                                      _colorfromhex("#3846A9"),
                                                  letterSpacing: 0.3),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                height: 1,
                                width: width,
                                color: _colorfromhex("#E9E9E9")),
                            Container(
                              color: Colors.white,
                              padding:
                                  EdgeInsets.only(left: width * (30 / 420)),
                              child: Column(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              padding: EdgeInsets.all(17),
                                              decoration: BoxDecoration(
                                                  color:
                                                      _colorfromhex("#72A258"),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Center(
                                                child: Image.asset(
                                                    'assets/per.png'),
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Tests4U',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto Medium',
                                                    fontSize:
                                                        width * (15 / 420),
                                                    color: _colorfromhex(
                                                        "#ABAFD1"),
                                                  ),
                                                ),
                                                Text(
                                                  'Challenger',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto Medium',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        width * (18 / 420),
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: 35,
                                          margin: EdgeInsets.only(right: 8),
                                          // alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: _colorfromhex("#F0F0F0"),
                                              borderRadius:
                                                  BorderRadius.circular(30.0)),
                                          child: OutlinedButton(
                                            onPressed: () => {
                                              if (mapResponse["data"]
                                                      ["paid_status"] !=
                                                  1)
                                                {
                                                  Navigator.of(context)
                                                      .pushNamed('/payment')
                                                }
                                              else
                                                {
                                                  Navigator.of(context)
                                                      .pushNamed('/mock-test')
                                                }
                                            },
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0))),
                                            ),
                                            child: Text(
                                              "Access",
                                              style: TextStyle(
                                                  fontFamily: 'Roboto Medium',
                                                  fontSize: 13,
                                                  color:
                                                      _colorfromhex("#3846A9"),
                                                  letterSpacing: 0.3),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
