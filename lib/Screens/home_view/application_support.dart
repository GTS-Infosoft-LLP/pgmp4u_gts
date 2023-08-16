import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../tool/ShapeClipper.dart';

class ApplicationSupportPage extends StatefulWidget {
  @override
  _ApplicationSupportPageState createState() => _ApplicationSupportPageState();
}

class _ApplicationSupportPageState extends State<ApplicationSupportPage> {
  String text1 =
      // "Please contact application support request to below email address. We strongly recommend to share full details of what you need. The support team will get back to you in 1-3 business days.";
      ///  platinum
      // "Part of this Application service you will receive the following support. These will assist to draft your application. Once your application is ready, you will send it to us for our review.\n\n1. A video - How to complete your application in your first attempt.\n2. Application Support Handbook\n3. Two examples\n4. Writable sample application\n5. Experience Calculator\n6. Mentor Connect ";

      /// gold
      // "Part of this Application service you will receive the following support. These will assist to draft your application. Once your application is ready, you will send it to us for our review.\n\n1. A video - How to complete your application in your first attempt.\n2. Application Support Handbook\n3. Two examples\n4. Writable sample application\n5. Experience Calculator\n\nUpgrade to Platinum to avail\n1. Session with Mentor\n2. Chat Support";

      ///silver
      "Part of this Application service you will receive the following support. These will assist to draft your application. Once your application is ready, you will send it to us for our review.\n\n1. A video - How to complete your application in your first attempt.\n\nUpgrade to Gold to avail\n1. Application Support Handbook\n2. Two examples\n3. Writable sample application\n4. Experience Calculator\n\nUpgrade to Platinum to avail\n1. Application Support Handbook\n2. Two examples\n3. Writable sample application\n4. Experience Calculator\n5. Session with Mentor\n6. Chat Support";

  Color _darkText = Color(0xff424b53);
  Color _lightText = Color(0xff424b53);

  @override
  void initState() {
    CourseProvider cp = Provider.of(context, listen: false);
    cp.changeonTap(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                          child: Text(
                        "Application Support",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Raleway",
                          fontSize: 22,
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: 25),
                child: Center(
                    child: Text(
                  "Application Service Comes With",
                  style:
                      TextStyle(color: _darkText, fontWeight: FontWeight.bold, fontFamily: "NunitoSans", fontSize: 20),
                ))),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 22, 22, 22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Icon(
                      //   Icons.arrow_forward,
                      //   color: Color(0xff5468ff),
                      //   size: 30,
                      // ),
                      Expanded(
                          child: Text(
                        text1,
                        style: TextStyle(
                          color: _lightText,
                          fontFamily: "NunitoSans",
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1000,
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * .7,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(4.0),
                        side: MaterialStateProperty.all(BorderSide(width: 2, color: Colors.indigo.shade500)),
                        // padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
                        shape:
                            MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo.shade500),
                        //shadowColor: MaterialStateProperty.all(Colors.indigo),
                      ),
                      onPressed: () async {
                        await send(context);
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
