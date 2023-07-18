import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pgmp4u/Screens/MockTest/model/pracTestModel.dart';
import 'package:pgmp4u/Screens/PracticeTests/practiceTextProvider.dart';
import 'package:pgmp4u/Screens/Tests/provider/category_provider.dart';
import 'package:pgmp4u/Screens/chat/controller/chatProvider.dart';
import 'package:pgmp4u/Screens/chat/screen/discussionGoupList.dart';
import 'package:pgmp4u/Screens/home_view/VideoLibrary/RandomPage.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:pgmp4u/provider/profileProvider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Tests/local_handler/hive_handler.dart';

class PracticeNew extends StatefulWidget {
  String pracTestName;
  int isFromNotification;
  final selectedId;

  PracticeNew({this.selectedId, this.isFromNotification = 0, this.pracTestName});

  @override
  _PracticeNewState createState() => _PracticeNewState(selectedIdNew: this.selectedId);
}

class _PracticeNewState extends State<PracticeNew> {
  final selectedIdNew;
  PracticeTextProvider practiceProvider;
  CategoryProvider categoryProvider;
  _PracticeNewState({
    this.selectedIdNew,
  });

  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  String getRightAnser(List value, opL) {
    String correct = "";
    if (value.length == 1) {}
  }

  bool _show = true;
  int _isattempt = 0;
  int _quetionNo = 0;
  int selectedAnswer;
  List<int> selAns = [];
  List<String> rightAns = [];
  List<int> correctAns = [];
  int realAnswer;
  String stringResponse;
  List listResponse;
  bool isListSame;
  int enableTap = 0;
  int isAnsCorrect;

  // 1---- correct   2--- not correct
  // Map mapResponse;

  List<PracTestModel> PTList = [];

  @override
  var currentIndex;
  void initState() {
    currentIndex = 0;
    selAns = [];
    correctAns = [];

    print("widhet test name=====>>>${widget.pracTestName}");
    print("widhet test selectedId=====>>>${widget.selectedId}");

    super.initState();
    practiceProvider = Provider.of(context, listen: false);
    categoryProvider = Provider.of(context, listen: false);

    context.read<CourseProvider>().setMasterListType("Chat");
    context.read<ProfileProvider>().subscriptionStatus("Chat");

    callApi();
  }

  Future callApi() async {
    await practiceProvider.apiCall(widget.selectedId, categoryProvider.type);
  }

  // Future apiCall2() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String stringValue = prefs.getString('token');
  //   print(stringValue);
  //   http.Response response; //api/MockTestQuestions/124
  //   response = await http.get(Uri.parse(REVIEWS_MOCK_TEST + "/22/4"),
  //       headers: {'Content-Type': 'application/json', 'Authorization': stringValue});

  //   if (response.statusCode == 200) {
  //     print(convert.jsonDecode(response.body));
  //     setState(() {
  //       var _mapResponse = convert.jsonDecode(response.body);

  //       listResponse = _mapResponse["data"];
  //     });
  //     // print(convert.jsonDecode(response.body));
  //   }
  // }

  // Future apiCall() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String stringValue = prefs.getString('token');
  //   print("stringValue  $stringValue");
  //   http.Response response;
  //   response = await http.get(Uri.parse(PRACTICE_TEST_QUESTIONS), headers: {
  //     'Content-Type': 'application/json',
  //     'Authorization': stringValue
  //   });

