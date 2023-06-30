import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/MockTest/model/quesOfDayModel.dart';
import 'package:pgmp4u/Screens/PracticeTests/practiceTextProvider.dart';
import 'package:pgmp4u/Screens/chat/controller/chatProvider.dart';
import 'package:pgmp4u/Screens/chat/screen/goupList.dart';
import 'package:pgmp4u/Screens/home_view/VideoLibrary/RandomPage.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class QuesOfDay extends StatefulWidget {
  var seltedId;
  QuesOfDay({Key key, this.seltedId}) : super(key: key);

  @override
  State<QuesOfDay> createState() => _QuesOfDayState();
}

class _QuesOfDayState extends State<QuesOfDay> {
  @override
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
  onTapOfPutOnDisscussion(String question, List<OptionsDay> li) async {


    List<String> optsName=[];
    for(int i=0;i<li.length;i++){
     String name='';

       name =li[i].questionOption;

      if(name.isEmpty  || name==null){}else{
        optsName.add(name);
      }



    }

    print("optsName=========>>${optsName}");
    setState(() => questionLoader = true);
    print('Question of The Day question : $question');
    print('Question of The Day question options : $li');
    if (question.isEmpty) return;

    if (!context.read<ChatProvider>().isChatSubscribed()) {
      setState(() => questionLoader = false);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RandomPage(),
          ));
      return;
    }
    print("*******************");
    await context.read<ChatProvider>().createDiscussionGroup(question,optsName, context).whenComplete(() {
      // Navigator.pop(context);
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
      // List<Options> options =
      //     data.pList[_quetionNo].ques.options.where((element) => element.questionOption.isNotEmpty).toList();
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
                      : data.qdList != null
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
                                                // Text("Uploaded on: "),
                                                // Text("${data.qdList[_quetionNo].sendDate}"),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    // finDate
                                                    // finDate

                                                    data.qdList[_quetionNo].sendDate.split(" ")[0].toString() == finDate
                                                        ? Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text("Today's Question "),
                                                              // Text("${data.qdList[_quetionNo].sendDate}"),
                                                            ],
                                                          )
                                                        : Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text("Uploaded on: "),
                                                              Text("${data.qdList[_quetionNo].sendDate}"),
                                                            ],
                                                          ),
                                                    new Spacer(),
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 15.0),
                                                      child: Container(
                                                        height: 35,
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
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(4.0),
                                                          child: Center(
                                                            child: InkWell(
                                                              onTap: () {
                                                                questionLoader
                                                                    ? null
                                                                    : onTapOfPutOnDisscussion(
                                                                        data.pList != null
                                                                            ? data.qdList[_quetionNo].question
                                                                            : '',
                                                                        data.qdList[_quetionNo].options);
                                                              },
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
                                                                    padding:
                                                                        const EdgeInsets.symmetric(horizontal: 4.0),
                                                                    child: Text(
                                                                      "Put on discussion",
                                                                      style:
                                                                          TextStyle(color: Colors.white, fontSize: 12),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                SizedBox(
                                                  height: 10,
                                                ),

                                                Container(
                                                  // color: Colors.amber,
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
                                                                setState(() {
                                                                  _quetionNo--;

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
                                                        // color: Colors.amber,
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
                                                                        setState(() {
                                                                          if (_quetionNo < data.qdList.length) {
                                                                            _quetionNo = _quetionNo + 1;
                                                                          }
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
                                                      // data.qdList.length - 1 > _quetionNo
                                                      //     ? Padding(
                                                      //         padding: const EdgeInsets.only(right: 18.0),
                                                      //         child: GestureDetector(
                                                      //           onTap: () => {
                                                      //             selAns = [],
                                                      //             rightAns = [],
                                                      //             correctAns = [],
                                                      //             setState(() {
                                                      //               if (_quetionNo < data.qdList.length) {
                                                      //                 _quetionNo = _quetionNo + 1;
                                                      //               }
                                                      //               selectedAnswer = null;
                                                      //             }),
                                                      //             print(_quetionNo)
                                                      //           },
                                                      //           child: Icon(
                                                      //             Icons.east,
                                                      //             size: width * (30 / 420),
                                                      //             color: Colors.black,
                                                      //           ),
                                                      //         ),
                                                      //       )
                                                      //     : Container(),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(top: height * (15 / 800)),
                                                  child: Text(
                                                    data.qdList != null ? data.qdList[_quetionNo].question : '',
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto Regular',
                                                      fontSize: width * (15 / 420),
                                                      color: Colors.black,
                                                      height: 1.7,
                                                    ),
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
                                                                // selAns.add(options[index].id);
                                                                // print("selAns=============$selAns");
                                                              });
                                                            }
                                                          },

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

                                                              // color: selAns.length != ansRef.length
                                                              //     ? Colors.white
                                                              //     : _isattempt <
                                                              //             options
                                                              //                 .where((element) =>
                                                              //                     element.isseleted == true)
                                                              //                 .toList()
                                                              //                 .length
                                                              //         ? options.any(
                                                              //                 (element) => element.isseleted == true)
                                                              //             ? data.qdList[_quetionNo].rightAnswer
                                                              //                     .contains("${options[index].id}")
                                                              //                 ? _colorfromhex("#E6F7E7")
                                                              //                 : options[index].isseleted
                                                              //                     ? data.qdList[_quetionNo]
                                                              //                             .rightAnswer
                                                              //                             .contains(
                                                              //                                 "${options[index].id}")
                                                              //                         ? _colorfromhex("#E6F7E7")
                                                              //                         : _colorfromhex("#FFF6F6")
                                                              //                     : Colors.white
                                                              //             : options[index].isseleted
                                                              //                 ? data.qdList[_quetionNo].rightAnswer
                                                              //                         .contains(
                                                              //                             "${options[index].id}")
                                                              //                     ? _colorfromhex("#E6F7E7")
                                                              //                     : _colorfromhex("#FFF6F6")
                                                              //                 : Colors.white
                                                              //         : options[index].isseleted
                                                              //             ? data.qdList[_quetionNo].rightAnswer
                                                              //                     .contains("${options[index].id}")
                                                              //                 ? _colorfromhex("#E6F7E7")
                                                              //                 : _colorfromhex("#FFF6F6")
                                                              //             : Colors.white

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

                                                                      // color: _isattempt <
                                                                      //         options
                                                                      //             .where((element) =>
                                                                      //                 element.isseleted == true)
                                                                      //             .toList()
                                                                      //             .length
                                                                      //     ? options.any((element) =>
                                                                      //             element.isseleted == true)
                                                                      //         ? data.qdList[_quetionNo].rightAnswer
                                                                      //                 .contains("${options[index].id}")
                                                                      //             ? _colorfromhex("#04AE0B")
                                                                      //             : options[index].isseleted
                                                                      //                 ? data.qdList[_quetionNo]
                                                                      //                         .rightAnswer
                                                                      //                         .contains(
                                                                      //                             "${options[index].id}")
                                                                      //                     ? _colorfromhex("#E6F7E7")
                                                                      //                     : _colorfromhex("#FF0000")
                                                                      //                 : Colors.white
                                                                      //         : options[index].isseleted
                                                                      //             ? data.qdList[_quetionNo].rightAnswer
                                                                      //                     .contains(
                                                                      //                         "${options[index].id}")
                                                                      //                 ? _colorfromhex("#E6F7E7")
                                                                      //                 : _colorfromhex("#FFF6F6")
                                                                      //             : Colors.white
                                                                      //     : options[index].isseleted
                                                                      //         ? data.qdList[_quetionNo].rightAnswer
                                                                      //                 .contains("${options[index].id}")
                                                                      //             ? _colorfromhex("#E6F7E7")
                                                                      //             : _colorfromhex("#FFF6F6")
                                                                      //         : Colors.white,

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
                                                                          Text(
                                                                            options[index].questionOption,
                                                                            style: TextStyle(fontSize: 16),
                                                                          ),
                                                                          // selectedAnswer != null &&
                                                                          //         int.parse(data.qdList[_quetionNo]
                                                                          //                 .rightAnswer) !=
                                                                          //             selectedAnswer &&
                                                                          //         options[index].id ==
                                                                          //             int.parse(data.qdList[_quetionNo]
                                                                          //                 .rightAnswer)

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
                                                                              :
                                                                              // options[index].id == selectedAnswer &&
                                                                              //         int.parse(data.qdList[_quetionNo]
                                                                              //                 .rightAnswer) !=
                                                                              //             selectedAnswer
                                                                              selAns.length == ansRef.length &&
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
                                                if (selAns.length == ansRef.length && ansRef.length > 0
                                                // _isattempt <
                                                //   options
                                                //       .where((element) => element.isseleted == true)
                                                //       .toList()
                                                //       .length
                                                )
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
