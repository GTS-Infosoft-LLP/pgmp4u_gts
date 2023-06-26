import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pgmp4u/Screens/PracticeTests/practiceTextProvider.dart';
import 'package:pgmp4u/Screens/Tests/provider/category_provider.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PracticeNew extends StatefulWidget {
  final selectedId;

  PracticeNew({
    this.selectedId,
  });

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
  int isAnsCorrect; // 1---- correct   2--- not correct
  // Map mapResponse;
  @override
  var currentIndex;
  void initState() {
    currentIndex = 0;
    selAns = [];
    correctAns = [];

    super.initState();
    practiceProvider = Provider.of(context, listen: false);
    categoryProvider = Provider.of(context, listen: false);

// practiceProvider.pList[_quetionNo].ques.options[0].questionOption

    // print("data.pList[_quetionNo].ques.options[1].id${practiceProvider.pList[0].ques.options[1].id}");

    callApi();
    // if (selectedIdNew == "result") {
    //   apiCall2();
    // } else {
    //   apiCall();
    // }
  }

  Future callApi() async {
    await practiceProvider.apiCall(categoryProvider.subCategoryId, categoryProvider.type);
  }

  Future apiCall2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print(stringValue);
    http.Response response; //api/MockTestQuestions/124
    response = await http.get(Uri.parse(REVIEWS_MOCK_TEST + "/22/4"),
        headers: {'Content-Type': 'application/json', 'Authorization': stringValue});

    if (response.statusCode == 200) {
      print(convert.jsonDecode(response.body));
      setState(() {
        var _mapResponse = convert.jsonDecode(response.body);

        listResponse = _mapResponse["data"];
      });
      // print(convert.jsonDecode(response.body));
    }
  }

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

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    return Sizer(builder: (context, orientation, deviceType) {
      return Scaffold(
        body: Consumer<PracticeTextProvider>(builder: (context, data, child) {
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
                                  Text(
                                    arguments != null ? '  Review' : '  Practice Questions',
                                    style: TextStyle(
                                        fontFamily: 'Roboto Medium',
                                        fontSize: width * (18 / 420),
                                        color: Colors.white,
                                        letterSpacing: 0.3),
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
                          : data.pList != null
                              ? Expanded(
                                  // width: width,
                                  // height: height - 235,
                                  child: PageView.builder(
                                      controller: pageController,
                                      itemCount: data.pList.length,
                                      onPageChanged: (index) {
                                        selAns = [];
                                        rightAns = [];
                                        correctAns = [];
                                        print("selAns=======$selAns");
                                        print("index====>>$index");
                                        print("currentIndex ====>>$currentIndex");
                                        if (currentIndex < index) {
                                          if (data.pList.length - 1 > _quetionNo) {
                                            setState(() {
                                              if (_quetionNo < data.pList.length) {
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
                                        _isattempt = data.pList[_quetionNo].ques.rightAnswer.contains(',')
                                            ? data.pList[_quetionNo].ques.rightAnswer.split(',').length - 1
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
                                                    top: height * (23 / 800),
                                                    bottom: height * (23 / 800)),
                                                color: Colors.white,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        _quetionNo != 0
                                                            ? GestureDetector(
                                                                onTap: () => {
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
                                                        data.pList.length - 1 > _quetionNo
                                                            ? GestureDetector(
                                                                onTap: () => {
                                                                  selAns = [],
                                                                  rightAns = [],
                                                                  correctAns = [],
                                                                  setState(() {
                                                                    if (_quetionNo < data.pList.length) {
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
                                                      child: Text(
                                                        data.pList != null ? data.pList[_quetionNo].ques.question : '',
                                                        style: TextStyle(
                                                          fontFamily: 'Roboto Regular',
                                                          fontSize: width * (15 / 420),
                                                          color: Colors.black,
                                                          height: 1.7,
                                                        ),
                                                      ),
                                                    ),

                                                    ListView.builder(
                                                        shrinkWrap: true,
                                                        physics: NeverScrollableScrollPhysics(),
                                                        itemCount: data.pList[_quetionNo].ques.options.length,
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
                                                                if (_isattempt <
                                                                    data.pList[_quetionNo].ques.options
                                                                        .where((element) => element.isseleted == true)
                                                                        .toList()
                                                                        .length) {
                                                                  return;
                                                                }
                                                                setState(() {
                                                                  data.pList[_quetionNo].ques.options[index].isseleted =
                                                                      !data.pList[_quetionNo].ques.options[index]
                                                                          .isseleted;
                                                                  // selectedAnswer =
                                                                  //     data.pList[_quetionNo].ques.options[index].id;

                                                                  // // print("selectedAnswer=====================>>>>>>$selectedAnswer");
                                                                  // rightAns = data.pList[_quetionNo].ques.rightAnswer
                                                                  //     .split(',');

                                                                  // for (int j = 0; j < rightAns.length; j++) {
                                                                  //   correctAns.add(int.parse(rightAns[j]));
                                                                  // }
                                                                  // print(
                                                                  //     "correctAns==================****************$correctAns");

                                                                  // // print("==rightAns=======$rightAns");

                                                                  // if (!selAns.contains(
                                                                  //     data.pList[_quetionNo].ques.options[index].id)) {
                                                                  //   selAns.add(
                                                                  //       data.pList[_quetionNo].ques.options[index].id);
                                                                  //   print("selAns=======$selAns");
                                                                  // }
                                                                  // if (selAns.length == rightAns.length) {
                                                                  //   print("of same length==========");
                                                                  //   checkAllAns(selAns, rightAns);
                                                                  // }
                                                                  // if (isListSame) {
                                                                  //   print("=========list are same========");
                                                                  // }

                                                                  // realAnswer = int.parse(
                                                                  //     data.pList[_quetionNo].ques.rightAnswer);

                                                                  // //   data
                                                                  // // .pList[
                                                                  // //     _quetionNo]
                                                                  // // .ques.question;
                                                                  // print(
                                                                  //     "data.pList[ _quetionNo].ques.rightAnswer==========>>>>>>$realAnswer");
                                                                });
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    // shape: BoxShape.circle,
                                                                    color: _isattempt <
                                                                            data.pList[_quetionNo].ques.options
                                                                                .where((element) =>
                                                                                    element.isseleted == true)
                                                                                .toList()
                                                                                .length
                                                                        ? data.pList[_quetionNo].ques.options.any(
                                                                                (element) => element.isseleted == true)
                                                                            ? data.pList[_quetionNo].ques.rightAnswer
                                                                                    .contains(
                                                                                        "${data.pList[_quetionNo].ques.options[index].id}")
                                                                                ? _colorfromhex("#E6F7E7")
                                                                                : data.pList[_quetionNo].ques
                                                                                        .options[index].isseleted
                                                                                    ? data.pList[_quetionNo].ques
                                                                                            .rightAnswer
                                                                                            .contains(
                                                                                                "${data.pList[_quetionNo].ques.options[index].id}")
                                                                                        ? _colorfromhex("#E6F7E7")
                                                                                        : _colorfromhex("#FFF6F6")
                                                                                    : Colors.white
                                                                            : data.pList[_quetionNo].ques.options[index]
                                                                                    .isseleted
                                                                                ? data.pList[_quetionNo].ques
                                                                                        .rightAnswer
                                                                                        .contains(
                                                                                            "${data.pList[_quetionNo].ques.options[index].id}")
                                                                                    ? _colorfromhex("#E6F7E7")
                                                                                    : _colorfromhex("#FFF6F6")
                                                                                : Colors.white
                                                                        : data.pList[_quetionNo].ques.options[index]
                                                                                .isseleted
                                                                            ? data.pList[_quetionNo].ques.rightAnswer
                                                                                    .contains(
                                                                                        "${data.pList[_quetionNo].ques.options[index].id}")
                                                                                ? _colorfromhex("#E6F7E7")
                                                                                : _colorfromhex("#FFF6F6")
                                                                            : Colors.white

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
                                                                    padding: const EdgeInsets.only(bottom: 5.0, top: 5),
                                                                    child: Container(
                                                                      width: width * (25 / 420),
                                                                      height: width * 25 / 420,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(width * (25 / 420)),
                                                                          color: _isattempt <
                                                                                  data.pList[_quetionNo].ques.options
                                                                                      .where((element) =>
                                                                                          element.isseleted == true)
                                                                                      .toList()
                                                                                      .length
                                                                              ? data.pList[_quetionNo].ques.options.any(
                                                                                      (element) =>
                                                                                          element.isseleted == true)
                                                                                  ? data.pList[_quetionNo].ques.rightAnswer.contains(
                                                                                          "${data.pList[_quetionNo].ques.options[index].id}")
                                                                                      ? _colorfromhex("#04AE0B")
                                                                                      : data.pList[_quetionNo].ques
                                                                                              .options[index].isseleted
                                                                                          ? data.pList[_quetionNo].ques.rightAnswer.contains(
                                                                                                  "${data.pList[_quetionNo].ques.options[index].id}")
                                                                                              ? _colorfromhex("#E6F7E7")
                                                                                              : _colorfromhex("#FF0000")
                                                                                          : Colors.white
                                                                                  : data.pList[_quetionNo].ques
                                                                                          .options[index].isseleted
                                                                                      ? data.pList[_quetionNo].ques.rightAnswer.contains(
                                                                                              "${data.pList[_quetionNo].ques.options[index].id}")
                                                                                          ? _colorfromhex("#E6F7E7")
                                                                                          : _colorfromhex("#FFF6F6")
                                                                                      : Colors.white
                                                                              : data.pList[_quetionNo].ques
                                                                                      .options[index].isseleted
                                                                                  ? data.pList[_quetionNo].ques.rightAnswer
                                                                                          .contains("${data.pList[_quetionNo].ques.options[index].id}")
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
                                                                          border: Border.all(color: Colors.black)),
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
                                                                              color: data.pList[_quetionNo].ques.options
                                                                                      .any((element) =>
                                                                                          element.isseleted == true)
                                                                                  ? data.pList[_quetionNo].ques
                                                                                          .rightAnswer
                                                                                          .contains(
                                                                                              "${data.pList[_quetionNo].ques.options[index].id}")
                                                                                      ? Colors.black
                                                                                      : Colors.black
                                                                                  : data.pList[_quetionNo].ques
                                                                                          .options[index].isseleted
                                                                                      ? data.pList[_quetionNo].ques
                                                                                              .rightAnswer
                                                                                              .contains(
                                                                                                  "${data.pList[_quetionNo].ques.options[index].id}")
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
                                                                          padding: const EdgeInsets.only(bottom: 6.0),
                                                                          child: Column(
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              Text(
                                                                                data.pList[_quetionNo].ques
                                                                                    .options[index].questionOption,
                                                                                style: TextStyle(fontSize: 16),
                                                                              ),
                                                                              selectedAnswer != null &&
                                                                                      int.parse(data.pList[_quetionNo]
                                                                                              .ques.rightAnswer) !=
                                                                                          selectedAnswer &&
                                                                                      data.pList[_quetionNo].ques
                                                                                              .options[index].id ==
                                                                                          int.parse(data
                                                                                              .pList[_quetionNo]
                                                                                              .ques
                                                                                              .rightAnswer)
                                                                                  ? Row(
                                                                                      mainAxisAlignment:
                                                                                          MainAxisAlignment.end,
                                                                                      children: [
                                                                                        Text("Correct Answer")
                                                                                      ],
                                                                                    )
                                                                                  : data.pList[_quetionNo].ques
                                                                                                  .options[index].id ==
                                                                                              selectedAnswer &&
                                                                                          int.parse(data
                                                                                                  .pList[_quetionNo]
                                                                                                  .ques
                                                                                                  .rightAnswer) !=
                                                                                              selectedAnswer
                                                                                      ? Row(
                                                                                          mainAxisAlignment:
                                                                                              MainAxisAlignment.end,
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
                                                                    ],
                                                                  )
                                                                ]),
                                                              ),
                                                            ),
                                                          );
                                                        }),

                                                    // Container(
                                                    //   height: 50,
                                                    //   color: Colors.amber,
                                                    // ),

                                                    // selectedAnswer != null
                                                    if (_isattempt <
                                                        data.pList[_quetionNo].ques.options
                                                            .where((element) => element.isseleted == true)
                                                            .toList()
                                                            .length)
                                                      Container(
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
                                                                        fontSize: width * (15 / 420),
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
                                                                      data.pList[_quetionNo].ques.rightAnswer ==
                                                                              data.pList[_quetionNo].ques.options[0].id
                                                                                  .toString()
                                                                          ? 'Answer A is the correct one'
                                                                          : data.pList[_quetionNo].ques.rightAnswer ==
                                                                                  data.pList[_quetionNo].ques.options[1]
                                                                                      .id
                                                                                      .toString()
                                                                              ? 'Answer B is the correct one'
                                                                              : data.pList[_quetionNo].ques
                                                                                          .rightAnswer ==
                                                                                      data.pList[_quetionNo].ques
                                                                                          .options[2].id
                                                                                          .toString()
                                                                                  ? 'Answer c is the correct one'
                                                                                  : data.pList[_quetionNo].ques
                                                                                              .rightAnswer ==
                                                                                          data.pList[_quetionNo].ques
                                                                                              .options[3].id
                                                                                              .toString()
                                                                                      ? 'Answer D is the correct one'
                                                                                      : 'Answer E is the correct one',
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
                                                                    margin: EdgeInsets.only(top: height * (9 / 800)),
                                                                    child: Text(
                                                                      data.pList[_quetionNo].ques.explanation,
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
                              : Text("No Data Found.....")
                    ],
                  ),
                ),
                Text(""),
                realAnswer == selectedAnswer && selectedAnswer != null
                    ? Positioned(
                        top: SizerUtil.deviceType == DeviceType.mobile ? 80 : 140,
                        left: width / 2.9,
                        child: Container(
                          width: 110,
                          height: 110,
                          child: Image.asset('assets/smile.png'),
                        ))
                    : Text(''),
                realAnswer != selectedAnswer && selectedAnswer != null
                    ? Positioned(
                        top: SizerUtil.deviceType == DeviceType.mobile ? 100 : 165,
                        left: width / 2.5,
                        child: selectedAnswer == null
                            ? Text('')
                            : realAnswer == selectedAnswer
                                ? Container(
                                    width: 100,
                                    height: 100,
                                    child: Image.asset('assets/smile.png'),
                                  )
                                : Image.asset('assets/smiley-sad1.png'),
                      )
                    : Text(''),
              ],
            ),
          );
        }),
      );
    });
  }

  void checkAllAns(List<int> selAns, List<String> rightAns) {
    isListSame = true;
    print("inside checkAllAns===============================");
    selAns.sort();
    print("selAns======$selAns");
    print("rightAns======$rightAns");

    for (int i = 0; i < selAns.length; i++) {
      if (selAns[i] == int.parse(rightAns[i])) {
      } else {
        isListSame = false;
        break;
      }
    }
    if (isListSame) {
      isAnsCorrect = 1;
      print("same are both the lkstssss");
    } else {
      isAnsCorrect = 2;
      print("  list are not same are both the lkstssss");
    }
  }
}
