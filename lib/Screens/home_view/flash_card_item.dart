import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pgmp4u/provider/response_provider.dart';
import 'package:provider/provider.dart';

import '../../provider/courseProvider.dart';
import '../../tool/ShapeClipper.dart';
import '../../utils/app_color.dart';
import '../../utils/app_textstyle.dart';
import 'VideoLibrary/RandomPage.dart';
import 'flash_card.dart';

class FlashCardItem extends StatefulWidget {
  const FlashCardItem({Key key}) : super(key: key);

  @override
  State<FlashCardItem> createState() => _FlashCardItemState();
}

class _FlashCardItemState extends State<FlashCardItem> {
  Color _darkText = Color(0xff424b53);
  Color _lightText = Color(0xff989d9e);
  ResponseProvider responseProvider;

  Future callCategoryApi() async {
    print(" api calling");
    responseProvider = Provider.of(context, listen: false);
    // ignore: unnecessary_statements
    responseProvider.getcategoryList();
  }

  @override
  void initState() {
    CourseProvider courseProvider = Provider.of(context, listen: false);
    print(
        "courseProvider.flashCate.length==========${courseProvider.flashCate.length}");

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
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                                    border: Border.all(
                                        color: Colors.white, width: 1)),
                                child: Center(
                                    child: IconButton(
                                        icon: Icon(Icons.arrow_back,
                                            color: Colors.white),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }))),
                            SizedBox(width: 20),
                            Center(
                                child: Text(
                              "Flash Card",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.transparent,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.bold),
                            )),
                          ],
                        ),
                      ),
                    ]),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "FlashCards4U",
                        style: TextStyle(
                            fontSize: 24,
                            color: _darkText,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    Consumer<CourseProvider>(
                        builder: (context, courseProvider, child) {
                      return courseProvider.flashCate.length == 0
                          ? Container(
                              height: MediaQuery.of(context).size.height * .5,
                              child: Center(
                                child: Text(
                                  "No Data Found...",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: courseProvider.flashCate.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    print(
                                        "flash card category id===>>${courseProvider.flashCate[index].id}");

                                    if (courseProvider
                                            .flashCate[index].payment_status ==
                                        0) {}

                                    courseProvider.getFlashCards(
                                        courseProvider.flashCate[index].id);

                                    Future.delayed(
                                        const Duration(milliseconds: 400), () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FlashCardsPage(
                                                    heding: courseProvider
                                                        .flashCate[index].name,
                                                  )));
                                    });
                                  },
                                  child: Card(
                                    margin: EdgeInsets.symmetric(
                                      vertical: 0.5,
                                    ),
                                    child: Container(
                                        decoration:
                                            BoxDecoration(color: Colors.white),
                                        child: ListTile(
                                            leading: Container(
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: index % 2 == 0
                                                      ? AppColor.purpule
                                                      : AppColor.green,
                                                ),
                                                child: Icon(
                                                  index % 2 == 0
                                                      ? FontAwesomeIcons.book
                                                      : FontAwesomeIcons.airbnb,
                                                  color: Colors.white,
                                                )
                                                // Icon
                                                // Image.asset(AppImage.picture_placeholder),
                                                // Image.network(
                                                //   "",width: 80,errorBuilder: (context, error, stackTrace) {
                                                //     return Image.asset(AppImage.picture_placeholder);
                                                //   },
                                                //   fit: BoxFit.fill,
                                                // )
                                                ),
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Read",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                courseProvider.flashCate[index]
                                                            .payment_status ==
                                                        1
                                                    ? InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      RandomPage(
                                                                          index:
                                                                              1)));
                                                        },
                                                        child: Text(
                                                          "Premium",
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                            subtitle: Text(
                                              courseProvider
                                                  .flashCate[index].name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppTextStyle.titleTile,
                                            ))),
                                  ),
                                );
                                // );
                              });
                    })

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
