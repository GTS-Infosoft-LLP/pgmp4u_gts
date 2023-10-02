import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pgmp4u/Screens/Domain/screens/taskDetails.dart';
import 'package:pgmp4u/Screens/Tests/local_handler/hive_handler.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:pgmp4u/tool/ShapeClipper.dart';

import 'package:provider/provider.dart';

import '../../../utils/app_color.dart';
import 'Models/taskModel.dart';
import 'domainProvider.dart';

class TaskList extends StatefulWidget {
  String subDomainName;
  String subDomainLable;
  TaskList({Key key, this.subDomainName, this.subDomainLable}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Color clr;
  List<TaskDetails> storedTasks = [];
  void initState() {
    print("subDomainName=====${widget.subDomainName}");
    print("subDomainLable=====${widget.subDomainLable}");
    if (widget.subDomainName == null || widget.subDomainName.isEmpty) {
      widget.subDomainName = "";
    }
    if (widget.subDomainLable == null || widget.subDomainLable.isEmpty) {
      widget.subDomainLable = "Task";
    }
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
              Consumer<DomainProvider>(builder: (context, dp, child) {
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
                      Consumer<CourseProvider>(builder: (context, cp, child) {
                        return Center(
                            child: Container(
                          // color: Colors.amber,
                          width: MediaQuery.of(context).size.width * .65,
                          child: Text(
                            widget.subDomainLable ?? "" + " Tasks",
                            // cp.selectedCourseName,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 22, color: Colors.white, fontFamily: "Roboto", fontWeight: FontWeight.bold),
                          ),
                        ));
                      }),
                    ],
                  ),
                );
              }),
            ]),
            SizedBox(height: 20),
            Consumer<DomainProvider>(builder: (context, dp, child) {
              return Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: dp.TaskList.isEmpty
                    ? SizedBox()
                    : Container(
                        width: MediaQuery.of(context).size.width * .93,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .67,
                          child: Text(
                            dp.selectedSubDomainName == ""
                                ? dp.selectedDomainName
                                : dp.TaskList.isEmpty
                                    ? ""
                                    : dp.selectedDomainName + "  --> " + dp.selectedSubDomainName,

                            // cp.pptCategoryList[index].name,
                            maxLines: 3,
                            style: TextStyle(
                              fontFamily: 'Roboto Regular',
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
              );
            }),
            Container(
                child: ValueListenableBuilder<Box<String>>(
              valueListenable: HiveHandler.getTaskItemsListener(),
              builder: (context, value, child) {
                DomainProvider dp = Provider.of(context, listen: false);
                if (value.containsKey(dp.selectedDomainId.toString())) {
                  // print("cp.selectedMasterId>>>>>${cp.selectedMasterId}");
                  List taskList = jsonDecode(value.get(dp.selectedDomainId.toString()));
                  print("storedTasks List questionsss  taskList:::::::::${taskList[0]["practiceTest"]}");
                  storedTasks = taskList.map((e) => TaskDetails.fromjson(e)).toList();
                  print("storedTasks List:::::: $storedTasks");
                  print("storedTasks List questionsss:::::::::${storedTasks[0].id}");
                } else {
                  storedTasks = [];
                }
                if (storedTasks == null) {
                  storedTasks = [];
                }
                return Consumer<DomainProvider>(builder: (context, dp, child) {
                  return dp.taskApiCall
                      ? Container(
                          height: MediaQuery.of(context).size.height * .60,
                          child: Center(child: CircularProgressIndicator.adaptive()))
                      : storedTasks.isEmpty
                          ? Center(
                              child: Text(
                              "No Data Found",
                              style: TextStyle(fontSize: 18),
                            ))
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                height: MediaQuery.of(context).size.height * .75,

                                // width: MediaQuery.of(context).size.width * .95,
                                child: ListView.builder(
                                    itemCount: storedTasks.length,
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
                                          print("storedTasks[index].id===${storedTasks[index].id}");
                                          print("storedTasks[index].name===${storedTasks[index].name}");
                                          dp.setSelectedTaskId(storedTasks[index].id);
                                          dp.setSelectedTaskLable(storedTasks[index].lable);
                                          dp.getTasksDetailData(storedTasks[index].id);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => TaskDetail(
                                                        subDomainName: storedTasks[index].name,
                                                        taskDetailsObj: storedTasks[index],
                                                      )));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                border: Border(
                                              bottom: BorderSide(
                                                width: 1,
                                                color: Color.fromARGB(255, 219, 211, 211),
                                              ),
                                            )),
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
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: index % 2 == 0 ? AppColor.purpule : AppColor.green,
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(17.0),
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(80),
                                                          ),
                                                          child: Center(
                                                            child: Text('${index + 1}', style: TextStyle()),
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
                                                            storedTasks[index].lable,
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
                                                        storedTasks[index].name,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Icon(
                                                  Icons.east,
                                                  color: Colors.grey,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            );
                });
              },
            )),
          ],
        ),
      ),
    );
  }
}
