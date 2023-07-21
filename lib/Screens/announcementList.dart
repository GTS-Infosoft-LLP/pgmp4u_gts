// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:pgmp4u/provider/profileProvider.dart';
// import 'package:provider/provider.dart';

// import '../utils/app_color.dart';
// import 'Profile/notifications.dart';
// import 'QuesOfDay.dart';

// class Announcements extends StatefulWidget {
//   const Announcements({Key key}) : super(key: key);

//   @override
//   State<Announcements> createState() => _AnnouncementsState();
// }

// class _AnnouncementsState extends State<Announcements> {
//     ScrollController scrollcontrol = ScrollController();
//   bool _isShow = true;


// @override
//   void initState() {
//         _isShow = false;
//     ProfileProvider _dshbrdProvider = Provider.of(context, listen: false);
//     _dshbrdProvider.showNotification(isFirstTime: true);

//     scrollcontrol.addListener(() {
//       print("controller is listeningggggg......");
//       if (scrollcontrol.position.pixels == scrollcontrol.position.maxScrollExtent) {
//         print("call again api");
//         _dshbrdProvider.showNotification();
//       }
//     });

  
//     super.initState();
//   }
//   @override
//   void dispose() {
//     scrollcontrol.removeListener(() {});
//     scrollcontrol.dispose();
//     super.dispose();
//   }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//        body: Container(
//          color: Color(0xfff7f7f7),
//          child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//            context.watch<ProfileProvider>().notificationLoader?
//            Expanded(
//                   flex: 8,
//                   child: Center(child: CircularProgressIndicator.adaptive()),
//                 ):
//                 Expanded(
//                   flex: 8,
//                   child: Consumer<ProfileProvider>(builder: (context, profileProvider, child) {
//                     return ListView.builder(
//                         controller: scrollcontrol,
//                         itemCount: profileProvider.Announcements.length,
//                         physics: BouncingScrollPhysics(),
//                         shrinkWrap: true,
//                         itemBuilder: (context, index) {
//                           return Padding(
//                             padding: const EdgeInsets.only(bottom: 18.0),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                               child: InkWell(
//                                 onTap: () {
//                                   // setState(() {
//                                   //   _isShow = !_isShow;
//                                   // });
//                                   print("_isShow===========$_isShow");

//                                   print("question id========${profileProvider.Announcements[index].questionId}");
//                                   var quesId = profileProvider.Announcements[index].questionId;
//                                   profileProvider.setNotifiId(profileProvider.Announcements[index].id);

//                                   if (profileProvider.Announcements[index].type == 2) {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => QuesOfDay(
//                                                   seltedId: profileProvider.Announcements[index].questionId,
//                                                 )));
//                                   }

//                                   if (profileProvider.Announcements[index].type == 1)
//                                     showDialog(
//                                         context: context,
//                                         builder: (context) => NotiShowDialog(
//                                               notiDesc: profileProvider.Announcements[index].announcementDetails,
//                                               notiTitle: profileProvider.Announcements[index].title,
//                                             ));
//                                 },
//                                 child: Container(
//                                     width: MediaQuery.of(context).size.width * .7,
//                                     decoration: BoxDecoration(
//                                         border: Border(
//                                       // top: BorderSide(width: 16.0, color: Colors.lightBlue.shade600),
//                                       bottom: BorderSide(color: Colors.grey[300]),
//                                     )),
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                             height: 52,
//                                             width: 52,
//                                             decoration: BoxDecoration(
//                                               borderRadius: BorderRadius.circular(8),
//                                               color: index % 2 == 0 ? AppColor.purpule : AppColor.green,
//                                             ),
//                                             child: Icon(
//                                               Icons.notifications_active,
//                                               color: Colors.white,
//                                             )),
//                                         SizedBox(
//                                           width: 15,
//                                         ),
//                                         Column(
//                                           mainAxisAlignment: MainAxisAlignment.start,
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Container(
//                                               width: MediaQuery.of(context).size.width * .7,
//                                               child: Container(
//                                                 width: MediaQuery.of(context).size.width * .5,
//                                                 child: Row(
//                                                   children: [
//                                                     Container(
//                                                       width: MediaQuery.of(context).size.width * .63,
//                                                       child: Text(
//                                                         profileProvider.Announcements[index].title ?? '',
//                                                         maxLines: 5,
//                                                         overflow: TextOverflow.ellipsis,
//                                                         style: TextStyle(
//                                                             fontFamily: 'Roboto Medium',
//                                                             color: Colors.black,
//                                                             fontSize: 16),
//                                                       ),
//                                                     ),
//                                                     profileProvider.Announcements[index].type == 1
//                                                         ? Icon(
//                                                             Icons.expand_more,
//                                                           )
//                                                         : SizedBox(),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                             profileProvider.Announcements[index].type == 2
//                                                 ? Container(
//                                                     width: MediaQuery.of(context).size.width * .7,
//                                                     child: Text(
//                                                       profileProvider.Announcements[index].courseName ?? '',
//                                                       maxLines: 5,
//                                                       overflow: TextOverflow.ellipsis,
//                                                       style: TextStyle(
//                                                           fontFamily: 'Roboto Medium',
//                                                           color: Colors.black54,
//                                                           fontSize: 16),
//                                                     ),
//                                                   )
//                                                 : SizedBox(),
//                                             SizedBox(
//                                               height: 5,
//                                             ),
//                                             Container(
//                                               width: MediaQuery.of(context).size.width * .7,
//                                               child: Text(
//                                                 profileProvider.Announcements[index].message ?? '',
//                                                 maxLines: 2,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: TextStyle(color: Colors.black87, fontSize: 14),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                           ],
//                                         )
//                                       ],
//                                     )),
//                               ),
//                             ),
//                           );
//                         });
                        
//                   }),
//                 )

//           ],
//          ),
//        )
//     );
//   }
// }