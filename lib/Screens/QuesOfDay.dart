import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pgmp4u/Screens/MockTest/model/quesOfDayModel.dart';
import 'package:pgmp4u/Screens/PracticeTests/practiceTextProvider.dart';
import 'package:pgmp4u/Screens/chat/controller/chatProvider.dart';
import 'package:pgmp4u/Screens/chat/screen/discussionGoupList.dart';
import 'package:pgmp4u/Screens/home_view/VideoLibrary/RandomPage.dart';
import 'package:pgmp4u/utils/extensions.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../provider/courseProvider.dart';
import '../provider/profileProvider.dart';

class QuesOfDay extends StatefulWidget {
  var seltedId;
  QuesOfDay({Key key, this.seltedId}) : super(key: key);

  @override
  State<QuesOfDay> createState() => _QuesOfDayState();
}

class _QuesOfDayState extends State<QuesOfDay> {
  @override
  var subQues;
  var plusQues;
  bool _show = true;
  int _isattempt = 0;
  int _quetionNo = 0;
  int selectedAnswer;
  List<int> ansRef = [];

  List<int> selAns = [];
  List<String> rightAns = [];
  List<int> correctAns = [];
  int isAnsCorrect = 0;
  int enableTap = 0;
  int realAnswer;
  var currentIndex;

  String finDate = "";
  void initState() {
    print("date time now========>${DateTime.now()}");
    String dt = DateTime.now().toString();

    PracticeTextProvider pr = Provider.of(context, listen: false);

    selAns = [];
    rightAns = [];
    ansRef = [];
    currentIndex = 0;
    QuesDay();
    context.read<CourseProvider>().setMasterListType("Chat");
    context.read<ProfileProvider>().subscriptionStatus("Chat");
    // TODO: implement initState
    super.initState();
  }

