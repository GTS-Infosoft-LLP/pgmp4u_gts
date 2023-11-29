import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pgmp4u/Process/processDomainProvider.dart';
import 'package:pgmp4u/Process/processTaskList.dart';
import 'package:pgmp4u/Process/subprocess_model.dart';
import 'package:provider/provider.dart';

import '../Screens/Tests/local_handler/hive_handler.dart';
import '../provider/courseProvider.dart';
import '../tool/ShapeClipper.dart';
import '../utils/app_color.dart';

class SubProcess extends StatefulWidget {
  const SubProcess({Key key}) : super(key: key);

  @override
  State<SubProcess> createState() => _SubProcessState();
}

class _SubProcessState extends State<SubProcess> {
  //  List<SubDomainDetails> storedSubDomainList = [];
  List storedSubProcessList = [];

  void initState() {
    super.initState();
  }

  @override
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
                        child: Container(
                          width: MediaQuery.of(context).size.width * .8,
                          child: Text(
                            "SubProcess",
                            // cp.selectedCourseName,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 22, color: Colors.white, fontFamily: "Roboto", fontWeight: FontWeight.bold),
                          ),
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
                "Process Name",
                // widget.dmnName,
                maxLines: 2,
                style: TextStyle(
                  fontFamily: 'Roboto Regular',
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              child: ValueListenableBuilder<Box<String>>(
                  valueListenable: HiveHandler.getSubProcessDetailListener(),
                  builder: (context, value, child) {
                    ProcessDomainProvider pdp = Provider.of(context, listen: false);
                    print("dp.selectedDomainId>>>>>>>> ${pdp.selectedProcessId}");

                    if (value.containsKey(pdp.selectedProcessId.toString())) {
                      print("not inside this condition");
                      List subProcessDetailList = jsonDecode(value.get(pdp.selectedProcessId.toString()));
                      storedSubProcessList = subProcessDetailList.map((e) => SubProcessDetails.fromjson(e)).toList();
                      print("storedSubProcessList:::::: $storedSubProcessList");
                    } else {
                      print("else condutoin is true..");
                      storedSubProcessList = [];
                    }
                    if (storedSubProcessList == null) {
                      storedSubProcessList = [];
                    }

                    return Consumer<ProcessDomainProvider>(builder: (context, pdp, child) {
                      return pdp.subProcessApiCall
                          ? Container(
                              height: MediaQuery.of(context).size.height * .60,
                              child: Center(child: CircularProgressIndicator.adaptive()))
                          : storedSubProcessList.length == 0
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
                                      itemCount:
                                          // 5,
                                          storedSubProcessList.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () async {
                                            ProcessDomainProvider pdp = Provider.of(context, listen: false);
                                            pdp.setSelectedSubProcessId(storedSubProcessList[index].id);
                                            // dp.setSelectedSubDomainName(storedSubProcessList[index].name);
                                            print("selected doadfdfmin id====${storedSubProcessList[index].id}");
                                            print("selected process id====${pdp.selectedProcessId}");

                                            pdp.getProcessTaskData(
                                                pdp.selectedProcessId, storedSubProcessList[index].id);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => ProcessTaskList(
                                                          subProcessLable: storedSubProcessList[index].lable,
                                                          subProcessName: storedSubProcessList[index].name,
                                                        )));
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
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              "sub-process task",
                                                              // storedSubProcessList[index].Tasks == 1 ||
                                                              //         storedSubProcessList[index].Tasks == 0
                                                              //     ? "${storedSubProcessList[index].Tasks} task "
                                                              //     : "${storedSubProcessList[index].Tasks} tasks ",
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
                                                          "sub process name",
                                                          // storedSubProcessList[index].name,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // new Spacer(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                );
                    });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
