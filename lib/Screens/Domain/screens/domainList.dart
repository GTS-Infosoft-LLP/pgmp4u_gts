import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pgmp4u/Screens/Domain/screens/Models/domainModel.dart';
import 'package:pgmp4u/Screens/Domain/screens/subDomainList.dart';
import 'package:pgmp4u/Screens/Domain/screens/tasksList.dart';
import 'package:pgmp4u/tool/ShapeClipper.dart';

import 'package:provider/provider.dart';

import '../../../provider/courseProvider.dart';
import '../../../utils/app_color.dart';
import '../../Tests/local_handler/hive_handler.dart';
import 'domainProvider.dart';

class DomainList extends StatefulWidget {
  String domainName;
  DomainList({Key key, this.domainName}) : super(key: key);

  @override
  State<DomainList> createState() => _DomainListState();
}

class _DomainListState extends State<DomainList> {
  @override
  Color clr;
  List<DomainDetails> storedDomainList = [];
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
                  valueListenable: HiveHandler.getDomainDetailListener(),
                  builder: (context, value, child) {
                    CourseProvider cp = Provider.of(context, listen: false);
                    if (value.containsKey(cp.selectedMasterId.toString())) {
                      List domainDetailList = jsonDecode(value.get(cp.selectedMasterId.toString()));
                      storedDomainList = domainDetailList.map((e) => DomainDetails.fromjson(e)).toList();
                      print("storedDomainList:::::: $storedDomainList");
                    } else {
                      storedDomainList = [];
                    }
                    if (storedDomainList == null) {
                      storedDomainList = [];
                    }

                    return Consumer<DomainProvider>(builder: (context, dp, child) {
                      return dp.domainApiCall
                          ? Container(
                              height: MediaQuery.of(context).size.height * .6,
                              child: Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            )
                          : storedDomainList.length == 0
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
                                      itemCount: storedDomainList.length,
                                      itemBuilder: (context, index) {
                                        if (index % 5 == 0) {
                                          clr = Color(0xff9953C1);
                                        } else if (index % 4 == 0) {
                                          clr = Color(0xff3F9FC9);
                                        } else if (index % 3 == 0) {
                                          clr = Color(0xff3FC964);
                                        } else if (index % 2 == 0) {
                                          clr = Color(0xffC93F7F);
                                        } else {
                                          clr = Color(0xffDE682B);
                                        }

                                        return InkWell(
                                          onTap: () async {
                                            print("storedDomainList[index].name====${storedDomainList[index].name}");
                                            dp.setSelectedDomainId(storedDomainList[index].id);
                                            dp.setSelectedDomainName(storedDomainList[index].name);
                                            dp.setSelectedSubDomainName("");

                                            if (storedDomainList[index].SubDomains == 0) {
                                              dp.getTasksData(storedDomainList[index].id, "");
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => TaskList(
                                                            subDomainName: "",
                                                          )));
                                            } else {
                                              dp.getSubDomainData(storedDomainList[index].id);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => SubDomain(
                                                            dmnName: storedDomainList[index].name,
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
                                                              storedDomainList[index].SubDomains == 1
                                                                  ? "${storedDomainList[index].Tasks} Task"
                                                                  : "${storedDomainList[index].Tasks} Tasks",
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
                                                          storedDomainList[index].name,
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

                    // );
                  }))
        ],
      )),
    );
  }
}
