import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class SettingsScreen extends StatefulWidget {
  final phoneNumber;

  final emailData;
  SettingsScreen({this.phoneNumber, this.emailData});

  @override
  _SettingsScreenState createState() => _SettingsScreenState(
      phoneNumberNew: this.phoneNumber, emailDataNew: this.emailData);
}

class _SettingsScreenState extends State<SettingsScreen> {
  final phoneNumberNew;
  final emailDataNew;

  _SettingsScreenState({this.phoneNumberNew, this.emailDataNew});
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  void initState() {
    super.initState();
    apiCall();
  }

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

    if (response.statusCode == 200) {
      print("responseseses ${response.body}");
      setState(() {
        mapResponse = convert.jsonDecode(response.body);
        print("Check Payment Status Res => ${mapResponse}");
      });
      // print(convert.jsonDecode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Stack(
      children: [
        
        Container(
          height: 149,
          width: width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg_layer.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          color: _colorfromhex("#ABAFD1").withOpacity(0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Container(
                margin: EdgeInsets.only(
                    left: width * (20 / 420),
                    right: width * (20 / 420),
                    top: height * (16 / 800)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => {Navigator.of(context).pop()},
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: width * (24 / 420),
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '  Settings',
                          style: TextStyle(
                              fontFamily: 'Roboto Medium',
                              fontSize: width * (18 / 420),
                              color: Colors.white,
                              letterSpacing: 0.3),
                        ),
                      ],
                    ),
                  
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              mapResponse != null
                  ? Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              // Container(
                              //   margin: EdgeInsets.only(
                              //       left: width * (18 / 420),
                              //       right: width * (18 / 420)),
                              //   child: Text(
                              //     'Settings',
                              //     style: TextStyle(
                              //         fontFamily: 'Roboto Bold',
                              //         fontSize: width * (18 / 420),
                              //         color: Colors.black,
                              //         letterSpacing: 0.3),
                              //   ),
                              // ),
                             
                              Container(
                                margin: EdgeInsets.only(bottom: 6, top: 20),
                                padding: EdgeInsets.only(
                                    top: 18,
                                    bottom: 15,
                                    left: width * (18 / 420),
                                    right: width * (18 / 420)),
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.home,
                                          size: width * (30 / 420),
                                          color: _colorfromhex("#ABAFD1"),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: width * (20 / 420)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Text(
                                                  'Name',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto Medium',
                                                    fontSize: width * (18 / 420),
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 5),
                                                child: Text(
                                                  phoneNumberNew??"",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'Roboto Regular',
                                                    fontSize:
                                                        width * (18 / 420),
                                                    color: _colorfromhex(
                                                        "#ABAFD1"),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                     
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                             
                              // Container(
                              //   margin: EdgeInsets.only(bottom: 6, top: 5),
                              //   padding: EdgeInsets.only(
                              //       top: 18,
                              //       bottom: 15,
                              //       left: width * (18 / 420),
                              //       right: width * (18 / 420)),
                              //   color: Colors.white,
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Row(
                              //         children: [
                              //           Icon(
                              //             Icons.home,
                              //             size: width * (30 / 420),
                              //             color: _colorfromhex("#ABAFD1"),
                              //           ),
                              //           Container(
                              //             margin: EdgeInsets.only(
                              //                 left: width * (20 / 420)),
                              //             child: Column(
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment.start,
                              //               crossAxisAlignment:
                              //                   CrossAxisAlignment.start,
                              //               children: [
                              //                 Container(
                              //                   child: Text(
                              //                     'Email',
                              //                     style: TextStyle(
                              //                       fontFamily: 'Roboto Medium',
                              //                       fontSize:
                              //                           width * (18 / 420),
                              //                       color: Colors.black,
                              //                     ),
                              //                   ),
                              //                 ),
                              //                 Container(
                              //                   margin: EdgeInsets.only(top: 5),
                              //                   child: Text(
                              //                     emailDataNew == ""
                              //                         ? "none"
                              //                         : emailDataNew,
                              //                     style: TextStyle(
                              //                       fontFamily:
                              //                           'Roboto Regular',
                              //                       fontSize:
                              //                           width * (18 / 420),
                              //                       color: _colorfromhex(
                              //                           "#ABAFD1"),
                              //                     ),
                              //                   ),
                              //                 )
                              //               ],
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     ],
                              //   ),
                              // ),
                             
                              mapResponse["data"]["paid_status"] != 1
                                  ? GestureDetector(
                                      onTap: () =>
                                          {_navigateAndRefresh(context)},
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(bottom: 6, top: 5),
                                        padding: EdgeInsets.only(
                                            top: 18,
                                            bottom: 15,
                                            left: width * (18 / 420),
                                            right: width * (18 / 420)),
                                        color: Colors.white,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.home,
                                                  size: width * (30 / 420),
                                                  color:
                                                      _colorfromhex("#ABAFD1"),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: width * (20 / 420)),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          'Get Premium',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto Medium',
                                                            fontSize: width *
                                                                (18 / 420),
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                              optionList(width, "Push Notification",
                                  showSwitch: true),
                              optionList(width, "Support"),
                              optionList(width, "Rate Us"),
                            
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              _colorfromhex("#4849DF")),
                        ),
                      )),
            
          
            ],
          ),
        ),
      
      ],
    ));
  
  }

  Widget optionList(double width, String text, {bool showSwitch = false}) {
    return GestureDetector(
      onTap: () => {},
      child: Container(
          margin: EdgeInsets.only(bottom: 6, top: 5),
          // padding: EdgeInsets.only(
          //     top: 18,
          //     bottom: 15,
          //     left: width * (18 / 420),
          //     right: width * (18 / 420)),
          color: Colors.white,
          child: ListTile(
            leading: Icon(
              Icons.home,
              size: width * (30 / 420),
              color: _colorfromhex("#ABAFD1"),
            ),
            title: Text(
              text,
              style: TextStyle(
                fontFamily: 'Roboto Medium',
                fontSize: width * (18 / 420),
                color: Colors.black,
              ),
            ),
            trailing: showSwitch
                ? SizedBox(
                    height: 0,
                    child: Switch.adaptive(value: false, onChanged: (v) {}))
                : Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
          )

          // Row(
          //   children: [
          //     Icon(
          //       Icons.home,
          //       size: width * (30 / 420),
          //       color: _colorfromhex("#ABAFD1"),
          //     ),
          //     Container(
          //       margin: EdgeInsets.only(left: width * (20 / 420)),
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Container(
          //             child: Text(
          //               text,
          //               style: TextStyle(
          //                 fontFamily: 'Roboto Medium',
          //                 fontSize: width * (18 / 420),
          //                 color: Colors.black,
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //     Spacer(),
          //     showSwitch
          //         ? SizedBox(
          //             height: 0,
          //             child: Switch.adaptive(value: false, onChanged: (v) {}))
          //         : SizedBox()
          //   ],
          // ),

          ),
    );
  }

  void _navigateAndRefresh(context) async {
    var result = await Navigator.of(context).pushNamed('/payment');
    print("Result from payment => $result");
    if (result == true) {
      apiCall();
    }
  }
}
