import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pgmp4u/Screens/home_view/VideoLibrary/RandomPage.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:provider/provider.dart';

import '../provider/profileProvider.dart';
import '../tool/ShapeClipper.dart';
import 'QuesOfDay.dart';

class QuesListCourse extends StatefulWidget {
  const QuesListCourse({Key key}) : super(key: key);

  @override
  State<QuesListCourse> createState() => _QuesListCourseState();
}

class _QuesListCourseState extends State<QuesListCourse> {
  @override
  Color clr;
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
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
                              border: Border.all(color: Colors.white, width: 1)),
                          child: Center(
                              child: IconButton(
                                  icon: Icon(Icons.arrow_back, color: Colors.white),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }))),
                      SizedBox(
                        width: 20,
                      ),
                      Center(
                          child: Text(
                        // "Video Library",
                        "Question of the day",
                        style: TextStyle(
                            fontSize: 20, color: Colors.white, fontFamily: "Raleway", fontWeight: FontWeight.bold),
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
              child: Column(
                children: [
                  Consumer<CourseProvider>(builder: (context, courseProvider, child) {
                    return Container(
                      height: MediaQuery.of(context).size.height * .78,
                      // color: Colors.amber,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: courseProvider.course.length,
                          itemBuilder: (context, index) {
                            if (index % 4 == 0) {
                              clr = Color(0xff3F9FC9);
                            } else if (index % 3 == 0) {
                              clr = Color(0xff3FC964);
                            } else if (index % 2 == 0) {
                              clr = Color(0xffDE682B);
                            } else {
                              clr = Color(0xffC93F7F);
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: InkWell(
                                onTap: () async {
                                  print("cousres id========>>>${courseProvider.course[index].id}");
                                  ProfileProvider pp = Provider.of(context, listen: false);
                                  pp.updateLoader(true);

                                  int courseId = courseProvider.course[index].id;
                                  await pp.subscriptionStatus("Question");

                                  var chkStat = await pp.successValue;
                                  pp.updateLoader(false);
                                  print("chkStat====$chkStat");
                                  if (chkStat == false) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RandomPage(
                                                  index: 7,
                                                  categoryId: 0,
                                                  price: pp.subsPrice.toString(),
                                                  categoryType: "Question",
                                                )));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => QuesOfDay(
                                                  seltedId: courseId,
                                                )));
                                  }

                                  // Future.delayed(Duration(milliseconds: 600), () {
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) => QuesOfDay(
                                  //                 seltedId: courseId,
                                  //               )));
                                  // });
                                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>));
                                },
                                child: ListTile(
                                  leading: Container(
                                      height: 70,
                                      width: 65,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: clr,
                                        // index % 2 == 0
                                        //     ? Color(0xff3F9FC9)
                                        //     : Color(0xffDE682B),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Icon(FontAwesomeIcons.graduationCap, color: Colors.white),
                                      )),
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        courseProvider.course[index].lable,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        courseProvider.course[index].course,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
