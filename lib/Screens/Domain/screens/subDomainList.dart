import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pgmp4u/Screens/Domain/screens/tasksList.dart';
import 'package:pgmp4u/tool/ShapeClipper.dart';
import 'package:provider/provider.dart';

import '../../../provider/courseProvider.dart';
import '../../../utils/app_color.dart';
import '../../Tests/local_handler/hive_handler.dart';
import 'Models/subDomainModel.dart';
import 'domainProvider.dart';

class SubDomain extends StatefulWidget {
  final dmnName;
  SubDomain({Key key, this.dmnName}) : super(key: key);

  @override
  State<SubDomain> createState() => _SubDomainState();
}

class _SubDomainState extends State<SubDomain> {
  @override
  Color clr;
  List<SubDomainDetails> storedSubDomainList = [];
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
                        child: Container(
                          width: MediaQuery.of(context).size.width * .8,
                          child: Text(
                            "Subdomain",
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
                widget.dmnName,
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
                    valueListenable: HiveHandler.getsubDomainDetailListener(),
                    builder: (context, value, child) {
                      print("is this even working...?");
                      DomainProvider dp = Provider.of(context, listen: false);
                      if (value.containsKey(dp.selectedDomainId.toString())) {
                        print("not inside this condition");
                        List subDomainDetailList = jsonDecode(value.get(dp.selectedDomainId.toString()));
                        storedSubDomainList = subDomainDetailList.map((e) => SubDomainDetails.fromjson(e)).toList();
                        print("storedSubDomainList:::::: $storedSubDomainList");
                      } else {
                        print("else condutoin is true..");
                        storedSubDomainList = [];
                      }
                      if (storedSubDomainList == null) {
                        storedSubDomainList = [];
                      }
                      return Consumer<DomainProvider>(builder: (context, dp, child) {
                        return dp.subDomainApiCall
                            ? Container(
                                height: MediaQuery.of(context).size.height * .60,
                                child: Center(child: CircularProgressIndicator.adaptive()))
                            : storedSubDomainList.length == 0
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
                                        itemCount: storedSubDomainList.length,
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
                                              dp.setSelectedSubDomainId(storedSubDomainList[index].id);
                                              dp.setSelectedSubDomainName(storedSubDomainList[index].name);
                                              print("selected doadfdfmin id====${storedSubDomainList[index].id}");
                                              print("selected doamin id====${dp.selectedDomainId}");

                                              dp.getTasksData(dp.selectedDomainId, storedSubDomainList[index].id);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => TaskList(
                                                            subDomainName: storedSubDomainList[index].name,
                                                            subDomainLable: storedSubDomainList[index].lable,
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
                                                          // color: Colors.amber,
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                storedSubDomainList[index].Tasks == 1 ||
                                                                        storedSubDomainList[index].Tasks == 0
                                                                    ? "${storedSubDomainList[index].Tasks} task "
                                                                    : "${storedSubDomainList[index].Tasks} tasks ",
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
                                                            storedSubDomainList[index].name,
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
                    }))
          ],
        ),
      ),
    );
  }
}