  Future QuesDay() async {
    PracticeTextProvider practiceProvider = Provider.of(context, listen: false);
    practiceProvider.getQuesDay(widget.seltedId);
  }

  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  bool questionLoader = false;
  onTapOfPutOnDisscussion(String question, List<OptionsDay> li, String crsNameLable) async {
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
    List<String> optsName = [];
    for (int i = 0; i < li.length; i++) {
      String name = '';

      name = li[i].questionOption;

      if (name.isEmpty || name == null) {
      } else {
        optsName.add(name);
      }
    }

    print("optsName=========>>$optsName");

    print('Question of The Day question : $question');
    print('Question of The Day question options : $li');

    if (question.isEmpty) {
      setState(() => questionLoader = false);
      return;
    }

    await context
        .read<ChatProvider>()
        .createDiscussionGroup(question, optsName, context, testName: 'Question of the day', crsName: crsNameLable)
        .whenComplete(() {
      setState(() => questionLoader = false);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupListPage(),
          ));
    });
  }

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    PageController pageController = PageController();
    return Scaffold(body: Consumer<PracticeTextProvider>(builder: (context, data, child) {
      List<OptionsDay> options = [];
      if (data.qdList.isNotEmpty) {
        options = data.qdList[_quetionNo].options.where((element) => element.questionOption.isNotEmpty).toList();
      }

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
                                'Question of the day',
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
                      : data.qdList != null && data.qdList.isNotEmpty
                          ? Expanded(
                              // width: width,
                              // height: height - 235,
                              child: PageView.builder(
                                  controller: pageController,
                                  itemCount: data.qdList.length,
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
                                      if (data.qdList.length - 1 > _quetionNo) {
                                        setState(() {
                                          if (_quetionNo < data.qdList.length) {
                                            _quetionNo = _quetionNo + 1;
                                          }
                                          selectedAnswer = null;
                                        });
                                        print(_quetionNo);
                                      }
                                    } else {
                                      if (_quetionNo != 0) {
                                        setState(() {
                                          _quetionNo--;

                                          selectedAnswer = null;
                                        });
                                      }
                                    }

                                    setState(() {
                                      currentIndex = index;
                                      print("final index===$currentIndex");
                                    });
                                    _isattempt = data.qdList[_quetionNo].rightAnswer.contains(',')
                                        ? data.qdList[_quetionNo].rightAnswer.split(',').length - 1
                                        : 0;
                                  },
                                  itemBuilder: (context, index) {
                                    final date = DateTime.fromMillisecondsSinceEpoch(data.qdList[_quetionNo].sendDate);

                                    final timeStamp = date.formatDateLabel();
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("Uploaded on: "),
                                                        Text(timeStamp),
                                                      ],
                                                    ),
                                                    new Spacer(),
                                                    putOnDiscussionWidget(context, data),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context).size.width * .95,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                                                })
                                                              },
                                                              child: Icon(
                                                                Icons.west,
                                                                size: width * (30 / 420),
                                                                color: Colors.black,
                                                              ),
                                                            )
                                                          : Container(),
                                                      Container(
                                                        width: MediaQuery.of(context).size.width * .75,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              'QUESTION ${_quetionNo + 1}',
                                                              style: TextStyle(
                                                                fontFamily: 'Roboto Regular',
                                                                fontSize: width * (16 / 420),
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                            new Spacer(),
                                                            data.qdList.length - 1 > _quetionNo
                                                                ? Padding(
                                                                    padding: const EdgeInsets.only(right: 18.0),
                                                                    child: GestureDetector(
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
                                                                          // if (_quetionNo < data.qdList.length) {
                                                                          //   _quetionNo = _quetionNo + 1;
                                                                          // }
                                                                          selectedAnswer = null;
                                                                        }),
                                                                        print(_quetionNo)
                                                                      },
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.only(right: 8.0),
                                                                        child: Icon(
                                                                          Icons.east,
                                                                          size: width * (30 / 420),
                                                                          color: Colors.black,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: height * (15 / 800)),
                                                  child: Html(
                                                    data: data.qdList != null ? data.qdList[_quetionNo].question : '',
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
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Maximum selection: ${data.qdList[index].rightAnswer.split(',').length}",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto Regular',
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                ListView.builder(
                                                    shrinkWrap: true,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemCount: options.length,
                                                    itemBuilder: (context, index) {
                                                      return Padding(
                                                        padding: const EdgeInsets.only(bottom: 15.0, top: 10),
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (enableTap == 0) {
                                                              setState(() {
                                                                rightAns = [];
                                                                ansRef = [];

                                                                rightAns =
                                                                    data.qdList[_quetionNo].rightAnswer.split(',');
                                                                print("rightAns========>>>$rightAns");

                                                                for (int i = 0; i < rightAns.length; i++) {
                                                                  ansRef.add(int.parse(rightAns[i]));
                                                                }
                                                                print("ansRef=========>>>>>>$ansRef");
                                                              });

                                                              setState(() {
                                                                selAns.add(options[index].id);
                                                                print("selAns=============$selAns");

                                                                if (selAns.length == ansRef.length &&
                                                                    ansRef.length > 0) {
                                                                  checkAllAns(selAns, ansRef);
                                                                  enableTap = 1;
                                                                }
                                                              });

                                                              if (_isattempt <
                                                                  options
                                                                      .where((element) => element.isseleted == true)
                                                                      .toList()
                                                                      .length) {
                                                                return;
                                                              }
                                                              setState(() {
                                                                options[index].isseleted = !options[index].isseleted;
                                                              });
                                                            }
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              // shape: BoxShape.circle,

                                                              color: selAns.contains(options[index].id) &&
                                                                      ansRef.contains(options[index].id) &&
                                                                      selAns.length == ansRef.length &&
                                                                      selAns.length > 0
                                                                  ? _colorfromhex("#E6F7E7")
                                                                  : selAns.contains(options[index].id) &&
                                                                          !ansRef.contains(options[index].id) &&
                                                                          selAns.length == ansRef.length &&
                                                                          selAns.length > 0
                                                                      ? _colorfromhex("#FFF6F6")
                                                                      : ansRef.contains(options[index].id) &&
                                                                              selAns.length == ansRef.length &&
                                                                              selAns.length > 0
                                                                          ? _colorfromhex("#E6F7E7")
                                                                          : selAns.contains(options[index].id) &&
                                                                                  ansRef.contains(options[index].id)
                                                                              ? _colorfromhex("#E6F7E7")
                                                                              : selAns.contains(options[index].id) &&
                                                                                      !ansRef
                                                                                          .contains(options[index].id)
                                                                                  ? _colorfromhex("#FFF6F6")
                                                                                  : Colors.white,
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
                                                                      color: selAns.contains(options[index].id) &&
                                                                              ansRef.contains(options[index].id) &&
                                                                              selAns.length == ansRef.length &&
                                                                              selAns.length > 0
                                                                          ? Colors.green
                                                                          : selAns.contains(options[index].id) &&
                                                                                  !ansRef.contains(options[index].id) &&
                                                                                  selAns.length == ansRef.length &&
                                                                                  selAns.length > 0
                                                                              ? Colors.red
                                                                              : ansRef.contains(options[index].id) &&
                                                                                      selAns.length == ansRef.length &&
                                                                                      selAns.length > 0
                                                                                  ? Colors.green
                                                                                  : selAns.contains(
                                                                                              options[index].id) &&
                                                                                          ansRef.contains(
                                                                                              options[index].id)
                                                                                      ? Colors.green
                                                                                      : selAns.contains(
                                                                                                  options[index].id) &&
                                                                                              !ansRef.contains(
                                                                                                  options[index].id)
                                                                                          ? Colors.red
                                                                                          : Colors.white,
                                                                      border: Border.all(
                                                                          color: selAns.length == ansRef.length &&
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
                                                                          color: options.any((element) =>
                                                                                  element.isseleted == true)
                                                                              ? data.qdList[_quetionNo].rightAnswer
                                                                                      .contains("${options[index].id}")
                                                                                  ? Colors.black
                                                                                  : Colors.black
                                                                              : options[index].isseleted
                                                                                  ? data.qdList[_quetionNo].rightAnswer
                                                                                          .contains(
                                                                                              "${options[index].id}")
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
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                            height: 8,
                                                                          ),
                                                                          Html(
                                                                            data: options[index].questionOption,
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
                                                                          (selAns.length == ansRef.length &&
                                                                                      selAns.length > 0 &&
                                                                                      selAns.contains(
                                                                                          options[index].id) &&
                                                                                      ansRef.contains(
                                                                                          options[index].id)) ||
                                                                                  (selAns.length == ansRef.length &&
                                                                                      selAns.length > 0 &&
                                                                                      ansRef
                                                                                          .contains(options[index].id))
                                                                              ? Row(
                                                                                  mainAxisAlignment:
                                                                                      MainAxisAlignment.end,
                                                                                  children: [Text("Correct Answer")],
                                                                                )
                                                                              : selAns.length == ansRef.length &&
                                                                                      selAns.length > 0 &&
                                                                                      selAns.contains(
                                                                                          options[index].id) &&
                                                                                      !ansRef
                                                                                          .contains(options[index].id)
                                                                                  ? Row(
                                                                                      mainAxisAlignment:
                                                                                          MainAxisAlignment.end,
                                                                                      children: [
                                                                                        Text("Your Selection")
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
                                                if (selAns.length == ansRef.length && ansRef.length > 0)
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
                                                                  data.qdList[_quetionNo].rightAnswer ==
                                                                          options[0].id.toString()
                                                                      ? 'Answer A is the correct one'
                                                                      : data.qdList[_quetionNo].rightAnswer ==
                                                                              options[1].id.toString()
                                                                          ? 'Answer B is the correct one'
                                                                          : data.qdList[_quetionNo].rightAnswer ==
                                                                                  options[2].id.toString()
                                                                              ? 'Answer c is the correct one'
                                                                              : data.qdList[_quetionNo].rightAnswer ==
                                                                                      options[3].id.toString()
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
                                                                  data.qdList[_quetionNo].explanation,
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
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            )
                          : data.qdList.isEmpty
                              ? Center(child: Container(height: 200, child: Text("No Data Found.....")))
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
            //     ? Positioned(
            //         top: SizerUtil.deviceType == DeviceType.mobile ? 80 : 140,
            //         left: width / 2.9,
            //         child: Container(
            //           width: 110,
            //           height: 110,
            //           child: Image.asset('assets/smile.png'),
            //         ))
            //     : Text(''),
            // realAnswer != selectedAnswer && selectedAnswer != null
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
            //                 : Image.asset('assets/smiley-sad1.png'),
            //       )
            //     : Text(''),
          ],
        ),
      );
    }));
  }

  Widget putOnDiscussionWidget(
    BuildContext context,
    PracticeTextProvider data,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: InkWell(
        onTap: () async {
          // subscriptionStatus
          print(
              'questionLoader : $questionLoader, context.read<ProfileProvider>().subscriptionApiCalling: ${context.read<ProfileProvider>().subscriptionApiCalling}');
          questionLoader
              ? null
              : context.read<ProfileProvider>().subscriptionApiCalling
                  ? null
                  : onTapOfPutOnDisscussion(data.pList != null ? data.qdList[_quetionNo].question : '',
                      data.qdList[_quetionNo].options, data.qdList[_quetionNo].lable);
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
            child: questionLoader || context.read<ProfileProvider>().subscriptionApiCalling
                ? SizedBox(width: 20, height: 20, child: Center(child: CircularProgressIndicator.adaptive()))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_outlined,
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
      ),
    );
  }

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
}
