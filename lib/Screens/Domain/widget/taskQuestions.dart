import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../MockTest/model/taskQuesModel.dart';
import '../../Tests/local_handler/hive_handler.dart';
import '../screens/domainProvider.dart';

class TaskQuestion extends StatefulWidget {
  const TaskQuestion({Key key}) : super(key: key);

  @override
  State<TaskQuestion> createState() => _TaskQuestionState();
}

class _TaskQuestionState extends State<TaskQuestion> {
  List<int> selAns = [];
  List<String> rightAns = [];
  List<int> correctAns = [];
  List<int> ansRef = [];
  int isAnsCorrect = 0;
  PageController pageController;

  int curIndex;
  @override
  List<TaskQues> storedTaskQues = [];
  void initState() {
    print("is thisss callingggg.....");
    curIndex = 0;
    pageController = PageController();
    super.initState();
  }

  int enableTap = 0;
  bool _show = true;

  void checkAllAns(List<int> selAns, List<int> rightAns) {
    bool isListSame = true;
    print("inside checkAllAns===============================");
    selAns.sort();
    print("selAns======$selAns");
    print("rightAns======$rightAns");

    for (int i = 0; i < selAns.length; i++) {
      if (selAns[i] == rightAns[i]) {
      } else {
        isListSame = false;
        break;
      }
    }
    if (isListSame) {
      isAnsCorrect = 1;
      print("same are both the lkstssss == answer correct");
    } else {
      isAnsCorrect = 2;
      print("  list are not same are both the lkstssss   answer incorrect");
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: HiveHandler.getTaskQuesListener(),
          builder: (context, value, child) {
            DomainProvider dp = Provider.of(context, listen: false);
            print("dp.selectedDomainId.toString():::::${dp.selectedTaskId.toString()}");
            if (value.containsKey(dp.selectedTaskId.toString())) {
              print("key is ppresenttttt");
              List taskQuesList = jsonDecode(value.get(dp.selectedTaskId.toString()));
              // List temp2 =
              // taskList[0]["practiceTest"];
              storedTaskQues = taskQuesList.map((e) => TaskQues.fromJson(e)).toList();
              print("storedTasks storedTaskQues List:::::: $storedTaskQues");
              // print("storedTasks List  keywrod:::::: ${taskList[0]["Keywords"]}");
              // print("storedTasks List question:::::: ${taskList[0]["practiceTest"]}");
            } else {
              storedTaskQues = [];
            }
            if (storedTaskQues == null) {
              storedTaskQues = [];
            }
            print("storedTaskQues:::::::$storedTaskQues");
            return Consumer<DomainProvider>(builder: (context, dp, child) {
              return Stack(
                children: [
                  Padding(
                    padding: isAnsCorrect > 0
                        ? const EdgeInsets.only(top: 60.0, bottom: 15, left: 15, right: 15)
                        : const EdgeInsets.only(top: 15.0, bottom: 15, left: 15, right: 15),
                    child: Container(
                      // dp.TaskQues[index].rightAnswer.split(',')
                      child: PageView.builder(
                          controller: pageController,
                          itemCount: storedTaskQues.length,
                          onPageChanged: (indx) {
                            curIndex = indx;
                            print("indx valuee====$indx");
                            enableTap = 0;
                            isAnsCorrect = 0;
                            selAns = [];
                            rightAns = [];
                            correctAns = [];
                            ansRef = [];
                            print("selAns===$selAns");
                            print("ansRef===$ansRef");
                            setState(() {});
                          },
                          itemBuilder: (context, indexxx) {
                            List<TaskQuesOption> Taskop = [];
                            if (storedTaskQues.isNotEmpty) {
                              Taskop = storedTaskQues[indexxx]
                                  .options
                                  .where((element) => element.questionOption.isNotEmpty)
                                  .toList();
                              // storedTaskQues[indexxx].options
                              //     .where((element) => element.questionOption.isNotEmpty)
                              //     .toList();
                            }
                            return storedTaskQues.isEmpty
                                ? Center(
                                    child: Text("No Data Found..."),
                                  )
                                : Container(
                                    // color: index % 2 == 0 ? Colors.black : Colors.brown,
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                indexxx == 0
                                                    ? SizedBox()
                                                    : InkWell(
                                                        onTap: () {
                                                          pageController.animateToPage(--curIndex,
                                                              duration: Duration(milliseconds: 500),
                                                              curve: Curves.easeInCirc);
                                                        },
                                                        child: Icon(
                                                          Icons.west,
                                                          size: 20,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                Text(
                                                  'QUESTION ${indexxx + 1}',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto Regular',
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                indexxx == storedTaskQues.length - 1
                                                    ? SizedBox()
                                                    : InkWell(
                                                        onTap: () {
                                                          // print("======${++curIndex}");
                                                          pageController.animateToPage(++curIndex,
                                                              duration: Duration(milliseconds: 500),
                                                              curve: Curves.easeInCirc);
                                                        },
                                                        child: Icon(
                                                          Icons.east,
                                                          size: 20,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              storedTaskQues[indexxx].question,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Maximum selection: ${storedTaskQues[indexxx].rightAnswer.split(',').length}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto Regular',
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: Taskop.length,
                                                physics: NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                      padding: const EdgeInsets.only(bottom: 8.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          if (enableTap == 0) {
                                                            rightAns = [];
                                                            ansRef = [];

                                                            rightAns = storedTaskQues[indexxx].rightAnswer.split(',');
                                                            // print("rightAns========>>>$rightAns");

                                                            for (int i = 0; i < rightAns.length; i++) {
                                                              ansRef.add(int.parse(rightAns[i]));
                                                            }
                                                            print("ansRef=========>>>>>>$ansRef");

                                                            selAns.add(Taskop[index].id);
                                                            print("selAns=============$selAns");

                                                            print("selAns.length=====${selAns.length}");
                                                            print(" ansRef.length====${ansRef.length}");

                                                            if (selAns.length == ansRef.length && ansRef.length > 0) {
                                                              print("***********$selAns");
                                                              print("***********$ansRef");
                                                              print("so is inside this alsoooo");

                                                              checkAllAns(selAns, ansRef);
                                                              enableTap = 1;
                                                              // dp.setList(selAns, ansRef);
                                                            }
                                                            setState(() {});
                                                          }
                                                        },
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width * .70,
                                                          height: width * 100 / 420,
                                                          // height: 100,
                                                          color: selAns.contains(Taskop[index].id) &&
                                                                  ansRef.contains(Taskop[index].id) &&
                                                                  selAns.length == ansRef.length &&
                                                                  selAns.length > 0
                                                              ? _colorfromhex("#E6F7E7")
                                                              : selAns.contains(Taskop[index].id) &&
                                                                      !ansRef.contains(Taskop[index].id) &&
                                                                      selAns.length == ansRef.length &&
                                                                      selAns.length > 0
                                                                  ? _colorfromhex("#FFF6F6")
                                                                  : ansRef.contains(Taskop[index].id) &&
                                                                          selAns.length == ansRef.length &&
                                                                          selAns.length > 0
                                                                      ? _colorfromhex("#E6F7E7")
                                                                      : selAns.contains(Taskop[index].id) &&
                                                                              ansRef.contains(Taskop[index].id)
                                                                          ? _colorfromhex("#E6F7E7")
                                                                          : selAns.contains(Taskop[index].id) &&
                                                                                  !ansRef.contains(Taskop[index].id)
                                                                              ? _colorfromhex("#FFF6F6")
                                                                              : Colors.white,
                                                          child: Row(
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundColor: Colors.black,
                                                                radius: 13,
                                                                child: CircleAvatar(
                                                                  radius: 12,
                                                                  backgroundColor: selAns.contains(Taskop[index].id) &&
                                                                          ansRef.contains(Taskop[index].id) &&
                                                                          selAns.length == ansRef.length &&
                                                                          selAns.length > 0
                                                                      ? Colors.green
                                                                      : selAns.contains(Taskop[index].id) &&
                                                                              !ansRef.contains(Taskop[index].id) &&
                                                                              selAns.length == ansRef.length &&
                                                                              selAns.length > 0
                                                                          ? Colors.red
                                                                          : ansRef.contains(Taskop[index].id) &&
                                                                                  selAns.length == ansRef.length &&
                                                                                  selAns.length > 0
                                                                              ? Colors.green
                                                                              : selAns.contains(Taskop[index].id) &&
                                                                                      ansRef.contains(Taskop[index].id)
                                                                                  ? Colors.green
                                                                                  : selAns.contains(Taskop[index].id) &&
                                                                                          !ansRef.contains(
                                                                                              Taskop[index].id)
                                                                                      ? Colors.red
                                                                                      : Colors.white,
                                                                  child: Text(
                                                                    index == 0
                                                                        ? 'A'
                                                                        : index == 1
                                                                            ? 'B'
                                                                            : index == 2
                                                                                ? 'C'
                                                                                : index == 3
                                                                                    ? 'D'
                                                                                    : 'E',
                                                                    style: TextStyle(
                                                                        fontFamily: 'Roboto Regular',
                                                                        fontSize: 14,
                                                                        color: Colors.black),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              Container(
                                                                // color: Colors.amber,
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    SizedBox(
                                                                        // height: 20,
                                                                        ),
                                                                    Container(
                                                                        width: MediaQuery.of(context).size.width * .70,
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(left: 8.0),
                                                                          child: Text(
                                                                            Taskop[index].questionOption,
                                                                            maxLines: 5,
                                                                          ),
                                                                        )),
                                                                    (selAns.length == ansRef.length &&
                                                                                selAns.length > 0 &&
                                                                                selAns.contains(Taskop[index].id) &&
                                                                                ansRef.contains(Taskop[index].id)) ||
                                                                            (selAns.length == ansRef.length &&
                                                                                selAns.length > 0 &&
                                                                                ansRef.contains(Taskop[index].id))
                                                                        ? Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width * .72,
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: [Text("Correct Answer")],
                                                                            ),
                                                                          )
                                                                        : selAns.length == ansRef.length &&
                                                                                selAns.length > 0 &&
                                                                                selAns.contains(Taskop[index].id) &&
                                                                                !ansRef.contains(Taskop[index].id)
                                                                            ? Container(
                                                                                width:
                                                                                    MediaQuery.of(context).size.width *
                                                                                        .72,
                                                                                child: Row(
                                                                                  mainAxisAlignment:
                                                                                      MainAxisAlignment.end,
                                                                                  children: [Text("Your Selection")],
                                                                                ),
                                                                              )
                                                                            : Container(),
                                                                    SizedBox(
                                                                      height: 10,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ));
                                                }),
                                            // InkWell(
                                            //   onTap: () {
                                            //     print("selAns.length====${selAns.length}");
                                            //     print("ansRef.length ====${ansRef.length}");
                                            //   },
                                            //   child: Container(
                                            //     height: 50,
                                            //     width: 10,
                                            //     color: Colors.deepPurple,
                                            //   ),
                                            // ),
                                            (selAns.length == ansRef.length) && (ansRef.length > 0)
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            // Colors .amber,
                                                            _colorfromhex("#FAFAFA"),
                                                        borderRadius: BorderRadius.circular(6)),
                                                    margin: EdgeInsets.only(top: height * (38 / 800)),
                                                    padding: EdgeInsets.only(
                                                        top: height * (10 / 800),
                                                        bottom: _show ? height * (23 / 800) : height * (12 / 800),
                                                        left: width * (18 / 420),
                                                        right: width * (10 / 420)),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              _show = !_show;
                                                            });
                                                          },
                                                          child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                Text(
                                                                  'See Solution',
                                                                  style: TextStyle(
                                                                    fontFamily: 'Roboto Regular',
                                                                    fontSize: 16,
                                                                    color: _colorfromhex("#ABAFD1"),
                                                                    height: 1.7,
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  _show ? Icons.expand_less : Icons.expand_more,
                                                                  size: width * (30 / 420),
                                                                  color: _colorfromhex("#ABAFD1"),
                                                                ),
                                                              ]),
                                                        ),
                                                        _show
                                                            ? Container(
                                                                margin: EdgeInsets.only(top: height * (9 / 800)),
                                                                child: Text(
                                                                  storedTaskQues[indexxx].rightAnswer ==
                                                                          Taskop[0].id.toString()
                                                                      ? 'Answer A is the correct one'
                                                                      : storedTaskQues[indexxx].rightAnswer ==
                                                                              Taskop[1].id.toString()
                                                                          ? 'Answer B is the correct one'
                                                                          : storedTaskQues[indexxx].rightAnswer ==
                                                                                  Taskop[2].id.toString()
                                                                              ? 'Answer c is the correct one'
                                                                              : storedTaskQues[indexxx].rightAnswer ==
                                                                                      Taskop[3].id.toString()
                                                                                  ? 'Answer D is the correct one'
                                                                                  : 'Answer E is the correct one',
                                                                  style: TextStyle(
                                                                    fontFamily: 'Roboto Regular',
                                                                    fontSize: 16,
                                                                    color: _colorfromhex("#04AE0B"),
                                                                    height: 1.7,
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(),
                                                        _show
                                                            ? Container(
                                                                margin: EdgeInsets.only(top: height * (9 / 800)),
                                                                child: Text(
                                                                  storedTaskQues[indexxx].explanation,
                                                                  style: TextStyle(
                                                                    fontFamily: 'Roboto Regular',
                                                                    fontSize: width * (15 / 420),
                                                                    color: Colors.black,
                                                                    height: 1.6,
                                                                  ),
                                                                ),
                                                              )
                                                            : Container()
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox()
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                          }),
                    ),
                  ),
                  isAnsCorrect == 1
                      ? Positioned(
                          top: 1,
                          // top: SizerUtil.deviceType == DeviceType.mobile ? 80 : 100,
                          left: width / 2.3,
                          child: Container(
                            width: 60,
                            height: 60,
                            child: Image.asset('assets/smile.png'),
                          ))
                      : isAnsCorrect == 2
                          ? Positioned(
                              top: 1,
                              // top: SizerUtil.deviceType == DeviceType.mobile ? 80 : 100,
                              left: width / 2.3,
                              child: Container(
                                width: 60,
                                height: 60,
                                child: Image.asset('assets/smiley-sad1.png'),
                              ))
                          : SizedBox()
                ],
              );
            });
          }),
    );
  }
}

Color _colorfromhex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}
