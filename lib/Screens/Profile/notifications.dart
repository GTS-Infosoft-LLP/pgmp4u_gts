import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:pgmp4u/Screens/QuesOfDay.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../provider/courseProvider.dart';
import '../../provider/profileProvider.dart';
import '../../utils/app_color.dart';

class Notifications extends StatefulWidget {
  final type;
  int fromSplash;
  Notifications({Key key, this.type, this.fromSplash = 0}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  ScrollController scrollcontrol = ScrollController();
  bool _isShow = true;

  @override
  void initState() {
    _isShow = false;
    print("widget.type===========${widget.type}");
    CourseProvider cp = Provider.of(context, listen: false);
    if (cp.crsDropList.isNotEmpty) {
      cp.setSelectedCourseId(cp.crsDropList[0].id);
    }
    if (widget.type == 1) {
      CourseProvider cp = Provider.of(context, listen: false);
      // cp.setSelectedCourseId(null);
      ProfileProvider _dshbrdProvider = Provider.of(context, listen: false);
      _dshbrdProvider.showNotification(crsId: "", isFirstTime: false);
    }

    ProfileProvider _dshbrdProvider = Provider.of(context, listen: false);
    // _dshbrdProvider.Announcements = [];
    // _dshbrdProvider.Notifications = [];
    // _dshbrdProvider.NotificationData = [];

    scrollcontrol.addListener(() {
      print("controller is listeningggggg......");
      // _dshbrdProvider.updateLoader(true);
      if (scrollcontrol.position.pixels == scrollcontrol.position.maxScrollExtent) {
        if (_dshbrdProvider.totalRecords > _dshbrdProvider.NotificationData.length) {
          log("this is true has more data");
          EasyLoading.showToast("Scroll to load previous notifications");
        }
        print("call again api");
        CourseProvider cp = Provider.of(context, listen: false);
        _dshbrdProvider.showNotification(crsId: cp.selectedCourseId, isFirstTime: false).whenComplete(() {
          _dshbrdProvider.updateLoader(false);
        });
        // if (widget.type == 1) {
        //   _dshbrdProvider.showNotification(isFromAnn: 1);
        // } else {
        //   _dshbrdProvider.showNotification(crsId: cp.selectedCourseId);
        // }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollcontrol.removeListener(() {});
    scrollcontrol.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, pp, child) {
      return Scaffold(
          body: Container(
        color: Color(0xfff7f7f7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            context.watch<ProfileProvider>().notificationLoader
                ? Expanded(
                    flex: 8,
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  )
                : Expanded(
                    flex: 8,
                    child: Consumer<ProfileProvider>(builder: (context, profileProvider, child) {
                      return widget.type == 0
                          ? profileProvider.totalRecords == 0
                              ? Center(
                                  child: Text(
                                    "No Data Available",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  controller: scrollcontrol,
                                  itemCount: profileProvider.Notifications.length,
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return _notificationTile(profileProvider, index, context);
                                  })
                          : profileProvider.totalRecords == 0
                              ? Center(
                                  child: Text(
                                    "No Data Available",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  controller: scrollcontrol,
                                  itemCount: profileProvider.Announcements.length,
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return _announcmentsTile(profileProvider, index, context);
                                  });
                    }),
                  )
          ],
        ),
      ));
    });
  }

  Widget _notificationTile(ProfileProvider profileProvider, int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: InkWell(
          onTap: () {
            print("_isShow===========$_isShow");

            print("question id========${profileProvider.Notifications[index].questionId}");
            var quesId = profileProvider.Notifications[index].questionId;
            profileProvider.setNotifiId(profileProvider.Notifications[index].id);

            if (profileProvider.Notifications[index].type == 2) {
              // context.read<CourseProvider>().setMasterListType("Question");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuesOfDay(
                            seltedId: profileProvider.Notifications[index].questionId,
                          )));
            }

            if (profileProvider.Notifications[index].type == 1)
              showDialog(
                  context: context,
                  builder: (context) => NotiShowDialog(
                        notiDesc: profileProvider.Notifications[index].announcementDetails,
                        notiTitle: profileProvider.Notifications[index].title,
                      ));
          },
          child: Container(
              width: MediaQuery.of(context).size.width * .65,
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(color: Colors.grey[300]),
              )),
              child: Row(
                children: [
                  Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: index % 2 == 0 ? AppColor.purpule : AppColor.green,
                      ),
                      child: Icon(
                        Icons.notifications_active,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .6,
                        child: Row(
                          children: [
                            Container(
                              // color: Colors.amber,
                              width: MediaQuery.of(context).size.width * .55,
                              child: Text(
                                profileProvider.Notifications[index].title ?? '',
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontFamily: 'Roboto Medium', color: Colors.black, fontSize: 16),
                              ),
                            ),
                            Spacer(),
                            profileProvider.Notifications[index].type == 1
                                ? Icon(
                                    Icons.expand_more,
                                    // size: 12,
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                      profileProvider.Notifications[index].type == 2
                          ? Container(
                              width: MediaQuery.of(context).size.width * .65,
                              child: Text(
                                profileProvider.Notifications[index].courseName ?? '',
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontFamily: 'Roboto Medium', color: Colors.black54, fontSize: 16),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .7,
                        child: Text(
                          profileProvider.Notifications[index].message ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            profileProvider.Notifications[index].createdAt ?? '',
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontFamily: 'Roboto Medium', color: Colors.black54, fontSize: 13),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget _announcmentsTile(ProfileProvider profileProvider, int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: InkWell(
          onTap: () {
            // setState(() {
            //   _isShow = !_isShow;
            // });
            print("_isShow===========$_isShow");

            print("question id========${profileProvider.Announcements[index].questionId}");
            var quesId = profileProvider.Announcements[index].questionId;
            profileProvider.setNotifiId(profileProvider.Announcements[index].id);

            if (profileProvider.Announcements[index].type == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuesOfDay(
                            seltedId: profileProvider.Announcements[index].questionId,
                          )));
            }

            if (profileProvider.Announcements[index].type == 1)
              showDialog(
                  context: context,
                  builder: (context) => NotiShowDialog(
                        notiDesc: profileProvider.Announcements[index].announcementDetails,
                        notiTitle: profileProvider.Announcements[index].title,
                      ));
          },
          child: Container(
              width: MediaQuery.of(context).size.width * .7,
              decoration: BoxDecoration(
                  border: Border(
                // top: BorderSide(width: 16.0, color: Colors.lightBlue.shade600),
                bottom: BorderSide(color: Colors.grey[300]),
              )),
              child: Row(
                children: [
                  Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: index % 2 == 0 ? AppColor.purpule : AppColor.green,
                      ),
                      child: Icon(
                        Icons.notifications_active,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .7,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .5,
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * .63,
                                child: Text(
                                  profileProvider.Announcements[index].title ?? '',
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontFamily: 'Roboto Medium', color: Colors.black, fontSize: 16),
                                ),
                              ),
                              profileProvider.Announcements[index].type == 1
                                  ? Icon(
                                      Icons.expand_more,
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                      profileProvider.Announcements[index].type == 2
                          ? Container(
                              width: MediaQuery.of(context).size.width * .7,
                              child: Text(
                                profileProvider.Announcements[index].courseName ?? '',
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontFamily: 'Roboto Medium', color: Colors.black54, fontSize: 16),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .7,
                        child: Text(
                          profileProvider.Announcements[index].message ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        profileProvider.Announcements[index].createdAt ?? '',
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontFamily: 'Roboto Medium', color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget AnnounList() {
    ProfileProvider profileProvider = Provider.of(context, listen: false);
    return ListView.builder(
        controller: scrollcontrol,
        itemCount: profileProvider.Announcements.length,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: InkWell(
                onTap: () {
                  // setState(() {
                  //   _isShow = !_isShow;
                  // });
                  print("_isShow===========$_isShow");

                  print("question id========${profileProvider.Announcements[index].questionId}");
                  var quesId = profileProvider.Announcements[index].questionId;
                  profileProvider.setNotifiId(profileProvider.Announcements[index].id);

                  if (profileProvider.Announcements[index].type == 2) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuesOfDay(
                                  seltedId: profileProvider.Announcements[index].questionId,
                                )));
                  }

                  if (profileProvider.Announcements[index].type == 1)
                    showDialog(
                        context: context,
                        builder: (context) => NotiShowDialog(
                              notiDesc: profileProvider.Announcements[index].announcementDetails,
                              notiTitle: profileProvider.Announcements[index].title,
                            ));
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * .7,
                    decoration: BoxDecoration(
                        border: Border(
                      // top: BorderSide(width: 16.0, color: Colors.lightBlue.shade600),
                      bottom: BorderSide(color: Colors.grey[300]),
                    )),
                    child: Row(
                      children: [
                        Container(
                            height: 52,
                            width: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: index % 2 == 0 ? AppColor.purpule : AppColor.green,
                            ),
                            child: Icon(
                              Icons.notifications_active,
                              color: Colors.white,
                            )),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .7,
                              child: Container(
                                width: MediaQuery.of(context).size.width * .5,
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * .63,
                                      child: Text(
                                        profileProvider.Announcements[index].title ?? '',
                                        maxLines: 5,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            TextStyle(fontFamily: 'Roboto Medium', color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                    profileProvider.Announcements[index].type == 1
                                        ? Icon(
                                            Icons.expand_more,
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                            profileProvider.Announcements[index].type == 2
                                ? Container(
                                    width: MediaQuery.of(context).size.width * .7,
                                    child: Text(
                                      profileProvider.Announcements[index].courseName ?? '',
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          TextStyle(fontFamily: 'Roboto Medium', color: Colors.black54, fontSize: 16),
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .7,
                              child: Text(
                                profileProvider.Announcements[index].message ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.black87, fontSize: 14),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      ],
                    )),
              ),
            ),
          );
        });
  }

  Widget NotifiList() {
    ProfileProvider profileProvider = Provider.of(context, listen: false);

    return ListView.builder(
        controller: scrollcontrol,
        itemCount: profileProvider.Notifications.length,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: InkWell(
                onTap: () {
                  // setState(() {
                  //   _isShow = !_isShow;
                  // });
                  print("_isShow===========$_isShow");

                  print("question id========${profileProvider.Notifications[index].questionId}");
                  var quesId = profileProvider.Notifications[index].questionId;
                  profileProvider.setNotifiId(profileProvider.Notifications[index].id);

                  if (profileProvider.Notifications[index].type == 2) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuesOfDay(
                                  seltedId: profileProvider.Notifications[index].questionId,
                                )));
                  }

                  if (profileProvider.Notifications[index].type == 1)
                    showDialog(
                        context: context,
                        builder: (context) => NotiShowDialog(
                              notiDesc: profileProvider.Notifications[index].announcementDetails,
                              notiTitle: profileProvider.Notifications[index].title,
                            ));
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * .7,
                    decoration: BoxDecoration(
                        border: Border(
                      // top: BorderSide(width: 16.0, color: Colors.lightBlue.shade600),
                      bottom: BorderSide(color: Colors.grey[300]),
                    )),
                    child: Row(
                      children: [
                        Container(
                            height: 52,
                            width: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: index % 2 == 0 ? AppColor.purpule : AppColor.green,
                            ),
                            child: Icon(
                              Icons.notifications_active,
                              color: Colors.white,
                            )),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * .63,
                                    child: Text(
                                      profileProvider.Notifications[index].title ?? '',
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontFamily: 'Roboto Medium', color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                  profileProvider.Notifications[index].type == 1
                                      ? Icon(
                                          Icons.expand_more,
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                            profileProvider.Notifications[index].type == 2
                                ? Container(
                                    width: MediaQuery.of(context).size.width * .7,
                                    child: Text(
                                      profileProvider.Notifications[index].courseName ?? '',
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          TextStyle(fontFamily: 'Roboto Medium', color: Colors.black54, fontSize: 16),
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .7,
                              child: Text(
                                profileProvider.Notifications[index].message ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.black87, fontSize: 14),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      ],
                    )),
              ),
            ),
          );
        });
  }
}

// class notiShowDialog {

// }
class NotiShowDialog extends StatelessWidget {
  String notiDesc;
  String notiTitle;
  NotiShowDialog({Key key, this.notiDesc, this.notiTitle});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notiTitle,
                style: TextStyle(fontFamily: 'Roboto MediumItalic', color: Colors.black, fontSize: 18),
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 5,
              ),
              Html(
                data: notiDesc,
                onAnchorTap: (url, ctx, attributes, element) async {
                  print("anchor url : $url");

                  Uri uri = Uri.parse(url);
                  if (await canLaunchUrlString(url)) {
                    await launchUrlString(url, mode: LaunchMode.externalApplication);
                  } else {
                    GFToast.showToast(
                      "Can not launch this url",
                      context,
                      toastPosition: GFToastPosition.BOTTOM,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
