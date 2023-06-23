import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/profileProvider.dart';
import '../tool/ShapeClipper.dart';

class QuesOfDay extends StatefulWidget {
  const QuesOfDay({Key key}) : super(key: key);

  @override
  State<QuesOfDay> createState() => _QuesOfDayState();
}

class _QuesOfDayState extends State<QuesOfDay> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: Color(0xfff7f7f7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: ShapeClipper(),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 50, 0, 0),
                    child: Row(children: [
                      Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                              border:
                                  Border.all(color: Colors.white, width: 1)),
                          child: Center(
                              child: IconButton(
                                  icon: Icon(Icons.arrow_back,
                                      color: Colors.white),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }))),
                      SizedBox(
                        width: 20,
                      ),
                      Center(
                          child: Text(
                        // "Video Library",
                        "Question of the Day",
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.bold),
                      )),
                    ]),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
              child: Consumer<ProfileProvider>(builder: (context, pp, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    // mainAxisAlignment:,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'QUESTION',
                          style: TextStyle(
                            fontFamily: 'Roboto Regular',
                            fontSize: 18,
                            color: Colors.black,
                            // _colorfromhex("#ABAFD1"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        pp.quesDayQues,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: pp.quesDayOption.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(top: height * (21 / 800)),
                              padding: EdgeInsets.only(
                                top: 13,
                                bottom: 13,
                                left: width * (13 / 420),
                                right: width * (11 / 420),
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white
                                  //  selectedAnswer.contains(index)
                                  //     ? _colorfromhex("#F2F2FF")
                                  //     : Colors.white
                                  ),
                              child: Row(
                                children: [
                                  Container(
                                    width: width * (25 / 420),
                                    height: width * 25 / 420,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: _colorfromhex("#3846A9")),
                                      // selectedAnswer.contains(index)
                                      //     ? _colorfromhex("#3846A9")
                                      //     : _colorfromhex("#F1F1FF")),
                                      borderRadius: BorderRadius.circular(
                                        width * (25 / 420),
                                      ),
                                      color: Colors.white,
                                      //  selectedAnswer.contains(index)
                                      //     ? _colorfromhex("#3846A9")
                                      //     : Colors.white,
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
                                        color: _colorfromhex("#ABAFD1"),
                                      ),
                                    )),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(left: 8),
                                      width: width - (width * (25 / 420) * 5),
                                      child: Text(
                                          pp.quesDayOption[index]
                                              .question_option,
                                          style: TextStyle(
                                              fontSize: width * 14 / 420)))
                                ],
                              ),
                            );
                          })
                    ],
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
