import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:getwidget/getwidget.dart';
import 'package:pgmp4u/Screens/MockTest/mockTestResult.dart';
import 'package:pgmp4u/Screens/chat/controller/chatProvider.dart';
import 'package:pgmp4u/Screens/chat/screen/discussionGoupList.dart';
import 'package:pgmp4u/Screens/home_view/VideoLibrary/RandomPage.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:pgmp4u/provider/profileProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../Models/mockquestionanswermodel.dart';
import '../Tests/local_handler/hive_handler.dart';

class MockTestQuestions extends StatefulWidget {
  final int selectedId;
  final String mockName;
  final attempt;
  MockTestQuestions({this.selectedId, this.mockName, this.attempt});

  @override
  _MockTestQuestionsState createState() =>
      new _MockTestQuestionsState(selectedIdNew: this.selectedId, mockNameNew: this.mockName, attemptNew: this.attempt);
}

class _MockTestQuestionsState extends State<MockTestQuestions> {
  QuestionAnswerModel questionAnswersList;
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  final selectedIdNew;
  final mockNameNew;
  final attemptNew;
  List ids = [];
  _MockTestQuestionsState({
    this.selectedIdNew,
    this.mockNameNew,
    this.attemptNew,
  });
  List submitData = [];
  bool _show = true;
  int _quetionNo = 0;
  List<int> selectedAnswer = [];
  String stringResponse;
  List listResponse;
  Map mapResponse;
  int selectedId;
  Map currentData;
  String startTime;
  bool loader = false;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    onChange: (value) => {},
    onChangeRawSecond: (value) => {},
    onChangeRawMinute: (value) => {},
  );
  var currentIndex;

  List<Queans> mockQuestion = [];

  @override
  void initState() {
    CourseProvider cp = Provider.of(context, listen: false);
    cp.timerValue = false;
    // _stopWatchTimer.setPresetMinuteTime(5);

    print("***********************************************");

    print("selectedId======${widget.selectedId}");
    print("mockName======${widget.mockName}");
    print("attempt======${widget.attempt}");

    print("***********************************************");
    currentIndex = 0;
    _stopWatchTimer.rawTime.listen((value) => {});
    _stopWatchTimer.minuteTime.listen((value) => {});
    _stopWatchTimer.secondTime.listen((value) => {});
    _stopWatchTimer.records.listen((value) => {});

    beforeCallApi();
    context.read<CourseProvider>().setMasterListType("Chat");
    context.read<ProfileProvider>().subscriptionStatus("Chat");
    super.initState();
  }

  beforeCallApi() async {
    await apiCall();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  // 0 -> fine
  // 1 -> error
  int isContinue = 0;
  updateIsContinue(int val) {
    isContinue = val;
    setState(() {});
  }

  Future submitMockTest(data, stopTime) async {
    updateIsContinue(0);
    print("*****************************");
    print("attemptNew==========$attemptNew");
    setState(() {
      loader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    http.Response response;

    var params = json.encode({
      "mock_test_id": selectedIdNew,
      "attempt_type": attemptNew + 1,
      "questons": submitData,
      "start_date_time": stopTime
    });

    print("api body==========$params");

    response = await http
        .post(
      Uri.parse(SUBMIT_MOCK_TEST),
      headers: {"Content-Type": "application/json", 'Authorization': stringValue},
      body: params,
    )
        .onError((error, stackTrace) {
      print("ONERRROR: $error");
      loader = false;
      updateIsContinue(1);

      return;
    });

    if (isContinue == 0) {
      print("Url :=> $SUBMIT_MOCK_TEST");
      print("request body  :=> $params");
      print("header :=> ${{'Content-Type': 'application/json', 'Authorization': stringValue}}");

      print("API Response => ${response.request.url}; $params; ${response.body}");
      print("response.statusCode===========${response.statusCode}");
      CourseProvider cp = Provider.of(context, listen: false);
      if (response.statusCode == 200) {
        HiveHandler.removeFromRestartBox(cp.selectedMockId.toString());
        Map responseData = json.decode(response.body);
        if (data == "back") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MockTestResult(
                    resultsData: responseData["data"],
                    mocktestId: selectedIdNew,
                    attemptData: attemptNew,
                    activeTime: stopTime,
                    atmptCount: cp.selectedMokAtmptCnt)),
          );

          // Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false);
        } else {
          setState(() {
            loader = false;
          });

          print(">>>>>>>>> review data $responseData");
          print("widget.attempt==========${widget.attempt}");
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MockTestResult(
                      resultsData: responseData["data"],
                      mocktestId: selectedIdNew,
                      attemptData: attemptNew,
                      activeTime: stopTime,
                      atmptCount: cp.selectedMokAtmptCnt,
                    )),
          );
        }

        GFToast.showToast(
          'Mock test submitted successfully',
          context,
          toastPosition: GFToastPosition.BOTTOM,
        );
        print("success");
      } else {
        setState(() {
          loader = false;
        });
        print(response.body);
        GFToast.showToast(
          "Something went wrong,please submit again",
          context,
          toastPosition: GFToastPosition.BOTTOM,
        );
      }
    }
  }

  Future<bool> goBack() {
    print("inside go back func");
    // print("time eeee===>>>${_yi}");
    print("submitData==========${submitData.toString()}");
    CourseProvider cp = Provider.of(context, listen: false);
    HiveHandler.addToRestartBox(cp.selectedMockId.toString(), cp.selectedAttemptNumer);
    HiveHandler.setSubmitMockData(cp.selectedMockId.toString(), submitData.toString());
    Navigator.pop(context);
  }

  Future<bool> _onWillPop() async {
    print("this function is calleddddd");
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Please submit the test',
              style: TextStyle(fontSize: 20, fontFamily: 'Roboto Bold', color: Colors.black),
            ),
            content: new Text(''),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () {
                  if (_stopWatchTimer.isRunning) {
                    CourseProvider cp = Provider.of(context, listen: false);
                    cp.restartList.remove(cp.selectedAttemptNumer);
                    if (isContinue == 1) {
                      Navigator.pop(context);
                      updateIsContinue(0);
                      GFToast.showToast(
                        'Check Your Internet Connection',
                        context,
                        toastPosition: GFToastPosition.BOTTOM,
                      );
                      setState(() {
                        loader = false;
                      });
                      Navigator.pop(context);

                      return;
                    }

                    submitMockTest("back", displayTime);
                  } else {
                    CourseProvider cp = Provider.of(context, listen: false);

                    HiveHandler.addToRestartBox(cp.selectedMockId.toString(), cp.selectedAttemptNumer);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future apiCall() async {
    // http://3.227.35.115:1011/api/MockTestQuestions/118
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("s********electedIdNew============$selectedIdNew");

    http.Response response;
    try {
      response = await http.get(Uri.parse(MOCK_TEST_QUESTIONS + '/$selectedIdNew'),
          headers: {'Content-Type': 'application/json', 'Authorization': stringValue});

      print("Url :=> ${Uri.parse(MOCK_TEST_QUESTIONS + '/$selectedIdNew')}");

      print("header :=> ${{'Content-Type': 'application/json', 'Authorization': stringValue}}");
      print("response.statusCode::: ${response.statusCode}");

      if (response.statusCode == 200) {
        print(">>>>>> quiz data ${response.body}");
        var _mapResponse = convert.jsonDecode(response.body);

        print("map resposne datat=====>>>${_mapResponse["data"]}");

        HiveHandler.setMockData(key: selectedIdNew.toString(), value: jsonEncode(_mapResponse['data']));

        setState(() {
          startTime = (new DateTime.now()).toString();
          mapResponse = convert.jsonDecode(response.body);
          listResponse = mapResponse["data"];
          questionAnswersList = QuestionAnswerModel.fromjson(mapResponse["data"]);
          _stopWatchTimer.onExecute.add(StopWatchExecute.start);
          print("listResponse.lengeth========${listResponse.length}");
        });
      }
    } on Exception {
      // TODO
    }
  }

  var displayTime = '';

  bool questionLoader = false;
  onTapOfPutOnDisscussion(String question, List<Optionss> list01) async {
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
    print('Mock text question : $question');

    List<String> mckOptions = [];

    for (int i = 0; i < list01.length; i++) {
      String optsValue = "";
      optsValue = list01[i].question_option;

      if (optsValue.isEmpty || optsValue == null) {
      } else {
        mckOptions.add(optsValue);
      }
    }

    print("optsValue=========$mckOptions");

    if (question.isEmpty) {
      setState(() => questionLoader = false);
      return;
    }

    await context
        .read<ChatProvider>()
        .createDiscussionGroup(question, mckOptions, context, testName: 'From Mock Test: ' + mockNameNew)
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
    List<Queans> _quizList = [];
    if (questionAnswersList != null) {
      _quizList = questionAnswersList?.list ?? [];
    }

    return SafeArea(
      child: WillPopScope(
        onWillPop: _stopWatchTimer.isRunning ? _onWillPop : goBack,
        child: Scaffold(
          body: ValueListenableBuilder<Box<String>>(
              valueListenable: HiveHandler.getMockTestListener(),
              builder: (context, value, child) {
                print("selecteed id:: ${selectedIdNew.toString()}");
                if (value.containsKey(selectedIdNew.toString())) {
                  print("value:>> ${value.get(selectedIdNew.toString())} ");
                  String data = value.get(selectedIdNew.toString());
                  List resList = jsonDecode(data);

                  mockQuestion = resList.map((e) => Queans.fromjss(e)).toList();
                } else {
                  print("errror  v1111==========");
                }

                print("mockQuestion==============>>   $mockQuestion");

                return Container(
                  color: _colorfromhex("#FCFCFF"),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Consumer<CourseProvider>(builder: (context, cp, child) {
                            return Container(
                              height: 149,
                              width: width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/vector1d.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: width * (20 / 420), right: width * (20 / 420), top: height * (16 / 800)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            print("_stopWatchTimer======$_stopWatchTimer");
                                            if (_stopWatchTimer.isRunning) {
                                              print("timmer is runninfdddd");
                                            } else {
                                              print("timmer is not runninfdddd");
                                            }
                                            try {
                                              if (_stopWatchTimer.isRunning)
                                                _onWillPop();
                                              else
                                                goBack();
                                            } catch (e) {
                                              print("errorrrrrr is =====>$e");
                                            }

                                            // if (loader) {} else {submitMockTest("back", displayTime)}
                                          },
                                          child: Icon(
                                            Icons.arrow_back_ios,
                                            size: width * (24 / 420),
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          mockNameNew,
                                          style: TextStyle(
                                              fontFamily: 'Roboto Medium',
                                              fontSize: width * (16 / 420),
                                              color: Colors.white,
                                              letterSpacing: 0.3),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        cp.resPauseTimer();
                                        if (_stopWatchTimer.isRunning) {
                                          _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                                          // commingSoonDialog(context);
                                          // showPausePopup();
                                        } else {
                                          _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          StreamBuilder<int>(
                                              stream: _stopWatchTimer.rawTime,
                                              initialData: _stopWatchTimer.rawTime.value,
                                              builder: (context, snap) {
                                                if (snap.hasData) {
                                                  final value = snap.data;
                                                  displayTime = StopWatchTimer.getDisplayTime(value,
                                                      hours: true, milliSecond: false);

                                                  return Text(
                                                    displayTime,
                                                    style: TextStyle(
                                                        fontFamily: 'Roboto Medium',
                                                        fontSize: width * (16 / 420),
                                                        color: Colors.white,
                                                        letterSpacing: 0.3),
                                                  );
                                                }

                                                return Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              }),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              cp.resPauseTimer();
                                              if (_stopWatchTimer.isRunning) {
                                                _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                                                // commingSoonDialog(context);
                                                // showPausePopup();
                                              } else {
                                                _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    cp.resPauseTimer();
                                                    if (_stopWatchTimer.isRunning) {
                                                      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                                                      // commingSoonDialog(context);
                                                      // showPausePopup();
                                                    } else {
                                                      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                                                    }
                                                  },
                                                  child: Icon(
                                                    cp.timerValue ? Icons.play_arrow : Icons.pause,
                                                    size: width * (24 / 420),
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  _stopWatchTimer.isRunning ? "Pause " : 'Resume ',
                                                  style: TextStyle(color: Colors.white, fontSize: 17),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          // showLoader
                          //     ? Container(
                          //         child: CircularProgressIndicator(
                          //             valueColor: AlwaysStoppedAnimation<Color>(_colorfromhex("#4849DF"))))
                          //     :
                          mockQuestion != null && mockQuestion.isNotEmpty
                              //questionAnswersList != null
                              ? Expanded(
                                  child: PageView.builder(
                                      controller: pageController,
                                      onPageChanged: (index) {
                                        print("index====>>$index");
                                        print("currentIndex ====>>$currentIndex");
                                        if (currentIndex < index) {
                                          if (mockQuestion.length - 1 > _quetionNo) {
                                            setState(() {
                                              if (_quetionNo < mockQuestion.length) {
                                                _quetionNo = _quetionNo + 1;
                                              }

                                              if (currentData != null) {
                                                submitData.add({
                                                  "question": currentData["question"],
                                                  "answer": currentData["answer"],
                                                  "correct": 0,
                                                  "category": currentData["category"],
                                                  "type": selectedAnswer.length > 2 ? 2 : 1
                                                });
                                                currentData = null;
                                              }
                                              selectedAnswer = [];
                                              ids = [];
                                            });
                                          } else {
                                            if (!loader) submitMockTest('', displayTime);
                                          }
                                        } else {
                                          if (_quetionNo != 0) {
                                            setState(() {
                                              _quetionNo--;
                                              selectedAnswer = [];
                                              ids = [];
                                              currentData = null;
                                            });
                                          }
                                        }
                                        setState(() {
                                          currentIndex = index;

                                          print("final index===$currentIndex");
                                        });
                                      },
                                      itemCount: mockQuestion.length,
                                      itemBuilder: (context, index) {
                                        return SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: width * (29 / 420),
                                                    right: width * (29 / 420),
                                                    top: height * (23 / 800),
                                                    bottom: height * (23 / 800)),
                                                margin: EdgeInsets.only(bottom: 40),
                                                color: Colors.white,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        // _quetionNo != 0
                                                        //     ? GestureDetector(
                                                        //         onTap: () => {
                                                        //           setState(() {
                                                        //             _quetionNo--;

                                                        //             selectedAnswer = null;
                                                        //           })
                                                        //         },
                                                        //         child: Icon(
                                                        //           Icons.arrow_back,
                                                        //           size: width * (24 / 420),
                                                        //           color: _colorfromhex(
                                                        //               "#ABAFD1"),
                                                        //         ),
                                                        //       )
                                                        //     : Container(),
                                                        Text(
                                                          'QUESTION ${_quetionNo + 1}',
                                                          style: TextStyle(
                                                            fontFamily: 'Roboto Regular',
                                                            fontSize: width * (16 / 420),
                                                            color: _colorfromhex("#ABAFD1"),
                                                          ),
                                                        ),

                                                        putOnDiscussionButton(context),

                                                        // listResponse.length - 1 > _quetionNo
                                                        //     ? GestureDetector(
                                                        //         onTap: () => {
                                                        //           setState(() {
                                                        //             if (_quetionNo <
                                                        //                 listResponse
                                                        //                     .length) {
                                                        //               _quetionNo =
                                                        //                   _quetionNo + 1;
                                                        //             }
                                                        //             selectedAnswer = null;
                                                        //           }),
                                                        //           print(_quetionNo)
                                                        //         },
                                                        //         child: Icon(
                                                        //           Icons.arrow_forward,
                                                        //           size: width * (24 / 420),
                                                        //           color: _colorfromhex(
                                                        //               "#ABAFD1"),
                                                        //         ),
                                                        //       )
                                                        //     : Container(),
                                                      ],
                                                    ),
                                                    // Question
                                                    Container(
                                                      margin: EdgeInsets.only(top: height * (15 / 800)),
                                                      child: Html(
                                                        data: mockQuestion[_quetionNo].questionDetail.questiondata,
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
                                                      //   mockQuestion[_quetionNo].questionDetail.questiondata,
                                                      //   // _quizList.isNotEmpty
                                                      //   //     //questionAnswersList != null
                                                      //   //     ? _quizList[_quetionNo].questionDetail.questiondata
                                                      //   //     //listResponse[_quetionNo]
                                                      //   //     //      ["Question"]
                                                      //   //     //["question"]
                                                      //   //     : '',
                                                      //   style: TextStyle(
                                                      //     fontFamily: 'Roboto Regular',
                                                      //     fontSize: width * (15 / 420),
                                                      //     color: Colors.black,
                                                      //     height: 1.7,
                                                      //   ),
                                                      // ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "Max Selectable Option : ${mockQuestion[_quetionNo].questionDetail.rightAnswer.length}",
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto Regular',
                                                        fontSize: width * (15 / 420),
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                        height: 1.7,
                                                      ),
                                                    ),
                                                    Column(
                                                      children: mockQuestion[_quetionNo]
                                                          .questionDetail
                                                          .Options
                                                          .map<Widget>((title) {
                                                        // print("title is >>> ${title.question_option}");
                                                        var index = mockQuestion[_quetionNo]
                                                            .questionDetail
                                                            .Options
                                                            .indexOf(title);

                                                        // if (title.question_option.isEmpty) {
                                                        //   // title.question_option = "None of these";
                                                        //   mockQuestion[_quetionNo]
                                                        //       .questionDetail
                                                        //       .Options
                                                        //       .removeAt(index);
                                                        // }
                                                        int rightAnswerLength =
                                                            mockQuestion[_quetionNo].questionDetail.rightAnswer.length;

                                                        // return mockQuestion[_quetionNo] .questionDetail.Options.where((element)=>element.question_option.isNotEmpty).toList();
                                                        return title.question_option != null
                                                            ? GestureDetector(
                                                                onTap: () => {
                                                                  if (selectedAnswer.length != rightAnswerLength)
                                                                    {
                                                                      setState(() {
                                                                        selectedAnswer.add(index);

                                                                        ids.add(mockQuestion[_quetionNo]
                                                                            .questionDetail
                                                                            .Options[index]
                                                                            .id);
                                                                        String finalString = ids.join(', ');

                                                                        currentData = {
                                                                          "question": mockQuestion[_quetionNo]
                                                                              .questionDetail
                                                                              .queID,
                                                                          // listResponse[
                                                                          //         _quetionNo][
                                                                          //     "Question"]["id"],

                                                                          "answer": finalString,
                                                                          // listResponse[
                                                                          //                 _quetionNo]
                                                                          //             [
                                                                          //             "Question"]
                                                                          //         ["Options"]
                                                                          //     [index]["id"],
                                                                          "correct": 1,
                                                                          "category": mockQuestion[_quetionNo]
                                                                              .questionDetail
                                                                              .category,
                                                                          "type": selectedAnswer.length > 2 ? 2 : 1
                                                                          //  listResponse[
                                                                          //             _quetionNo]
                                                                          //         ["Question"]
                                                                          //     ["category"]
                                                                        };
                                                                        print("currentData  $currentData");
                                                                      })
                                                                    }
                                                                },
                                                                child: Container(
                                                                  margin: EdgeInsets.only(top: height * (21 / 800)),
                                                                  padding: EdgeInsets.only(
                                                                    top: 13,
                                                                    bottom: 13,
                                                                    left: width * (13 / 420),
                                                                    right: width * (11 / 420),
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      color: selectedAnswer.contains(index)
                                                                          ? _colorfromhex("#F2F2FF")
                                                                          : Colors.white),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        width: width * (25 / 420),
                                                                        height: width * 25 / 420,
                                                                        decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                              color: selectedAnswer.contains(index)
                                                                                  ? _colorfromhex("#3846A9")
                                                                                  : _colorfromhex("#F1F1FF")),
                                                                          borderRadius: BorderRadius.circular(
                                                                            width * (25 / 420),
                                                                          ),
                                                                          color: selectedAnswer.contains(index)
                                                                              ? _colorfromhex("#3846A9")
                                                                              : Colors.white,
                                                                        ),
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
                                                                              color: selectedAnswer.contains(index)
                                                                                  ? Colors.white
                                                                                  : _colorfromhex("#ABAFD1"),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.only(left: 8),
                                                                        width: width - (width * (25 / 420) * 5),
                                                                        child: Html(
                                                                          data: title.question_option,
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

                                                                        // Text(title.question_option,
                                                                        //     style: TextStyle(
                                                                        //         fontSize: width * 14 / 420))
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              )
                                                            : SizedBox();
                                                      }).toList(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                )
                              : Container(
                                  child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(_colorfromhex("#4849DF")),
                                ))
                        ],
                      ),
                      mockQuestion != null && mockQuestion.isNotEmpty
                          //questionAnswersList != null
                          ? Positioned(
                              bottom: 0,
                              child: Container(
                                width: width,
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      _quetionNo == 0 ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                                  children: [
                                    _quetionNo != 0
                                        ? GestureDetector(
                                            onTap: () => {
                                              setState(() {
                                                currentIndex--;
                                                print("currentIndex: $currentIndex");
                                              }),
                                              setState(() {
                                                _quetionNo--;
                                                selectedAnswer = [];
                                                ids = [];
                                                currentData = null;
                                              })
                                            },
                                            child: Container(
                                              width: width / 2,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(right: 2),
                                                    child: Icon(
                                                      Icons.arrow_back_ios,
                                                      size: width * (20 / 420),
                                                      color: _colorfromhex("#3A47AD"),
                                                    ),
                                                  ),
                                                  Text(
                                                    "Previous",
                                                    style: TextStyle(
                                                      fontSize: width * (18 / 420),
                                                      fontFamily: 'Roboto Medium',
                                                      color: _colorfromhex("#3A47AD"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    GestureDetector(
                                      onTap: () => {
                                        if (mockQuestion.length - 1 > _quetionNo)
                                          {
                                            setState(() {
                                              currentIndex = currentIndex + 1;
                                            }),
                                            setState(() {
                                              if (_quetionNo < mockQuestion.length) {
                                                _quetionNo = _quetionNo + 1;
                                              }

                                              if (currentData != null) {
                                                submitData.add({
                                                  "question": currentData["question"],
                                                  "answer": currentData["answer"],
                                                  "correct": 0,
                                                  "category": currentData["category"],
                                                  "type": selectedAnswer.length > 2 ? 2 : 1
                                                });
                                                currentData = null;
                                              }
                                              selectedAnswer = [];
                                              ids = [];
                                            }),
                                          }
                                        else
                                          {if (!loader) submitMockTest('', displayTime)}
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(top: height * (20 / 800), bottom: height * (16 / 800)),
                                        width: width / 2,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                          ),
                                          gradient: LinearGradient(
                                              colors: [
                                                _colorfromhex("#3A47AD"),
                                                _colorfromhex("#5163F3"),
                                              ],
                                              begin: const FractionalOffset(0.0, 0.0),
                                              end: const FractionalOffset(1.0, 0.0),
                                              stops: [0.0, 1.0],
                                              tileMode: TileMode.clamp),
                                        ),
                                        child: loader
                                            ? Container(
                                                child: Center(
                                                child: Container(
                                                  width: 30,
                                                  height: 30,
                                                  child: CircularProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                  ),
                                                ),
                                              ))
                                            : Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    mockQuestion.length - 1 > _quetionNo ? "Next" : "Finish",
                                                    style: TextStyle(
                                                      fontSize: width * (18 / 420),
                                                      fontFamily: 'Roboto Medium',
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(left: 2),
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: width * (20 / 420),
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          : Container()
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget putOnDiscussionButton(BuildContext context) {
    return InkWell(
      onTap: () {
        questionLoader || context.read<ProfileProvider>().subscriptionApiCalling
            ? null
            : onTapOfPutOnDisscussion(
                mockQuestion[_quetionNo].questionDetail.questiondata, mockQuestion[_quetionNo].questionDetail.Options);
      },
      child: Container(
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
        child: questionLoader || context.watch<ProfileProvider>().subscriptionApiCalling
            ? Center(child: SizedBox(width: 20, height: 20, child: Center(child: CircularProgressIndicator.adaptive())))
            : Padding(
                padding: const EdgeInsets.all(8.0),
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
    );
  }

  void showPausePopup() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              elevation: 20,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title: Column(
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     InkWell(
                  //         onTap: () {
                  //           Navigator.pop(context);
                  //         },
                  //         child: Icon(Icons.cancel)),
                  //   ],
                  // ),
                  // SizedBox(height: 15),
                  Text("Test is currently paused \n Press the button to continue with the test.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Roboto Medium',
                        fontWeight: FontWeight.w200,
                        color: Colors.black,
                      )),
                ],
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: InkWell(
                      onTap: () {
                        CourseProvider cp = Provider.of(context, listen: false);
                        _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                        Navigator.pop(context);
                        cp.resPauseTimer();
                      },
                      child: Container(
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
                          child: Center(
                            child: Text(
                              "Resume Test",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ))),
                )
              ],
            ));
  }
}
