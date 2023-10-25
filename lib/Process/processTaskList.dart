import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pgmp4u/Process/processDomainProvider.dart';
import 'package:provider/provider.dart';

import '../Screens/Tests/local_handler/hive_handler.dart';
import '../provider/courseProvider.dart';
import '../tool/ShapeClipper.dart';
import '../utils/app_color.dart';

class ProcessTaskList extends StatefulWidget {
  String subProcessName;
  String subProcessLable;
  ProcessTaskList({Key key}) : super(key: key);

  @override
  State<ProcessTaskList> createState() => _ProcessTaskListState();
}

class _ProcessTaskListState extends State<ProcessTaskList> {

  // List<TaskDetails> storedTasks = [];
    List storedProcessTasks = [];

  @override
  Widget build(BuildContext context) {
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
              Consumer<ProcessDomainProvider>(builder: (context, pdp, child) {
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
                            widget.subProcessLable ?? "" + " Process",
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


            Consumer<ProcessDomainProvider>(builder: (context, pdp, child) {
              return Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: pdp.ProcessTaskList.isEmpty
                    ? SizedBox()
                    : Container(
                        width: MediaQuery.of(context).size.width * .93,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .67,
                          child: Text(
                            pdp.selectedSubProcessName == ""
                                ? pdp.selectedProcessName
                                : pdp.ProcessTaskList.isEmpty
                                    ? ""
                                    : pdp.selectedProcessName + "  --> " + pdp.selectedSubProcessName,

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
                 builder: (context, value, child){
                              ProcessDomainProvider pdp = Provider.of(context, listen: false);
                if (value.containsKey(pdp.selectedProcessId.toString())) {
                  // print("cp.selectedMasterId>>>>>${cp.selectedMasterId}");
                  List processTaskList = jsonDecode(value.get(pdp.selectedProcessId.toString()));
                  print("storedProcessTasks List questionsss  taskList:::::::::${processTaskList[0]["practiceTest"]}");
                  // storedProcessTasks = processTaskList.map((e) => TaskDetails.fromjson(e)).toList();
                  print("storedProcessTasks List:::::: $storedProcessTasks");
                  print("storedProcessTasks List questionsss:::::::::${storedProcessTasks[0].id}");
                } else {
                  storedProcessTasks = [];
                }
                if (storedProcessTasks == null) {
                  storedProcessTasks = [];
                }

                                 return Consumer<ProcessDomainProvider>(builder: (context, pdp, child) {
                  return pdp.processTaskApiCall
                      ? Container(
                          height: MediaQuery.of(context).size.height * .60,
                          child: Center(child: CircularProgressIndicator.adaptive()))
                      : storedProcessTasks.isEmpty
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
                                    itemCount:5, 
                                    // storedProcessTasks.length,
                                    itemBuilder: (context, index) {
                                      

                                      return InkWell(
                                        onTap: () async {
                                          print("storedTasks[index].id===${storedProcessTasks[index].id}");
                                          print("storedTasks[index].name===${storedProcessTasks[index].name}");
                                          // pdp.setSelectedProcessTaskId(storedProcessTasks[index].id);
                                          // pdp.setSelectedProcessTaskLable(storedProcessTasks[index].lable);
                                          // pdp.getTasksDetailData(storedProcessTasks[index].id);
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => TaskDetail(
                                          //               subDomainName: storedTasks[index].name,
                                          //               taskDetailsObj: storedTasks[index],
                                          //             )));
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
                                                            "Process task lable",
                                                            // storedProcessTasks[index].lable,
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
                                                        "process task name",
                                                        // storedProcessTasks[index].name,
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
                 }
               )
            )


      ],
    ),
    ));
  }
}
