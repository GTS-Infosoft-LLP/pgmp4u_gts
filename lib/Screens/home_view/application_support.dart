import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:pgmp4u/components/applSupportRow.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:pgmp4u/provider/profileProvider.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../provider/Subscription/subscriptionPage.dart';
import '../../provider/Subscription/subscriptionProvider.dart';
import '../../tool/ShapeClipper.dart';
import '../chat/screen/discussionGoupList.dart';

class ApplicationSupportPage extends StatefulWidget {
  @override
  _ApplicationSupportPageState createState() => _ApplicationSupportPageState();
}

class _ApplicationSupportPageState extends State<ApplicationSupportPage> {
  String text1 =
      // "Please contact application support request to below email address. We strongly recommend to share full details of what you need. The support team will get back to you in 1-3 business days.";

      "Part of this Application service you will receive the following support. These will assist to draft your application. Once your application is ready, you will send it to us for our review.";

  String appbarTxt;
  Color _darkText = Color(0xff424b53);
  Color _lightText = Color(0xff424b53);

  @override
  void initState() {
    CourseProvider cp = Provider.of(context, listen: false);
    print("p.selectedPlanType == ${cp.selectedPlanType}");
    if (cp.selectedPlanType == 0 || cp.selectedPlanType == 1) {
      appbarTxt = "Silver and Free";
    } else if (cp.selectedPlanType == 2) {
      appbarTxt = "Gold";
    } else {
      appbarTxt = "Platinum";
    }

    cp.changeonTap(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(builder: (context, cp, child) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipPath(
                      clipper: ShapeClipper(),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xff5468ff), Color(0xff3643a3)]),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                border: Border.all(color: Colors.white, width: 1)),
                            child: Center(
                                child: IconButton(
                                    icon: Icon(Icons.arrow_back, color: Colors.white),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }))),
                        SizedBox(width: 30),
                        Center(
                            child: Container(
                          width: MediaQuery.of(context).size.width * .75,
                          child: Text(
                            "Application Support\n " + appbarTxt,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Raleway",
                              fontSize: 22,
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),

              // Padding(
              //     padding: EdgeInsets.only(top: 25),
              //     child: Center(
              //         child: Text(
              //       "Application Service Comes With",
              //       style: TextStyle(
              //           color: _darkText, fontWeight: FontWeight.bold, fontFamily: "NunitoSans", fontSize: 20),
              //     ))),
              SizedBox(height: 10),

              cp.selectedPlanType == 0 || cp.selectedPlanType == 1
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: Center(
                        child: Text(
                          "Currently, Application Support is part of only Gold and Platinum Plans",
                          // textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _lightText,
                            fontFamily: "NunitoSans",
                            fontSize: 15,
                          ),
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  : SizedBox(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 22, 22, 22),
                    child: Text(
                      text1,
                      style: TextStyle(
                        color: _lightText,
                        fontFamily: "NunitoSans",
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1000,
                    ),
                  ),

                  AppSupportRow("A video - How to complete your application in your first attempt.", context),

                  AppSupportRow("Application Support Handbook", context),

                  AppSupportRow("Two examples", context),

                  AppSupportRow("Writable sample application", context),

                  AppSupportRow("Experience Calculator", context),
                  cp.selectedPlanType == 0 || cp.selectedPlanType == 1 || cp.selectedPlanType == 3
                      ? AppSupportRow("Session with Mentor", context)
                      : SizedBox(),

                  SizedBox(
                    height: 20,
                  ),

                  cp.selectedPlanType == 2
                      ? Text(
                          "Upgrade to Platinum for Session with Mentor",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        )
                      : SizedBox(),

                  // cp.selectedPlanType == 1 || cp.selectedPlanType == 0
                  //     ? Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             "Upgrade to Gold to avail",
                  //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  //           ),
                  //           SizedBox(
                  //             height: 10,
                  //           ),
                  //           // AppSupportRow("A video - How to complete your application in your first attempt.", context),
                  //           AppSupportRow("Application Support Handbook", context),
                  //           AppSupportRow("Two examples", context),
                  //           AppSupportRow("Writable sample application", context),
                  //           AppSupportRow("Experience Calculator", context),

                  //           SizedBox(
                  //             height: 10,
                  //           ),
                  //           Text(
                  //             "Upgrade to Platinum to avail",
                  //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  //           ),

                  //           SizedBox(
                  //             height: 10,
                  //           ),
                  //           AppSupportRow("Application Support Handbook", context),
                  //           AppSupportRow("Two examples", context),
                  //           AppSupportRow("Writable sample application", context),
                  //           AppSupportRow("Experience Calculator", context),
                  //           AppSupportRow("Session with Mentor", context),
                  //           AppSupportRow("Chat Support", context),
                  //         ],
                  //       )
                  //     : SizedBox(),

                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      cp.selectedPlanType == 0 || cp.selectedPlanType == 1 || cp.selectedPlanType == 2
                          ? Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * .4,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all<double>(4.0),
                                    side:
                                        MaterialStateProperty.all(BorderSide(width: 2, color: Colors.indigo.shade500)),
                                    // padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo.shade500),
                                    //shadowColor: MaterialStateProperty.all(Colors.indigo),
                                  ),
                                  onPressed: () async {
                                    ProfileProvider pp = Provider.of(context, listen: false);
                                    pp.updateLoader(false);
                                    pp.setSelectedContainer(2);
                                    SubscriptionProvider sp = Provider.of(context, listen: false);
                                    sp.SelectedPlanType = 3;
                                    await sp.setSelectedDurTimeQt(0, 0, isFirtTime: 1);
                                    sp.setSelectedIval(2);
                                    if (sp.durationPackData.isNotEmpty) {
                                      sp.setSelectedRadioVal(0);
                                    }
                                    sp.selectedIval = 2;
                                    // await sp.getSubscritionData(storedCourse[index].id);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Subscriptionpg()));
                                  },
                                  child: Text(
                                    "Upgrade",
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  )),
                            )
                          : SizedBox(),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * .4,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all<double>(4.0),
                              side: MaterialStateProperty.all(BorderSide(width: 2, color: Colors.indigo.shade500)),
                              // padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo.shade500),
                              //shadowColor: MaterialStateProperty.all(Colors.indigo),
                            ),
                            onPressed: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => GroupListPage()));
                              // await send(context);
                              //showDialog(context: context, builder: (context)=>AlertDialog());

                              //                   final Email email = Email(
                              //   body: 'Email body',
                              //   subject: 'Email subject',
                              //   recipients: ['example@example.com'],
                              //   cc: ['cc@example.com'],
                              //   bcc: ['bcc@example.com'],
                              //   attachmentPaths: ['/path/to/attachment.zip'],
                              //   isHTML: false,
                              // );
                              // await FlutterEmailSender.send(email);
                            },
                            child: Text(
                              "Chat",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            )),
                      ),
                    ],
                  )
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(5, 22, 22, 22),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Icon(
                  //         Icons.arrow_forward,
                  //         color: Color(0xff5468ff),
                  //         size: 30,
                  //       ),
                  //       Expanded(
                  //           child: Text(
                  //         text2,
                  //         style: TextStyle(
                  //           color: _lightText,
                  //           fontFamily: "NunitoSans",
                  //           fontSize: 15,
                  //         ),
                  //         overflow: TextOverflow.ellipsis,
                  //         maxLines: 1000,
                  //       )),
                  //     ],
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(5, 22, 22, 22),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Icon(
                  //         Icons.arrow_forward,
                  //         color: Color(0xff5468ff),
                  //         size: 30,
                  //       ),
                  //       Expanded(
                  //           child: Text(
                  //         text3,
                  //         style: TextStyle(
                  //           color: _lightText,
                  //           fontFamily: "NunitoSans",
                  //           fontSize: 15,
                  //         ),
                  //         overflow: TextOverflow.ellipsis,
                  //         maxLines: 1000,
                  //       )),
                  //     ],
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(5, 22, 22, 22),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Icon(
                  //         Icons.arrow_forward,
                  //         color: Color(0xff5468ff),
                  //         size: 30,
                  //       ),
                  //       Expanded(
                  //           child: Text(
                  //         text4,
                  //         style: TextStyle(
                  //           color: _lightText,
                  //           fontFamily: "NunitoSans",
                  //           fontSize: 15,
                  //         ),
                  //         overflow: TextOverflow.ellipsis,
                  //         maxLines: 1000,
                  //       )),
                  //     ],
                  //   ),
                  // )
                ]),
              )
            ]),
          ),
        ),
      );
    });
  }
}

Future<void> send(BuildContext context) async {
  final Email email = Email(
//  final Email email = Email(
//       body: _bodyController.text,
//       subject: _subjectController.text,
//       recipients: [_recipientController.text],
//       attachmentPaths: attachments,
//       isHTML: isHTML,
//     );

    body: "",
    subject: "For Support",
    recipients: ["dharam@vcareprojectmanagement.com"],
    attachmentPaths: [],
    isHTML: false,
  );

  String platformResponse;

  try {
    print("sendeddddd");
    await FlutterEmailSender.send(email);
    platformResponse = 'success';
  } catch (error) {
    print(error);
    platformResponse = error.toString();
  }

  // if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(platformResponse),
    ),
  );
}
