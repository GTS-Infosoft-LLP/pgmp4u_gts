import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:pgmp4u/Screens/home_view/application_support.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:pgmp4u/tool/ShapeClipper.dart';
import 'package:provider/provider.dart';

import '../utils/app_color.dart';
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

  List<MasterDetails> Mastertemplist = [];
  void initState() {
    CourseProvider courseProvider = Provider.of(context, listen: false);
    print("master list===${courseProvider.masterList}");

    if (Mastertemplist.isEmpty) {
      Mastertemplist = HiveHandler.getMasterDataList(key: courseProvider.selectedCourseId.toString());
      print("*************************************************");
      print("tempList==========$Mastertemplist");
    }

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
                Container(
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
                      Center(
                          child: Text(
                        // "Video Library",
                        "Master Content",
                        style: TextStyle(
                            fontSize: 28, color: Colors.white, fontFamily: "Raleway", fontWeight: FontWeight.bold),
                      )),
                    ]),
                  ),
                )
              ],
            ),

            SizedBox(
              height: 15,
            ),

            Consumer<CourseProvider>(builder: (context, cp, child) {
              return SingleChildScrollView(
                child:
                    // Mastertemplist.isEmpty
                    //     ? Center(child: Container(height: 400, child: Text("No Data Found")))
                    //     :
                    Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: ValueListenableBuilder<Box<List<MasterDetails>>>(
                          valueListenable: HiveHandler.getMasterListener(),
                          builder: (context, value, child) {
                            CourseProvider cp = Provider.of(context, listen: false);
                            storedMaster = value.get(cp.selectedCourseId.toString());

                            print("storedMaster========================$storedMaster");

                            if (storedMaster == null) {
                              storedMaster = [];
                            }
                            // print("storedFlash========================${storedMaster[0].name}");

                            return Consumer<CourseProvider>(builder: (context, courseProvider, child) {
                              return storedMaster.isNotEmpty
                                  ? Container(
                                      height: MediaQuery.of(context).size.height * .75,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: storedMaster.length,
                                          itemBuilder: (context, index) {
                                            print("storedMaster[index].label=====${storedMaster[index].label}");
                                            if (storedMaster[index].type == "Videos") {
                                              icon1 = FontAwesomeIcons.video;
                                            } else if (storedMaster[index].label == "Revise") {
                                              icon1 = Icons.numbers_outlined;
                                            } else if (storedMaster[index].label == "Bytes") {
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
                                                    //  color: Colors.amber,
                                                    decoration: BoxDecoration(
                                                        // shape: BoxShape.circle,
                                                        color: Colors.transparent,
                                                        border: Border(
                                                          bottom: BorderSide(width: 1.5, color: Colors.grey[300]),
                                                        )),
                                                    // Border.all(color: Colors.black, width: 1)),
                                                    child: InkWell(
                                                      onTap: () {
                                                        courseProvider.setSelectedMasterId(storedMaster[index].id);

                                                        print("id of the master list===${storedMaster[index].id}");
                                                        String page = storedMaster[index].type;

                                                        courseProvider.setMasterListType(storedMaster[index].type);







                                                        print("page=====$page");

                                                        if (page == "Videos") {
                                                          courseProvider.getVideoCate(storedMaster[index].id);

                                                          Future.delayed(Duration(milliseconds: 400), () {
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
                                                                  builder: (context) => ApplicationSupportPage()));
                                                        }

                                                        if (page == "Flash Cards") {
                                                          courseProvider.getFlashCate(storedMaster[index].id);

                                                          Future.delayed(Duration(milliseconds: 400), () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => FlashCardItem(
                                                                          title: storedMaster[index].name,
                                                                        )));
                                                          });
                                                        }

                                                        if (page == "Mock Test") {
                                                          courseProvider.getTest(storedMaster[index].id);

                                                          Future.delayed(Duration(milliseconds: 700), () {
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
                                                          courseProvider.getTest(storedMaster[index].id);

                                                          Future.delayed(const Duration(milliseconds: 700), () async {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => MockTest(
                                                                          testName: storedMaster[index].name,
                                                                        )));
                                                          });
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
                                                                  // gradient: LinearGradient(
                                                                  //     begin: Alignment.topLeft,
                                                                  //     end: Alignment.bottomRight,
                                                                  //     colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                                                                ),

                                                                // color: Colors.black,
                                                                child: Icon(
                                                                  icon1,
                                                                  color: Colors.white,
                                                                )
                                                                // Icons.edit,color: Colors.white),
                                                                ),
                                                          ),
                                                          SizedBox(
                                                            width: 15,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                storedMaster[index].label,
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors.grey,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(context).size.width * .65,
                                                                child: Text(
                                                                  storedMaster[index].name,
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                    fontSize: 18,
                                                                    color: Colors.black,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                            );
                                            // Center(child: Text("No Data Found",style: TextStyle(color: Colors.black,fontSize: 18)),);
                                          }),
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

                    // SizedBox(height: 20,)
                  ],
                ),
              );
            }),

            //  SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
