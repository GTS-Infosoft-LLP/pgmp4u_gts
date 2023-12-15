import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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

import '../Domain/disImage.dart';
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
  var plusQues;
  var subQues;
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
  List<int> ans = [];
  Map<String, dynamic> selQuesMap = {};
  List answer = [];
  List<Map<String, dynamic>> answersMapp = [];

  List<int> finalSelectedAns = [];
  List<int> finalCorrectAns = [];

  // 1---- correct   2--- not correct
  // Map mapResponse;

  List<PracTestModel> PTList = [];

  @override
  var currentIndex;
  void initState() {
    currentIndex = 0;
    selAns = [];
    correctAns = [];

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

  bool questionLoader = false;
  onTapOfPutOnDisscussion(String question, List<String> optionQues, String img) async {
    CourseProvider cp = Provider.of(context, listen: false);
    ProfileProvider pp = Provider.of(context, listen: false);
    print("pp.isChatSubscribed====${pp.isChatSubscribed}");
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

    if (question.isEmpty) {
      setState(() => questionLoader = false);
      return;
    }

    await context
        .read<ChatProvider>()
        .createDiscussionGroup(question, optionQues, img, context,
            testName: 'From Practice Test: ' + widget.pracTestName, crsName: cp.selectedCourseLable)
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

              if (v1 != null) {
                List temp = jsonDecode(v1);
                PTList = temp.map((e) => PracTestModel.fromJson(e)).toList();
              } else {
                PTList = [];
                pracTestProv.practiceApiLoader = false;
              }

              List<Options> op = [];
              if (PTList.isNotEmpty) {
                pracTestProv.practiceApiLoader = false;
                op = PTList[_quetionNo].ques.options.where((element) => element.questionOption.isNotEmpty).toList();
              }

              return Consumer<PracticeTextProvider>(builder: (context, data, child) {
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
                                        Container(
                                          width: MediaQuery.of(context).size.width * .8,
                                          child: RichText(
                                              maxLines: 2,
                                              text: TextSpan(children: <TextSpan>[
                                                TextSpan(
                                                  text: "  " + widget.pracTestName,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: width * (17 / 420),
                                                    fontFamily: 'Roboto Medium',
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                              ])),
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
                                        child: PageView.builder(
                                            controller: pageController,
                                            itemCount: PTList.length,
                                            onPageChanged: (index) {
                                              ans = [];
                                              enableTap = 0;
                                              isAnsCorrect = 0;
                                              selAns = [];
                                              rightAns = [];
                                              correctAns = [];
                                              print("selAns=======$selAns");

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
                                                                        subQues = _quetionNo,
                                                                        pageController.animateToPage(--subQues,
                                                                            duration: Duration(milliseconds: 500),
                                                                            curve: Curves.easeInCirc),
                                                                        setState(() {
                                                                          // _quetionNo--;

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
                                                              RichText(
                                                                  text: TextSpan(children: <TextSpan>[
                                                                TextSpan(
                                                                  text: 'QUESTION ${_quetionNo + 1}',
                                                                  style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: width * (16 / 420),
                                                                    fontFamily: 'Roboto Regular',
                                                                  ),
                                                                ),
                                                              ])),
                                                              PTList.length - 1 > _quetionNo
                                                                  ? GestureDetector(
                                                                      onTap: () => {
                                                                        enableTap = 0,
                                                                        isAnsCorrect = 0,
                                                                        selAns = [],
                                                                        rightAns = [],
                                                                        correctAns = [],
                                                                        plusQues = _quetionNo,
                                                                        pageController.animateToPage(++plusQues,
                                                                            duration: Duration(milliseconds: 500),
                                                                            curve: Curves.easeInCirc),
                                                                        setState(() {
                                                                          selectedAnswer = null;
                                                                          realAnswer = null;
                                                                        }),
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
                                                                  fontSize: FontSize(18),
                                                                )
                                                              },
                                                            ),
                                                          ),
                                                          PTList[_quetionNo].ques.image != null
                                                              ? InkWell(
                                                                  onTap: () async {
                                                                    bool result = await checkInternetConn();
                                                                    if (result) {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => ImageDispalyScreen(
                                                                                    quesImages:
                                                                                        PTList[_quetionNo].ques.image,
                                                                                  )));
                                                                    } else {
                                                                      EasyLoading.showInfo(
                                                                          "Please check your Internet Connection");
                                                                    }
                                                                  },
                                                                  child: Container(
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.grey[300],
                                                                      borderRadius: BorderRadius.circular(20),
                                                                    ),
                                                                    child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      child: CachedNetworkImage(
                                                                        imageUrl: PTList[_quetionNo].ques.image,
                                                                        fit: BoxFit.cover,
                                                                        placeholder: (context, url) => Padding(
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal: 78.0, vertical: 28),
                                                                          child: CircularProgressIndicator(
                                                                            strokeWidth: 2,
                                                                            color: Colors.grey[400],
                                                                          ),
                                                                        ),
                                                                        errorWidget: (context, url, error) => Container(
                                                                            height:
                                                                                MediaQuery.of(context).size.width * .4,
                                                                            child: Center(child: Icon(Icons.error))),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : SizedBox(),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              RichText(
                                                                  // maxLines: 2,
                                                                  textAlign: TextAlign.left,
                                                                  text: TextSpan(children: <TextSpan>[
                                                                    TextSpan(
                                                                      text:
                                                                          "Maximum selection: ${PTList[index].ques.rightAnswer.split(',').length}",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 18,
                                                                        fontFamily: 'Roboto Regular',
                                                                      ),
                                                                    ),
                                                                  ])),
                                                            ],
                                                          ),
                                                          ListView.builder(
                                                              shrinkWrap: true,
                                                              physics: NeverScrollableScrollPhysics(),
                                                              itemCount: op.length,
                                                              itemBuilder: (context, index) {
                                                                selQuesMap = {};
                                                                print("selQuesMap>>>>>${selQuesMap['selected']}");
                                                                finalSelectedAns = [];
                                                                finalSelectedAns.clear();
                                                                finalCorrectAns = [];
                                                                print("finalSelectedAns>>>>>>>>>>>$finalSelectedAns");

                                                                for (int i = 0; i < answersMapp.length; i++) {
                                                                  if (answersMapp[i]["questionNumber"] ==
                                                                      (_quetionNo)) {
                                                                    selQuesMap = {
                                                                      "questionNumber": _quetionNo,
                                                                      "selected": answersMapp[i]["selectedAnser"] ?? [],
                                                                      "right": answersMapp[i]["rightNumber"] ?? []
                                                                    };

                                                                    answer = (answersMapp[i]["selectedAnser"]);
                                                                    print("answer extracted>>>>>>$answer");
                                                                  }
                                                                }
                                                                finalSelectedAns = selQuesMap['selected'] ?? [];
                                                                finalCorrectAns = selQuesMap['right'] ?? [];
                                                                print(
                                                                    "finalSelectedAns final selected answers for this question;::::$finalSelectedAns");
                                                                print(
                                                                    "finalCorrectAns answers for this question;::::$finalCorrectAns");
                                                                if (finalSelectedAns.isNotEmpty) {
                                                                  print("finalSelectedAns is not empty");
                                                                  // setState(() {
                                                                  _show = true;
                                                                  print("value of is showw>>$_show");
                                                                  // });
                                                                }

                                                                if (selQuesMap.isNotEmpty) {
                                                                  enableTap = 1;
                                                                }

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

                                                                          for (int i = 0; i < rightAns.length; i++) {
                                                                            correctAns.add(int.parse(rightAns[i]));
                                                                          }
                                                                        });

                                                                        setState(() {
                                                                          ans.add(op[index].id);

                                                                          answer.add(op[index].id);
                                                                          selAns.add(op[index].id);
                                                                          print("selAns=============$selAns");

                                                                          if (selAns.length == correctAns.length &&
                                                                              correctAns.length > 0) {
                                                                            addToMap(_quetionNo, selAns, correctAns);
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
                                                                        color: (selAns.contains(op[index].id) &&
                                                                                correctAns.contains(op[index].id) &&
                                                                                selAns.length == correctAns.length &&
                                                                                selAns.length > 0)
                                                                            ? Color(0xffE6F7E7)
                                                                            : (selAns.contains(op[index].id) &&
                                                                                    !correctAns
                                                                                        .contains(op[index].id) &&
                                                                                    selAns.length ==
                                                                                        correctAns.length &&
                                                                                    selAns.length > 0)
                                                                                ? Color(0xffFFF6F6)
                                                                                : (correctAns.contains(op[index].id) &&
                                                                                        selAns.length ==
                                                                                            correctAns.length &&
                                                                                        selAns.length > 0)
                                                                                    ? Color(0xffE6F7E7)
                                                                                    : (selAns.contains(op[index].id) &&
                                                                                            correctAns
                                                                                                .contains(op[index].id))
                                                                                        ? Color(0xffE6F7E7)
                                                                                        : (selAns.contains(op[index].id) &&
                                                                                                !correctAns.contains(
                                                                                                    op[index].id))
                                                                                            ? Color(0xffFFF6F6)
                                                                                            : finalSelectedAns.contains(
                                                                                                        op[index].id) &&
                                                                                                    finalCorrectAns.contains(
                                                                                                        op[index].id)
                                                                                                ? Color(0xffE6F7E7)
                                                                                                : finalSelectedAns.contains(
                                                                                                            op[index]
                                                                                                                .id) &&
                                                                                                        !finalCorrectAns
                                                                                                            .contains(op[index].id)
                                                                                                    ? Color(0xffFFF6F6)
                                                                                                    : finalCorrectAns.contains(op[index].id)
                                                                                                        ? Color(0xffE6F7E7)
                                                                                                        : Colors.white,
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
                                                                                        ? PTList[_quetionNo]
                                                                                                .ques
                                                                                                .rightAnswer
                                                                                                .contains(
                                                                                                    "${op[index].id}")
                                                                                            ? Color(0xff04AE0B)
                                                                                            : op[index].isseleted
                                                                                                ? PTList[_quetionNo]
                                                                                                        .ques
                                                                                                        .rightAnswer
                                                                                                        .contains(
                                                                                                            "${op[index].id}")
                                                                                                    ? Color(0xffE6F7E7)
                                                                                                    : Color(0xffFF0000)
                                                                                                : Colors.white
                                                                                        : op[index].isseleted
                                                                                            ? PTList[_quetionNo]
                                                                                                    .ques
                                                                                                    .rightAnswer
                                                                                                    .contains(
                                                                                                        "${op[index].id}")
                                                                                                ? Color(0xffE6F7E7)
                                                                                                : Color(0xffFFF6F6)
                                                                                            : Colors.white
                                                                                    : op[index].isseleted
                                                                                        ? PTList[_quetionNo]
                                                                                                .ques
                                                                                                .rightAnswer
                                                                                                .contains(
                                                                                                    "${op[index].id}")
                                                                                            ? Color(0xffE6F7E7)
                                                                                            : Color(0xffFFF6F6)
                                                                                        : finalCorrectAns
                                                                                                .contains(op[index].id)
                                                                                            ? Color(0xff04AE0B)
                                                                                            : (finalSelectedAns.contains(
                                                                                                        op[index].id) &&
                                                                                                    !finalCorrectAns.contains(
                                                                                                        op[index].id))
                                                                                                ? Color(0xffFF0000)
                                                                                                : Colors.white,
                                                                                border: Border.all(color: selAns.length == correctAns.length && selAns.length > 0 ? Colors.grey : Colors.black)),
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
                                                                                          fontSize: FontSize(18),
                                                                                        )
                                                                                      },
                                                                                    ),
                                                                                    (finalCorrectAns.contains(op[index].id)) ||
                                                                                            (selAns.length == correctAns.length &&
                                                                                                selAns.length > 0 &&
                                                                                                selAns.contains(
                                                                                                    op[index].id) &&
                                                                                                correctAns.contains(
                                                                                                    op[index].id)) ||
                                                                                            (selAns.length == correctAns.length &&
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
                                                                                        : (selAns.length == correctAns.length &&
                                                                                                    selAns.length > 0 &&
                                                                                                    selAns.contains(
                                                                                                        op[index].id) &&
                                                                                                    !correctAns.contains(
                                                                                                        op[index]
                                                                                                            .id)) ||
                                                                                                (finalSelectedAns.contains(
                                                                                                        op[index].id) &&
                                                                                                    !finalCorrectAns
                                                                                                        .contains(op[index].id))
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
                                                          if ((selAns.length == correctAns.length &&
                                                                  correctAns.length > 0) ||
                                                              (finalSelectedAns.isNotEmpty))
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
                                                                      print("this is taping");
                                                                      setState(() {
                                                                        _show = !_show;
                                                                            print("this is taping>>>${_show}");
                                                                      });
                                                                    },
                                                                    child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          RichText(
                                                                              text: TextSpan(children: <TextSpan>[
                                                                            TextSpan(
                                                                              text: 'See Solution',
                                                                              style: TextStyle(
                                                                                  color: _colorfromhex("#ABAFD1"),
                                                                                  fontSize: width * (15 / 420),
                                                                                  fontFamily: 'Roboto Regular',
                                                                                  height: 1.7),
                                                                            ),
                                                                          ])),
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
                                                                          child: RichText(
                                                                              text: TextSpan(children: <TextSpan>[
                                                                            TextSpan(
                                                                              text:
                                                                                  "${getTstAns(op, PTList[_quetionNo].ques.rightAnswer)}",
                                                                              style: TextStyle(
                                                                                  color: _colorfromhex("#04AE0B"),
                                                                                  fontSize: width * (15 / 420),
                                                                                  fontFamily: 'Roboto Regular',
                                                                                  height: 1.7),
                                                                            ),
                                                                          ])))
                                                                      : Container(),
                                                                  _show
                                                                      ? Container(
                                                                          margin:
                                                                              EdgeInsets.only(top: height * (9 / 800)),
                                                                          child: Html(
                                                                            data: PTList[_quetionNo].ques.explanation,
                                                                            style: {
                                                                              "body": Style(
                                                                                padding: EdgeInsets.only(top: 5),
                                                                                fontFamily: 'Roboto Regular',

                                                                                margin: EdgeInsets.zero,
                                                                                color: Color(0xff000000),
                                                                                textAlign: TextAlign.left,
                                                                                // maxLines: 7,
                                                                                // textOverflow: TextOverflow.ellipsis,
                                                                                fontSize: FontSize(18),
                                                                              )
                                                                            },
                                                                          ),
                                                                        )
                                                                      : Container()
                                                                ],
                                                              ),
                                                            )
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
      onTap: () async {
        bool result = await checkInternetConn();

        if (result) {
          ProfileProvider pp = Provider.of(context, listen: false);
          await pp.subscriptionStatus("Chat");
          print("op le ${op.length}");
          List<String> otsList = getList(op);
          print("otsList le ${otsList.length}");

          questionLoader
              ? null
              : context.read<ProfileProvider>().subscriptionApiCalling
                  ? null
                  : onTapOfPutOnDisscussion(PTList != null ? PTList[_quetionNo].ques.question : '', otsList,
                      PTList != null ? PTList[_quetionNo].ques.image : '');
        } else {
          EasyLoading.showInfo("Please check your Internet Connection");
        }
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
                              child: RichText(
                                  text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                  text: "Put on discussion",
                                  style: TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ]))),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void check(List<int> selAns, List<int> rightAns) {
    // for(int)
  }

  void checkAllAns(List<int> selAns, List<int> rightAns) {
    isListSame = true;

    selAns.sort();

    for (int i = 0; i < selAns.length; i++) {
      if (selAns[i] == (rightAns[i])) {
      } else {
        isListSame = false;

        break;
      }
    }

    if (isListSame) {
      isAnsCorrect = 1;
    } else {
      isAnsCorrect = 2;
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

    return optsValueList;
  }

  String getTstAns(List<Options> op, String ansRight) {
    _show = true;

    List<int> checkFrmList = [];
    List<String> checkStrList = [];
    checkStrList = ansRight.split(',');
    for (int i = 0; i < checkStrList.length; i++) {
      checkFrmList.add(int.parse(checkStrList[i]));
    }
    print("checkFrmList:::::********************************$checkFrmList");

    print("ansRight>>>>>>>>>$ansRight");
    String correct = "";
    List<int> rightAns = [];
    print("op length>>>>>>>>>${op.length}");

    for (int i = 0; i < op.length; i++) {
      print("op>>>>>>>>>${op[i].id}");
    }
    // print("finalSelectedAns for correct option>>>>$finalSelectedAns");
    // print("correctanslength===${correctAns.length}");
    // if (correctAns.isEmpty) {
    //   rightAns = finalSelectedAns;
    // } else {
    //   rightAns = correctAns;
    // }
    rightAns = checkFrmList;
    print("rightAns rightAns rightAns>>>>$rightAns");

    if (rightAns.length == 1) {
      if (rightAns.contains(op[0].id)) {
        print("this is correct");
        correct = 'Answer A is the correct one';
      } else if (rightAns.contains(op[1].id)) {
        correct = 'Answer B is the correct one';
      } else if (rightAns.contains(op[2].id)) {
        correct = 'Answer C is the correct one';
        print("this is correct ans c");
      } else if (rightAns.contains(op[3].id)) {
        correct = 'Answer D is the correct one';
      } else {
        correct = 'Answer E is the correct one';
      }
    } else if (rightAns.length == 2) {
      if (op.length > 4) {
        print("E option is present ");

        if (rightAns.contains(op[0].id) && rightAns.contains(op[4].id)) {
          correct = "Answer A and E are the correct one";
        } else if (rightAns.contains(op[1].id) && rightAns.contains(op[4].id)) {
          correct = "Answer B and E are the correct one";
        } else if (rightAns.contains(op[2].id) && rightAns.contains(op[4].id)) {
          correct = "Answer C and E are the correct one";
        } else if (rightAns.contains(op[3].id) && rightAns.contains(op[4].id)) {
          correct = "Answer D and E are the correct one";
        }
      } else {
        print("E option is not present and means its absent ");
        if (rightAns.contains(op[0].id) && rightAns.contains(op[1].id)) {
          correct = "Answer A and B are the correct one";
        } else if (rightAns.contains(op[0].id) && rightAns.contains(op[2].id)) {
          correct = "Answer A and C are the correct one";
        } else if (rightAns.contains(op[0].id) && rightAns.contains(op[3].id)) {
          correct = "Answer A and D are the correct one";
        } else if (rightAns.contains(op[1].id) && rightAns.contains(op[2].id)) {
          correct = "Answer B and C are the correct one";
        } else if (rightAns.contains(op[1].id) && rightAns.contains(op[3].id)) {
          correct = "Answer B and D are the correct one";
        } else if (rightAns.contains(op[2].id) && rightAns.contains(op[3].id)) {
          correct = "Answer C and D are the correct one";
        }
      }
    } else if (rightAns.length == 3) {
      print("checking for length 3");

      if (op.length > 4) {
        print("E option is present");
        if (rightAns.contains(op[0].id) && rightAns.contains(op[1].id) && rightAns.contains(op[4].id)) {
          correct = "Answer A, B and E are the correct one";
        } else if (rightAns.contains(op[0].id) && rightAns.contains(op[2].id) && rightAns.contains(op[4].id)) {
          correct = "Answer A, C and E are the correct one";
        } else if (rightAns.contains(op[0].id) && rightAns.contains(op[3].id) && rightAns.contains(op[4].id)) {
          correct = "Answer A, D and E are the correct one";
        }
        if (rightAns.contains(op[1].id) && rightAns.contains(op[2].id) && rightAns.contains(op[4].id)) {
          correct = "Answer B, C and E are the correct one";
        } else if (rightAns.contains(op[1].id) && rightAns.contains(op[3].id) && rightAns.contains(op[4].id)) {
          correct = "Answer B, D and E are the correct one";
        } else if (rightAns.contains(op[2].id) && rightAns.contains(op[3].id) && rightAns.contains(op[4].id)) {
          correct = "Answer C, D and E are the correct one";
        }
      } else {
        print("E option is not present and means its absent ");
        if (rightAns.contains(op[0].id) && rightAns.contains(op[1].id) && rightAns.contains(op[2].id)) {
          correct = "Answer A, B and C are the correct one";
        } else if (rightAns.contains(op[0].id) && rightAns.contains(op[1].id) && rightAns.contains(op[3].id)) {
          correct = "Answer A, B and D are the correct one";
        } else if (rightAns.contains(op[0].id) && rightAns.contains(op[2].id) && rightAns.contains(op[3].id)) {
          correct = "Answer A, C and D are the correct one";
        } else if (rightAns.contains(op[2].id) && rightAns.contains(op[3].id) && rightAns.contains(op[1].id)) {
          correct = "Answer B, C and D are the correct one";
        }
      }
    }

    // if (correctAns.length == 1) {
    //   if (correctAns.contains(op[0].id)) {
    //     correct = 'Answer A is the correct one';
    //   } else if (correctAns.contains(op[1].id)) {
    //     correct = 'Answer B is the correct one';
    //   } else if (correctAns.contains(op[2].id)) {
    //     correct = 'Answer C is the correct one';
    //   } else if (correctAns.contains(op[3].id)) {
    //     correct = 'Answer D is the correct one';
    //   } else {
    //     correct = 'Answer E is the correct one';
    //   }
    // } else if (correctAns.length == 2) {
    //   if (correctAns.contains(op[0].id) && correctAns.contains(op[1].id)) {
    //     correct = "Answer A and B are the correct one";
    //   } else if (correctAns.contains(op[0].id) && correctAns.contains(op[2].id)) {
    //     correct = "Answer A and C are the correct one";
    //   } else if (correctAns.contains(op[0].id) && correctAns.contains(op[3].id)) {
    //     correct = "Answer A and D are the correct one";
    //   } else if (correctAns.contains(op[0].id) && correctAns.contains(op[4].id)) {
    //     correct = "Answer A and E are the correct one";
    //   } else if (correctAns.contains(op[1].id) && correctAns.contains(op[2].id)) {
    //     correct = "Answer B and C are the correct one";
    //   } else if (correctAns.contains(op[1].id) && correctAns.contains(op[3].id)) {
    //     correct = "Answer B and D are the correct one";
    //   } else if (correctAns.contains(op[1].id) && correctAns.contains(op[4].id)) {
    //     correct = "Answer B and E are the correct one";
    //   } else if (correctAns.contains(op[2].id) && correctAns.contains(op[3].id)) {
    //     correct = "Answer C and D are the correct one";
    //   } else if (correctAns.contains(op[2].id) && correctAns.contains(op[4].id)) {
    //     correct = "Answer C and E are the correct one";
    //   } else if (correctAns.contains(op[3].id) && correctAns.contains(op[4].id)) {
    //     correct = "Answer D and E are the correct one";
    //   }
    // } else if (correctAns.length == 3) {
    //   if (correctAns.contains(op[0].id) && correctAns.contains(op[1].id) && correctAns.contains(op[2].id)) {
    //     correct = "Answer A, B and C are the correct one";
    //   } else if (correctAns.contains(op[0].id) && correctAns.contains(op[1].id) && correctAns.contains(op[3].id)) {
    //     correct = "Answer A, B and D are the correct one";
    //   } else if (correctAns.contains(op[0].id) && correctAns.contains(op[1].id) && correctAns.contains(op[4].id)) {
    //     correct = "Answer A, B and E are the correct one";
    //   } else if (correctAns.contains(op[0].id) && correctAns.contains(op[2].id) && correctAns.contains(op[3].id)) {
    //     correct = "Answer A, C and D are the correct one";
    //   } else if (correctAns.contains(op[0].id) && correctAns.contains(op[2].id) && correctAns.contains(op[4].id)) {
    //     correct = "Answer A, C and E are the correct one";
    //   } else if (correctAns.contains(op[0].id) && correctAns.contains(op[3].id) && correctAns.contains(op[4].id)) {
    //     correct = "Answer A, D and E are the correct one";
    //   } else if (correctAns.contains(op[1].id) && correctAns.contains(op[2].id) && correctAns.contains(op[3].id)) {
    //     correct = "Answer B, C and D are the correct one";
    //   } else if (correctAns.contains(op[1].id) && correctAns.contains(op[2].id) && correctAns.contains(op[4].id)) {
    //     correct = "Answer B, C and E are the correct one";
    //   } else if (correctAns.contains(op[1].id) && correctAns.contains(op[3].id) && correctAns.contains(op[4].id)) {
    //     correct = "Answer B, D and E are the correct one";
    //   } else if (correctAns.contains(op[2].id) && correctAns.contains(op[3].id) && correctAns.contains(op[4].id)) {
    //     correct = "Answer C, D and E are the correct one";
    //   }
    // }
    print("correct======$correct");
    return correct;
  }

  void addToMap(int quetionNo, List<int> selAns, List<int> rytAns) {
    Map<String, dynamic> map = {"questionNumber": quetionNo, "selectedAnser": selAns, "rightNumber": rytAns};

    answersMapp.add(map);
  }

  Future checkInternetConn() async {
    bool result = await InternetConnectionChecker().hasConnection;

    if (result == false) {
      Future.delayed(Duration(seconds: 1), () async {
        //  await EasyLoading.showToast("Internet Not Connected",toastPosition: EasyLoadingToastPosition.bottom);
      });
      return result;
    } else {}
    return result;
  }
}
