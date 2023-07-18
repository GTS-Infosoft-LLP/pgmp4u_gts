import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/Domain/screens/taskDetails.dart';
import 'package:pgmp4u/tool/ShapeClipper.dart';
import 'package:provider/provider.dart';

import 'domainProvider.dart';

class SubDomain extends StatefulWidget {
  const SubDomain({Key key}) : super(key: key);

  @override
  State<SubDomain> createState() => _SubDomainState();
}

class _SubDomainState extends State<SubDomain> {
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
                      Center(
                          child: Container(
                        // color: Colors.amber,
                        width: MediaQuery.of(context).size.width * .65,
                        child: Text(
                          "Sub Domains",
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
                "Domain Name",
                // cp.pptCategoryList[index].name,
                maxLines: 2,
                style: TextStyle(
                  fontFamily: 'Roboto Regular',
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            Consumer<DomainProvider>(builder: (context, dp, child) {
              return dp.subDomainApiCall
                  ? Container(
                      height: MediaQuery.of(context).size.height * .60,
                      child: Center(child: CircularProgressIndicator.adaptive()))
                  : Container(
                      height: MediaQuery.of(context).size.height * .70,
                      // width: MediaQuery.of(context).size.width * .95,
                      child: ListView.builder(
                          itemCount: dp.SubDomainList.length,
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
                                dp.setSelectedSubDomainId(dp.SubDomainList[index].id);
                                print("selected doadfdfmin id====${dp.SubDomainList[index].id}");
                                print("selected doamin id====${dp.selectedDomainId}");
                                dp.getTasksData(dp.SubDomainList[index].id);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetail()));
                                // print("cp.pptCategoryList===========${cp.pptCategoryList[index].id}");

                                // await cp.getPpt(cp.pptCategoryList[index].id);

                                // var pptPayStat = await cp.successValuePPT;
                                // print("pptPayStat======$pptPayStat");
                                // print("cp.pptCategoryList[index]====${cp.pptCategoryList[index].price}");
                                // if (pptPayStat == false) {
                                //   Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) => RandomPage(
                                //                 categoryId: cp.pptCategoryList[index].id,
                                //                 price: cp.pptCategoryList[index].price,
                                //                 index: 5,
                                //               )));
                                // } else {
                                //   // Navigator.push(
                                //   //     context,
                                //   //     MaterialPageRoute(
                                //   //         builder: (context) => PPTData(
                                //   //               title: cp.pptCategoryList[index].name,
                                //   //             )));
                                // }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 10),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(width: 1, color: Color.fromARGB(255, 219, 211, 211)))),
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
                                            decoration:
                                                BoxDecoration(borderRadius: BorderRadius.circular(10), color: clr
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
                                                  child: Text('${index + 1}',
                                                      style: TextStyle(color: Colors.white, fontSize: 18)),
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
                                                  dp.SubDomainList[index].Tasks == 1 ||
                                                          dp.SubDomainList[index].Tasks == 0
                                                      ? "${dp.SubDomainList[index].Tasks} task available"
                                                      : "${dp.SubDomainList[index].Tasks} tasks available",
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
                                              dp.SubDomainList[index].name,
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
                                      new Spacer(),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(right: 8.0),
                                      //   child: Column(
                                      //     mainAxisAlignment: MainAxisAlignment.center,
                                      //     children: [
                                      //       Text(
                                      //         "Premium",
                                      //         // "",
                                      //         // cp.pptCategoryList[index].paymentStatus == 1 ? "Premium" : "",
                                      //         style: TextStyle(
                                      //           fontSize: 14,
                                      //           color: Colors.black,
                                      //         ),
                                      //       ),
                                      //       Container(
                                      //         child: Icon(
                                      //           Icons.east,
                                      //           size: 30,
                                      //           color: _colorfromhex("#ABAFD1"),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
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
