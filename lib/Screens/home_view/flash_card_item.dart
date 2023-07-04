import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:pgmp4u/Screens/Tests/local_handler/hive_handler.dart';
import 'package:pgmp4u/Screens/home_view/VideoLibrary/RandomPage.dart';
import 'package:pgmp4u/provider/response_provider.dart';
import 'package:provider/provider.dart';

import '../../provider/courseProvider.dart';
import '../../tool/ShapeClipper.dart';
import '../../utils/app_color.dart';
import '../MockTest/model/flashCateModel.dart';
import '../flashDisplay.dart';

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

  List<FlashCateDetails> flashCateTempList = [];

  Future callCategoryApi() async {
    print(" api calling");
    responseProvider = Provider.of(context, listen: false);
    // ignore: unnecessary_statements
    // responseProvider.getcategoryList();
  }

  List<FlashCateDetails> storedFlashCate = [];
  @override
  void initState() {
    CourseProvider courseProvider = Provider.of(context, listen: false);
    print("courseProvider.flashCate.length==========${courseProvider.flashCate.length}");
    // if (flashCateTempList.isEmpty) {
    //   flashCateTempList = HiveHandler.getFlashCateDataList(key: courseProvider.selectedMasterId.toString());
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
                Stack(children: <Widget>[
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
                              cp.selectedCourseName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 22, color: Colors.white, fontFamily: "Roboto", fontWeight: FontWeight.bold),
                            ),
                          )),
                        ],
                      ),
                    );
                  }),
                ]),
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
                  child: ValueListenableBuilder<Box<List<FlashCateDetails>>>(
                      valueListenable: HiveHandler.getFlashCateListener(),
                      builder: (context, value, child) {
                        CourseProvider cp = Provider.of(context, listen: false);
                        // try {
                        //   print(
                        //       "value.get(cp.selectedMasterId==========${value.get(cp.selectedMasterId, defaultValue: [])}");
                        //   // print("thrfhfhdfh ========================${value.get(cp.selectedMasterId.toString())}");
                        // } on Exception catch (e) {
                        //   print("erororrrr=====$e");
                        // }
                        print("cp.selectedMasterId=======${cp.selectedMasterId}");
                        storedFlashCate = value.get(cp.selectedMasterId.toString(), defaultValue: []) ?? [];

                        print("storedFlashCate========================$storedFlashCate");

                        if (storedFlashCate == null) {
                          storedFlashCate = [];
                        }

                        return Consumer<CourseProvider>(builder: (context, courseProvider, child) {
                          return storedFlashCate.length == 0
                              ? Container(
                                  height: MediaQuery.of(context).size.height * .5,
                                  child: Center(
                                    child: Text(
                                      "No Data Found...",
                                      style: TextStyle(color: Colors.black, fontSize: 18),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: MediaQuery.of(context).size.height * .70,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: storedFlashCate.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            if (storedFlashCate[index].payment_status == 1) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => RandomPage(
                                                          index: 1,
                                                          price: storedFlashCate[index].price,
                                                          categoryId: storedFlashCate[index].id)));
                                            } else {
                                              print("flash card category id===>>${storedFlashCate[index].id}");

                                              courseProvider.setSelectedFlashCategory(storedFlashCate[index].id);

                                              if (storedFlashCate[index].payment_status == 0) {}
                                              courseProvider.FlashCards = [];

                                              courseProvider.getFlashCards(storedFlashCate[index].id);

                                              Future.delayed(const Duration(milliseconds: 400), () {
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             FlashCardsPage(
                                                //               heding: courseProvider
                                                //                   .flashCate[index].name,
                                                //             )));
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => FlashDisplay(
                                                              heding: storedFlashCate[index].name,
                                                            )));
                                                //FlashDisplay
                                              });
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    border:
                                                        Border(bottom: BorderSide(width: 1.5, color: Colors.grey[300])),
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
                                                            color: index % 2 == 0 ? AppColor.purpule : AppColor.green,
                                                          ),
                                                          child: Icon(
                                                            index % 2 == 0
                                                                ? FontAwesomeIcons.book
                                                                : FontAwesomeIcons.airbnb,
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

                                                    // Container(
                                                    //   child: Row(
                                                    //     mainAxisAlignment: MainAxisAlignment.end,
                                                    //     children: [
                                                    //       Text(
                                                    //         "Premium",
                                                    //         style: TextStyle(
                                                    //           fontSize: 16,
                                                    //           fontFamily: 'Roboto Medium',
                                                    //           fontWeight: FontWeight.w600,
                                                    //         ),
                                                    //         maxLines: 2,
                                                    //         overflow: TextOverflow.ellipsis,
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),

                                                    // )
                                                  ],
                                                )

                                                // ListTile(
                                                //     leading: Container(
                                                //         height: 60,
                                                //         width: 60,
                                                //         decoration: BoxDecoration(
                                                //           borderRadius: BorderRadius.circular(8),
                                                //           color: index % 2 == 0 ? AppColor.purpule : AppColor.green,
                                                //         ),
                                                //         child: Icon(
                                                //           index % 2 == 0
                                                //               ? FontAwesomeIcons.book
                                                //               : FontAwesomeIcons.airbnb,
                                                //           color: Colors.white,
                                                //         )

                                                //         ),
                                                //     // title: Row(
                                                //     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                //     //   children: [
                                                //     //     // Text(
                                                //     //     //   "",
                                                //     //     //   style: TextStyle(fontSize: 12),
                                                //     //     // ),
                                                //     //     storedFlashCate[index].payment_status == 1
                                                //     //         ? InkWell(
                                                //     //             onTap: () {
                                                //     //               Navigator.push(
                                                //     //                   context,
                                                //     //                   MaterialPageRoute(
                                                //     //                       builder: (context) => RandomPage(index: 1)));
                                                //     //             },
                                                //     //             child: Text(
                                                //     //               "Premium",
                                                //     //               style: TextStyle(fontSize: 12),
                                                //     //             ),
                                                //     //           )
                                                //     //         : SizedBox(),
                                                //     //   ],
                                                //     // ),
                                                //     title: Text(
                                                //       storedFlashCate[index].name,
                                                //       maxLines: 2,
                                                //       overflow:  TextOverflow.ellipsis,
                                                //     ))

                                                ),
                                          ),
                                        );
                                        // );
                                      }),
                                );
                        });
                      }),
                )

                // Consumer<ResponseProvider>(
                //   builder: ((context, responseProvider, child) {
                //     return Container(
                //         child: responseProvider.apiStatus
                //             ? Center(
                //                 child: CircularProgressIndicator.adaptive(),
                //               )
                //             : responseProvider.categoryList != null
                //                 ? ListView.builder(
                //                     physics: NeverScrollableScrollPhysics(),
                //                     shrinkWrap: true,
                //                     itemCount: responseProvider
                //                         .categoryList.categoryList.length,
                //                     itemBuilder: (context, index) {
                //                       var itemscategoryList =
                //                           responseProvider
                //                               .categoryList.categoryList;

                //                       var item = itemscategoryList[index];
                //                       return InkWell(
                //                         onTap: () async {
                //                           print(" tap on card");
                //                           await responseProvider
                //                               .setCategoryid(item.id);
                //                           Navigator.push(
                //                               context,
                //                               MaterialPageRoute(
                //                                   builder: (context) =>
                //                                       FlashCardsPage()));
                //                         },
                //                         child: Card(
                //                           margin: EdgeInsets.symmetric(
                //                             vertical: 0.5,
                //                           ),
                //                           child: Container(
                //                               decoration: BoxDecoration(
                //                                   color: Colors.white),
                //                               child: ListTile(
                //                                   leading: Container(
                //                                       decoration:
                //                                           BoxDecoration(
                //                                         borderRadius:
                //                                             BorderRadius
                //                                                 .circular(
                //                                                     8),
                //                                         color:
                //                                             index % 2 == 0
                //                                                 ? AppColor
                //                                                     .purpule
                //                                                 : AppColor
                //                                                     .green,
                //                                       ),
                //                                       child: Image.network(
                //                                         "${item.thumbnail}",width: 80,errorBuilder: (context, error, stackTrace) {
                //                                           return Image.asset(AppImage.picture_placeholder);
                //                                         },
                //                                         fit: BoxFit.fill,
                //                                       )),
                //                                   title: Text(
                //                                     "Flash Card",
                //                                     style: TextStyle(
                //                                         fontSize: 12),
                //                                   ),
                //                                   subtitle: Text(
                //                                     item.title,
                //                                     maxLines: 2,
                //                                     overflow: TextOverflow
                //                                         .ellipsis,
                //                                     style: AppTextStyle
                //                                         .titleTile,
                //                                   ))),
                //                         ),
                //                       );
                //                     })
                //                 : Center(
                //                     child: Padding(
                //                     padding:
                //                         const EdgeInsets.only(top: 100),
                //                     child: Text("No data found"),
                //                   )));
                //   }),
                // )
              ])))),
    );
  }
}
