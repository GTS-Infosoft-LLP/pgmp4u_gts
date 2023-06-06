import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pgmp4u/api/apis.dart';
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

import 'model/review_moke_test.dart';

class ReviewMockTest extends StatefulWidget {
  final selectedId;
  final attemptData;
  ReviewMockTest({
    this.selectedId,
    this.attemptData,
  });

  @override
  _ReviewMockTestState createState() => _ReviewMockTestState(
      selectedIdNew: this.selectedId, attemptDataNew: this.attemptData);
}

class _ReviewMockTestState extends State<ReviewMockTest> {
  final selectedIdNew;
  final attemptDataNew;
  _ReviewMockTestState({this.selectedIdNew, this.attemptDataNew});
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  bool _show = true;
  int _quetionNo = 0;
  List<int> selectedAnswer;
  List realAnswer;
  String stringResponse;
  List<Data> listResponse;
  ReviewMokeText mapResponse;
  @override
  void initState() {
    super.initState();
    apiCall2();
  }

  Future apiCall2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print(stringValue);
    http.Response response;
    response = await http.get(
        Uri.parse(REVIEWS_MOCK_TEST +
            "/" +
            selectedIdNew.toString() +
            '/' +
            attemptDataNew.toString()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjoxMjI0LCJuYW1lIjoic2hlcnUga2FiamEiLCJtb2JpbGUiOm51bGwsImVtYWlsIjoic2hlcnVrYWJqYTEyMzRAZ21haWwuY29tIiwicGFzc3dvcmQiOm51bGwsImNyZWF0ZWQiOiIyMDIzLTA2LTA2IiwiZXhhbV9kYXRlIjpudWxsLCJwcm9maWxlX2ltYWdlIjpudWxsLCJsaW5rZWRpbiI6bnVsbCwiZ29vZ2xlIjoiMTA5NjI4MDgxOTg2OTk2NzU5NDQ0IiwicTEiOiIiLCJxMiI6IiIsInEzIjoiIiwicTQiOiIiLCJxNSI6IiIsInE2IjoiIiwiZW1haWxfc2VudCI6MCwic3RhdHVzIjoxLCJkZWxldGVTdGF0dXMiOjF9LCJpYXQiOjE2ODYwMzA4NDAsImV4cCI6MTY4Njg5NDg0MH0.OXQMII0HGdne95qA2nEUfTPXRHaykJhcozcOzmrhcwY"
        });

    print(
        ">>>>>> url ${Uri.parse(REVIEWS_MOCK_TEST + "/" + selectedIdNew.toString() + '/' + attemptDataNew.toString())}");

