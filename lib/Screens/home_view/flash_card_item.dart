import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:pgmp4u/Screens/Tests/local_handler/hive_handler.dart';
import 'package:pgmp4u/provider/profileProvider.dart';
import 'package:pgmp4u/provider/response_provider.dart';
import 'package:provider/provider.dart';

import '../../provider/courseProvider.dart';
import '../../tool/ShapeClipper.dart';
import '../../utils/app_color.dart';
import '../MockTest/model/flashCateModel.dart';
import '../flashDisplay.dart';
import 'VideoLibrary/RandomPage.dart';

class FlashCardItem extends StatefulWidget {
  String title;
  FlashCardItem({Key key, this.title}) : super(key: key);

  @override
  State<FlashCardItem> createState() => _FlashCardItemState();
}

class _FlashCardItemState extends State<FlashCardItem> {
  Color _darkText = Color(0xff424b53);
  Color _lightText = Color(0xff989d9e);
  ResponseProvider responseProvider;
  CourseProvider cp;

  List<FlashCateDetails> flashCateTempList = [];

  Future callCategoryApi() async {
    print(" api calling");
    responseProvider = Provider.of(context, listen: false);
    // ignore: unnecessary_statements
    // responseProvider.getcategoryList();
  }

  List<FlashCateDetails> storedFlashCate = [];
  @override
  IconData icon1;
  void initState() {
    cp = Provider.of(context, listen: false);
    cp.changeonTap(0);
    print("cp.flashCate.length==========${cp.flashCate.length}");
    // if (flashCateTempList.isEmpty) {
    //   flashCateTempList = HiveHandler.getFlashCateDataList(key: cp.selectedMasterId.toString());
    //   print("flashCateTempList=========$flashCateTempList");
    // }

    callCategoryApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
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
                              colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                        ),
                      ),
                    ),
                    Consumer<CourseProvider>(builder: (context, cp, child) {
                      return Container(
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
                                child: Container(
                              // color: Colors.amber,
                              width: MediaQuery.of(context).size.width * .65,
                              child: Text(
                                cp.selectedCourseLable,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    widget.title,
                    style: TextStyle(fontSize: 24, color: _darkText, fontWeight: FontWeight.bold),
                  ),
                ),

                // flashCateTempList.isEmpty
                //     ? Center(
                //         child: Container(
                //         child: Text("No Data Found"),
                //       ))
                //     :
                Container(
                  child: ValueListenableBuilder<Box<String>>(
                      valueListenable: HiveHandler.getFlashCateListener(),
                      builder: (context, value, child) {
                        print("cp.selectedMasterId======= ${cp.selectedMasterId}");

                        if (value.containsKey(cp.selectedMasterId.toString())) {
                          List flashCardList = jsonDecode(value.get(cp.selectedMasterId.toString()));
                          print(">>> flashCardList :  $flashCardList");
                          storedFlashCate = flashCardList.map((e) => FlashCateDetails.fromjson(e)).toList();
                        } else {
                          storedFlashCate = [];
                        }

                        print("storedFlashCate========================$storedFlashCate");

                        if (storedFlashCate == null) {
                          storedFlashCate = [];
                        }

                        return Consumer<CourseProvider>(builder: (context, courseProvider, child) {
                          return courseProvider.flashCateDataApiCall
                              ? Container(
                                  height: MediaQuery.of(context).size.height * .6,
                                  child: Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  ),
                                )
                              : storedFlashCate.length == 0
                                  ? Container(
                                      height: MediaQuery.of(context).size.height * .5,
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              "No Data Found...",
                                              style: TextStyle(color: Colors.black, fontSize: 18),
                                            ),
                                            courseProvider.checkInternet == 1
                                                ? Text(
                                                    "Check your internet connection",
                                                    style: TextStyle(color: Colors.black, fontSize: 18),
                                                  )
                                                : Text(""),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: MediaQuery.of(context).size.height * .70,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: storedFlashCate.length,
                                          itemBuilder: (context, index) {
                                            if (index % 5 == 0) {
                                              icon1 = FontAwesomeIcons.book;
                                            } else if (index % 4 == 0) {
                                              icon1 = FontAwesomeIcons.cloud;
                                            } else if (index % 3 == 0) {
                                              icon1 = FontAwesomeIcons.coins;
                                            } else if (index % 2 == 0) {
                                              icon1 = FontAwesomeIcons.deezer;
                                            } else {
                                              icon1 = FontAwesomeIcons.airbnb;
                                            }
                                            return InkWell(
                                              onTap: () async {
                                                print("flash card category id===>>${storedFlashCate[index].id}");

                                                courseProvider.setSelectedFlashCategory(storedFlashCate[index].id);
                                                courseProvider.FlashCards = [];

                                                ProfileProvider pp = Provider.of(context, listen: false);
                                                pp.updateLoader(true);

                                                await courseProvider
                                                    .getFlashCards(
                                                        storedFlashCate[index].id, storedFlashCate[index].price)
                                                    .onError((error, stackTrace) {
                                                  pp.updateLoader(false);
                                                });
                                                var flashPayStat = await cp.successValueFlash;
                                                pp.updateLoader(false);
                                                print("flashPayStat=======$flashPayStat");
                                                if (flashPayStat == false) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => RandomPage(
                                                                categoryId: storedFlashCate[index].id,
                                                                price: storedFlashCate[index].price,
                                                                index: 1,
                                                              )));
                                                } else {
                                                  Future.delayed(const Duration(milliseconds: 0), () async {
                                                    {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => FlashDisplay(
                                                                    heding: storedFlashCate[index].name,
                                                                  )));
                                                      //FlashDisplay
                                                    }
                                                  });
                                                  // }
                                                }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            bottom: BorderSide(
                                                                width: 1.5, color: Color.fromARGB(255, 219, 211, 211))),
                                                        color: Colors.transparent),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(bottom: 6.0, top: 6),
                                                          child: Container(
                                                              height: 60,
                                                              width: 60,
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(8),
                                                                color:
                                                                    index % 2 == 0 ? AppColor.purpule : AppColor.green,
                                                              ),
                                                              child: Icon(
                                                                icon1,

                                                                // index % 2 == 0
                                                                //     ? FontAwesomeIcons.book
                                                                //     : FontAwesomeIcons.airbnb,
                                                                color: Colors.white,
                                                              )),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              width: MediaQuery.of(context).size.width * .7,
                                                              // color: Colors.amber,
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    // width: MediaQuery.of(context).size.width * .7,
                                                                    child: Text(
                                                                      storedFlashCate[index].flashcards.toString() +
                                                                          " ${widget.title} available",
                                                                      style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontFamily: 'Roboto Medium',
                                                                          // fontWeight: FontWeight.w600,
                                                                          color: Colors.grey),
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),
                                                                  storedFlashCate[index].payment_status == 1
                                                                      ? Text(
                                                                          "Premium",
                                                                          style: TextStyle(
                                                                            fontSize: 14,
                                                                            fontFamily: 'Roboto Medium',
                                                                            fontWeight: FontWeight.w600,
                                                                          ),
                                                                          maxLines: 2,
                                                                          overflow: TextOverflow.ellipsis,
                                                                        )
                                                                      : Text(""),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: 2),
                                                            Container(
                                                              width: MediaQuery.of(context).size.width * .7,
                                                              child: Text(
                                                                storedFlashCate[index].name,
                                                                style: TextStyle(
                                                                  fontSize: 16,
                                                                  fontFamily: 'Roboto Medium',
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            );
                                            // );
                                          }),
                                    );
                        });
                      }),
                )
              ])))),
    );
  }
}
