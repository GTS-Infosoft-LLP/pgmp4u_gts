import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:getwidget/getwidget.dart';
import 'package:pgmp4u/Screens/MockTest/mockTestResult.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../Models/mockquestionanswermodel.dart';
import '../chat/chatPage.dart';


class MockTestQuestions extends StatefulWidget {
  final int selectedId;
  final String mockName;
  final attempt;
  MockTestQuestions({this.selectedId, this.mockName, this.attempt});

  @override
  _MockTestQuestionsState createState() => new _MockTestQuestionsState(
      selectedIdNew: this.selectedId,
      mockNameNew: this.mockName,
      attemptNew: this.attempt);
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

    
  @override
  void initState() {
    super.initState();
   currentIndex=0;
    _stopWatchTimer.rawTime.listen((value) => {});
    _stopWatchTimer.minuteTime.listen((value) => {});
    _stopWatchTimer.secondTime.listen((value) => {});
    _stopWatchTimer.records.listen((value) => {});
    apiCall();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  Future submitMockTest(data, stopTime) async {
    setState(() {
      loader = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    http.Response response;

    var params = json.encode({
      "mock_test_id": selectedIdNew,
      "attempt_type": attemptNew,
      "questons": submitData,
      "start_date_time": stopTime
    });

    response = await http.post(
      Uri.parse(SUBMIT_MOCK_TEST),
      headers: {
        "Content-Type": "application/json",
        'Authorization': stringValue
      },
      body: params,
    );

    print("Url :=> ${SUBMIT_MOCK_TEST}");
    print("request body  :=> ${params}");
    print("header :=> ${{
      'Content-Type': 'application/json',
      'Authorization': stringValue
    }}");

    print("API Response => ${response.request.url}; $params; ${response.body}");

    if (response.statusCode == 200) {
      Map responseData = json.decode(response.body);
      if (data == "back") {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/dashboard', (Route<dynamic> route) => false);
      } else {
        setState(() {
          loader = false;
        });

        print(">>>>>>>>> review data ${responseData}");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MockTestResult(
                    resultsData: responseData["data"],
                    mocktestId: selectedIdNew,
                    attemptData: attemptNew,
                    activeTime: stopTime,
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

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(
              'Please submit the test',
              style: TextStyle(
                  fontSize: 20, fontFamily: 'Roboto Bold', color: Colors.black),
            ),
            content: new Text(''),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => {submitMockTest("back", displayTime)},
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

    http.Response response;
    response = await http
        .get(Uri.parse(MOCK_TEST_QUESTIONS + '/${selectedIdNew}'), headers: {
      'Content-Type': 'application/json',
      'Authorization': stringValue
    });

    print("Url :=> ${Uri.parse(MOCK_TEST_QUESTIONS + '/${selectedIdNew}')}");

    print("header :=> ${{
      'Content-Type': 'application/json',
      'Authorization': stringValue
    }}");
    print("response.statusCode::: ${response.statusCode}");

    if (response.statusCode == 200) {
      print(">>>>>> quiz data ${response.body}");

      setState(() {
        startTime = (new DateTime.now()).toString();
        mapResponse = convert.jsonDecode(response.body);
        listResponse = mapResponse["data"];
        questionAnswersList = QuestionAnswerModel.fromjson(mapResponse["data"]);
        _stopWatchTimer.onExecute.add(StopWatchExecute.start);
      });
    }
  }

  var displayTime = '';

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
        onWillPop: _onWillPop,
        child: StreamBuilder<int>(
            stream: _stopWatchTimer.rawTime,
            initialData: _stopWatchTimer.rawTime.value,
            builder: (context, snap) {
              if (snap.hasData) {
                final value = snap.data;
                displayTime = StopWatchTimer.getDisplayTime(value,
                    hours: true, milliSecond: false);
                return Scaffold(
                  body: Container(
                    color: _colorfromhex("#FCFCFF"),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
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
                                    left: width * (20 / 420),
                                    right: width * (20 / 420),
                                    top: height * (16 / 800)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () => {
                                            if (loader)
                                              {}
                                            else
                                              {
                                                submitMockTest(
                                                    "back", displayTime)
                                              }
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
                                    Text(
                                      displayTime,
                                      style: TextStyle(
                                          fontFamily: 'Roboto Medium',
                                          fontSize: width * (16 / 420),
                                          color: Colors.white,
                                          letterSpacing: 0.3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            _quizList.isNotEmpty
                                //questionAnswersList != null
                                ? Expanded(
                                    child: PageView.builder(
                      
                                      controller: pageController,
                                      onPageChanged:(index){

                                        

                                        print("index====>>${index}");  
                                        print("currentIndex ====>>${currentIndex}"); 
                                        if(currentIndex<index){

                                      if (listResponse.length - 1 >
                                              _quetionNo)
                                            {
                                              setState(() {
                                                if (_quetionNo <
                                                    listResponse.length) {
                                                  _quetionNo = _quetionNo + 1;
                                                }

                                                if (currentData != null) {
                                                  submitData.add({
                                                    "question":
                                                        currentData["question"],
                                                    "answer":
                                                        currentData["answer"],
                                                    "correct": 0,
                                                    "category":
                                                        currentData["category"],
                                                    "type":
                                                        selectedAnswer.length >
                                                                2
                                                            ? 2
                                                            : 1
                                                  });
                                                  currentData = null;
                                                }
                                                selectedAnswer = [];
                                                ids = [];
                                              });
                                            }
                                          else
                                            {
                                              if (!loader)
                                                submitMockTest('', displayTime);
                                            }
                                        }else{


                                      if( _quetionNo != 0){

                                            setState(() {
                                                  _quetionNo--;
                                                  selectedAnswer = [];
                                                  ids = [];
                                                  currentData = null;
                                                });
                                        }
                                        }
                                        setState(() {
                                          currentIndex=index;

                                          print("final index===${currentIndex}");
                                        });
                                      } ,
                                      itemCount: _quizList.length,
                                      itemBuilder: (context,index) {

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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
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
                                                            fontFamily:
                                                                'Roboto Regular',
                                                            fontSize:
                                                                width * (16 / 420),
                                                            color: _colorfromhex(
                                                                "#ABAFD1"),
                                                          ),
                                                        ),


                                                          InkWell(
                                                            onTap: (){
                                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(v1: mockNameNew,)));
                                                            },
                                                            child: Container(
                                                              height: 40,
                                                              width: 100,
                                                              decoration: BoxDecoration(
                                                                 gradient: LinearGradient(
                                                                         colors: [
                                                                             _colorfromhex("#3A47AD"),
                                                                           _colorfromhex("#5163F3"),
                                                                             ],
                                                                           begin: const FractionalOffset(0.0, 0.0),
                                                                            end: const FractionalOffset(1.0, 0.0),
                                                                            stops: [0.0, 1.0],
                                                                            tileMode: TileMode.clamp),
                                                                            borderRadius: BorderRadius.all(Radius.circular(50)), 
                                                              ),
                                                              child: Center(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                  children: [
                                                                  Container(
                                                                    height: 20,
                                                                    width: 10,
                                                                    child: Icon(Icons.chat_bubble_rounded,color: Colors.white,)),
                                                                  Text("Chat",
                                                                  style: TextStyle(
                                                                   fontSize: width * (18 / 420),
                                                                  fontFamily:  'Roboto Medium',
                                                                  color: Colors.white,
                                                                  ),
                                                                  )
                                                                ]),
                                                              ),
                                                          
                                                          
                                                            ),
                                                          )


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
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: height * (15 / 800)),
                                                      child: Text(
                                                        _quizList.isNotEmpty
                                                            //questionAnswersList != null
                                                            ? _quizList[_quetionNo]
                                                                .questionDetail
                                                                .questiondata
                                                            //listResponse[_quetionNo]
                                                            //      ["Question"]
                                                            //["question"]
                                                            : '',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Roboto Regular',
                                                          fontSize:
                                                              width * (15 / 420),
                                                          color: Colors.black,
                                                          height: 1.7,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "Max Selectable Option : ${_quizList[_quetionNo].questionDetail.rightAnswer.length}",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Roboto Regular',
                                                        fontSize:
                                                            width * (15 / 420),
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                        height: 1.7,
                                                      ),
                                                    ),
                                                    Column(
                                                      children:
                                                          _quizList[_quetionNo]
                                                              .questionDetail
                                                              .Options
                                                              .map<Widget>((title) {
                                                                // print("title is >>> ${title.question_option}");
                                                        var index =
                                                            _quizList[_quetionNo]
                                                                .questionDetail
                                                                .Options
                                                                .indexOf(title);

                                                        int rightAnswerLength =
                                                            _quizList[_quetionNo]
                                                                .questionDetail
                                                                .rightAnswer
                                                                .length;
                                                        return title .question_option.isNotEmpty ? GestureDetector(
                                                          onTap: () => {
                                                            if (selectedAnswer
                                                                    .length !=
                                                                rightAnswerLength)
                                                              {

                                                                setState(() {
                                                                  selectedAnswer
                                                                      .add(index);

                                                                  ids.add(_quizList[
                                                                          _quetionNo]
                                                                      .questionDetail
                                                                      .Options[
                                                                          index]
                                                                      .id);
                                                                  String
                                                                      finalString =
                                                                      ids.join(
                                                                          ', ');

                                                                  currentData = {
                                                                    "question": _quizList[
                                                                            _quetionNo]
                                                                        .questionDetail
                                                                        .queID,
                                                                    // listResponse[
                                                                    //         _quetionNo][
                                                                    //     "Question"]["id"],

                                                                    "answer":
                                                                        finalString,
                                                                    // listResponse[
                                                                    //                 _quetionNo]
                                                                    //             [
                                                                    //             "Question"]
                                                                    //         ["Options"]
                                                                    //     [index]["id"],
                                                                    "correct": 1,
                                                                    "category": _quizList[
                                                                            _quetionNo]
                                                                        .questionDetail
                                                                        .category,
                                                                    "type":
                                                                        selectedAnswer.length >
                                                                                2
                                                                            ? 2
                                                                            : 1
                                                                    //  listResponse[
                                                                    //             _quetionNo]
                                                                    //         ["Question"]
                                                                    //     ["category"]
                                                                  };
                                                                  print(
                                                                      "currentData  $currentData");
                                                                })
                                                              }
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets.only(
                                                                top: height *
                                                                    (21 / 800)),
                                                            padding:
                                                                EdgeInsets.only(
                                                              top: 13,
                                                              bottom: 13,
                                                              left: width *
                                                                  (13 / 420),
                                                              right: width *
                                                                  (11 / 420),
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                color: selectedAnswer
                                                                        .contains(
                                                                            index)
                                                                    ? _colorfromhex(
                                                                        "#F2F2FF")
                                                                    : Colors.white),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: width *
                                                                      (25 / 420),
                                                                  height: width *
                                                                      25 /
                                                                      420,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: selectedAnswer.contains(
                                                                                index)
                                                                            ? _colorfromhex(
                                                                                "#3846A9")
                                                                            : _colorfromhex(
                                                                                "#F1F1FF")),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      width *
                                                                          (25 /
                                                                              420),
                                                                    ),
                                                                    color: selectedAnswer
                                                                            .contains(
                                                                                index)
                                                                        ? _colorfromhex(
                                                                            "#3846A9")
                                                                        : Colors
                                                                            .white,
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      index == 0
                                                                          ? 'A'
                                                                          : index ==
                                                                                  1
                                                                              ? 'B'
                                                                              : index == 2
                                                                                  ? 'C'
                                                                                  : index == 3
                                                                                      ? 'D'
                                                                                      : 'E' ,
                                                                                      
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Roboto Regular',
                                                                        color: selectedAnswer.contains(
                                                                                index)
                                                                            ? Colors
                                                                                .white
                                                                            : _colorfromhex(
                                                                                "#ABAFD1"),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                8),
                                                                    width: width -
                                                                        (width *
                                                                            (25 /
                                                                                420) *
                                                                            5),
                                                                    child: Text(
                                                                        title
                                                                            .question_option,
                                                                        style: TextStyle(
                                                                            fontSize: width *
                                                                                14 /
                                                                                420)))
                                                              ],
                                                            ),
                                                          ),
                                                        ):SizedBox();
                                                      }).toList(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    ),
                                  )
                                : Container(
                                    child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        _colorfromhex("#4849DF")),
                                  ))
                          ],
                        ),
                        _quizList.isNotEmpty
                            //questionAnswersList != null
                            ? Positioned(
                                bottom: 0,
                                child: Container(
                                  width: width,
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: _quetionNo == 0
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.spaceBetween,
                                    children: [
                                      _quetionNo != 0
                                          ? GestureDetector(
                                              onTap: () => {
                                                setState(() {
                                                  currentIndex--;
                                                  print("currentIndex: ${currentIndex}");
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
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right: 2),
                                                      child: Icon(
                                                        Icons.arrow_back_ios,
                                                        size:
                                                            width * (20 / 420),
                                                        color: _colorfromhex(
                                                            "#3A47AD"),
                                                      ),
                                                    ),
                                                    Text(
                                                      "Previous",
                                                      style: TextStyle(
                                                        fontSize:
                                                            width * (18 / 420),
                                                        fontFamily:
                                                            'Roboto Medium',
                                                        color: _colorfromhex(
                                                            "#3A47AD"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      GestureDetector(
                                        onTap: () => {
                                          if (listResponse.length - 1 >
                                              _quetionNo)
                                            {

                                             setState(() {
                                                currentIndex=currentIndex+1;
                                             }),
                                              setState(() {

                                                
                                                if (_quetionNo <
                                                    listResponse.length) {
                                                  _quetionNo = _quetionNo + 1;
                                                }

                                                if (currentData != null) {
                                                  submitData.add({
                                                    "question":
                                                        currentData["question"],
                                                    "answer":
                                                        currentData["answer"],
                                                    "correct": 0,
                                                    "category":
                                                        currentData["category"],
                                                    "type":
                                                      selectedAnswer.length >
                                                                2
                                                            ? 2
                                                            : 1
                                                  });
                                                  currentData = null;
                                                }
                                                selectedAnswer = [];
                                                ids = [];
                                              }),
                                            }
                                          else
                                            {
                                              if (!loader)
                                                submitMockTest('', displayTime)
                                            }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              top: height * (20 / 800),
                                              bottom: height * (16 / 800)),
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
                                                begin: const FractionalOffset(
                                                    0.0, 0.0),
                                                end: const FractionalOffset(
                                                    1.0, 0.0),
                                                stops: [0.0, 1.0],
                                                tileMode: TileMode.clamp),
                                          ),
                                          child: loader
                                              ? Container(
                                                  child: Center(
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    child:
                                                        CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.white),
                                                    ),
                                                  ),
                                                ))
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      listResponse.length - 1 >
                                                              _quetionNo
                                                          ? "Next"
                                                          : "Finish",
                                                      style: TextStyle(
                                                        fontSize:
                                                            width * (18 / 420),
                                                        fontFamily:
                                                            'Roboto Medium',
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 2),
                                                      child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        size:
                                                            width * (20 / 420),
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
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
