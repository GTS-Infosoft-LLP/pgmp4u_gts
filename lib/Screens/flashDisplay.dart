import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pgmp4u/Screens/Tests/local_handler/hive_handler.dart';
import 'package:provider/provider.dart';

import '../provider/courseProvider.dart';
import '../provider/response_provider.dart';
import '../tool/ShapeClipper.dart';
import 'MockTest/model/flashCardModel.dart';

class FlashDisplay extends StatefulWidget {
  String heding;
  FlashDisplay({Key key, this.heding}) : super(key: key);

  @override
  State<FlashDisplay> createState() => _FlashDisplayState();
}

class _FlashDisplayState extends State<FlashDisplay> {
  @override
  ResponseProvider responseProvider;

  LinearGradient liGrdint;
  List<FlashCardDetails> flashTemp = [];

  void initState() {
    responseProvider = Provider.of(context, listen: false);
    CourseProvider courseProvider = Provider.of(context, listen: false);

    if (flashTemp.isEmpty) {
      flashTemp = HiveHandler.getflashCardsList(keyName: courseProvider.selectedFlashCategory.toString());

      print("length of flash list ==>> ${courseProvider.FlashCards.length}");
    }

    callCardDetailsApi();
    super.initState();
  }

  callCardDetailsApi() async {
    // await responseProvider.getCardDetails();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: <Widget>[
                      ClipPath(
                        clipper: ShapeClipper(),
                        // CardPageClipper(),
                        child: Container(
                          // height: MediaQuery.of(context).size.height*.25,
                          height: 150,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(40, 50, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                            SizedBox(width: 20),
                            Center(
                                child: Text(
                              widget.heding,
                              style: TextStyle(
                                  fontSize: 22, color: Colors.white, fontFamily: "Roboto", fontWeight: FontWeight.bold),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // flashTemp.isEmpty
                  //     ? Center(
                  //         child: Container(
                  //         height: 400,
                  //         child: Text("No Data Found..."),
                  //       ))
                  //     :
                  Container(
                    child: ValueListenableBuilder<Box<String>>(
                        valueListenable: HiveHandler.getDisplayFlashListener(),
                        builder: (context, value, child) {
                          CourseProvider cp = Provider.of(context, listen: false);
                          List<FlashCardDetails> storedFlash = [];

                          if (value.containsKey(cp.selectedFlashCategory.toString())) {
                            List flashCardDisplay = jsonDecode(value.get(cp.selectedFlashCategory.toString()));
                            print(">>> flashCardList :  $flashCardDisplay");
                            storedFlash = flashCardDisplay.map((e) => FlashCardDetails.fromjson(e)).toList();
                          } else {
                            storedFlash = [];
                          }

                          print("storedFlashCate========================$storedFlash");

                          if (storedFlash == null) {
                            storedFlash = [];
                          }

                          return Consumer<CourseProvider>(builder: (context, courseProvider, child) {
                            return storedFlash.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 28.0),
                                      child: Container(
                                        child: Text("No Data Found"),
                                      ),
                                    ),
                                  )
                                : Container(
                                    // color: Colors.amber,
                                    height: MediaQuery.of(context).size.height * .8,
                                    child: PageView.builder(
                                        itemCount: storedFlash.length,
                                        itemBuilder: (context, index) {
                                          if (index % 4 == 0) {
                                            liGrdint = LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [Color(0xff5082BC), Color(0xff8AA1C9)]);
                                          } else if (index % 3 == 0) {
                                            liGrdint = LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [Color(0xffF3924D), Color(0xffECAB8E)]);
                                          } else if (index % 2 == 0) {
                                            liGrdint = LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [Color(0xff8E8BE6), Color(0xffA8B1FC)]);
                                          } else {
                                            liGrdint = LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [Color(0xff4195B7), Color(0xff76ACC2)]);
                                          }

                                          return Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    gradient: liGrdint,
                                                    // color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 5.0,
                                                      ),
                                                    ],
                                                    borderRadius: BorderRadius.circular(40),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      // gradient: liGrdint,
                                                      color: Colors.white,

                                                      borderRadius: BorderRadius.circular(40),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                                          child: Text(
                                                            storedFlash[index].title,
                                                            textAlign: TextAlign.left,
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 30,
                                                                fontFamily: "Roboto",
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                        Expanded(
                                                          child: SingleChildScrollView(
                                                            child: Container(
                                                              height: MediaQuery.of(context).size.height * .6,
                                                              // color: Colors.blue,
                                                              child: Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                                                child: SingleChildScrollView(
                                                                  child: Html(
                                                                    data: storedFlash[index].description,
                                                                    style: {
                                                                      "body": Style(
                                                                        padding: EdgeInsets.only(top: 5),
                                                                        margin: EdgeInsets.zero,
                                                                        color: Color(0xff000000),
                                                                        textAlign: TextAlign.left,
                                                                        // maxLines: 7,
                                                                        // textOverflow: TextOverflow.ellipsis,
                                                                        fontSize: FontSize(22),
                                                                      )
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                  );
                          });
                        }),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
