import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:pgmp4u/Screens/Domain/screens/domainProvider.dart';
import 'package:pgmp4u/Screens/home_view/VideoLibrary/RandomPage.dart';
import 'package:pgmp4u/Screens/home_view/application_support.dart';
import 'package:pgmp4u/Screens/pptCateScreen.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:pgmp4u/tool/ShapeClipper.dart';
import 'package:provider/provider.dart';

import '../provider/profileProvider.dart';
import '../utils/app_color.dart';
import 'Domain/screens/domainList.dart';
import 'MockTest/mockTest.dart';
import 'MockTest/model/masterdataModel.dart';
import 'Tests/local_handler/hive_handler.dart';
import 'home_view/flash_card_item.dart';
import 'home_view/video_library.dart';

class MasterListPage extends StatefulWidget {
  const MasterListPage({Key key}) : super(key: key);

  @override
  State<MasterListPage> createState() => _MasterListPageState();
}

class _MasterListPageState extends State<MasterListPage> {
  @override
  IconData icon1;
  List<MasterDetails> storedMaster = [];

  // List<MasterDetails> Mastertemplist = [];

  void initState() {
    print("init cakllinggggg.....");
    CourseProvider courseProvider = Provider.of(context, listen: false);
    print("master list===${courseProvider.masterList}");
    courseProvider.changeonTap(0);

    if (courseProvider.masterList.isEmpty) {
      print("list is empty");
      storedMaster = [];
      print("=============$storedMaster");
    }

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xfff7f7f7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
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
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 50, 0, 0),
                      child: Row(children: [
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
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => FlashCardBtn()));
                          },
                          child: RichText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              // textAlign: TextAlign.center,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                  text: cp.selectedCourseLable,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontFamily: "Raleway",
                                      fontWeight: FontWeight.bold

                                      // fontFamily: AppFont.poppinsRegular,
                                      ),
                                ),
                              ])),
                        
                        ),
                      ]),
                    ),
                  );
                })
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Consumer<CourseProvider>(builder: (context, cp, child) {
              return cp.masterDataApiCall
                  ? Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: ValueListenableBuilder<Box<String>>(
                            valueListenable: HiveHandler.getMasterListener(),
                            builder: (context, value, child) {
                              String courseId = context.read<CourseProvider>().selectedCourseId.toString();

                              if (value.containsKey(courseId)) {
                                List masterDataList = jsonDecode(value.get(courseId));
                                storedMaster = masterDataList.map((e) => MasterDetails.fromjson(e)).toList();
                              } else {
                                storedMaster = [];
                              }
                              if (storedMaster == null) {
                                storedMaster = [];
                              }
                              return Consumer<CourseProvider>(builder: (context, courseProvider, child) {
                                return storedMaster.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.only(bottom: 0.0),
                                        child: Container(
                                          // color: Colors.amber,
                                          // height: MediaQuery.of(context).size.height * .75,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: storedMaster.length,
                                              itemBuilder: (context, index) {
                                                if (storedMaster[index].type == "Videos") {
                                                  icon1 = FontAwesomeIcons.video;
                                                } else if (storedMaster[index].label == "Revise") {
                                                  icon1 = Icons.numbers_outlined;
                                                } else if (storedMaster[index].type == "PPT") {
                                                  icon1 = FontAwesomeIcons.laptopFile;
                                                } else if (storedMaster[index].type == "Domain") {
                                                  icon1 = FontAwesomeIcons.bahai;
                                                } else if (storedMaster[index].label == "Remember") {
                                                  icon1 = FontAwesomeIcons.lightbulb;
                                                } else if (storedMaster[index].name == "Tips4U") {
                                                  icon1 = FontAwesomeIcons.rankingStar;
                                                } else if (storedMaster[index].type == "Flash Cards") {
                                                  icon1 = FontAwesomeIcons.tableColumns;
                                                } else if (storedMaster[index].type == "Support") {
                                                  icon1 = FontAwesomeIcons.userGraduate;
                                                } else if (storedMaster[index].type == "Mock Test") {
                                                  icon1 = FontAwesomeIcons.bookOpenReader;
                                                } else if (storedMaster[index].type == "Practice Test") {
                                                  icon1 = FontAwesomeIcons.book;
                                                } else {
                                                  icon1 = (Icons.add_chart_rounded);
                                                }
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 22.0,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 8.0),
                                                    child: Container(
                                                        height: 70,
                                                        decoration: BoxDecoration(
                                                            color: Colors.transparent,
                                                            border: Border(
                                                              bottom: BorderSide(
                                                                  width: 1.5,
                                                                  color: Color.fromARGB(255, 219, 211, 211)),
                                                            )),
                                                        child: InkWell(
                                                          onTap: () async {
                                                            courseProvider.changeonTap(0);
                                                            if (courseProvider.tapOnce == 0) {
                                                              courseProvider.changeonTap(1);
                                                              courseProvider
                                                                  .setSelectedMasterId(storedMaster[index].id);

                                                              print(
                                                                  "id of the master list===${storedMaster[index].id}");
                                                              String page = storedMaster[index].type;

                                                              courseProvider
                                                                  .setMasterListType(storedMaster[index].type);

                                                              print("page=====$page");

                                                              if (page == "PPT") {
                                                                courseProvider.getPptCategory(storedMaster[index].id);

                                                                Future.delayed(Duration(milliseconds: 0), () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => PPTCardItem(
                                                                              title: storedMaster[index].name)));
                                                                });
                                                              }

                                                              if (page == "Domain") {
                                                                ProfileProvider pp =
                                                                    Provider.of(context, listen: false);
                                                                DomainProvider dp = Provider.of(context, listen: false);
                                                                pp.updateLoader(true);
                                                                await dp.getDomainData(
                                                                    storedMaster[index].id, cp.selectedCourseId);
                                                                var checkStat = dp.domainStatus;
                                                                pp.updateLoader(false);
                                                                print("====checkStat====$checkStat");
                                                                if (checkStat == false) {
                                                                  // print("")
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => RandomPage(
                                                                                categoryType: "Domain",
                                                                                categoryId: storedMaster[index].id,
                                                                                index: 6,
                                                                                price: storedMaster[index].price,
                                                                              )));
                                                                } else {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => DomainList(
                                                                              domainName: storedMaster[index].name)));
                                                                }
                                                              }
                                                              if (page == "Videos") {
                                                                print("this tab is being tapppppedddd");
                                                                courseProvider.getVideoCate(storedMaster[index].id);
                                                                Future.delayed(Duration(milliseconds: 0), () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => VideoLibraryPage(
                                                                              title: storedMaster[index].name)));
                                                                });
                                                              }
                                                              if (page == "Support") {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            ApplicationSupportPage()));
                                                              }
                                                              if (page == "Flash Cards") {
                                                                courseProvider.getFlashCate(storedMaster[index].id);
                                                                Future.delayed(Duration(milliseconds: 0), () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => FlashCardItem(
                                                                                title: storedMaster[index].name,
                                                                              )));
                                                                });
                                                              }
                                                              if (page == "Mock Test") {
                                                                print(
                                                                    "storedMaster[index].idooooooooooooooooooooooooooo${storedMaster[index].id}");
                                                                courseProvider.getTest(
                                                                    storedMaster[index].id, "Mock Test");
                                                                Future.delayed(Duration.zero, () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => MockTest(
                                                                                testName: storedMaster[index].name,
                                                                                testType: storedMaster[index].type,
                                                                              )));
                                                                });
                                                              }
                                                              if (page == "Practice Test") {
                                                                courseProvider.getTest(
                                                                    storedMaster[index].id, "Practice Test");
                                                                Future.delayed(Duration.zero, () async {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => MockTest(
                                                                                testName: storedMaster[index].name,
                                                                                testType: storedMaster[index].type,
                                                                              )));
                                                                });
                                                              }
                                                            }
                                                          },
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
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      color: index % 2 == 0
                                                                          ? AppColor.purpule
                                                                          : AppColor.green,
                                                                    ),
                                                                    child: Center(
                                                                      child: Icon(
                                                                        icon1,
                                                                        color: Colors.white,
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
                                                                    width: MediaQuery.of(context).size.width * .65,
                                                                    // color: Colors.amber,
                                                                    child: RichText(
                                                                        overflow: TextOverflow.ellipsis,
                                                                        maxLines: 2,
                                                                        // textAlign: TextAlign.center,
                                                                        text: TextSpan(children: <TextSpan>[
                                                                          TextSpan(
                                                                            text: storedMaster[index].label,
                                                                            style: TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 14,

                                                                              // fontFamily: AppFont.poppinsRegular,
                                                                            ),
                                                                          ),
                                                                        ])),
                                                                  ),

                                                              
                                                                  SizedBox(
                                                                    height: 3,
                                                                  ),
                                                                  Container(
                                                                    width: MediaQuery.of(context).size.width * .65,
                                                                    child: RichText(
                                                                        overflow: TextOverflow.ellipsis,
                                                                        maxLines: 2,
                                                                        // textAlign: TextAlign.center,
                                                                        text: TextSpan(children: <TextSpan>[
                                                                          TextSpan(
                                                                            text: storedMaster[index].name,
                                                                            style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 18,

                                                                              // fontFamily: AppFont.poppinsRegular,
                                                                            ),
                                                                          ),
                                                                        ])),
                                                                
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                );
                                              }),
                                        ),
                                      )
                                    : Container(
                                        height: 150,
                                        child: Center(
                                          child: Text("No Data Found", style: TextStyle(fontSize: 18)),
                                        ),
                                      );
                              });
                            }),
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
