import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/Domain/screens/taskDetails.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:pgmp4u/tool/ShapeClipper.dart';

import 'package:provider/provider.dart';



class TaskList extends StatefulWidget {
  const TaskList({Key key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Color clr;
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    Color _colorfromhex(String hexColor) {
      final hexCode = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: <Widget>[
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
              Consumer<CourseProvider>(builder: (context, cp, child) {
                return Container(
                  padding: EdgeInsets.fromLTRB(40, 50, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
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
                      SizedBox(width: 20),
                      Center(
                          child: Container(
                        // color: Colors.amber,
                        width: MediaQuery.of(context).size.width * .65,
                        child: Text(
                          "Tasks",
                          // cp.selectedCourseName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 22, color: Colors.white, fontFamily: "Roboto", fontWeight: FontWeight.bold),
                        ),
                      )),
                    ],
                  ),
                );
              }),
            ]),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                "Sub Domain Name",
                // cp.pptCategoryList[index].name,
                maxLines: 2,
                style: TextStyle(
                  fontFamily: 'Roboto Regular',
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            Consumer<CourseProvider>(builder: (context, cp, child) {
              // return cp.isPPTLoading
              //     ? Container(
              //         height: MediaQuery.of(context).size.height * .60,
              //         child: Center(child: CircularProgressIndicator.adaptive()))
              //     :
              return Container(
                height: MediaQuery.of(context).size.height * .78,
                // width: MediaQuery.of(context).size.width * .95,
                child: ListView.builder(
                    itemCount: 5,
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

                      return InkWell(
                        onTap: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetail()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10),
                          child: Container(
                            decoration: const BoxDecoration(
                                border:
                                    Border(bottom: BorderSide(width: 1, color: Color.fromARGB(255, 219, 211, 211)))),
                            height: 70,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: clr
                                          // index % 2 == 0 ? AppColor.purpule : AppColor.green,

                                          //     colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                                          ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(17.0),
                                        child: Container(
                                          // decoration: BoxDecoration(
                                          //   color: Colors.white,
                                          //   borderRadius: BorderRadius.circular(80),
                                          // ),
                                          child: Center(
                                            child: Icon(
                                              Icons.checklist_sharp,
                                              // size: 30,
                                              color: Colors.white,
                                            ),

                                            // Text('${index + 1}',
                                            //     style: TextStyle(color: Colors.white, fontSize: 18)),
                                          ),
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * .45,
                                      // color: Colors.amber,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "8 Tasks available",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * .55,
                                      child: Text(
                                        "Task Name",
                                        // cp.pptCategoryList[index].name,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
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
      ),
    );
  }
}