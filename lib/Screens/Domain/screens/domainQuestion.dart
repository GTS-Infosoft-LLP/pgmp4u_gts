import 'package:flutter/material.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:provider/provider.dart';



class DomainQuestions extends StatefulWidget {
  const DomainQuestions({Key key}) : super(key: key);

  @override
  State<DomainQuestions> createState() => _DomainQuestionsState();
}

class _DomainQuestionsState extends State<DomainQuestions> {
  @override
  var currentIndex;
  var colorIndex;
  PageController pageController;
  void initState() {
    colorIndex = 0;
    pageController = PageController();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  Widget build(BuildContext context) {
    Color _colorfromhex(String hexColor) {
      final hexCode = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    }

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: _colorfromhex("#FCFCFF"),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  margin: EdgeInsets.only(left: width * (20 / 420), right: width * (20 / 420), top: 20),
                  child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: width * (24 / 420),
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Questions",
                          style: TextStyle(
                              fontFamily: 'Roboto Medium', fontSize: 18, color: Colors.white, letterSpacing: 0.3),
                        ),
                      ]),
                ),
              ),
              // SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(
                  "Details " + "${colorIndex + 1}" + "/5",
                  // cp.pptCategoryList[index].name,
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Consumer<CourseProvider>(builder: (context, cp, child) {
                return Container(
                    height: MediaQuery.of(context).size.height * .7,
                    // width: MediaQuery.of(context).size.width * .9,
                    // color: Colors.blue,
                    child: Stack(
                      children: [
                        PageView.builder(
                            itemCount: 5,
                            onPageChanged: (index) {
                              print("index valuee====$index");
                              setState(() {
                                colorIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0, top: 20),
                                  child: Container(
                                    // height: 100,
                                    // width: 100,
                                    // color: Colors.amber,
                                    child: SingleChildScrollView(
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Task",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Which of the following is not considered as a risk response strategy in project management",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                              fontFamily: "Roboto Regular"),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "Maximum Selection: ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "Options",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),

                                        ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: 5,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(bottom: 8.0, right: 15),
                                                child: Container(
                                                  decoration: BoxDecoration(color: Colors.green[200]),
                                                  child: Row(children: [
                                                    Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          border: Border.all(color: Colors.black),
                                                          // borderRadius: BorderRadius.circular(width * (25 / 420)),
                                                          color: _colorfromhex("#04AE0B")),
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
                                                              color: Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(left: 8),
                                                          width: width - (width * (25 / 420) * 5),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                              Text(
                                                                  "Which of the following is not considered as a Which of the following is not considered as a risk response ollowing is not considered as a risk response"),
                                                              SizedBox(
                                                                height: 8,
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ]),
                                                ),
                                              );
                                            })

                                        // Padding(
                                        //   padding: const EdgeInsets.only(right: 18.0),
                                        //   child: ListView.builder(
                                        //       itemCount: 2,
                                        //       shrinkWrap: true,
                                        //       // physics: NeverScrollableScrollPhysics(),
                                        //       itemBuilder: (context, index) {
                                        //         return Padding(
                                        //           padding: const EdgeInsets.only(bottom: 8.0),
                                        //           child: Container(
                                        //             height: 100,
                                        //             decoration: BoxDecoration(color: _colorfromhex("#E6F7E7")),
                                        //           ),
                                        //         );
                                        //       }),
                                        // )
                                      ]),
                                    ),
                                  ),
                                ),
                              );
                            }),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Container(
                            // color: Colors.black12,

                            child: Row(
                                children: List.generate(5, (index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      gradient: index <= colorIndex
                                          ? LinearGradient(
                                              colors: [
                                                _colorfromhex("#3A47AD"),
                                                _colorfromhex("#5163F3"),
                                              ],
                                              begin: const FractionalOffset(0.0, 0.0),
                                              end: const FractionalOffset(1.0, 0.0),
                                              stops: [0.0, 1.0],
                                              tileMode: TileMode.clamp)
                                          : LinearGradient(
                                              colors: [
                                                Colors.grey,
                                                Colors.grey,
                                              ],
                                            )),
                                  height: 10,
                                  width: MediaQuery.of(context).size.width * .1,
                                  // color: Colors.black,
                                ),
                              );
                            })),
                          ),
                        )
                      ],
                    ));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
