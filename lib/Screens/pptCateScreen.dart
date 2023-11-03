import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pgmp4u/Screens/pptData.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:provider/provider.dart';

import '../Models/pptCateModel.dart';
import '../provider/profileProvider.dart';
import '../tool/ShapeClipper.dart';
import '../utils/app_color.dart';
import 'Pdf/screens/pdfViewer.dart';
import 'Tests/local_handler/hive_handler.dart';
import 'home_view/VideoLibrary/RandomPage.dart';

class PPTCardItem extends StatefulWidget {
  String title;
  PPTCardItem({Key key, this.title}) : super(key: key);

  @override
  State<PPTCardItem> createState() => _PPTCardItemState();
}

IconData icon1;
Color _darkText = Color(0xff424b53);
Color _lightText = Color(0xff989d9e);

class _PPTCardItemState extends State<PPTCardItem> {
  @override
  List<PPTCateDetails> storedpptCate = [];
  void initState() {
    CourseProvider cp = Provider.of(context, listen: false);
    cp.changeonTap(0);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                padding: EdgeInsets.fromLTRB(20, 50, 10, 0),
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
                            fontSize: 22, color: Colors.white, fontFamily: "Roboto", fontWeight: FontWeight.bold),
                      ),
                    )),
                  ],
                ),
              );
            }),
          ]),
          SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              widget.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 24, color: _darkText, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            child: ValueListenableBuilder<Box<String>>(
                valueListenable: HiveHandler.getPptCateListener(),
                builder: (context, value, child) {
                  CourseProvider cp = Provider.of(context, listen: false);
                  if (value.containsKey(cp.selectedMasterId.toString())) {
                    print("cp.selectedMasterId>>>>>${cp.selectedMasterId}");
                    List pptCateList = jsonDecode(value.get(cp.selectedMasterId.toString()));
                    storedpptCate = pptCateList.map((e) => PPTCateDetails.fromjson(e)).toList();
                    print("storedpptCate List:::::: $storedpptCate");
                  } else {
                    storedpptCate = [];
                  }
                  if (storedpptCate == null) {
                    storedpptCate = [];
                  }
                  return Consumer<CourseProvider>(builder: (context, cp, child) {
                    return cp.isPPTLoading
                        ? Container(
                            height: MediaQuery.of(context).size.height * .60,
                            child: Center(child: CircularProgressIndicator.adaptive()))
                        : storedpptCate.isEmpty
                            ? Container(
                                height: MediaQuery.of(context).size.height * .30,
                                child: Center(
                                    child: Text(
                                  "No Data Found...",
                                  style: TextStyle(fontSize: 18),
                                )),
                              )
                            : Container(
                                height: MediaQuery.of(context).size.height * .70,
                                child: ListView.builder(
                                    itemCount: storedpptCate.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () async {
                                          ProfileProvider pp = Provider.of(context, listen: false);
                                          pp.updateLoader(true);
                                          print("storedpptCate===========${storedpptCate[index].id}");
                                          print("cp.pptUrlLink>>>>>>>>>>>>>>>>>>> ${cp.pptUrlLink}");
                                          await cp.getPpt(storedpptCate[index].id);
                                          var lngth = cp.pptDataList.length;

                                          print("pptDataList length====$lngth");
                                          bool result = await checkInternetConn();
                                          print("cp object:::: ${cp.oflinePptDtail}");
                                          if (result) {
                                            cp.setOflinePptDetail(cp.pptDataList[0]);
                                          }

                                          var pptPayStat = await cp.successValuePPT;
                                          print("pptPayStat======$pptPayStat");
                                          print("storedpptCate[index]====${storedpptCate[index].price}");
                                          if (pptPayStat == false) {
                                            pp.updateLoader(false);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => RandomPage(
                                                          categoryId: storedpptCate[index].id,
                                                          price: storedpptCate[index].price,
                                                          index: 5,
                                                        )));
                                          } else {
                                            if (lngth == 1 || lngth == 0) {
                                              pp.updateLoader(false);
                                              // var urlPpt = cp.pptDataList[0].filename;
                                              // print("urlPpt====$urlPpt");
                                              pp.updateLoader(false);
                                              if (result) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => PdfViewer(
                                                              pdfModel: cp.pptDataList[0],
                                                              pdfName: cp.pptUrlLink,
                                                            )));
                                              } else {
                                                EasyLoading.showInfo("Please check your Internet Connection");
                                              }
                                            } else {
                                              pp.updateLoader(false);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => PPTData(
                                                            title: storedpptCate[index].name,
                                                          )));
                                            }
                                            pp.updateLoader(false);
                                          }
                                          pp.updateLoader(false);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 1, color: Color.fromARGB(255, 219, 211, 211)))),
                                            height: 78,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 0,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 4.0),
                                                  child: Container(
                                                      height: 60,
                                                      width: 60,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: index % 2 == 0 ? AppColor.purpule : AppColor.green,
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(17.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(80),
                                                          ),
                                                          child: Center(
                                                            child: Text('${index + 1}'),
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      // color: Colors.amber,
                                                      width: MediaQuery.of(context).size.width * .68,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(
                                                              // color: Colors.amber,
                                                              width: MediaQuery.of(context).size.width * .67,
                                                              child: RichText(
                                                                  // maxLines: 1000,
                                                                  // overflow: TextOverflow.ellipsis,
                                                                  // textAlign: TextAlign.left,
                                                                  text: TextSpan(children: <TextSpan>[
                                                                TextSpan(
                                                                  text: storedpptCate[index].label,
                                                                  style: TextStyle(
                                                                    color: Colors.grey,
                                                                    fontSize: 14,
                                                                    // fontFamily: "NunitoSans",

                                                                    // height: 1.7
                                                                    // fontWeight: FontWeight.w600,
                                                                    // letterSpacing: 0.3,
                                                                  ),
                                                                ),
                                                              ]))),
                                                          RichText(
                                                              // maxLines: 1000,
                                                              // overflow: TextOverflow.ellipsis,
                                                              // textAlign: TextAlign.left,
                                                              text: TextSpan(children: <TextSpan>[
                                                            TextSpan(
                                                              text: storedpptCate[index].paymentStatus == 1
                                                                  ? "Premium"
                                                                  : "",
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 14,
                                                                // fontFamily: "NunitoSans",

                                                                // height: 1.7
                                                                // fontWeight: FontWeight.w600,
                                                                // letterSpacing: 0.3,
                                                              ),
                                                            ),
                                                          ]))
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 0,
                                                    ),
                                                    Container(
                                                        width: MediaQuery.of(context).size.width * .65,
                                                        child:
                                                            // Text(
                                                            //   storedpptCate[index].name,
                                                            //   maxLines: 2,
                                                            //   style: TextStyle(
                                                            //     fontSize: 18,
                                                            //     color: Colors.black,
                                                            //   ),
                                                            // ),

                                                            RichText(
                                                                maxLines: 2,
                                                                // overflow: TextOverflow.ellipsis,
                                                                // textAlign: TextAlign.left,
                                                                text: TextSpan(children: <TextSpan>[
                                                                  TextSpan(
                                                                    text: storedpptCate[index].name,
                                                                    style: TextStyle(
                                                                      color: Colors.black,
                                                                      fontSize: 18,
                                                                      // fontFamily: "NunitoSans",

                                                                      // height: 1.7
                                                                      // fontWeight: FontWeight.w600,
                                                                      // letterSpacing: 0.3,
                                                                    ),
                                                                  ),
                                                                ]))),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              );
                  });
                }),
          )
        ],
      )),
    );
  }

  Future checkInternetConn() async {
    bool result = await InternetConnectionChecker().hasConnection;
    print("result while call fun $result");
    if (result == false) {
      Future.delayed(Duration(seconds: 1), () async {
        //  await EasyLoading.showToast("Internet Not Connected",toastPosition: EasyLoadingToastPosition.bottom);
      });
      return result;
    } else {}
    return result;
  }
}
