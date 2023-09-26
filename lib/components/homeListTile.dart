// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:pgmp4u/Screens/masterPage.dart';
// import 'package:pgmp4u/provider/courseProvider.dart';
// import 'package:provider/provider.dart';

// import '../Screens/MockTest/model/courseModel.dart';
// import '../provider/Subscription/subscriptionPage.dart';
// import '../provider/Subscription/subscriptionProvider.dart';
// import '../provider/profileProvider.dart';

// Widget HomeListTile(Color clr, BuildContext context, CourseDetails storedCourse) {
//   return ListTile(
//     leading: Container(
//         // color: Colors.blueAccent,
//         height: 80,
//         width: 65,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           color: clr,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Icon(FontAwesomeIcons.graduationCap, color: Colors.white),
//         )),
//     title: Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           storedCourse.lable,
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey,
//           ),
//         ),
//         Text(
//           storedCourse.course,
//           style: TextStyle(
//             fontSize: 18,
//             color: Colors.black,
//           ),
//         ),
//       ],
//     ),
//     trailing: storedCourse.isSubscribed == 0
//         ? InkWell(
//             onTap: () {
//               // Navigator.push(context, MaterialPageRoute(builder: (context) => Subscriptionpg()));
//             },
//             child: Container(
//               height: 80,
//               // color: Colors.amber,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   InkWell(
//                      onTap: () async {
//                       CourseProvider courseProvider=Provider.of(context, listen: false);
//                                                               Future.delayed(const Duration(seconds: 5), () {
//                                                                 courseProvider.setFloatButton(1);
//                                                               });
//                                                               print(
//                                                                   "isSubscribedd::: ${storedCourse[index].isSubscribed}");
//                                                               courseProvider.setSelectedPlanType(
//                                                                   storedCourse[index].subscriptionType);
//                                                               ProfileProvider pp = Provider.of(context, listen: false);
//                                                               pp.updateLoader(true);
//                                                               courseProvider
//                                                                   .setSelectedCourseId(storedCourse[index].id);
//                                                               courseProvider
//                                                                   .setSelectedCourseName(storedCourse[index].course);
//                                                               courseProvider
//                                                                   .setSelectedCourseLable(storedCourse[index].lable);

//                                                               if (storedCourse[index].isSubscribed == 0) {
//                                                                 pp.updateLoader(false);
//                                                                 pp.setSelectedContainer(2);
//                                                                 SubscriptionProvider sp =
//                                                                     Provider.of(context, listen: false);
//                                                                 sp.SelectedPlanType = 3;
//                                                                 await sp.setSelectedDurTimeQt(0, 0, isFirtTime: 1);
//                                                                 sp.setSelectedIval(2);
//                                                                 if (sp.durationPackData.isNotEmpty) {
//                                                                   sp.setSelectedRadioVal(0);
//                                                                 }
//                                                                 sp.selectedIval = 2;
//                                                                 // await sp.getSubscritionData(storedCourse[index].id);

//                                                                 Future.delayed(const Duration(milliseconds: 4), () {
//                                                                   sp.setSelectedIval(2);
//                                                                   pp.setSelectedContainer(2);
//                                                                   if (sp.durationPackData.isNotEmpty) {
//                                                                     sp.setSelectedRadioVal(0);
//                                                                   }
//                                                                   sp.selectedIval = 2;
//                                                                   print("sp.selectedIval::${sp.selectedIval}");
//                                                                   Navigator.push(
//                                                                       context,
//                                                                       MaterialPageRoute(
//                                                                           builder: (context) => Subscriptionpg(
//                                                                                 showDrpDown: 0,
//                                                                                 showFreeTrial: 0,
//                                                                               )));
//                                                                 });
//                                                               } else {
//                                                                 pp.updateLoader(false);
//                                                                 courseProvider.getMasterData(storedCourse[index].id);
//                                                                 Future.delayed(const Duration(milliseconds: 100), () {
//                                                                   Navigator.push(
//                                                                       context,
//                                                                       MaterialPageRoute(
//                                                                           builder: (context) => MasterListPage()));
//                                                                 });
//                                                               }
//                                                               pp.updateLoader(false);
//                                                               Future.delayed(const Duration(seconds: 5), () {
//                                                                 courseProvider.setFloatButton(1);
//                                                               });
//                                                             },
//                     child: Container(
//                       height: 30,
//                       child: Chip(
//                           label: Text(
//                             "Join",
//                             style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//                           ),
//                           backgroundColor: Color(0xff3F9FC9)),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   // Text("Platinum")
//                 ],
//               ),
//             ),
//           )
//         : Container(
//             height: 80,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Container(
//                   height: 35,
//                   child: Chip(
//                       label: Text(
//                         "Enrolled",
//                         style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
//                       ),
//                       backgroundColor: Color(0xff3F9FC9)),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 storedCourse.subscriptionType == 1
//                     ? Text("Silver",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 13,
//                         ))
//                     : storedCourse.subscriptionType == 2
//                         ? Text("Gold",
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 13,
//                             ))
//                         : storedCourse.subscriptionType == 3
//                             ? Text("Platinum",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 13,
//                                 ))
//                             : storedCourse.subscriptionType == 4
//                                 ? Text("3 Days Trial",
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 13,
//                                     ))
//                                 : Text("")
//               ],
//             ),
//           ),
//   );
// }