  //   if (response.statusCode == 200) {
  //     print(convert.jsonDecode(response.body));
  //     setState(() {
  //       var _mapResponse = convert.jsonDecode(response.body);
  //       listResponse = _mapResponse["data"];
  //     });
  //     // print(convert.jsonDecode(response.body));
  //   }
  // }
  bool questionLoader = false;
  onTapOfPutOnDisscussion(String question, List<String> optionQues) async {
    if (!context.read<ProfileProvider>().isChatSubscribed) {
      setState(() => questionLoader = false);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RandomPage(
                    index: 4,
                    price: context.read<ProfileProvider>().subsPrice.toString(),
                    categoryType: context.read<CourseProvider>().selectedMasterType,
                    categoryId: 0,
                  )));
      return;
    }

    setState(() => questionLoader = true);

    print('Practice question : $question');

    print("optionQues=========$optionQues");

    if (question.isEmpty) {
      setState(() => questionLoader = false);
      return;
    }

    await context
        .read<ChatProvider>()
        .createDiscussionGroup(question, optionQues, context, testName: 'From Practice Test: ' + widget.pracTestName)
        .whenComplete(() {
      setState(() => questionLoader = false);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupListPage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        body: ValueListenableBuilder(
            valueListenable: HiveHandler.getPracTestListener(),
            builder: (context, value, child) {
              PracticeTextProvider pracTestProv = Provider.of(context, listen: false);
              var v1 = value.get(pracTestProv.selectedPracTestId.toString());
              print("value of v1111======>>>>>>>>>$v1");

              if (v1 != null) {
                List temp = jsonDecode(v1);
                PTList = temp.map((e) => PracTestModel.fromJson(e)).toList();
              } else {
                PTList = [];
                pracTestProv.practiceApiLoader = false;
              }

              // print("=====PTList=======$PTList");

              // print("**************************************************");
              List<Options> op = [];
              if (PTList.isNotEmpty) {
                pracTestProv.practiceApiLoader = false;
                // print("list is not emptyyyyy");
                op = PTList[_quetionNo].ques.options.where((element) => element.questionOption.isNotEmpty).toList();

                // print("op======>>${op.length}");
              }

              return Consumer<PracticeTextProvider>(builder: (context, data, child) {
                // List<Options> options = [];

                // if (data.pList.isNotEmpty) {
                //   options = data.pList[_quetionNo].ques.options
                //       .where((element) => element.questionOption.isNotEmpty)
                //       .toList();
                // }

                // data.pList[_quetionNo].ques.options.where((element) => element.questionOption.isNotEmpty).toList();
                return Container(
                  color: _colorfromhex("#FCFCFF"),
                  child: Stack(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Container(
                              height: SizerUtil.deviceType == DeviceType.mobile ? 195 : 250,
                              width: width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/bg_layer2.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: width * (20 / 420), right: width * (20 / 420), top: height * (50 / 800)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () => {Navigator.of(context).pop()},
                                          child: Icon(
                                            Icons.arrow_back_ios,
                                            size: width * (24 / 420),
                                            color: Colors.white,
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Text(
                                            //   arguments != null ? '  Review' : '',
                                            //   style: TextStyle(
                                            //       fontFamily: 'Roboto Medium',
                                            //       fontSize: width * (18 / 420),
                                            //       color: Colors.white,
                                            //       letterSpacing: 0.3),
                                            // ),
                                            Container(
                                              width: MediaQuery.of(context).size.width * .8,
                                              child: Text(
                                                "  " + widget.pracTestName,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontFamily: 'Roboto Medium',
                                                    fontSize: width * (18 / 420),
                                                    color: Colors.white,
                                                    letterSpacing: 0.3),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            data.practiceApiLoader
                                ? Container(
                                    child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(_colorfromhex("#4849DF"))))
                                // : data.pList != null
                                : PTList != null
                                    ? Expanded(
                                        // width: width,
                                        // height: height - 235,
                                        child: PageView.builder(
                                            controller: pageController,
                                            // itemCount: data.pList.length,
                                            itemCount: PTList.length,
                                            onPageChanged: (index) {
                                              enableTap = 0;
                                              isAnsCorrect = 0;
                                              selAns = [];
                                              rightAns = [];
                                              correctAns = [];
                                              print("selAns=======$selAns");
                                              print("index====>>$index");
                                              print("currentIndex ====>>$currentIndex");
                                              if (currentIndex < index) {
                                                if (PTList.length - 1 > _quetionNo) {
                                                  setState(() {
                                                    if (_quetionNo < PTList.length) {
                                                      _quetionNo = _quetionNo + 1;
                                                    }
                                                    selectedAnswer = null;
                                                    realAnswer = null;
                                                  });
                                                  print(_quetionNo);
                                                }
                                              } else {
                                                if (_quetionNo != 0) {
                                                  setState(() {
                                                    _quetionNo--;

                                                    selectedAnswer = null;
                                                    realAnswer = null;
                                                  });
                                                }
                                              }

                                              setState(() {
                                                currentIndex = index;
                                                print("final index===$currentIndex");
                                              });
                                              _isattempt = PTList[_quetionNo].ques.rightAnswer.contains(',')
                                                  ? PTList[_quetionNo].ques.rightAnswer.split(',').length - 1
                                                  : 0;
                                            },
                                            itemBuilder: (context, index) {
                                              return SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: width * (29 / 420),
                                                          right: width * (29 / 420),
                                                          // top: height * (23 / 800),
                                                          top: 10,
                                                          bottom: height * (23 / 800)),
                                                      color: Colors.white,
                                                      child: Column(
                                                        children: [
                                                          putOnDiscussionButton(op, context),

                                                          SizedBox(
                                                            height: 10,
                                                          ),

                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              _quetionNo != 0
                                                                  ? GestureDetector(
                                                                      onTap: () => {
                                                                        enableTap = 0,
                                                                        isAnsCorrect = 0,
                                                                        selAns = [],
                                                                        rightAns = [],
                                                                        correctAns = [],
                                                                        setState(() {
                                                                          _quetionNo--;

                                                                          selectedAnswer = null;
                                                                          realAnswer = null;
                                                                        })
                                                                      },
                                                                      child: Icon(
                                                                        Icons.west,
                                                                        size: width * (30 / 420),
                                                                        color: Colors.black,
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                              Text(
                                                                'QUESTION ${_quetionNo + 1}',
                                                                style: TextStyle(
                                                                  fontFamily: 'Roboto Regular',
                                                                  fontSize: width * (16 / 420),
                                                                  color: Colors.black,
                                                                ),
                                                              ),
                                                              PTList.length - 1 > _quetionNo
                                                                  ? GestureDetector(
                                                                      onTap: () => {
                                                                        enableTap = 0,
                                                                        isAnsCorrect = 0,
                                                                        selAns = [],
                                                                        rightAns = [],
                                                                        correctAns = [],
                                                                        setState(() {
                                                                          if (_quetionNo < PTList.length) {
                                                                            _quetionNo = _quetionNo + 1;
                                                                          }
                                                                          selectedAnswer = null;
                                                                          realAnswer = null;
                                                                        }),
                                                                        print(_quetionNo)
                                                                      },
                                                                      child: Icon(
                                                                        Icons.east,
                                                                        size: width * (30 / 420),
                                                                        color: Colors.black,
                                                                      ),
                                                                    )
                                                                  : Container(),
                                                            ],
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(top: height * (15 / 800)),
                                                            child: Html(
                                                              data: PTList != null
                                                                  ? PTList[_quetionNo].ques.question
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
                                                            //   PTList != null ? PTList[_quetionNo].ques.question : '',
                                                            //   style: TextStyle(
                                                            //     fontFamily: 'Roboto Regular',
                                                            //     fontSize: width * (15 / 420),
                                                            //     color: Colors.black,
                                                            //     height: 1.7,
                                                            //   ),
                                                            // ),
                                                          ),

                                                          SizedBox(
                                                            height: 20,
                                                          ),

                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                "Maximum selection: ${PTList[index].ques.rightAnswer.split(',').length}",
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
                                                              physics: NeverScrollableScrollPhysics(),
                                                              itemCount: op.length,
                                                              itemBuilder: (context, index) {
                                                                // if (data.pList[_quetionNo].ques.options[index]
                                                                //         .questionOption ==
                                                                //     "") {
                                                                //   data.pList[_quetionNo].ques.options
                                                                //       .remove(data.pList[_quetionNo].ques.options[index]);
                                                                // }
                                                                return Padding(
                                                                  padding: const EdgeInsets.only(bottom: 15.0, top: 10),
                                                                  child: InkWell(
                                                                    onTap: () {
                                                                      if (enableTap == 0) {
                                                                        setState(() {
                                                                          correctAns = [];
                                                                          rightAns = [];
                                                                          rightAns = PTList[_quetionNo]
                                                                              .ques
                                                                              .rightAnswer
                                                                              .split(',');
                                                                          print("rightAns========>>>$rightAns");

                                                                          for (int i = 0; i < rightAns.length; i++) {
                                                                            correctAns.add(int.parse(rightAns[i]));
                                                                          }
                                                                          print("correctAns=========>>>>>>$correctAns");
                                                                        });

                                                                        setState(() {
                                                                          selAns.add(op[index].id);
                                                                          print("selAns=============$selAns");

                                                                          if (selAns.length == correctAns.length &&
                                                                              correctAns.length > 0) {
                                                                            checkAllAns(selAns, correctAns);
                                                                            enableTap = 1;
                                                                          }
                                                                        });

                                                                        if (_isattempt <
                                                                            op
                                                                                .where((element) =>
                                                                                    element.isseleted == true)
                                                                                .toList()
                                                                                .length) {
                                                                          return;
                                                                        }
                                                                        setState(() {
                                                                          op[index].isseleted = !op[index].isseleted;
                                                                        });
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                      decoration: BoxDecoration(
                                                                        // shape: BoxShape.circle,

                                                                        color: selAns.contains(op[index].id) &&
                                                                                correctAns.contains(op[index].id) &&
                                                                                selAns.length == correctAns.length &&
                                                                                selAns.length > 0
                                                                            ? _colorfromhex("#E6F7E7")
                                                                            : selAns.contains(op[index].id) &&
                                                                                    !correctAns
                                                                                        .contains(op[index].id) &&
                                                                                    selAns.length ==
                                                                                        correctAns.length &&
                                                                                    selAns.length > 0
                                                                                ? _colorfromhex("#FFF6F6")
                                                                                : correctAns.contains(op[index].id) &&
                                                                                        selAns.length ==
                                                                                            correctAns.length &&
                                                                                        selAns.length > 0
                                                                                    ? _colorfromhex("#E6F7E7")
                                                                                    : selAns.contains(op[index].id) &&
                                                                                            correctAns
                                                                                                .contains(op[index].id)
                                                                                        ? _colorfromhex("#E6F7E7")
                                                                                        : selAns.contains(
                                                                                                    op[index].id) &&
                                                                                                !correctAns.contains(
                                                                                                    op[index].id)
                                                                                            ? _colorfromhex("#FFF6F6")
                                                                                            : Colors.white,

                                                                        // color: _isattempt <
                                                                        //         op
                                                                        //             .where((element) =>
                                                                        //                 element.isseleted == true)
                                                                        //             .toList()
                                                                        //             .length
                                                                        //     ? op.any((element) =>
                                                                        //             element.isseleted == true)
                                                                        //         ? PTList[_quetionNo]
                                                                        //                 .ques
                                                                        //                 .rightAnswer
                                                                        //                 .contains("${op[index].id}")
                                                                        //             ? _colorfromhex("#E6F7E7")
                                                                        //             : op[index].isseleted
                                                                        //                 ? PTList[_quetionNo]
                                                                        //                         .ques
                                                                        //                         .rightAnswer
                                                                        //                         .contains(
                                                                        //                             "${op[index].id}")
                                                                        //                     ? _colorfromhex("#E6F7E7")
                                                                        //                     : _colorfromhex("#FFF6F6")
                                                                        //                 : Colors.white
                                                                        //         : op[index].isseleted
                                                                        //             ? PTList[_quetionNo]
                                                                        //                     .ques
                                                                        //                     .rightAnswer
                                                                        //                     .contains(
                                                                        //                         "${op[index].id}")
                                                                        //                 ? _colorfromhex("#E6F7E7")
                                                                        //                 : _colorfromhex("#FFF6F6")
                                                                        //             : Colors.white
                                                                        //     : op[index].isseleted
                                                                        //         ? PTList[_quetionNo]
                                                                        //                 .ques
                                                                        //                 .rightAnswer
                                                                        //                 .contains("${op[index].id}")
                                                                        //             ? _colorfromhex("#E6F7E7")
                                                                        //             : _colorfromhex("#FFF6F6")
                                                                        //         : Colors.white

                                                                        // correctAns.contains(data.pList[_quetionNo]
                                                                        //             .ques.options[index].id) &&
                                                                        //         selAns.contains(data.pList[_quetionNo].ques
                                                                        //             .options[index].id)
                                                                        //     ? _colorfromhex("#E6F7E7")
                                                                        //     : correctAns.contains(data.pList[_quetionNo]
                                                                        //                 .ques.options[index].id) &&
                                                                        //             !selAns.contains(data.pList[_quetionNo]
                                                                        //                 .ques.options[index].id)
                                                                        //         ? _colorfromhex("#FFF6F6")
                                                                        //         : Colors.white

                                                                        // color: data.pList[_quetionNo].ques.options[index].id ==
                                                                        //             selectedAnswer &&
                                                                        //         int.parse(data.pList[_quetionNo].ques.rightAnswer) ==
                                                                        //             selectedAnswer
                                                                        //     ? _colorfromhex("#E6F7E7")
                                                                        //     : data.pList[_quetionNo].ques.options[index].id ==
                                                                        //                 selectedAnswer &&
                                                                        //             int.parse(data.pList[_quetionNo].ques.rightAnswer) !=
                                                                        //                 selectedAnswer
                                                                        //         ? _colorfromhex("#FFF6F6")
                                                                        //         : selectedAnswer != null &&
                                                                        //                 int.parse(data.pList[_quetionNo].ques
                                                                        //                         .rightAnswer) !=
                                                                        //                     selectedAnswer &&
                                                                        //                 data.pList[_quetionNo].ques
                                                                        //                         .options[index].id ==
                                                                        //                     int.parse(data.pList[_quetionNo]
                                                                        //                         .ques.rightAnswer)
                                                                        //             ? _colorfromhex("#E6F7E7")
                                                                        //             : Colors.white,

                                                                        // border: Border(
                                                                        //   bottom: BorderSide(
                                                                        //       width: 1.5, color: Colors.grey[300]),
                                                                        // )
                                                                      ),
                                                                      child: Row(children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              bottom: 5.0, top: 5),
                                                                          child: Container(
                                                                            width: width * (25 / 420),
                                                                            height: width * 25 / 420,
                                                                            decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(
                                                                                    width * (25 / 420)),
                                                                                color: _isattempt <
                                                                                        op
                                                                                            .where((element) =>
                                                                                                element.isseleted ==
                                                                                                true)
                                                                                            .toList()
                                                                                            .length
                                                                                    ? op.any((element) =>
                                                                                            element.isseleted == true)
                                                                                        ? PTList[_quetionNo].ques.rightAnswer.contains(
                                                                                                "${op[index].id}")
                                                                                            ? _colorfromhex("#04AE0B")
                                                                                            : op[index].isseleted
                                                                                                ? PTList[_quetionNo]
                                                                                                        .ques
                                                                                                        .rightAnswer
                                                                                                        .contains(
                                                                                                            "${op[index].id}")
                                                                                                    ? _colorfromhex(
                                                                                                        "#E6F7E7")
                                                                                                    : _colorfromhex(
                                                                                                        "#FF0000")
                                                                                                : Colors.white
                                                                                        : op[index].isseleted
                                                                                            ? PTList[_quetionNo]
                                                                                                    .ques
                                                                                                    .rightAnswer
                                                                                                    .contains(
                                                                                                        "${op[index].id}")
                                                                                                ? _colorfromhex(
                                                                                                    "#E6F7E7")
                                                                                                : _colorfromhex(
                                                                                                    "#FFF6F6")
                                                                                            : Colors.white
                                                                                    : op[index].isseleted
                                                                                        ? PTList[_quetionNo]
                                                                                                .ques
                                                                                                .rightAnswer
                                                                                                .contains(
                                                                                                    "${op[index].id}")
                                                                                            ? _colorfromhex("#E6F7E7")
                                                                                            : _colorfromhex("#FFF6F6")
                                                                                        : Colors.white,

                                                                                // color: data.pList[_quetionNo].ques.options[index].id ==
                                                                                //             selectedAnswer &&
                                                                                //         int.parse(data.pList[_quetionNo].ques.rightAnswer) ==
                                                                                //             selectedAnswer
                                                                                //     ? _colorfromhex("#04AE0B")
                                                                                //     : data.pList[_quetionNo].ques
                                                                                //                     .options[index].id ==
                                                                                //                 selectedAnswer &&
                                                                                //             int.parse(data.pList[_quetionNo]
                                                                                //                     .ques.rightAnswer) !=
                                                                                //                 selectedAnswer
                                                                                //         ? _colorfromhex("#FF0000")
                                                                                //         : selectedAnswer != null &&
                                                                                //                 int.parse(data.pList[_quetionNo].ques.rightAnswer) !=
                                                                                //                     selectedAnswer &&
                                                                                //                 data.pList[_quetionNo].ques
                                                                                //                         .options[index].id ==
                                                                                //                     int.parse(data.pList[_quetionNo].ques.rightAnswer)
                                                                                //             ? _colorfromhex("#04AE0B")
                                                                                //             : Colors.white,
                                                                                //selectedAnswer == realAnswer ? _colorfromhex("#E6F7E7") : Colors.white,

                                                                                //data.pList[_quetionNo].ques.options.

                                                                                border: Border.all(
                                                                                    color: selAns.length == correctAns.length &&
                                                                                            selAns.length > 0
                                                                                        ? Colors.grey
                                                                                        : Colors.black)),
                                                                            child: Center(
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
                                                                                    fontSize: width * 14 / 420,
                                                                                    color: op.any((element) =>
                                                                                            element.isseleted == true)
                                                                                        ? PTList[_quetionNo]
                                                                                                .ques
                                                                                                .rightAnswer
                                                                                                .contains(
                                                                                                    "${op[index].id}")
                                                                                            ? Colors.black
                                                                                            : Colors.black
                                                                                        : op[index].isseleted
                                                                                            ? PTList[_quetionNo]
                                                                                                    .ques
                                                                                                    .rightAnswer
                                                                                                    .contains(
                                                                                                        "${op[index].id}")
                                                                                                ? Colors.green
                                                                                                : Colors.red
                                                                                            : Colors.black),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              // color:
                                                                              //     Colors.amber,
                                                                              margin: EdgeInsets.only(left: 8),
                                                                              width: width - (width * (25 / 420) * 5),
                                                                              child: Padding(
                                                                                padding:
                                                                                    const EdgeInsets.only(bottom: 6.0),
                                                                                child: Column(
                                                                                  mainAxisAlignment:
                                                                                      MainAxisAlignment.start,
                                                                                  crossAxisAlignment:
                                                                                      CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      height: 8,
                                                                                    ),

                                                                                    Html(
                                                                                      data: op[index].questionOption,
                                                                                      style: {
                                                                                        "body": Style(
                                                                                          padding:
                                                                                              EdgeInsets.only(top: 5),
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
                                                                                    //   op[index].questionOption,
                                                                                    //   style: TextStyle(fontSize: 16),
                                                                                    // ),
                                                                                    // selectedAnswer != null &&
                                                                                    //         int.parse(data.pList[_quetionNo]
                                                                                    //                 .ques.rightAnswer) !=
                                                                                    //             selectedAnswer &&
                                                                                    //         options[index].id ==
                                                                                    //             int.parse(data
                                                                                    //                 .pList[_quetionNo]
                                                                                    //                 .ques
                                                                                    //                 .rightAnswer)

                                                                                    (selAns.length ==
                                                                                                    correctAns.length &&
                                                                                                selAns.length > 0 &&
                                                                                                selAns.contains(
                                                                                                    op[index].id) &&
                                                                                                correctAns.contains(
                                                                                                    op[index].id)) ||
                                                                                            (selAns.length ==
                                                                                                    correctAns.length &&
                                                                                                selAns.length > 0 &&
                                                                                                correctAns.contains(
                                                                                                    op[index].id))
                                                                                        ? Row(
                                                                                            mainAxisAlignment:
                                                                                                MainAxisAlignment.end,
                                                                                            children: [
                                                                                              Text("Correct Answer")
                                                                                            ],
                                                                                          )
                                                                                        :
                                                                                        // options[index].id ==
                                                                                        //             selectedAnswer &&
                                                                                        //         int.parse(data
                                                                                        //                 .pList[_quetionNo]
                                                                                        //                 .ques
                                                                                        //                 .rightAnswer) !=
                                                                                        //             selectedAnswer

                                                                                        selAns.length ==
                                                                                                    correctAns.length &&
                                                                                                selAns.length > 0 &&
                                                                                                selAns.contains(
                                                                                                    op[index].id) &&
                                                                                                !correctAns.contains(
                                                                                                    op[index].id)
                                                                                            ? Row(
                                                                                                mainAxisAlignment:
                                                                                                    MainAxisAlignment
                                                                                                        .end,
                                                                                                children: [
                                                                                                  Text("Your Selection")
                                                                                                  //: Text("Correct Answer")
                                                                                                ],
                                                                                              )
                                                                                            : Container()
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),

                                                                       
                                                                          ],
                                                                        )
                                                                      ]),
                                                                    ),
                                                                  ),
                                                                );
                                                              }),

                                             
                                                          if (selAns.length == correctAns.length &&
                                                              correctAns.length > 0)
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color: _colorfromhex("#FAFAFA"),
                                                                  borderRadius: BorderRadius.circular(6)),
                                                              margin: EdgeInsets.only(top: height * (38 / 800)),
                                                              padding: EdgeInsets.only(
                                                                  top: height * (10 / 800),
                                                                  bottom:
                                                                      _show ? height * (23 / 800) : height * (12 / 800),
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
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            'See Solution',
                                                                            style: TextStyle(
                                                                              fontFamily: 'Roboto Regular',
                                                                              fontSize: width * (15 / 420),
                                                                              color: _colorfromhex("#ABAFD1"),
                                                                              height: 1.7,
                                                                            ),
                                                                          ),
                                                                          Icon(
                                                                            _show
                                                                                ? Icons.expand_less
                                                                                : Icons.expand_more,
                                                                            size: width * (30 / 420),
                                                                            color: _colorfromhex("#ABAFD1"),
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                  _show
                                                                      ? Container(
                                                                          margin:
                                                                              EdgeInsets.only(top: height * (9 / 800)),
                                                                          child: Text(
                                                                            "${getTstAns(op)}",
                                                                    

                                                                            ///////////////////////
                                                                            // correctAns.contains(op[0].id)
                                                                            //     ? 'Answer A is the correct one'
                                                                            //     :

                                                                            //     // PTList[_quetionNo].ques.rightAnswer ==
                                                                            //     //         op[1].id.toString()
                                                                            //     correctAns.contains(op[1].id)
                                                                            //         ? 'Answer B is the correct one'
                                                                            //         : correctAns.contains(op[2].id)
                                                                            //             ? 'Answer c is the correct one'
                                                                            //             : correctAns.contains(op[3].id)
                                                                            //                 ? 'Answer D is the correct one'
                                                                            //                 : 'Answer E is the correct one',

                                                                            ///////////////
                                                                            style: TextStyle(
                                                                              fontFamily: 'Roboto Regular',
                                                                              fontSize: width * (15 / 420),
                                                                              color: _colorfromhex("#04AE0B"),
                                                                              height: 1.7,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Container(),
                                                                  _show
                                                                      ? Container(
                                                                          margin:
                                                                              EdgeInsets.only(top: height * (9 / 800)),
                                                                          child: Text(
                                                                            PTList[_quetionNo].ques.explanation,
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

                                                          // Column(
                                                          //   children: data
                                                          //       .questionsList[
                                                          //           _quetionNo]
                                                          //       .optionsList
                                                          //       .map<Widget>((title) {
                                                          //     var index = data
                                                          //         .questionsList[
                                                          //             _quetionNo]
                                                          //         .optionsList
                                                          //         .indexOf(title);
                                                          //     return GestureDetector(
                                                          //       onTap: () => {
                                                          //         setState(() {
                                                          //           selectedAnswer =
                                                          //               title.id;
                                                          //           realAnswer = data
                                                          //               .questionsList[
                                                          //                   _quetionNo]
                                                          //               .rightAnswer;
                                                          //         })
                                                          //       },
                                                          //       child: Container(
                                                          //         color: title.id ==
                                                          //                     selectedAnswer &&
                                                          //                 data.questionsList[_quetionNo].rightAnswer ==
                                                          //                     selectedAnswer
                                                          //             ? _colorfromhex(
                                                          //                 "#E6F7E7")
                                                          //             : title.id ==
                                                          //                         selectedAnswer &&
                                                          //                     data.questionsList[_quetionNo].rightAnswer !=
                                                          //                         selectedAnswer
                                                          //                 ? _colorfromhex(
                                                          //                     "#FFF6F6")
                                                          //                 : selectedAnswer != null &&
                                                          //                         data.questionsList[_quetionNo].rightAnswer !=
                                                          //                             selectedAnswer &&
                                                          //                         title.id ==
                                                          //                             data.questionsList[_quetionNo].rightAnswer
                                                          //                     ? _colorfromhex("#E6F7E7")
                                                          //                     : Colors.white,
                                                          //         margin:
                                                          //             EdgeInsets.only(
                                                          //                 top: height *
                                                          //                     (21 /
                                                          //                         800)),
                                                          //         padding: EdgeInsets.only(
                                                          //             top: 13,
                                                          //             bottom: 13,
                                                          //             left: width *
                                                          //                 (13 / 420),
                                                          //             right: width *
                                                          //                 (11 / 420)),
                                                          //         child: Row(
                                                          //           children: [
                                                          //             Container(
                                                          //               width: width *
                                                          //                   (25 /
                                                          //                       420),
                                                          //               height:
                                                          //                   width *
                                                          //                       25 /
                                                          //                       420,
                                                          //               decoration: BoxDecoration(
                                                          //                   borderRadius: BorderRadius.circular(
                                                          //                     width *
                                                          //                         (25 /
                                                          //                             420),
                                                          //                   ),
                                                          //                   color: title.id == selectedAnswer && data.questionsList[_quetionNo].rightAnswer == selectedAnswer
                                                          //                       ? _colorfromhex("#04AE0B")
                                                          //                       : title.id == selectedAnswer && data.questionsList[_quetionNo].rightAnswer != selectedAnswer
                                                          //                           ? _colorfromhex("#FF0000")
                                                          //                           : selectedAnswer != null && data.questionsList[_quetionNo].rightAnswer != selectedAnswer && title.id == data.questionsList[_quetionNo].rightAnswer
                                                          //                               ? _colorfromhex("#04AE0B")
                                                          //                               : Colors.white),
                                                          //               child: Center(
                                                          //                 child: Text(
                                                          //                   index == 0
                                                          //                       ? 'A'
                                                          //                       : index == 1
                                                          //                           ? 'B'
                                                          //                           : index == 2
                                                          //                               ? 'C'
                                                          //                               : index == 3
                                                          //                                   ? 'D'
                                                          //                                   : '',
                                                          //                   style: TextStyle(
                                                          //                       fontFamily: 'Roboto Regular',
                                                          //                       fontSize: width * 14 / 420,
                                                          //                       color: title.id == selectedAnswer && data.questionsList[_quetionNo].rightAnswer == selectedAnswer
                                                          //                           ? Colors.white
                                                          //                           : title.id == selectedAnswer && data.questionsList[_quetionNo].rightAnswer != selectedAnswer
                                                          //                               ? Colors.white
                                                          //                               : selectedAnswer != null && data.questionsList[_quetionNo].rightAnswer != selectedAnswer && title.id == data.questionsList[_quetionNo].rightAnswer
                                                          //                                   ? Colors.white
                                                          //                                   : Colors.grey),
                                                          //                 ),
                                                          //               ),
                                                          //             ),
                                                          //             Column(
                                                          //               mainAxisAlignment:
                                                          //                   MainAxisAlignment
                                                          //                       .end,
                                                          //               crossAxisAlignment:
                                                          //                   CrossAxisAlignment
                                                          //                       .end,
                                                          //               children: [
                                                          //                 Container(
                                                          //                   margin: EdgeInsets.only(
                                                          //                       left:
                                                          //                           8),
                                                          //                   width: width -
                                                          //                       (width *
                                                          //                           (25 / 420) *
                                                          //                           5),
                                                          //                   child: Text(
                                                          //                       title
                                                          //                           .questionsOptions,
                                                          //                       style:
                                                          //                           TextStyle(fontSize: width * 14 / 420)),
                                                          //                 ),
                                                          //                 selectedAnswer != null &&
                                                          //                         data.questionsList[_quetionNo].rightAnswer !=
                                                          //                             selectedAnswer &&
                                                          //                         title.id ==
                                                          //                             data.questionsList[_quetionNo].rightAnswer
                                                          //                     ? Row(
                                                          //                         mainAxisAlignment:
                                                          //                             MainAxisAlignment.end,
                                                          //                         children: [
                                                          //                           Text(
                                                          //                             'Correct Answer',
                                                          //                           ),
                                                          //                         ],
                                                          //                       )
                                                          //                     : title.id == selectedAnswer && data.questionsList[_quetionNo].rightAnswer != selectedAnswer
                                                          //                         ? Row(
                                                          //                             mainAxisAlignment: MainAxisAlignment.end,
                                                          //                             children: [
                                                          //                               Text(
                                                          //                                 'Your selection',
                                                          //                               ),
                                                          //                             ],
                                                          //                           )
                                                          //                         : Container(),
                                                          //               ],
                                                          //             )
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //     );
                                                          //   }).toList(),
                                                          // ),

                                                          // ;  Container(
                                                          //     decoration: BoxDecoration(
                                                          //         color: _colorfromhex(
                                                          //             "#FAFAFA"),
                                                          //         borderRadius:
                                                          //             BorderRadius
                                                          //                 .circular(6)),
                                                          //     margin: EdgeInsets.only(
                                                          //         top: height *
                                                          //             (38 / 800)),
                                                          //     // padding: EdgeInsets.only(
                                                          //     //     top: height *
                                                          //     //         (10 / 800),
                                                          //     //     bottom: _show
                                                          //     //         ? height *
                                                          //     //             (23 / 800)
                                                          //     //         : height *
                                                          //     //             (12 / 800),
                                                          //     //     left: width *
                                                          //     //         (18 / 420),
                                                          //     //     right: width *
                                                          //     //         (10 / 420)),
                                                          //     // child: Column(
                                                          //     //   mainAxisAlignment:
                                                          //     //       MainAxisAlignment
                                                          //     //           .start,
                                                          //     //   crossAxisAlignment:
                                                          //     //       CrossAxisAlignment
                                                          //     //           .start,
                                                          //     //   // children: [
                                                          //     //   //   GestureDetector(
                                                          //     //   //     child: Row(
                                                          //     //   //       mainAxisAlignment:
                                                          //     //   //           MainAxisAlignment
                                                          //     //   //               .spaceBetween,
                                                          //     //   //       children: [],
                                                          //     //   //     ),
                                                          //     //   //   ),
                                                          //     //   // ],
                                                          //     // ),
                                                          //   )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                      )
                                    : PTList == []
                                        ? Container(
                                            height: 250,
                                            child: Text(
                                              "No Data Found.....",
                                              style: TextStyle(fontSize: 20),
                                            ))
                                        : Text("No Data Found.....")
                          ],
                        ),
                      ),
                      Text(""),

                      isAnsCorrect == 1
                          ? Positioned(
                              top: SizerUtil.deviceType == DeviceType.mobile ? 80 : 140,
                              left: width / 2.9,
                              child: Container(
                                width: 110,
                                height: 110,
                                child: Image.asset('assets/smile.png'),
                              ))
                          : isAnsCorrect == 2
                              ? Positioned(
                                  top: SizerUtil.deviceType == DeviceType.mobile ? 80 : 140,
                                  left: width / 2.9,
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    child: Image.asset('assets/smiley-sad1.png'),
                                  ))
                              : SizedBox()

                      // realAnswer == selectedAnswer && selectedAnswer != null
                      // isAnsCorrect == 1
                      //     ? Positioned(
                      //         top: SizerUtil.deviceType == DeviceType.mobile ? 80 : 140,
                      //         left: width / 2.9,
                      //         child: Container(
                      //           width: 110,
                      //           height: 110,
                      //           child: Image.asset('assets/smile.png'),
                      //         ))
                      //     : Text(''),
                      // // realAnswer != selectedAnswer && selectedAnswer != null
                      // isAnsCorrect == 1
                      //     ? Positioned(
                      //         top: SizerUtil.deviceType == DeviceType.mobile ? 100 : 165,
                      //         left: width / 2.5,
                      //         child: selectedAnswer == null
                      //             ? Text('')
                      //             : realAnswer == selectedAnswer
                      //                 ? Container(
                      //                     width: 100,
                      //                     height: 100,
                      //                     child: Image.asset('assets/smile.png'),
                      //                   )
                      //                 : isAnsCorrect == 2
                      //                     ? Image.asset('assets/smiley-sad1.png')
                      //                     : SizedBox())
                      //     : Text(''),
                    ],
                  ),
                );
              });
            }),
      );
    });
  }

  Widget putOnDiscussionButton(List<Options> op, BuildContext context) {
    return InkWell(
      onTap: () {
        print("op le ${op.length}");
        List<String> otsList = getList(op);
        print("otsList le ${otsList.length}");

        questionLoader
            ? null
            : context.read<ProfileProvider>().subscriptionApiCalling
                ? null
                : onTapOfPutOnDisscussion(PTList != null ? PTList[_quetionNo].ques.question : '', otsList);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(""),
          new Spacer(),
          Container(
            height: 35,
            constraints: BoxConstraints(minWidth: 100),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                gradient: LinearGradient(
                    colors: [
                      _colorfromhex("#3A47AD"),
                      _colorfromhex("#5163F3"),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)),
            child: questionLoader || context.read<ProfileProvider>().subscriptionApiCalling
                ? Center(
                    child: SizedBox(width: 20, height: 20, child: Center(child: CircularProgressIndicator.adaptive())))
                : Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Center(
                      child: Row(
                        children: [
                          Icon(
                            Icons.chat_bubble_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              "Put on discussion",
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void checkAllAns(List<int> selAns, List<int> rightAns) {
    isListSame = true;
    print("inside checkAllAns===============================");
    selAns.sort();
    print("selAns======$selAns");
    print("rightAns======$rightAns");

    for (int i = 0; i < selAns.length; i++) {
      if (selAns[i] == (rightAns[i])) {
      } else {
        isListSame = false;
        print("isListSame=======$isListSame");
        break;
      }
    }

    print("isListSame=======$isListSame");
    if (isListSame) {
      isAnsCorrect = 1;
      print("same are both the lkstssss");
    } else {
      isAnsCorrect = 2;
      print("  list are not same are both the lkstssss");
    }
  }

  List<String> getList(List<Options> options) {
    List<String> optsValueList = [];

    for (int i = 0; i < options.length; i++) {
      String name = '';
      name = options[i].questionOption;
      if (name.isNotEmpty || name != null) {
        optsValueList.add(name);
      }
    }
    print("optsValueList==========$optsValueList");

    return optsValueList;
  }

  String getTstAns(List<Options> op) {

    String correct = "";
    print("correctanslength===${correctAns.length}");
    if (correctAns.length == 1) {
      if (correctAns.contains(op[0].id)) {
        correct = 'Answer A is the correct one';
      } else if (correctAns.contains(op[1].id)) {
        correct = 'Answer B is the correct one';
      } else if (correctAns.contains(op[2].id)) {
        correct = 'Answer C is the correct one';
      } else if (correctAns.contains(op[3].id)) {
        correct = 'Answer D is the correct one';
      } else {
        correct = 'Answer E is the correct one';
      }
    } else if (correctAns.length == 2) {
      if (correctAns.contains(op[0].id) && correctAns.contains(op[1].id)) {
        correct = "Answer A and B are the correct one";
      } else if (correctAns.contains(op[0].id) && correctAns.contains(op[2].id)) {
        correct = "Answer A and C are the correct one";
      } else if (correctAns.contains(op[0].id) && correctAns.contains(op[3].id)) {
        correct = "Answer A and D are the correct one";
      } else if (correctAns.contains(op[0].id) && correctAns.contains(op[4].id)) {
        correct = "Answer A and E are the correct one";
      } else if (correctAns.contains(op[1].id) && correctAns.contains(op[2].id)) {
        correct = "Answer B and C are the correct one";
      } else if (correctAns.contains(op[1].id) && correctAns.contains(op[3].id)) {
        correct = "Answer B and D are the correct one";
      } else if (correctAns.contains(op[1].id) && correctAns.contains(op[4].id)) {
        correct = "Answer B and E are the correct one";
      } else if (correctAns.contains(op[2].id) && correctAns.contains(op[3].id)) {
        correct = "Answer C and D are the correct one";
      } else if (correctAns.contains(op[2].id) && correctAns.contains(op[4].id)) {
        correct = "Answer C and E are the correct one";
      } else if (correctAns.contains(op[3].id) && correctAns.contains(op[4].id)) {
        correct = "Answer D and E are the correct one";
      }
    } else if (correctAns.length == 3) {
      if (correctAns.contains(op[0].id) && correctAns.contains(op[1].id) && correctAns.contains(op[2].id)) {
        correct = "Answer A, B and C are the correct one";
      } else if (correctAns.contains(op[0].id) && correctAns.contains(op[1].id) && correctAns.contains(op[3].id)) {
        correct = "Answer A, B and D are the correct one";
      } else if (correctAns.contains(op[0].id) && correctAns.contains(op[1].id) && correctAns.contains(op[4].id)) {
        correct = "Answer A, B and E are the correct one";
      } else if (correctAns.contains(op[0].id) && correctAns.contains(op[2].id) && correctAns.contains(op[3].id)) {
        correct = "Answer A, C and D are the correct one";
      } else if (correctAns.contains(op[0].id) && correctAns.contains(op[2].id) && correctAns.contains(op[4].id)) {
        correct = "Answer A, C and E are the correct one";
      } else if (correctAns.contains(op[0].id) && correctAns.contains(op[3].id) && correctAns.contains(op[4].id)) {
        correct = "Answer A, D and E are the correct one";
      } else if (correctAns.contains(op[1].id) && correctAns.contains(op[2].id) && correctAns.contains(op[3].id)) {
        correct = "Answer B, C and D are the correct one";
      } else if (correctAns.contains(op[1].id) && correctAns.contains(op[2].id) && correctAns.contains(op[4].id)) {
        correct = "Answer B, C and E are the correct one";
      } else if (correctAns.contains(op[1].id) && correctAns.contains(op[3].id) && correctAns.contains(op[4].id)) {
        correct = "Answer B, D and E are the correct one";
      } else if (correctAns.contains(op[2].id) && correctAns.contains(op[3].id) && correctAns.contains(op[4].id)) {
        correct = "Answer C, D and E are the correct one";
      }
    }
    print("correct======$correct");
    return correct;
  }
}
