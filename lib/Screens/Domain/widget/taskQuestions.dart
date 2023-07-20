import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/Domain/screens/Models/taskModel.dart';
import 'package:pgmp4u/Screens/Domain/screens/domainProvider.dart';
import 'package:provider/provider.dart';

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
    return Consumer<DomainProvider>(builder: (context, dp, child) {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          // color: Colors.amber,dp.TaskQues[index].rightAnswer.split(',')
          child: PageView.builder(
              itemCount: dp.TaskQues.length,
              onPageChanged: (indx) {
                print("indx valuee====$indx");
                enableTap = 0;
                isAnsCorrect = 0;
                selAns = [];
                rightAns = [];
                correctAns = [];
                ansRef = [];
                print("selAns===$selAns");
                print("ansRef===$ansRef");
              },
              itemBuilder: (context, indexxx) {
                List<TaskOptions> Taskop = [];
                if (dp.TaskQues.isNotEmpty) {
                  Taskop = dp.TaskQues[indexxx].options.where((element) => element.questionOption.isNotEmpty).toList();
                }
                return  Container(
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
                                        : Icon(
                                            Icons.west,
                                            size: 20,
                                            color: Colors.black,
                                          ),
                                    Text(
                                      'QUESTION ${indexxx + 1}',
                                      style: TextStyle(
                                        fontFamily: 'Roboto Regular',
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    indexxx == dp.TaskQues.length - 1
                                        ? SizedBox()
                                        : Icon(
                                            Icons.east,
                                            size: 20,
                                            color: Colors.black,
                                          ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  dp.TaskQues[indexxx].question,
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
                                      "Maximum selection: ${dp.TaskQues[indexxx].rightAnswer.split(',').length}",
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
                                    itemBuilder: (context, index) {
                                      return Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0),
                                          child: InkWell(
                                            onTap: () {
                                              if (enableTap == 0) {
                                                rightAns = [];
                                                ansRef = [];

                                                rightAns = dp.TaskQues[indexxx].rightAnswer.split(',');
                                                print("rightAns========>>>$rightAns");

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
                                              height: 100,
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
                                                                              !ansRef.contains(Taskop[index].id)
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
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                          // height: 10,
                                                          ),
                                                      Container(
                                                          width: 280,
                                                          child: Text(
                                                            Taskop[index].questionOption,
                                                            maxLines: 5,
                                                          )),
                                                      (selAns.length == ansRef.length &&
                                                                  selAns.length > 0 &&
                                                                  selAns.contains(Taskop[index].id) &&
                                                                  ansRef.contains(Taskop[index].id)) ||
                                                              (selAns.length == ansRef.length &&
                                                                  selAns.length > 0 &&
                                                                  ansRef.contains(Taskop[index].id))
                                                          ? Container(
                                                              width: 280,
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
                                                                  width: 280,
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                    children: [Text("Your Selection")],
                                                                  ),
                                                                )
                                                              : Container()
                                                    ],
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
                                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                                                      dp.TaskQues[indexxx].rightAnswer == Taskop[0].id.toString()
                                                          ? 'Answer A is the correct one'
                                                          : dp.TaskQues[indexxx].rightAnswer == Taskop[1].id.toString()
                                                              ? 'Answer B is the correct one'
                                                              : dp.TaskQues[indexxx].rightAnswer ==
                                                                      Taskop[2].id.toString()
                                                                  ? 'Answer c is the correct one'
                                                                  : dp.TaskQues[indexxx].rightAnswer ==
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
                                                      dp.TaskQues[indexxx].explanation,
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
      );
    });
  }
}

Color _colorfromhex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}