    print("header : ${{
      'Content-Type': 'application/json',
      'Authorization': stringValue
    }}");
    if (response.statusCode == 200) {
      print(convert.jsonDecode(response.body));
      setState(() {
        mapResponse =
            ReviewMokeText.fromJson(convert.jsonDecode(response.body));
        listResponse = mapResponse.data;
        selectedAnswer = listResponse[0].youranswer;
      });
      // print(convert.jsonDecode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    List<int> _currentAnserIndex = [];
    int _currentYourAnserIndex = 0;
    final arguments = ModalRoute.of(context).settings.arguments as Map;
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: _colorfromhex("#FCFCFF"),
          child: Stack(
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      height: 195,
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
                                  '  Review',
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
                    listResponse != null && listResponse.length > 0
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _quetionNo != 0
                                                ? GestureDetector(
                                                    onTap: () => {
                                                      setState(() {
                                                        _quetionNo--;

                                                        selectedAnswer =
                                                            listResponse[
                                                                    _quetionNo]
                                                                .youranswer;

                                                        realAnswer = mapResponse
                                                            .data[_quetionNo]
                                                            .question
                                                            .rightAnswer;

                                                        //  mapResponse[
                                                        //                 "data"]
                                                        //             [_quetionNo]
                                                        //         ["Question"]
                                                        //     ["right_answer"];
                                                      })
                                                    },
                                                    child: Icon(
                                                      Icons.arrow_back,
                                                      size: width * (24 / 420),
                                                      color: _colorfromhex(
                                                          "#ABAFD1"),
                                                    ),
                                                  )
                                                : Container(),
                                            Text(
                                              'QUESTION ${_quetionNo + 1}',
                                              style: TextStyle(
                                                fontFamily: 'Roboto Regular',
                                                fontSize: width * (16 / 420),
                                                color: _colorfromhex("#ABAFD1"),
                                              ),
                                            ),
                                            listResponse.length - 1 > _quetionNo
                                                ? GestureDetector(
                                                    onTap: () => {
                                                      setState(() {
                                                        if (_quetionNo <
                                                            listResponse
                                                                .length) {
                                                          _quetionNo =
                                                              _quetionNo + 1;
                                                        }
                                                        selectedAnswer =
                                                            listResponse[
                                                                    _quetionNo]
                                                                .youranswer;

                                                        realAnswer = mapResponse
                                                            .data[_quetionNo]
                                                            .question
                                                            .rightAnswer;
                                                      }),
                                                      print(_quetionNo)
                                                    },
                                                    child: Icon(
                                                      Icons.arrow_forward,
                                                      size: width * (24 / 420),
                                                      color: _colorfromhex(
                                                          "#ABAFD1"),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: height * (15 / 800)),
                                          child: Text(
                                            listResponse != null
                                                ? listResponse[_quetionNo]
                                                    .question
                                                    .question
                                                : '',
                                            style: TextStyle(
                                              fontFamily: 'Roboto Regular',
                                              fontSize: width * (15 / 420),
                                              color: Colors.black,
                                              height: 1.7,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: listResponse[_quetionNo]
                                              .question
                                              .options
                                              .map<Widget>((title) {
                                                  print("question option ${title}");
                                            var index = listResponse[_quetionNo]
                                                .question
                                                .options
                                                .indexOf(title);
                                            // print("index >>>>>> $index");

                                            print(
                                                "is right answer ${listResponse[_quetionNo].question.options[index].customRight}");

                                            /// Right answer index find
                                            List<int> _rightAnwerId =
                                                listResponse[_quetionNo]
                                                    .question
                                                    .rightAnswer;
                                            //     ['Question']
                                            // ['right_answer'];

                                            var _optionList =
                                                listResponse[_quetionNo]
                                                    .question
                                                    .options;

                                            var getObject = [];

                                            for (var item in _optionList) {
                                              if (_rightAnwerId
                                                  .contains(item.id)) {
                                                getObject.add(item);
                                              }
                                            }

                                            List<int> _index = [];
                                            for (int i = 0;
                                                i < getObject.length;
                                                i++) {
                                              _index.add(_optionList
                                                  .indexOf(getObject[i]));
                                            }

                                            _currentAnserIndex = _index;
                                            // print("get index ${_index}");

                                            /// Your wrong answer index find
                                            List _yourAnserId =
                                                listResponse[_quetionNo]
                                                    .youranswer;

                                            // print("your id ${_yourAnserId}");
                                            List _yourAnswerObject = [];
                                            for (var item in _optionList) {
                                              if (_yourAnserId
                                                  .contains(item.id)) {
                                                _yourAnswerObject.add(item);
                                              }
                                            }
                                            //  _optionList
                                            //     .firstWhere((element) =>
                                            //         element['id'].toString() ==
                                            //         _yourAnserId.toString());

                                            List<int> _currentYourAnserIndex =
                                                [];

                                            for (int i = 0;
                                                i < _yourAnswerObject.length;
                                                i++) {
                                              _currentYourAnserIndex.add(
                                                  _optionList.indexOf(
                                                      _yourAnswerObject[i]));
                                            }
                                            // _optionList
                                            //     .indexOf(_yourAnswerObject);

                                            // print(
                                            //     "your answer inde ${_currentYourAnserIndex}");
                                            print(
                                                "selectedAnswer answer $selectedAnswer");
                                            print(
                                                "selectedAnswer title.id is >>> ${title.question}");
                                            print(
                                                "selectedAnswer answer right ${listResponse[_quetionNo].question.rightAnswer}");

                                            return GestureDetector(
                                              onTap: () => {
                                                setState(() {
                                                  selectedAnswer.add(title.id);
                                                  realAnswer =
                                                      listResponse[_quetionNo]
                                                          .question
                                                          .rightAnswer;
                                                  //     ["Question"]
                                                  // ["right_answer"];
                                                })
                                              },
                                              child: Container(
                                                color: selectedAnswer.contains(
                                                            title.id) &&
                                                        listResponse[_quetionNo]
                                                            .question
                                                            .rightAnswer
                                                            .contains(
                                                                selectedAnswer)
                                                    ? _colorfromhex("#E6F7E8")
                                                    : selectedAnswer.contains(
                                                                title.id) &&
                                                            !listResponse[_quetionNo]
                                                                .question
                                                                .rightAnswer
                                                                .contains(
                                                                    selectedAnswer)
                                                        //     ["Question"][
                                                        // "right_answer"] !=

                                                        ? _colorfromhex(
                                                            "#FFF6F6")
                                                        : selectedAnswer != null &&
                                                                !listResponse[
                                                                        _quetionNo]
                                                                    .question
                                                                    .rightAnswer
                                                                    .contains(
                                                                        selectedAnswer) &&
                                                                listResponse[_quetionNo]
                                                                    .question
                                                                    .rightAnswer
                                                                    .contains(
                                                                        title.id)
                                                            //     ["Question"]
                                                            // ["right_answer"]
                                                            ? _colorfromhex("#E6F7E7")
                                                            : Colors.white,
                                                margin: EdgeInsets.only(
                                                    top: height * (21 / 800)),
                                                padding: EdgeInsets.only(
                                                    top: 13,
                                                    bottom: 13,
                                                    left: width * (13 / 420),
                                                    right: width * (11 / 420)),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: width * (25 / 420),
                                                      height: width * 25 / 420,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            width * (25 / 420),
                                                          ),
                                                          color: selectedAnswer
                                                                      .contains(title
                                                                          .id) &&
                                                                  listResponse[_quetionNo]
                                                                      .question
                                                                      .rightAnswer
                                                                      .contains(
                                                                          selectedAnswer)
                                                              ? _colorfromhex(
                                                                  "#04AE0B")
                                                              : selectedAnswer.contains(title
                                                                          .id) &&
                                                                      !listResponse[_quetionNo]
                                                                          .question
                                                                          .rightAnswer
                                                                          .contains(
                                                                              selectedAnswer)
                                                                  // ["Question"]["right_answer"] !=

                                                                  ? _colorfromhex(
                                                                      "#FF0000")
                                                                  : selectedAnswer !=
                                                                              null &&
                                                                          !listResponse[_quetionNo]
                                                                              .question
                                                                              .rightAnswer
                                                                              .contains(selectedAnswer) &&
                                                                          listResponse[_quetionNo].question.rightAnswer.contains(title.id)
                                                                      ? _colorfromhex("#04AE0B")
                                                                      : Colors.white),
                                                      child: Center(
                                                        child: Text(
                                                          index == 0
                                                              ? 'A'
                                                              : index == 1
                                                                  ? 'B'
                                                                  : index == 2
                                                                      ? 'C'
                                                                      : index ==
                                                                              3
                                                                          ? 'D'
                                                                          : '',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto Regular',
                                                              color: selectedAnswer
                                                                          .contains(title
                                                                              .id) &&
                                                                      listResponse[
                                                                              _quetionNo]
                                                                          .question
                                                                          .rightAnswer
                                                                          .contains(
                                                                              selectedAnswer)
                                                                  ? Colors.white
                                                                  : selectedAnswer.contains(title
                                                                              .id) &&
                                                                          !listResponse[_quetionNo].question.rightAnswer.contains(
                                                                              selectedAnswer)
                                                                      ? Colors
                                                                          .white
                                                                      : selectedAnswer != null &&
                                                                              !listResponse[_quetionNo].question.rightAnswer.contains(selectedAnswer) &&
                                                                              listResponse[_quetionNo].question.rightAnswer.contains(title.id)
                                                                          ? Colors.white
                                                                          : Colors.grey),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                            left: 8),
                                                        width: width -
                                                            (width *
                                                                (25 / 420) *
                                                                5),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                title
                                                                    .questionOption,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        width *
                                                                            14 /
                                                                            420)),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomRight,
                                                                  child: getTextSelecd(
                                                                      _currentAnserIndex,
                                                                      _currentYourAnserIndex,
                                                                      index)),
                                                            )
                                                          ],
                                                        ))
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
                                                        BorderRadius.circular(
                                                            6)),
                                                margin: EdgeInsets.only(
                                                    top: height * (38 / 800)),
                                                padding: EdgeInsets.only(
                                                    top: height * (10 / 800),
                                                    bottom: _show
                                                        ? height * (23 / 800)
                                                        : height * (12 / 800),
                                                    left: width * (18 / 420),
                                                    right: width * (10 / 420)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto Regular',
                                                              fontSize: width *
                                                                  (15 / 420),
                                                              color:
                                                                  _colorfromhex(
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
                                                                (30 / 420),
                                                            color:
                                                                _colorfromhex(
                                                                    "#ABAFD1"),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    _show
                                                        ? Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: height *
                                                                        (9 /
                                                                            800)),
                                                            child: Text(
                                                              'Answer ${getRightAnser(_currentAnserIndex)} is the correct one',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto Regular',
                                                                fontSize: width *
                                                                    (15 / 420),
                                                                color: _colorfromhex(
                                                                    "#04AE0B"),
                                                                height: 1.7,
                                                              ),
                                                            ),
                                                          )
                                                        : Container(),
                                                    _show
                                                        ? Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: height *
                                                                        (9 /
                                                                            800)),
                                                            child: Text(
                                                              listResponse[
                                                                      _quetionNo]
                                                                  .question
                                                                  .explanation,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Roboto Regular',
                                                                fontSize: width *
                                                                    (15 / 420),
                                                                color: Colors
                                                                    .black,
                                                                height: 1.6,
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
                        : Container(
                            child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                _colorfromhex("#4849DF")),
                          ))
                  ],
                ),
              ),
              Positioned(
                top: 100,
                left: width / 2.5,
                child: selectedAnswer == null
                    ? Text('')
                    : realAnswer == selectedAnswer
                        ? Text('data')
                        : Image.asset('assets/smiley-sad1.png'),
              )
            ],
          ),
        ),
      ),
    );
  }

  // bool isSelected(var title) {
  //   return selectedAnswer != null &&
  //       listResponse[_quetionNo]["Question"]["right_answer"] !=
  //           selectedAnswer &&
  //       title["id"] == listResponse[_quetionNo]["Question"]["right_answer"];
  // }

  // bool isCurrentOption(var title, _quetionNo) {
  //   return title["id"] == selectedAnswer &&
  //       listResponse[_quetionNo]["Question"]["right_answer"] == selectedAnswer;
  // }

  String getRightAnser(List value) {
    String correct = "";
    int customIndex;
    for (int i = 0; i < value.length; i++) {
      customIndex;
      switch (value[i]) {
        case 1:
          correct = "A";
          break;
        case 2:
          correct = "B";
          break;
        case 3:
          correct = "C";
          break;
        case 4:
          correct = "D";
          break;
      }
    }
    return correct;
  }

  Widget getTextSelecd(List rightIndex, List wrongIndex, currentIndex) {
    print("rightIndex is >>> $rightIndex");
    print("current index >> $wrongIndex");
    Widget returnWidget = SizedBox();
    if (rightIndex.contains(currentIndex)) {
      returnWidget = Text("Right Answer");
    } else if (wrongIndex.contains(currentIndex)) {
      returnWidget = Text("Your selection");
    } else {
      returnWidget = SizedBox();
    }
    return returnWidget;
  }
}
