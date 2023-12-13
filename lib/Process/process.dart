import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pgmp4u/Process/processDomainProvider.dart';
import 'package:pgmp4u/Process/processTaskList.dart';
import 'package:pgmp4u/Process/process_model.dart';
import 'package:pgmp4u/Process/subProcess.dart';
import 'package:provider/provider.dart';

import '../Screens/Tests/local_handler/hive_handler.dart';
import '../provider/courseProvider.dart';
import '../tool/ShapeClipper.dart';
import '../utils/app_color.dart';

class ProcessList extends StatefulWidget {
  const ProcessList({Key key}) : super(key: key);

  @override
  State<ProcessList> createState() => _ProcessListState();
}

class _ProcessListState extends State<ProcessList> {
  Color clr;
  List<ProcessDetails> storedProcessList = [];
  @override
  Widget build(BuildContext context) {
    Color _colorfromhex(String hexColor) {
      final hexCode = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                  padding: EdgeInsets.fromLTRB(20, 50, 10, 0),
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
                          cp.selectedCourseLable,
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
            Container(
                child: ValueListenableBuilder<Box<String>>(
                    valueListenable: HiveHandler.getProcessDetailListener(),
                    builder: (context, value, child) {
                      CourseProvider cp = Provider.of(context, listen: false);
                      if (value.containsKey(cp.selectedMasterId.toString())) {
                        List processDetailList = jsonDecode(value.get(cp.selectedMasterId.toString()));
                        storedProcessList = processDetailList.map((e) => ProcessDetails.fromjson(e)).toList();
                        print("storedProcesssList:::::: $storedProcessList");
                      } else {
                        storedProcessList = [];
                      }
                      if (storedProcessList == null) {
                        storedProcessList = [];
                      }

                      return Consumer<ProcessDomainProvider>(builder: (context, pdp, child) {
                        return pdp.processApiCall
                            ? Container(
                                height: MediaQuery.of(context).size.height * .6,
                                child: Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                              )
                            : storedProcessList.length == 0
                                ? Container(
                                    height: MediaQuery.of(context).size.height * .5,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "No Data Found...",
                                            style: TextStyle(color: Colors.black, fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: MediaQuery.of(context).size.height * .70,
                                    // width: MediaQuery.of(context).size.width * .95,
                                    child: ListView.builder(
                                        itemCount: storedProcessList.length,
                                        // storedDomainList.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () async {
                                              ProcessDomainProvider pdp = Provider.of(context, listen: false);
                                              pdp.setSelectedProcessId(storedProcessList[index].id);
                                              pdp.setSelectedProcessName(storedProcessList[index].name);
                                              // dp.setSelectedSubDomainName("");

                                              if (storedProcessList[index].SubProcesses == 0) {
                                                print("is this truuu ");
                                                pdp.getProcessTaskData(storedProcessList[index].id, 0);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => ProcessTaskList(
                                                              subProcessLable: storedProcessList[index].lable,
                                                              subProcessName: storedProcessList[index].name,
                                                            )));
                                              } else {
                                                print("elseeeeee  is this truuu ");
                                                pdp.getSubProcessData(storedProcessList[index].id);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => SubProcess(
                                                            // dmnName: storedDomainList[index].name,
                                                            )));
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10),
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: 1, color: Color.fromARGB(255, 219, 211, 211)))),
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
                                                                child: Text('${index + 1}',
                                                                    style: TextStyle(color: Colors.black)),
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
                                                                storedProcessList[index].lable == null
                                                                    ? "Process"
                                                                    : storedProcessList[index].lable,
                                                                // storedProcessList[index].SubDomains == 1
                                                                //     ? "${storedProcessList[index].Tasks} Task"
                                                                //     : "${storedProcessList[index].Tasks} Tasks",
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
                                                            storedProcessList[index].name,
                                                            // storedProcessList[index].name,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    new Spacer(),
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 8.0),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            child: Icon(
                                                              Icons.east,
                                                              size: 30,
                                                              color: _colorfromhex("#ABAFD1"),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  );
                      });
                    }))
          ],
        ),
      ),
    );
  }
}
