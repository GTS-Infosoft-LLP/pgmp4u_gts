import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pgmp4u/Screens/Domain/screens/domainProvider.dart';
import 'package:pgmp4u/tool/ShapeClipper.dart';
import 'package:provider/provider.dart';

import 'domainQuestion.dart';

class TaskDetail extends StatefulWidget {
  const TaskDetail({Key key}) : super(key: key);

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  @override
  var currentIndex;
  int colorIndex;
  int count;
  PageController pageController;
  ScrollController scrollController;
  void initState() {
    colorIndex = 0;
    count = 100;
    pageController = PageController();
    scrollController = ScrollController();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    scrollController.dispose();
  }

  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DomainQuestions()));
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
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                    ),
                  ),
                ),
                Consumer<DomainProvider>(builder: (context, dp, child) {
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
                            "Task Details",
                            // cp.selectedCourseName,
                            maxLines: 2,
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
              Consumer<DomainProvider>(builder: (context, dp, child) {
                return dp.taskApiCall
                    ? Container(
                        height: MediaQuery.of(context).size.height * .60,
                        child: Center(child: CircularProgressIndicator.adaptive()))
                    : Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: Text(
                          "Details " + "${colorIndex + 1}" + "/${dp.TaskList.length}",
                          // cp.pptCategoryList[index].name,
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
              Consumer<DomainProvider>(builder: (context, dp, child) {
                return Container(
                    height: MediaQuery.of(context).size.height * .7,
                    // width: MediaQuery.of(context).size.width * .9,
                    // color: Colors.blue,
                    child: Stack(
                      children: [
                        PageView.builder(
                            controller: pageController,
                            itemCount: dp.TaskList.length,
                            onPageChanged: (index) {
                              print("index valuee====$index");
                              setState(() {
                                colorIndex = index;
                              });

                              if (colorIndex % 10 == 0) {
                                double maxWidth = MediaQuery.of(context).size.width - 10;
                                double eachTileWidth = MediaQuery.of(context).size.width * .08 + 4;
                                scrollController.animateTo(eachTileWidth * colorIndex,
                                    curve: Curves.easeInCubic, duration: Duration(seconds: 1));
                              }
                            },
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 15.0, top: 20),
                                child: Container(
                                  height: 100,
                                  // width: 100,
                                  // color: Colors.amber,
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Task",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      dp.TaskList[index].name,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                          fontFamily: "Roboto Regular"),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Discription",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: Container(
                                        height: MediaQuery.of(context).size.height * .54,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 4.0, right: 18),
                                          child: SingleChildScrollView(
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: Column(
                                                children: [
                                                  Html(
                                                    data: dp.TaskList != null ? dp.TaskList[index].description : '',
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
                                                  dp.TaskList[index].Image != null
                                                      ? Container(
                                                          width: MediaQuery.of(context).size.width * .92,
                                                          height: MediaQuery.of(context).size.height * .2,
                                                          decoration: BoxDecoration(
                                                            color: Colors.grey[300],
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(10),
                                                            child: CachedNetworkImage(
                                                              imageUrl: dp.TaskList[index].Image != null
                                                                  ? dp.TaskList[index].Image
                                                                  : '',
                                                              fit: BoxFit.cover,
                                                              // width: MediaQuery.of(context).size.width * .92,
                                                              // height: MediaQuery.of(context).size.height * .2,
                                                              placeholder: (context, url) => Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal: 78.0, vertical: 28),
                                                                child: CircularProgressIndicator(
                                                                  strokeWidth: 2,
                                                                  color: Colors.grey[400],
                                                                ),
                                                              ),
                                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                                            ),
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Html(
                                                    data: dp.TaskList != null
                                                        ? "Keywords: " + dp.TaskList[index].Keywords
                                                        : '',
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
                                                  Html(
                                                    data: dp.TaskList != null
                                                        ? "Examples: " + dp.TaskList[index].Examples
                                                        : '',
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
                                                  // Text(
                                                  //   "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                                                  //   style: TextStyle(
                                                  //     fontSize: 18,
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ]),
                                ),
                              );
                            }),
                        Container(
                          margin: const EdgeInsets.only(left: 10.0),
                          height: 12,
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: dp.TaskList.length,
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

                                // color: Colors.black,
                              ),
                            ),
                          ),
                        )
                      ],
                    ));
              }),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ));
  }
}
