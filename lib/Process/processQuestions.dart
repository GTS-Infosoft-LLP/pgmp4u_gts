import 'dart:convert';

import 'package:flutter/material.dart';
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
              storedProcessTaskQues = [];
            }
            if (storedProcessTaskQues == null) {
              storedProcessTaskQues = [];
            }
          }),
    );
  }
}
