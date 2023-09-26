import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:getwidget/getwidget.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pgmp4u/Models/restartModel.dart';
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
import '../Domain/disImage.dart';
import '../Tests/local_handler/hive_handler.dart';

class MockTestQuestions extends StatefulWidget {
  final int selectedId;
  final String mockName;
  final attempt;
  final int selectedIndex;
  RestartModel restartModel;
  bool connStatus;

  MockTestQuestions(
      {this.selectedId, this.mockName, this.attempt, this.selectedIndex, this.restartModel, this.connStatus});

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

  PageController pageController;
  final Connectivity _connectivity = Connectivity();
  var subQues;
  var plusQues;
  final selectedIdNew;
  final mockNameNew;
  final attemptNew;
  List ids = [];
  List answer = [];
  bool isNetAvailable = true;
  List<Map<String, dynamic>> answersMapp = [];
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
  bool anotherLoader = false;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    onChange: (value) => {},
    onChangeRawSecond: (value) => {},
    onChangeRawMinute: (value) => {},
  );
  var currentIndex;

  List<Queans> mockQuestion = [];
  int timecheck;

  @override
  void initState() {
    pageController = PageController(initialPage: -2);
    print("widget.restartModel========${widget.restartModel}");
    beforeCallApi();
    if (mockQuestion.isEmpty) {
      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    }
    timecheck = 0;
    CourseProvider cp = Provider.of(context, listen: false);
    cp.timerValue = false;
    cp.allowScroll = 1;
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

    print("cp.totalTime=====${cp.totalTime}");
    if (cp.totalTime != null) {
      timecheck = cp.totalTime;
    }

    if (widget.restartModel != null) {
      int time1 = int.tryParse(widget.restartModel.displayTime) ?? 0;
      print("tryyy parseee=====${int.tryParse(widget.restartModel.displayTime)}");
      _stopWatchTimer.setPresetTime(mSec: time1);
    }

    context.read<CourseProvider>().setMasterListType("Chat");
    context.read<ProfileProvider>().subscriptionStatus("Chat");
    super.initState();

    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  beforeCallApi() async {
    if (widget.restartModel != null) {
      answersMapp = widget.restartModel.answersMapp;
      print("answersMapp after hive set::::$answersMapp");
      if (widget.restartModel.atempedData != null) {
        submitData = widget.restartModel.atempedData;
      }
      print("submit data  submit data  submit data submit data >>>>> $submitData");

      if (widget.restartModel.quesNum < 0) {
        widget.restartModel.quesNum = 2;
      }
      print("widget.restartModel.quesNum=====${widget.restartModel.quesNum}");
      if (widget.restartModel.quesNum < 1) {
        widget.restartModel.quesNum = 2;
      }
      setState(() {
        _quetionNo = widget.restartModel.quesNum;
      });

      try {
        // Future.delayed(Duration(seconds: 2), () {

        SchedulerBinding.instance.addPostFrameCallback((_) {
          pageController.animateToPage(widget.restartModel.quesNum,
              duration: Duration(milliseconds: 10), curve: Curves.bounceOut);
          // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });

        // });
      } catch (e, stackTrace) {
        print("startcktrsace::: $stackTrace");
        print("errororororor::::: $e");
      }
    }
    await apiCall();
  }

  @override
  void dispose() {
    super.dispose();
    if (pageController != null) {
      pageController.dispose();
    }

    _stopWatchTimer.dispose();
  }

  // 0 -> fine
  // 1 -> error
  int isContinue = 0;
  updateIsContinue(int val) {
    isContinue = val;
    setState(() {});
  }

  Future submitMockTest(data, stopTime) async {
    print("submitData====$submitData");
    updateIsContinue(0);

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
    CourseProvider cp = Provider.of(context, listen: false);
    try {
      response = await http
          .post(
        Uri.parse(SUBMIT_MOCK_TEST),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: params,
      )
          .whenComplete(() async {
        CourseProvider courseProvider = Provider.of(context, listen: false);

        await courseProvider.getTestDetails(courseProvider.selectedMockId);
        await courseProvider.apiCall(courseProvider.selectedTstPrcentId);
        await http.get(Uri.parse(MOCK_TEST + '/${courseProvider.selectedTstPrcentId}'),
            headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
      });

      if (response.statusCode == 200) {
        CourseProvider courseProvider = Provider.of(context, listen: false);
        if (courseProvider.notSubmitedMockID != null) {
          HiveHandler.removeFromSubmitMockBox(courseProvider.notSubmitedMockID);
          courseProvider.setnotSubmitedMockID("");
          courseProvider.setToBeSubmitIndex(1000);
        }
      }
    } catch (error, stackTrace) {
      print("ONERRROR: $error");
      print("ONERRROR stackTrace>>>>  $stackTrace");
      loader = false;
      // updateIsContinue(1);
      CourseProvider cp = Provider.of(context, listen: false);

      cp.toPage = _quetionNo;
      cp.setPauseTime(
        displayTime,
        answersMapp,
        atmpData: submitData,
      );
      print("answersMapp internet >> $answersMapp");

      print("answersMapp internet >> ${cp.totalTime}");

      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
      // if (error == "Failed host lookup: 'apivcarestage.vcareprojectmanagement.com'") {
      cp.setToBeSubmitIndex(widget.selectedIndex);
      showInternetPopup();
      cp.setnotSubmitedMockID(cp.selectedMockId.toString());
      HiveHandler.addNotSubmittedMock(params, KeyName: cp.selectedMockId.toString());
      // }
      return;
    }
    print("is continue>>>> $isContinue");

    if (isContinue == 0) {
      print("Url :=> $SUBMIT_MOCK_TEST");
      print("request body  :=> $params");
      print("header :=> ${{'Content-Type': 'application/json', 'Authorization': stringValue}}");

      print("API Response => ${response.request.url}; $params; ${response.body}");
      print("response.statusCode===========${response.statusCode}");
      CourseProvider cp = Provider.of(context, listen: false);
      if (response.statusCode == 200) {
        cp.totalTime = 0;
        HiveHandler.removeFromRestartBox(cp.selectedMockId.toString());
        Map responseData = json.decode(response.body);
        print("data::::: $data");
        if (data == "back" || data == "") {
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

          // print(">>>>>>>>> review data $responseData");
          // print("widget.attempt==========${widget.attempt}");
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
    CourseProvider cp = Provider.of(context, listen: false);
    // var params = json.encode({
    //   "mock_test_id": selectedIdNew,
    //   "attempt_type": attemptNew + 1,
    //   "questons": submitData,
    //   "start_date_time": cp.totalTime.toString(),
    // });

    try {
      var connectivityResult = (Connectivity().checkConnectivity());
      print("connectivityResult:::$connectivityResult");
    } catch (e) {
      print("errorrrr>>>>$e");
    }

    print("inside go back func");
    // print("time eeee===>>>${_yi}");
    print("submitData==========${submitData.toString()}");

    print("cp.toPage${cp.toPage}");
    print("go back answersMapp>>>> $answersMapp");

    HiveHandler.addToRestartBox(
        cp.selectedMockId.toString(),
        RestartModel(
            displayTime: cp.totalTime.toString(),
            quesNum: cp.toPage,
            restartAttempNum: cp.selectedAttemptNumer,
            answersMapp: answersMapp,
            atempedData: submitData)); /////////////
    cp.setToRestartList(displayTime, cp.selectedAttemptNumer, cp.toPage);
    // HiveHandler.setSubmitMockData(cp.selectedMockId.toString(), submitData.toString());
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
                  Navigator.of(context).pop(false);
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
                    print("this is callingggggggggggg");

                    submitMockTest("back", displayTime);
                  } else {
                    CourseProvider cp = Provider.of(context, listen: false);
                    print("cp.toPage,cp.toPage,===${cp.toPage}");

                    HiveHandler.addToRestartBox(
                        cp.selectedMockId.toString(),
                        RestartModel(
                            displayTime: displayTime,
                            quesNum: cp.toPage,
                            restartAttempNum: cp.selectedAttemptNumer,
                            answersMapp: answersMapp,
                            atempedData: submitData));

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("s********electedIdNew============$selectedIdNew");

    anotherLoader = true;
    http.Response response;
    try {
      response = await http.get(Uri.parse(MOCK_TEST_QUESTIONS + '/$selectedIdNew'),
          headers: {'Content-Type': 'application/json', 'Authorization': stringValue}).onError((error, stackTrace) {
        anotherLoader = false;

        print("erroeee::::: $error");
        print("stackTrace:::: $stackTrace");
      });

      anotherLoader = false;
      setState(() {});
      print("Url :=> ${Uri.parse(MOCK_TEST_QUESTIONS + '/$selectedIdNew')}");

      print("header :=> ${{'Content-Type': 'application/json', 'Authorization': stringValue}}");
      // print("responseeeeeeeeee>>>>>>>>>>>>>>> $response");
      // print("responseeeee body>>>>>>>${response.body}");
      if (response != null) {
        if (response.body != null) {
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
      }
    } on Exception {}
  }

  var displayTime = '';

  bool questionLoader = false;
  onTapOfPutOnDisscussion(String question, List<Optionss> list01, String quesImg) async {
    CourseProvider cp = Provider.of(context, listen: false);

    await context.read<ProfileProvider>().subscriptionStatus("Chat");
    print("context.read<ProfileProvider>().isChatSubscribed${context.read<ProfileProvider>().isChatSubscribed}");
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

    // print("optsValue=========$mckOptions");

    if (question.isEmpty) {
      setState(() => questionLoader = false);
      return;
    }

    await context
        .read<ChatProvider>()
        .createDiscussionGroup(question, mckOptions, quesImg, context,
            testName: 'From Mock Test: ' + mockNameNew, crsName: cp.selectedCourseLable)
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
                print("mockQuestion length >>> ${mockQuestion.length}");
                print("selecteed id:: ${selectedIdNew.toString()}");
                if (value.containsKey(selectedIdNew.toString())) {
                  // print("value:>> ${value.get(selectedIdNew.toString())} ");
                  String data = value.get(selectedIdNew.toString());
                  List resList = jsonDecode(data);
                  mockQuestion = resList.map((e) => Queans.fromjss(e)).toList();
                } else {
                  print("errror  v1111==========");
                }
                List<Optionss> op = [];
                if (mockQuestion.isNotEmpty) {
                  op = mockQuestion[_quetionNo]
                      .questionDetail
                      .Options
                      .where((element) => element.question_option.isNotEmpty)
                      .toList();
                  if (op.isNotEmpty) {
                    // print("mock test op opopo po pop::; ${op[0].question_option}");
                  }
                }

                // print("mockQuestion==============>>   $mockQuestion");

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
                                          cp.setScroll(0, _quetionNo);
                                          cp.setPauseTime(displayTime, answersMapp, atmpData: submitData);
                                          _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                                          // commingSoonDialog(context);
                                          // showPausePopup();
                                        } else {
                                          cp.setScroll(1, _quetionNo);
                                          cp.totalTime = 0;
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
                                              print("display timeee====$displayTime");
                                              print("question  number that will set in model:::$_quetionNo");
                                              cp.resPauseTimer();
                                              if (_stopWatchTimer.isRunning) {
                                                print("display timeee====$displayTime");
                                                print("stop timerrrrr");
                                                cp.setScroll(0, _quetionNo);
                                                cp.setPauseTime(displayTime, answersMapp, atmpData: submitData);
                                                _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                                                // commingSoonDialog(context);
                                                // showPausePopup();
                                              } else {
                                                print("startttt timerrrrr");
                                                cp.totalTime = 0;
                                                cp.setScroll(1, _quetionNo);
                                                _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    print("submeit datta:::::;$submitData");
                                                    cp.resPauseTimer();
                                                    print("question  number that will set in model:::$_quetionNo");
                                                    if (_stopWatchTimer.isRunning) {
                                                      cp.setScroll(0, _quetionNo);
                                                      cp.setPauseTime(displayTime, answersMapp, atmpData: submitData);

                                                      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                                                      // commingSoonDialog(context);
                                                      // showPausePopup();
                                                    } else {
                                                      cp.setScroll(1, _quetionNo);
                                                      cp.totalTime = 0;
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
                              ? Consumer<CourseProvider>(builder: (context, cp, child) {
                                  print("cp.allowScroll ${cp.allowScroll}");
                                  return Expanded(
                                    child: PageView.builder(
                                        controller: pageController,
                                        physics: cp.allowScroll == 1
                                            ? BouncingScrollPhysics()
                                            : NeverScrollableScrollPhysics(),
                                        onPageChanged: (index) {
                                          print("lkjgkjdfhgkljh");

                                          // answer = [];

                                          if (answersMapp != null) {
                                            for (int i = 0; i < answersMapp.length; i++) {
                                              if (answersMapp[i]["questionNumber"] == (_quetionNo)) {
                                                answer = (answersMapp[i]["selectedAnser"]);
                                              }
                                            }
                                          }

                                          print("ansers after they are set:::::$answer");

                                          if (currentData != null) {
                                            if (selectedAnswer.length ==
                                                mockQuestion[_quetionNo].questionDetail.rightAnswer.length) {
                                              print("submit data before length:::: $submitData");

                                              for (int i = 0; i < submitData.length; i++) {
                                                if (submitData[i]["question"] == currentData["question"]) {
                                                  submitData.removeAt(i);
                                                }
                                              }
                                              print("submit data after length:::: $submitData");

                                              submitData.add({
                                                "question": currentData["question"],
                                                "answer": currentData["answer"],
                                                "correct": 0,
                                                "category": currentData["category"],
                                                "type": selectedAnswer.length > 2 ? 2 : 1
                                              });
                                              print("submitData to be submitted::::::$submitData");

                                              currentData = null;
                                            } else {}
                                          }
                                          print(" index current   >> $currentIndex");
                                          print(" index  >> $index");
                                          if (currentIndex < index) {
                                            print("dfg");

                                            if (mockQuestion.length - 1 > _quetionNo) {
                                              if (_quetionNo < mockQuestion.length) {
                                                _quetionNo = _quetionNo + 1;
                                              }

                                              selectedAnswer = [];
                                              ids = [];
                                            } else {
                                              if (!loader) submitMockTest('', displayTime);
                                            }
                                          } else {
                                            print("hwllo");
                                            if (_quetionNo != 0) {
                                              _quetionNo--;
                                              selectedAnswer = [];
                                              ids = [];
                                              currentData = null;
                                            }
                                          }

                                          currentIndex = index;
                                          setState(() {});
                                        },
                                        itemCount: mockQuestion.length,
                                        itemBuilder: (context, index) {
                                          print("index is $index");
                                          print("current Indedx: $index ");
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
                                                          Text(
                                                            'QUESTION ${_quetionNo + 1}',
                                                            style: TextStyle(
                                                              fontFamily: 'Roboto Regular',
                                                              fontSize: width * (16 / 420),
                                                              color: _colorfromhex("#ABAFD1"),
                                                            ),
                                                          ),
                                                          widget.connStatus
                                                              ? putOnDiscussionButton(context)
                                                              : SizedBox(),
                                                        ],
                                                      ),
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
                                                      ),
                                                      mockQuestion[_quetionNo].questionDetail.image != null
                                                          ? InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => ImageDispalyScreen(
                                                                              quesImages: mockQuestion[_quetionNo]
                                                                                  .questionDetail
                                                                                  .image,
                                                                            )));
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: Colors.grey[300],
                                                                  borderRadius: BorderRadius.circular(20),
                                                                ),
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  child: CachedNetworkImage(
                                                                    imageUrl:
                                                                        mockQuestion[_quetionNo].questionDetail.image,
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
                                                                        height: MediaQuery.of(context).size.width * .4,
                                                                        child: Center(child: Icon(Icons.error))),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : SizedBox(),
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

                                                      ListView.builder(
                                                          shrinkWrap: true,
                                                          physics: NeverScrollableScrollPhysics(),
                                                          itemCount: op.length,
                                                          itemBuilder: (context, index) {
                                                            if (answersMapp != null) {
                                                              for (int i = 0; i < answersMapp.length; i++) {
                                                                if (answersMapp[i]["questionNumber"] == (_quetionNo)) {
                                                                  print(
                                                                      "answersMapp[i][selectedAnser]::::${answersMapp[i]["selectedAnser"]}");
                                                                  // answer = answersMapp[i]["selectedAnser"];
                                                                  answer = (answersMapp[i]["selectedAnser"]);
                                                                  print("answer:::::::answer::::::::$answer");
                                                                }
                                                              }
                                                            }

                                                            int rightAnswerLength = mockQuestion[_quetionNo]
                                                                .questionDetail
                                                                .rightAnswer
                                                                .length;
                                                            return Padding(
                                                              padding: const EdgeInsets.only(bottom: 15),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  if (cp.allowScroll == 0) {
                                                                    showPausePopup();
                                                                  } else if (cp.allowScroll == 1) {
                                                                    print(
                                                                        "selectedAnswer length::::${selectedAnswer.length}");
                                                                    print(
                                                                        "rightAnswerLength length::::$rightAnswerLength");
                                                                    {
                                                                      if (selectedAnswer.length != rightAnswerLength) {
                                                                        selectedAnswer.add(index);
                                                                        // showAnswer.add(mockQuestion[_quetionNo].questionDetail.Options[index].id);

                                                                        // showAnswer.add({"questionNo":_quetionNo,"selectedAns":mockQuestion[_quetionNo].questionDetail.Options[index].id});

                                                                        ids.add(mockQuestion[_quetionNo]
                                                                            .questionDetail
                                                                            .Options[index]
                                                                            .id);
                                                                        String finalString = ids.join(', ');
                                                                        print("_quetionNo::::${_quetionNo + 1}");
                                                                        print("finalString of ids::::$finalString");
                                                                        addToMap(_quetionNo, ids);

                                                                        // answersMapp.add(){}

                                                                        currentData = {
                                                                          "question": mockQuestion[_quetionNo]
                                                                              .questionDetail
                                                                              .queID,
                                                                          "answer": finalString,
                                                                          "correct": 1,
                                                                          "category": mockQuestion[_quetionNo]
                                                                              .questionDetail
                                                                              .category,
                                                                          "type": selectedAnswer.length > 2 ? 2 : 1
                                                                        };

                                                                        print(
                                                                            "currentData current  first tim,e:::::  $currentData");
                                                                      } else {
                                                                        var previusData = currentData['answer'];
                                                                        print(
                                                                            "selected answers::; list ${currentData['answer']}");
                                                                        print("inside this conditiion:::;");
                                                                        print(
                                                                            "currentData current data before:::::  $currentData");
                                                                        selectedAnswer = [];
                                                                        answer = [];

                                                                        Future.delayed(Duration(milliseconds: 200));
                                                                        ids = [];

                                                                        selectedAnswer.add(index);
                                                                        print(
                                                                            "selected answe after tap=====$selectedAnswer");
                                                                        ids.add(mockQuestion[_quetionNo]
                                                                            .questionDetail
                                                                            .Options[index]
                                                                            .id);

                                                                        print("after added in answe$answer");
                                                                        String finalStr = ids.join(', ');
                                                                        addToMap(_quetionNo, ids);
                                                                        currentData = {
                                                                          "question": mockQuestion[_quetionNo]
                                                                              .questionDetail
                                                                              .queID,
                                                                          "answer": finalStr,
                                                                          "correct": 1,
                                                                          "category": mockQuestion[_quetionNo]
                                                                              .questionDetail
                                                                              .category,
                                                                          "type": selectedAnswer.length > 2 ? 2 : 1
                                                                        };
                                                                        var nextData = currentData['answer'];
                                                                        print("::nextData:: $nextData");
                                                                        print("::previusData:: $previusData");
                                                                        // if (nextData == previusData) {
                                                                        //   answer = [];
                                                                        //   selectedAnswer = [];
                                                                        // }

                                                                        setState(() {});
                                                                      }
                                                                    }
                                                                    setState(() {});
                                                                  }
                                                                },
                                                                child: Container(
                                                                  margin: EdgeInsets.only(top: 10),
                                                                  padding: EdgeInsets.only(
                                                                    bottom: 5,
                                                                    top: 5,
                                                                    left: width * (13 / 420),
                                                                    right: width * (11 / 420),
                                                                  ),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(8),
                                                                      color: selectedAnswer.contains(index) ||
                                                                              answer.contains(mockQuestion[_quetionNo]
                                                                                  .questionDetail
                                                                                  .Options[index]
                                                                                  .id)
                                                                          ? Color(0xffF2F2FF)
                                                                          : Colors.white),
                                                                  child: Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 5.0, bottom: 5),
                                                                        child: Container(
                                                                          width: width * (25 / 420),
                                                                          height: width * 25 / 420,
                                                                          decoration: BoxDecoration(
                                                                            border: Border.all(
                                                                                color: selectedAnswer.contains(index) ||
                                                                                        answer.contains(
                                                                                            mockQuestion[_quetionNo]
                                                                                                .questionDetail
                                                                                                .Options[index]
                                                                                                .id)
                                                                                    ? Color(0xff3846A9)
                                                                                    : Color(0xffF1F1FF)),
                                                                            borderRadius: BorderRadius.circular(
                                                                              width * (25 / 420),
                                                                            ),
                                                                            color: selectedAnswer.contains(index) ||
                                                                                    answer.contains(
                                                                                        mockQuestion[_quetionNo]
                                                                                            .questionDetail
                                                                                            .Options[index]
                                                                                            .id)
                                                                                ? Color(0xff3846A9)
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
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.only(left: 8),
                                                                        width: width - (width * (25 / 420) * 5),
                                                                        child: Html(
                                                                          data: op[index].question_option,
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
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          })

                                                      // Column(
                                                      //   children: mockQuestion[_quetionNo]
                                                      //       .questionDetail
                                                      //       .Options
                                                      //       .map<Widget>((title) {
                                                      //     var index = mockQuestion[_quetionNo]
                                                      //         .questionDetail
                                                      //         .Options
                                                      //         .indexOf(title);

                                                      //     int rightAnswerLength = mockQuestion[_quetionNo]
                                                      //         .questionDetail
                                                      //         .rightAnswer
                                                      //         .length;

                                                      //     print("_question numner:::::::$_quetionNo");
                                                      //     print("::::answersMapp::::$answersMapp");
                                                      //     // for (int i = 0; i < answersMapp.length; i++) {
                                                      //     //   if (answersMapp[i]["questionNumber"] == (_quetionNo)) {
                                                      //     //     answer = (answersMapp[i]["selectedAnser"]);
                                                      //     //   }
                                                      //     // }

                                                      //     print(
                                                      //         "option index id:::::;::${mockQuestion[_quetionNo].questionDetail.Options[index].id}");

                                                      //     String finalStr;
                                                      //     var finalString;
                                                      //     return title.question_option != null
                                                      //         ? GestureDetector(
                                                      //             onTap: () => {
                                                      //               if (cp.allowScroll == 0)
                                                      //                 {showPausePopup()}
                                                      //               else if (cp.allowScroll == 1)
                                                      //                 {
                                                      //                   // if (answer.length == rightAnswerLength)
                                                      //                   //   {}
                                                      //                   // else
                                                      //                   print(
                                                      //                       "selectedAnswer length::::${selectedAnswer.length}"),
                                                      //                   print(
                                                      //                       "rightAnswerLength length::::$rightAnswerLength"),
                                                      //                   {
                                                      //                     if (selectedAnswer.length !=
                                                      //                         rightAnswerLength)
                                                      //                       {
                                                      //                         selectedAnswer.add(index),
                                                      //                         // showAnswer.add(mockQuestion[_quetionNo].questionDetail.Options[index].id);

                                                      //                         // showAnswer.add({"questionNo":_quetionNo,"selectedAns":mockQuestion[_quetionNo].questionDetail.Options[index].id});

                                                      //                         ids.add(mockQuestion[_quetionNo]
                                                      //                             .questionDetail
                                                      //                             .Options[index]
                                                      //                             .id),
                                                      //                         finalString = ids.join(', '),
                                                      //                         print("_quetionNo::::${_quetionNo + 1}"),
                                                      //                         print(
                                                      //                             "finalString of ids::::$finalString"),
                                                      //                         addToMap(_quetionNo, ids),

                                                      //                         // answersMapp.add(){}

                                                      //                         currentData = {
                                                      //                           "question": mockQuestion[_quetionNo]
                                                      //                               .questionDetail
                                                      //                               .queID,
                                                      //                           "answer": finalString,
                                                      //                           "correct": 1,
                                                      //                           "category": mockQuestion[_quetionNo]
                                                      //                               .questionDetail
                                                      //                               .category,
                                                      //                           "type":
                                                      //                               selectedAnswer.length > 2 ? 2 : 1
                                                      //                         },

                                                      //                         print(
                                                      //                             "currentData current  first tim,e:::::  $currentData"),
                                                      //                       }
                                                      //                     else
                                                      //                       {
                                                      //                         print("inside this conditiion:::;"),
                                                      //                         print(
                                                      //                             "currentData current data before:::::  $currentData"),
                                                      //                         selectedAnswer = [],
                                                      //                         answer = [],
                                                      //                         ids = [],
                                                      //                         selectedAnswer.add(index),
                                                      //                         ids.add(mockQuestion[_quetionNo]
                                                      //                             .questionDetail
                                                      //                             .Options[index]
                                                      //                             .id),
                                                      //                         finalStr = ids.join(', '),
                                                      //                         currentData = {
                                                      //                           "question": mockQuestion[_quetionNo]
                                                      //                               .questionDetail
                                                      //                               .queID,
                                                      //                           "answer": finalStr,
                                                      //                           "correct": 1,
                                                      //                           "category": mockQuestion[_quetionNo]
                                                      //                               .questionDetail
                                                      //                               .category,
                                                      //                           "type":
                                                      //                               selectedAnswer.length > 2 ? 2 : 1
                                                      //                         },
                                                      //                         print(
                                                      //                             "currentData current data after:::::  $currentData"),
                                                      //                         print("idsssssss$ids"),
                                                      //                         print(
                                                      //                             "seleccted answer dfasfd:::;$selectedAnswer"),
                                                      //                         print("answer answer dfasfd:::;$answer"),
                                                      //                         // setState(() {})
                                                      //                       }
                                                      //                   },
                                                      //                   setState(() {})
                                                      //                 }
                                                      //             },
                                                      //             child: Container(
                                                      //               margin: EdgeInsets.only(top: height * (21 / 800)),
                                                      //               padding: EdgeInsets.only(
                                                      //                 top: 13,
                                                      //                 bottom: 13,
                                                      //                 left: width * (13 / 420),
                                                      //                 right: width * (11 / 420),
                                                      //               ),
                                                      //               decoration: BoxDecoration(
                                                      //                   borderRadius: BorderRadius.circular(8),
                                                      //                   color: selectedAnswer.contains(index) ||
                                                      //                           answer.contains(mockQuestion[_quetionNo]
                                                      //                               .questionDetail
                                                      //                               .Options[index]
                                                      //                               .id)
                                                      //                       ? Color(0xffF2F2FF)
                                                      //                       : Colors.white),
                                                      //               child:
                                                      // Row(
                                                      //                 children: [
                                                      //                   Container(
                                                      //                     width: width * (25 / 420),
                                                      //                     height: width * 25 / 420,
                                                      //                     decoration: BoxDecoration(
                                                      //                       border: Border.all(
                                                      //                           color: selectedAnswer.contains(index) ||
                                                      //                                   answer.contains(
                                                      //                                       mockQuestion[_quetionNo]
                                                      //                                           .questionDetail
                                                      //                                           .Options[index]
                                                      //                                           .id)
                                                      //                               ? Color(0xff3846A9)
                                                      //                               : Color(0xffF1F1FF)),
                                                      //                       borderRadius: BorderRadius.circular(
                                                      //                         width * (25 / 420),
                                                      //                       ),
                                                      //                       color: selectedAnswer.contains(index) ||
                                                      //                               answer.contains(
                                                      //                                   mockQuestion[_quetionNo]
                                                      //                                       .questionDetail
                                                      //                                       .Options[index]
                                                      //                                       .id)
                                                      //                           ? Color(0xff3846A9)
                                                      //                           : Colors.white,
                                                      //                     ),
                                                      //                     child: Center(
                                                      //                       child: Text(
                                                      //                         index == 0
                                                      //                             ? 'A'
                                                      //                             : index == 1
                                                      //                                 ? 'B'
                                                      //                                 : index == 2
                                                      //                                     ? 'C'
                                                      //                                     : index == 3
                                                      //                                         ? 'D'
                                                      //                                         : 'E',
                                                      //                         style: TextStyle(
                                                      //                           fontFamily: 'Roboto Regular',
                                                      //                           color: selectedAnswer.contains(index)
                                                      //                               ? Colors.white
                                                      //                               : _colorfromhex("#ABAFD1"),
                                                      //                         ),
                                                      //                       ),
                                                      //                     ),
                                                      //                   ),
                                                      //                   Container(
                                                      //                     margin: EdgeInsets.only(left: 8),
                                                      //                     width: width - (width * (25 / 420) * 5),
                                                      //                     child: Html(
                                                      //                       data: title.question_option,
                                                      //                       style: {
                                                      //                         "body": Style(
                                                      //                           padding: EdgeInsets.only(top: 5),
                                                      //                           margin: EdgeInsets.zero,
                                                      //                           color: Color(0xff000000),
                                                      //                           textAlign: TextAlign.left,
                                                      //                           fontSize: FontSize(18),
                                                      //                         )
                                                      //                       },
                                                      //                     ),
                                                      //                   )
                                                      //                 ],
                                                      //               ),
                                                      //             ),
                                                      //           )
                                                      //         : SizedBox();
                                                      //   }).toList(),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  );
                                })
                              :
                              // anotherLoader == false && mockQuestion.isEmpty
                              //     ? Center(
                              //         child: Text(
                              //         "No Data Found",
                              //         style: TextStyle(fontSize: 16),
                              //       ))
                              //     : anotherLoader == true
                              //         ?
                              Container(
                                  child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(_colorfromhex("#4849DF")),
                                ))
                          // : SizedBox()
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
                                              print("_quetionNo:::::_quetionNo$_quetionNo"),
                                              subQues = _quetionNo,

                                              setState(() {
                                                _quetionNo--;
                                              }),
                                              print("subQues::::::;$subQues"),
                                              print("-------subQues::::::;${--subQues}"),
                                              // if (pageController != null)
                                              {
                                                pageController.previousPage(
                                                  duration: Duration(milliseconds: 500), // You can adjust the duration
                                                  curve: Curves.ease,
                                                ),
                                                // pageController.animateToPage(--subQues,
                                                //     duration: Duration(milliseconds: 500), curve: Curves.easeInCirc),
                                              }
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
                                        print("how many timez this prints....."),
                                        if (mockQuestion.length - 1 > _quetionNo)
                                          {
                                            plusQues = _quetionNo,
                                            pageController.nextPage(
                                              duration: Duration(milliseconds: 500), // You can adjust the duration
                                              curve: Curves.ease,
                                            ),
                                            // pageController.animateToPage(++plusQues,
                                            //     duration: Duration(milliseconds: 500), curve: Curves.easeInCirc),
                                            if (currentData != null)
                                              {
                                                print("selectedAnswer.length::::::::::${selectedAnswer.length}"),
                                                // print("rightAnswer.length:::::::::::::${mockQuestion[_quetionNo].questionDetail.rightAnswer.length}");

                                                if (selectedAnswer.length ==
                                                    mockQuestion[_quetionNo].questionDetail.rightAnswer.length)
                                                  {
                                                    print("submit data before length poi:::: $submitData"),
                                                    for (int i = 0; i < submitData.length; i++)
                                                      {
                                                        if (submitData[i]["question"] == currentData["question"])
                                                          {
                                                            submitData.removeAt(i),
                                                          }
                                                      },
                                                    print("submit data after length poi:::: $submitData"),
                                                    print("addedd to listt"),
                                                    submitData.add({
                                                      "question": currentData["question"],
                                                      "answer": currentData["answer"],
                                                      "correct": 0,
                                                      "category": currentData["category"],
                                                      "type": selectedAnswer.length > 2 ? 2 : 1
                                                    }),
                                                    currentData = null,
                                                    print(
                                                        "submit data after length after again final add :::: $submitData"),
                                                  }
                                                else
                                                  {}
                                              },
                                            selectedAnswer = [],
                                            ids = [],
                                            setState(() {}),
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
      onTap: () async {

bool result= await checkInternetConn();
if(result){
  ProfileProvider pp = Provider.of(context, listen: false);
        await pp.subscriptionStatus("Chat");
        questionLoader || context.read<ProfileProvider>().subscriptionApiCalling
            ? null
            : onTapOfPutOnDisscussion(mockQuestion[_quetionNo].questionDetail.questiondata,
                mockQuestion[_quetionNo].questionDetail.Options, mockQuestion[_quetionNo].questionDetail.image);
}else{
        EasyLoading.showInfo("Please check your internet connection");
}

      
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
        // barrierDismissible: false,
        builder: (context) => AlertDialog(
              elevation: 20,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title: Column(
                children: [
                  Text("Test is currently paused \n Press the Resume button to continue with the test.",
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
                        // CourseProvider cp = Provider.of(context, listen: false);
                        // _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                        Navigator.pop(context);
                        // cp.resPauseTimer();
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
                              "Dismiss",
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

  void addToMap(int quetionNo, List finalString) {
    for (int i = 0; i < answersMapp.length; i++) {
      if (answersMapp[i]["questionNumber"] == quetionNo) {
        answersMapp.removeAt(i);
      }
    }
    Map<String, dynamic> map = {"questionNumber": quetionNo, "selectedAnser": finalString};

    answersMapp.add(map);
    print("answersMapp::::::::$answersMapp");
  }

  void showInternetPopup() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              elevation: 20,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              title: Column(
                children: [
                  Text(
                      "No Internet Connection!\n Results are saved \n Test will be submitted whenever internet connection is available",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Container(
                            height: 35,
                            width: MediaQuery.of(context).size.width * .15,
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
                                "OK",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ))),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ],
            ));
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

  // <bool> ifNet() async{
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   return true;
  // }
}
