import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pgmp4u/Process/processDomainProvider.dart';
import 'package:pgmp4u/Process/processQuestions.dart';
import 'package:pgmp4u/Process/processTask_model.dart';
import 'package:provider/provider.dart';

import '../Screens/Domain/disImage.dart';
import '../Screens/Domain/screens/Models/taskModel.dart';
import '../Screens/Tests/local_handler/hive_handler.dart';
import '../provider/courseProvider.dart';
import '../tool/ShapeClipper.dart';

class ProcessTaskDetails extends StatefulWidget {
  String subProcessName;
  ProcessTskDetails processTaskDetailsObj;
  ProcessTaskDetails({Key key, this.subProcessName, this.processTaskDetailsObj}) : super(key: key);

  @override
  State<ProcessTaskDetails> createState() => _ProcessTaskDetailsState();
}

class _ProcessTaskDetailsState extends State<ProcessTaskDetails> {
  var currentIndex;
  int colorIndex;
  int count;
  int isChange;
  PageController pageController;
  ScrollController scrollController;
  int isAnsCorrect = 0;
  var indexPg;
  // List<TaskDetails> storedTask = [];
  List storedProcessTask = [];

  @override
  void initState() {
    isChange = 0;
    colorIndex = 0;
    currentIndex = 0;
    count = 100;
    indexPg = 0;
    pageController = PageController();
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: currentIndex == 4
          ? SizedBox()
          : InkWell(
              onTap: () {
                print("currentIndex====$currentIndex");
                var plusIndex = ++currentIndex;
                print("plusIndex=====$plusIndex");

                pageController.animateToPage(plusIndex,
                    duration: Duration(milliseconds: 500), curve: Curves.easeInCirc);

                colorIndex++;

                print("current index====$currentIndex");
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * .9,
                  height: 50,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.only(bottomRight: Radius.circular(14.0)),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gradient: LinearGradient(
                        colors: [_colorfromhex('#3846A9'), _colorfromhex('#5265F8')],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1.0, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Next",
                          style: TextStyle(color: Colors.white, fontFamily: 'Roboto Medium', fontSize: 18),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.east,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: <Widget>[
              ClipPath(
                clipper: ShapeClipper(),
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                  ),
                ),
              ),
              Consumer<ProcessDomainProvider>(builder: (context, pdp, child) {
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
                        width: MediaQuery.of(context).size.width * .65,
                        child: Text(
                          // widget.subDomainName,
                          pdp.selectedProcessName,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontFamily: "Roboto Regular",
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                    ],
                  ),
                );
              }),
            ]),
            SizedBox(height: 20),
            Consumer<ProcessDomainProvider>(builder: (context, pdp, child) {
              return pdp.processTaskDetailApiCall
                  ? Container(
                      height: MediaQuery.of(context).size.height * .60,
                      child: Center(child: CircularProgressIndicator.adaptive()))
                  : Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Text(
                        "process task name",
                        // pdp.selectedProcessTaskName,
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    );
            }),
            SizedBox(
              height: 10,
            ),
            ValueListenableBuilder(
                valueListenable: HiveHandler.getTaskItemsListener(),
                builder: (context, value, child) {
                  ProcessDomainProvider pdp = Provider.of(context, listen: false);
                  if (value.containsKey(pdp.selectedProcessId.toString())) {
                    print("containsssss keyyyyy");
                    List taskList = jsonDecode(value.get(pdp.selectedProcessId.toString()));

                    storedProcessTask = taskList.map((e) => TaskDetails.fromjson(e)).toList();
                    print("storedTasks storedTaskQues List:::::: $storedProcessTask");
                    // print("storedTasks List  keywrod:::::: ${taskList[0]["Keywords"]}");
                    // print("storedTasks List question:::::: ${taskList[0]["practiceTest"]}");
                  } else {
                    storedProcessTask = [];
                  }
                  if (storedProcessTask == null) {
                    storedProcessTask = [];
                  }

                  return Consumer<ProcessDomainProvider>(builder: (context, pdp, child) {
                    return Container(
                        height: MediaQuery.of(context).size.height * .7,
                        // width: MediaQuery.of(context).size.width * .9,
                        // color: Colors.blue,
                        child: Stack(
                          children: [
                            PageView.builder(
                                controller: pageController,
                                itemCount: 5,
                                onPageChanged: (index) {
                                  setState(() {
                                    colorIndex = index;
                                    currentIndex = index;
                                  });

                                  if (colorIndex % 10 == 0) {
                                    double maxWidth = MediaQuery.of(context).size.width - 10;
                                    double eachTileWidth = MediaQuery.of(context).size.width * .08 + 4;
                                    scrollController.animateTo(eachTileWidth * colorIndex,
                                        curve: Curves.easeInCubic, duration: Duration(seconds: 1));
                                  }
                                },
                                itemBuilder: (context, index) {
                                  return storedProcessTask.isEmpty
                                      ? Center(child: Text("No Data Found"))
                                      : currentIndex == 0
                                          ? ProcessTaskDisc(context, 0, widget.processTaskDetailsObj)
                                          : currentIndex == 1
                                              ? ProcessTaskImg(context, 0, widget.processTaskDetailsObj)
                                              : currentIndex == 2
                                                  ? ProcessTaskExple(context, 0, widget.processTaskDetailsObj)
                                                  : currentIndex == 3
                                                      ? ProcessTaskKeywrd(context, 0, widget.processTaskDetailsObj)
                                                      :
                                                      //  SizedBox();
                                                      pdp.ProcessQues.isNotEmpty
                                                          ? ProcessTaskQuestions()
                                                          : Center(
                                                              child: Text(
                                                              "No Questions Available",
                                                              style: TextStyle(fontSize: 18),
                                                            ));
                                }),
                            pdp.processTaskDetailApiCall
                                ? SizedBox()
                                : Container(
                                    margin: const EdgeInsets.only(left: 10.0),
                                    height: 12,
                                    child: ListView.builder(
                                      controller: scrollController,
                                      itemCount: 5,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) => Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                              gradient: index <= colorIndex
                                                  ? LinearGradient(
                                                      colors: [
                                                        _colorfromhex("#3A47AD"),
                                                        _colorfromhex("#5163F3"),
                                                      ],
                                                      begin: const FractionalOffset(0.0, 0.0),
                                                      end: const FractionalOffset(1.0, 0.0),
                                                      stops: [0.0, 1.0],
                                                      tileMode: TileMode.clamp)
                                                  : LinearGradient(
                                                      colors: [
                                                        Colors.grey,
                                                        Colors.grey,
                                                      ],
                                                    )),
                                          height: 10,
                                          width: MediaQuery.of(context).size.width * .08,
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ));
                  });
                }),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  ProcessTaskDisc(BuildContext context, index, ProcessTskDetails tdo) {
    ProcessDomainProvider pdp = Provider.of(context, listen: false);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 10, bottom: 40),
        child: Column(children: [
          SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Task",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Roboto Regular',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Html(
              data: tdo.name,
              // dp.TaskDetailList != null || dp.TaskDetailList.isNotEmpty ? dp.TaskDetailList[currentIndex].name : '',
              style: {
                "body": Style(
                  padding: EdgeInsets.only(top: 5),
                  margin: EdgeInsets.zero,
                  color: Colors.black,
                  // Color.fromARGB(255, 110, 68, 68),
                  textAlign: TextAlign.left,
                  // maxLines: 7,
                  // textOverflow: TextOverflow.ellipsis,
                  fontSize: FontSize(18),
                )
              },
            ),

            //  Text(
            //   dp.TaskDetailList.isNotEmpty ? dp.TaskDetailList[currentIndex].name : "",
            //   textAlign: TextAlign.left,
            //   style:
            //       TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black, fontFamily: "Roboto Regular"),
            // ),
          ),
          SizedBox(
            height: 15,
          ),
          Consumer<CourseProvider>(builder: (context, cp, child) {
            return Align(
              alignment: Alignment.topLeft,
              child: Text(
                cp.selectedCourseLable == "PMP®" ? "Enablers" : "Description",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Roboto Regular',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            );
          }),
          SizedBox(
            height: 5,
          ),
          Html(
            data: tdo.description,
            // dp.TaskDetailList != null || dp.TaskDetailList.isNotEmpty
            //     ? dp.TaskDetailList[currentIndex].description
            //     : '',
            style: {
              "body": Style(
                padding: EdgeInsets.only(top: 5),
                margin: EdgeInsets.zero,
                color: Color(0xff000000),
                textAlign: TextAlign.left,
                // maxLines: 7,
                // textOverflow: TextOverflow.ellipsis,
                fontSize: FontSize(18),
              )
            },
          ),
        ]),
      ),
    );
  }

  ProcessTaskImg(BuildContext context, index, ProcessTskDetails tdo) {
    ProcessDomainProvider pdp = Provider.of(context, listen: false);
    print("dddd ${tdo.Image}");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25,
          ),
          Text(
            "  Flow Diagram",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: 'Roboto Regular',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10),
            child: InkWell(
              onTap: () async {
                bool result = await checkInternetConn();
                if (result) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageDispalyScreen(
                              // quesImages: pdp.ProcessTaskDetailList[index].Image,
                              )));
                } else {
                  EasyLoading.showInfo("Please check your Internet Connection");
                }
              },
              child: Container(
                // width: MediaQuery.of(context).size.width * .92,
                // height: MediaQuery.of(context).size.height * .2,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: tdo.Image,
                    // dp.TaskDetailList[index].Image != null ? dp.TaskDetailList[index].Image : '',
                    fit: BoxFit.cover,
                    // width: MediaQuery.of(context).size.width * .92,
                    // height: MediaQuery.of(context).size.height * .2,
                    placeholder: (context, url) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 78.0, vertical: 28),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey[400],
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                        height: MediaQuery.of(context).size.width * .4,
                        child: Center(
                            // child: Image.asset(tdo.Image),
                            child: Icon(Icons.error))),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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

  ProcessTaskExple(BuildContext context, index, ProcessTskDetails tdo) {
    ProcessDomainProvider pdp = Provider.of(context, listen: false);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15, top: 18, bottom: 38),
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Examples ",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Roboto Regular',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Html(
              data: tdo.Examples,
              //  dp.TaskDetailList != null ? dp.TaskDetailList[index].Examples : '',
              style: {
                "body": Style(
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  margin: EdgeInsets.zero,
                  color: Color(0xff000000),
                  textAlign: TextAlign.left,
                  // maxLines: 7,
                  // textOverflow: TextOverflow.ellipsis,
                  fontSize: FontSize(18),
                )
              },
            ),
          ],
        ),
      ),
    );
  }

  ProcessTaskKeywrd(BuildContext context, index, ProcessTskDetails tdo) {
    ProcessDomainProvider pdp = Provider.of(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "    Keywords",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Roboto Regular',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 80.0, left: 15),
            child: Html(
              data: tdo.Keywords,
              style: {
                "body": Style(
                  padding: EdgeInsets.only(top: 5),
                  margin: EdgeInsets.zero,
                  color: Color(0xff000000),
                  textAlign: TextAlign.left,
                  // maxLines: 7,
                  // textOverflow: TextOverflow.ellipsis,
                  fontSize: FontSize(18),
                )
              },
            ),
          ),
        ],
      ),
    );
  }
}

Color _colorfromhex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}
