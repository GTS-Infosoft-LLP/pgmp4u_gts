import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pgmp4u/Process/processDomainProvider.dart';
import 'package:provider/provider.dart';

import '../Screens/MockTest/model/taskQuesModel.dart';
import '../Screens/Tests/local_handler/hive_handler.dart';

class ProcessTaskQuestions extends StatefulWidget {
  const ProcessTaskQuestions({Key key}) : super(key: key);

  @override
  State<ProcessTaskQuestions> createState() => _ProcessTaskQuestionsState();
}

class _ProcessTaskQuestionsState extends State<ProcessTaskQuestions> {
  List<int> selAns = [];
  List<String> rightAns = [];
  List<int> correctAns = [];
  List<int> ansRef = [];
  int isAnsCorrect = 0;
  PageController pageController;

  int curIndex;

  List<TaskQues> storedProcessTaskQues = [];
  @override
  void initState() {
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
          valueListenable: HiveHandler.getProcessTaskQuesListener(),
          builder: (context, value, child) {
            ProcessDomainProvider pdp = Provider.of(context, listen: false);
            print("dp.selectedProcessTaskId.toString():::::${pdp.selectedProcessTaskId.toString()}");
            if (value.containsKey(pdp.selectedProcessTaskId.toString())) {
              print("key is ppresenttttt");
              List processTaskQuesList = jsonDecode(value.get(pdp.selectedProcessTaskId.toString()));

              storedProcessTaskQues = processTaskQuesList.map((e) => TaskQues.fromJson(e)).toList();
              print("storedProcessTaskQues storedProcessTaskQues List:::::: $storedProcessTaskQues");
              // print("storedTasks List  keywrod:::::: ${taskList[0]["Keywords"]}");
              // print("storedTasks List question:::::: ${taskList[0]["practiceTest"]}");
            } else {
              print("key is absenttttt");
              storedProcessTaskQues = [];
            }
            if (storedProcessTaskQues == null) {
              storedProcessTaskQues = [];
            }

            return Consumer<ProcessDomainProvider>(
              builder: (context, pdp, child) {
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
                            itemCount: storedProcessTaskQues.length,
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
                              if (storedProcessTaskQues.isNotEmpty) {
                                Taskop = storedProcessTaskQues[indexxx]
                                    .options
                                    .where((element) => element.questionOption.isNotEmpty)
                                    .toList();
                                // storedTaskQues[indexxx].options
                                //     .where((element) => element.questionOption.isNotEmpty)
                                //     .toList();
                              }
                              return storedProcessTaskQues.isEmpty
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
                                                  indexxx == storedProcessTaskQues.length - 1
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
                                                storedProcessTaskQues[indexxx].question,
                                                style: TextStyle(color: Colors.black, fontSize: 17),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Maximum selection: ${storedProcessTaskQues[indexxx].rightAnswer.split(',').length}",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto Regular',
                                                      fontSize: 17,
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
                                                        padding: const EdgeInsets.only(bottom: 20.0),
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (enableTap == 0) {
                                                              rightAns = [];
                                                              ansRef = [];

                                                              rightAns =
                                                                  storedProcessTaskQues[indexxx].rightAnswer.split(',');
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
                                                              }
                                                              setState(() {});
                                                            }
                                                          },
                                                          child: Container(
                                                            width: MediaQuery.of(context).size.width * .70,
                                                            // height: height * 60 / 420,
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
                                                                    backgroundColor: selAns
                                                                                .contains(Taskop[index].id) &&
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
                                                                                        ansRef
                                                                                            .contains(Taskop[index].id)
                                                                                    ? Colors.green
                                                                                    : selAns.contains(
                                                                                                Taskop[index].id) &&
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
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      SizedBox(
                                                                          // height: 20,
                                                                          ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(bottom: 0.0),
                                                                        child: Container(
                                                                            // color: Colors.white,
                                                                            width:
                                                                                MediaQuery.of(context).size.width * .70,
                                                                            child: Padding(
                                                                              padding: const EdgeInsets.only(left: 8.0),
                                                                              child: Column(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment.center,
                                                                                crossAxisAlignment:
                                                                                    CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    Taskop[index].questionOption,
                                                                                    style: TextStyle(fontSize: 15),
                                                                                    // maxLines: 3,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )),
                                                                      ),
                                                                      (selAns.length == ansRef.length &&
                                                                                  selAns.length > 0 &&
                                                                                  selAns.contains(Taskop[index].id) &&
                                                                                  ansRef.contains(Taskop[index].id)) ||
                                                                              (selAns.length == ansRef.length &&
                                                                                  selAns.length > 0 &&
                                                                                  ansRef.contains(Taskop[index].id))
                                                                          ? Container(
                                                                              width: MediaQuery.of(context).size.width *
                                                                                  .72,
                                                                              child: Row(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment.end,
                                                                                children: [Text("Correct Answer")],
                                                                              ),
                                                                            )
                                                                          : selAns.length == ansRef.length &&
                                                                                  selAns.length > 0 &&
                                                                                  selAns.contains(Taskop[index].id) &&
                                                                                  !ansRef.contains(Taskop[index].id)
                                                                              ? Container(
                                                                                  width: MediaQuery.of(context)
                                                                                          .size
                                                                                          .width *
                                                                                      .72,
                                                                                  child: Row(
                                                                                    mainAxisAlignment:
                                                                                        MainAxisAlignment.end,
                                                                                    children: [Text("Your Selection")],
                                                                                  ),
                                                                                )
                                                                              : Container(),
                                                                      SizedBox(
                                                                          // height: 10,
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
                                                          color: _colorfromhex("#FAFAFA"),
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
                                                                print(
                                                                    "storedProcessTaskQues[indexxx].explanation${storedProcessTaskQues[indexxx].explanation}");
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
                                                                    "${getTstAns(Taskop)}",
                                                                    // storedTaskQues[indexxx].rightAnswer ==
                                                                    //         Taskop[0].id.toString()
                                                                    //     ? 'Answer A is the correct one'
                                                                    //     : storedTaskQues[indexxx].rightAnswer ==
                                                                    //             Taskop[1].id.toString()
                                                                    //         ? 'Answer B is the correct one'
                                                                    //         : storedTaskQues[indexxx].rightAnswer ==
                                                                    //                 Taskop[2].id.toString()
                                                                    //             ? 'Answer c is the correct one'
                                                                    //             : storedTaskQues[indexxx].rightAnswer ==
                                                                    //                     Taskop[3].id.toString()
                                                                    //                 ? 'Answer D is the correct one'
                                                                    //                 : 'Answer E is the correct one',
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
                                                                  child: Html(
                                                                    data: storedProcessTaskQues[indexxx].explanation,
                                                                    style: {
                                                                      "body": Style(
                                                                        padding: EdgeInsets.only(top: 5),
                                                                        fontFamily: 'Roboto Regular',
                                                                        margin: EdgeInsets.zero,
                                                                        color: Color(0xff000000),
                                                                        maxLines: 7,
                                                                        textOverflow: TextOverflow.ellipsis,
                                                                        fontSize: FontSize(
                                                                          width * (15 / 420),
                                                                        ),
                                                                      )
                                                                    },
                                                                  ),
                                                                  //     Text(
                                                                  //   storedTaskQues[indexxx].explanation,
                                                                  //   style: TextStyle(
                                                                  //     fontFamily: 'Roboto Regular',
                                                                  //     fontSize: width * (15 / 420),
                                                                  //     color: Colors.black,
                                                                  //     height: 1.6,
                                                                  //   ),
                                                                  // ),
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
                  ],
                );
              },
            );
          }),
    );
  }

  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  String getTstAns(List<TaskQuesOption> op) {
    String correct = "";
    print("rightAns lenght===${rightAns.length}");
    print("rightAns ===$rightAns");
    for (int i = 0; i < op.length; i++) {
      print("op>>>>>>>>>>${op[i].id}");
    }
    print("op length>>>>>>>..${op.length}");
    if (rightAns.contains(op[2].id.toString()) &&
        rightAns.contains(op[3].id.toString()) &&
        rightAns.contains(op[1].id.toString())) {
      print(" b c and d are presettttttt ");
    } else {
      print("b c and d are absent");
    }

    if (rightAns.length == 1) {
      if (rightAns.contains(op[0].id.toString())) {
        print("this is correct");
        correct = 'Answer A is the correct one';
      } else if (rightAns.contains(op[1].id.toString())) {
        correct = 'Answer B is the correct one';
      } else if (rightAns.contains(op[2].id.toString())) {
        correct = 'Answer C is the correct one';
        print("this is correct ans c");
      } else if (rightAns.contains(op[3].id.toString())) {
        correct = 'Answer D is the correct one';
      } else {
        correct = 'Answer E is the correct one';
      }
    } else if (rightAns.length == 2) {
      if (op.length > 4) {
        print("E option is present ");

        if (rightAns.contains(op[0].id.toString()) && rightAns.contains(op[4].id.toString())) {
          correct = "Answer A and E are the correct one";
        } else if (rightAns.contains(op[1].id.toString()) && rightAns.contains(op[4].id.toString())) {
          correct = "Answer B and E are the correct one";
        } else if (rightAns.contains(op[2].id.toString()) && rightAns.contains(op[4].id.toString())) {
          correct = "Answer C and E are the correct one";
        } else if (rightAns.contains(op[3].id.toString()) && rightAns.contains(op[4].id.toString())) {
          correct = "Answer D and E are the correct one";
        }
      } else {
        print("E option is not present and means its absent ");
        if (rightAns.contains(op[0].id.toString()) && rightAns.contains(op[1].id.toString())) {
          correct = "Answer A and B are the correct one";
        } else if (rightAns.contains(op[0].id.toString()) && rightAns.contains(op[2].id.toString())) {
          correct = "Answer A and C are the correct one";
        } else if (rightAns.contains(op[0].id.toString()) && rightAns.contains(op[3].id.toString())) {
          correct = "Answer A and D are the correct one";
        } else if (rightAns.contains(op[1].id.toString()) && rightAns.contains(op[2].id.toString())) {
          correct = "Answer B and C are the correct one";
        } else if (rightAns.contains(op[1].id.toString()) && rightAns.contains(op[3].id.toString())) {
          correct = "Answer B and D are the correct one";
        } else if (rightAns.contains(op[2].id.toString()) && rightAns.contains(op[3].id.toString())) {
          correct = "Answer C and D are the correct one";
        }
      }
    } else if (rightAns.length == 3) {
      print("checking for length 3");

      if (op.length > 4) {
        print("E option is present");
        if (rightAns.contains(op[0].id.toString()) &&
            rightAns.contains(op[1].id.toString()) &&
            rightAns.contains(op[4].id.toString())) {
          correct = "Answer A, B and E are the correct one";
        } else if (rightAns.contains(op[0].id.toString()) &&
            rightAns.contains(op[2].id.toString()) &&
            rightAns.contains(op[4].id.toString())) {
          correct = "Answer A, C and E are the correct one";
        } else if (rightAns.contains(op[0].id.toString()) &&
            rightAns.contains(op[3].id.toString()) &&
            rightAns.contains(op[4].id.toString())) {
          correct = "Answer A, D and E are the correct one";
        }
        if (rightAns.contains(op[1].id.toString()) &&
            rightAns.contains(op[2].id.toString()) &&
            rightAns.contains(op[4].id.toString())) {
          correct = "Answer B, C and E are the correct one";
        } else if (rightAns.contains(op[1].id.toString()) &&
            rightAns.contains(op[3].id.toString()) &&
            rightAns.contains(op[4].id.toString())) {
          correct = "Answer B, D and E are the correct one";
        } else if (rightAns.contains(op[2].id.toString()) &&
            rightAns.contains(op[3].id.toString()) &&
            rightAns.contains(op[4].id.toString())) {
          correct = "Answer C, D and E are the correct one";
        }
      } else {
        print("E option is not present and means its absent ");
        if (rightAns.contains(op[0].id.toString()) &&
            rightAns.contains(op[1].id.toString()) &&
            rightAns.contains(op[2].id.toString())) {
          correct = "Answer A, B and C are the correct one";
        } else if (rightAns.contains(op[0].id.toString()) &&
            rightAns.contains(op[1].id.toString()) &&
            rightAns.contains(op[3].id.toString())) {
          correct = "Answer A, B and D are the correct one";
        } else if (rightAns.contains(op[0].id.toString()) &&
            rightAns.contains(op[2].id.toString()) &&
            rightAns.contains(op[3].id.toString())) {
          correct = "Answer A, C and D are the correct one";
        } else if (rightAns.contains(op[2].id.toString()) &&
            rightAns.contains(op[3].id.toString()) &&
            rightAns.contains(op[1].id.toString())) {
          correct = "Answer B, C and D are the correct one";
        }
      }
    }
    print("correct======$correct");
    return correct;
  }
}
