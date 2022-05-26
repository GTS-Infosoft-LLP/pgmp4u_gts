import 'dart:io';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pgmp4u/Screens/PracticeTests/practiceTextProvider.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PracticeTestCopy extends StatefulWidget {
  final selectedId;

  PracticeTestCopy({
    this.selectedId,
  });

  @override
  _PracticeTestCopyState createState() =>
      _PracticeTestCopyState(selectedIdNew: this.selectedId);
}

class _PracticeTestCopyState extends State<PracticeTestCopy> {
  final selectedIdNew;
  PracticeTextProvider practiceProvider;
  _PracticeTestCopyState({
    this.selectedIdNew,
  });
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  bool _show = true;
  int _quetionNo = 0;
  int selectedAnswer;
  int realAnswer;
  String stringResponse;
  List listResponse;
  // Map mapResponse;
  @override
  void initState() {
    super.initState();
    practiceProvider = Provider.of(context, listen: false);

    callApi();
    // if (selectedIdNew == "result") {
    //   apiCall2();
    // } else {
    //   apiCall();
    // }
  }

  Future callApi() async {
    await practiceProvider.apiCall();
  }

  Future apiCall2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print(stringValue);
    http.Response response;
    response = await http.get(Uri.parse(REVIEWS_MOCK_TEST + "/22/4"), headers: {
      'Content-Type': 'application/json',
      'Authorization': stringValue
    });

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
                        height: SizerUtil.deviceType == DeviceType.mobile
                            ? 195
                            : 250,
                        width: width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/bg_layer2.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(
                              left: width * (20 / 420),
                              right: width * (20 / 420),
                              top: height * (16 / 800)),
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
                                    arguments != null
                                        ? '  Review'
                                        : '  Practice Questions',
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      _colorfromhex("#4849DF"))))
                          : data.questionsList.isNotEmpty
                              ? Expanded(
                                  // width: width,
                                  // height: height - 235,
                                  child: SingleChildScrollView(
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  _quetionNo != 0
                                                      ? GestureDetector(
                                                          onTap: () => {
                                                            setState(() {
                                                              _quetionNo--;

                                                              selectedAnswer =
                                                                  null;
                                                              realAnswer = null;
                                                            })
                                                          },
                                                          child: Icon(
                                                            Icons.west,
                                                            size: width *
                                                                (30 / 420),
                                                            color: Colors.black,
                                                          ),
                                                        )
                                                      : Container(),
                                                  Text(
                                                    'QUESTION ${_quetionNo + 1}',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Roboto Regular',
                                                      fontSize:
                                                          width * (16 / 420),
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  data.questionsList.length -
                                                              1 >
                                                          _quetionNo
                                                      ? GestureDetector(
                                                          onTap: () => {
                                                            setState(() {
                                                              if (_quetionNo <
                                                                  data.questionsList
                                                                      .length) {
                                                                _quetionNo =
                                                                    _quetionNo +
                                                                        1;
                                                              }
                                                              selectedAnswer =
                                                                  null;
                                                              realAnswer = null;
                                                            }),
                                                            print(_quetionNo)
                                                          },
                                                          child: Icon(
                                                            Icons.east,
                                                            size: width *
                                                                (30 / 420),
                                                            color: Colors.black,
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: height * (15 / 800)),
                                                child: Text(
                                                  data.questionsList != null
                                                      ? data
                                                          .questionsList[
                                                              _quetionNo]
                                                          .questions
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
                                              Column(
                                                children: data
                                                    .questionsList[_quetionNo]
                                                    .optionsList
                                                    .map<Widget>((title) {
                                                  var index = data
                                                      .questionsList[_quetionNo]
                                                      .optionsList
                                                      .indexOf(title);
                                                  return GestureDetector(
                                                    onTap: () => {
                                                      setState(() {
                                                        selectedAnswer =
                                                            title.id;
                                                        realAnswer = data
                                                            .questionsList[
                                                                _quetionNo]
                                                            .rightAnswer;
                                                      })
                                                    },
                                                    child: Container(
                                                      color: title.id ==
                                                                  selectedAnswer &&
                                                              data
                                                                      .questionsList[
                                                                          _quetionNo]
                                                                      .rightAnswer ==
                                                                  selectedAnswer
                                                          ? _colorfromhex(
                                                              "#E6F7E7")
                                                          : title.id ==
                                                                      selectedAnswer &&
                                                                  data
                                                                          .questionsList[
                                                                              _quetionNo]
                                                                          .rightAnswer !=
                                                                      selectedAnswer
                                                              ? _colorfromhex(
                                                                  "#FFF6F6")
                                                              : selectedAnswer !=
                                                                          null &&
                                                                      data.questionsList[_quetionNo].rightAnswer !=
                                                                          selectedAnswer &&
                                                                      title.id ==
                                                                          data
                                                                              .questionsList[
                                                                                  _quetionNo]
                                                                              .rightAnswer
                                                                  ? _colorfromhex(
                                                                      "#E6F7E7")
                                                                  : Colors
                                                                      .white,
                                                      margin: EdgeInsets.only(
                                                          top: height *
                                                              (21 / 800)),
                                                      padding: EdgeInsets.only(
                                                          top: 13,
                                                          bottom: 13,
                                                          left: width *
                                                              (13 / 420),
                                                          right: width *
                                                              (11 / 420)),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: width *
                                                                (25 / 420),
                                                            height: width *
                                                                25 /
                                                                420,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(
                                                                  width *
                                                                      (25 /
                                                                          420),
                                                                ),
                                                                color: title.id == selectedAnswer && data.questionsList[_quetionNo].rightAnswer == selectedAnswer
                                                                    ? _colorfromhex("#04AE0B")
                                                                    : title.id == selectedAnswer && data.questionsList[_quetionNo].rightAnswer != selectedAnswer
                                                                        ? _colorfromhex("#FF0000")
                                                                        : selectedAnswer != null && data.questionsList[_quetionNo].rightAnswer != selectedAnswer && title.id == data.questionsList[_quetionNo].rightAnswer
                                                                            ? _colorfromhex("#04AE0B")
                                                                            : Colors.white),
                                                            child: Center(
                                                              child: Text(
                                                                index == 0
                                                                    ? 'A'
                                                                    : index == 1
                                                                        ? 'B'
                                                                        : index ==
                                                                                2
                                                                            ? 'C'
                                                                            : index == 3
                                                                                ? 'D'
                                                                                : '',
                                                                style: TextStyle(
                                                                    fontFamily: 'Roboto Regular',
                                                                    fontSize: width * 14 / 420,
                                                                    color: title.id == selectedAnswer && data.questionsList[_quetionNo].rightAnswer == selectedAnswer
                                                                        ? Colors.white
                                                                        : title.id == selectedAnswer && data.questionsList[_quetionNo].rightAnswer != selectedAnswer
                                                                            ? Colors.white
                                                                            : selectedAnswer != null && data.questionsList[_quetionNo].rightAnswer != selectedAnswer && title.id == data.questionsList[_quetionNo].rightAnswer
                                                                                ? Colors.white
                                                                                : Colors.grey),
                                                              ),
                                                            ),
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
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
                                                                        .questionsOptions,
                                                                    style: TextStyle(
                                                                        fontSize: width *
                                                                            14 /
                                                                            420)),
                                                              ),
                                                              selectedAnswer !=
                                                                          null &&
                                                                      data.questionsList[_quetionNo].rightAnswer !=
                                                                          selectedAnswer &&
                                                                      title.id ==
                                                                          data
                                                                              .questionsList[
                                                                                  _quetionNo]
                                                                              .rightAnswer
                                                                  ? Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                          'Correct Answer',
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : title.id ==
                                                                              selectedAnswer &&
                                                                          data.questionsList[_quetionNo].rightAnswer !=
                                                                              selectedAnswer
                                                                      ? Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            Text(
                                                                              'Your selection',
                                                                            ),
                                                                          ],
                                                                        )
                                                                      : Container(),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                              selectedAnswer != null
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                          color: _colorfromhex(
                                                              "#FAFAFA"),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6)),
                                                      margin: EdgeInsets.only(
                                                          top: height *
                                                              (38 / 800)),
                                                      padding: EdgeInsets.only(
                                                          top: height *
                                                              (10 / 800),
                                                          bottom: _show
                                                              ? height *
                                                                  (23 / 800)
                                                              : height *
                                                                  (12 / 800),
                                                          left: width *
                                                              (18 / 420),
                                                          right: width *
                                                              (10 / 420)),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                _show = !_show;
                                                              });
                                                            },
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  'See Solution',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Roboto Regular',
                                                                    fontSize: width *
                                                                        (15 /
                                                                            420),
                                                                    color: _colorfromhex(
                                                                        "#ABAFD1"),
                                                                    height: 1.7,
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  _show
                                                                      ? Icons
                                                                          .expand_less
                                                                      : Icons
                                                                          .expand_more,
                                                                  size: width *
                                                                      (30 /
                                                                          420),
                                                                  color: _colorfromhex(
                                                                      "#ABAFD1"),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          _show
                                                              ? Container(
                                                                  margin: EdgeInsets.only(
                                                                      top: height *
                                                                          (9 /
                                                                              800)),
                                                                  child: Text(
                                                                    data.questionsList[_quetionNo] ==
                                                                            data.questionsList[_quetionNo].optionsList[0].id
                                                                        ? 'Answer A is the correct one'
                                                                        : data.questionsList[_quetionNo].rightAnswer == data.questionsList[_quetionNo].optionsList[1].id
                                                                            ? 'Answer B is the correct one'
                                                                            : data.questionsList[_quetionNo].rightAnswer == data.questionsList[_quetionNo].optionsList[2].id
                                                                                ? 'Answer C is the correct one'
                                                                                : 'Answer D is the correct one',
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Roboto Regular',
                                                                      fontSize:
                                                                          width *
                                                                              (15 / 420),
                                                                      color: _colorfromhex(
                                                                          "#04AE0B"),
                                                                      height:
                                                                          1.7,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container(),
                                                          _show
                                                              ? Container(
                                                                  margin: EdgeInsets.only(
                                                                      top: height *
                                                                          (9 /
                                                                              800)),
                                                                  child: Text(
                                                                    data
                                                                        .questionsList[
                                                                            _quetionNo]
                                                                        .explantions,
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Roboto Regular',
                                                                      fontSize:
                                                                          width *
                                                                              (15 / 420),
                                                                      color: Colors
                                                                          .black,
                                                                      height:
                                                                          1.6,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container()
                                                        ],
                                                      ),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(child: Text("No Data Found"))
                    ],
                  ),
                ),
                realAnswer == selectedAnswer && selectedAnswer != null
                    ? Positioned(
                        top: SizerUtil.deviceType == DeviceType.mobile
                            ? 80
                            : 140,
                        left: width / 2.9,
                        child: Container(
                          width: 110,
                          height: 110,
                          child: Image.asset('assets/smile.png'),
                        ))
                    : Text(''),
                realAnswer != selectedAnswer && selectedAnswer != null
                    ? Positioned(
                        top: SizerUtil.deviceType == DeviceType.mobile
                            ? 100
                            : 165,
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
}
