import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pgmp4u/Screens/QuesOfDay.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../provider/profileProvider.dart';
import '../../tool/ShapeClipper.dart';
import '../../utils/app_color.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  ScrollController scrollcontrol = ScrollController();
  bool _isShow = true;

  @override
  void initState() {
    _isShow = false;
    ProfileProvider _dshbrdProvider = Provider.of(context, listen: false);
    _dshbrdProvider.showNotification(isFirstTime: true);

    scrollcontrol.addListener(() {
      print("controller is listeningggggg......");
      if (scrollcontrol.position.pixels == scrollcontrol.position.maxScrollExtent) {
        print("call again api");
        _dshbrdProvider.showNotification();
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
    return Scaffold(
        body: Container(
      color: Color(0xfff7f7f7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
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
                Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Row(
                      children: [
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
                        SizedBox(
                          width: 20,
                        ),
                        Center(
                            child: Text(
                          // "Video Library",
                          "Announcements",
                          style: TextStyle(
                              fontSize: 28, color: Colors.white, fontFamily: "Raleway", fontWeight: FontWeight.bold),
                        )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          context.watch<ProfileProvider>().notificationLoader
              ? Expanded(
                  flex: 8,
                  child: Center(child: CircularProgressIndicator.adaptive()),
                )
              : Expanded(
                  flex: 8,
                  child: Consumer<ProfileProvider>(builder: (context, profileProvider, child) {
                    return ListView.builder(
                        controller: scrollcontrol,
                        itemCount: profileProvider.NotificationData.length,
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

                                  print("question id========${profileProvider.NotificationData[index].questionId}");
                                  var quesId = profileProvider.NotificationData[index].questionId;
                                  profileProvider.setNotifiId(profileProvider.NotificationData[index].id);

                                  if (profileProvider.NotificationData[index].type == 2) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => QuesOfDay(
                                                  seltedId: profileProvider.NotificationData[index].questionId,
                                                )));
                                  }

                                  if (profileProvider.NotificationData[index].type == 1)
                                    showDialog(
                                        context: context,
                                        builder: (context) => NotiShowDialog(
                                              notiDesc: profileProvider.NotificationData[index].announcementDetails,
                                              notiTitle: profileProvider.NotificationData[index].title,
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
                                                        profileProvider.NotificationData[index].title ?? '',
                                                        maxLines: 5,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                            fontFamily: 'Roboto Medium',
                                                            color: Colors.black,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                    profileProvider.NotificationData[index].type == 1
                                                        ? Icon(
                                                            Icons.expand_more,
                                                          )
                                                        : SizedBox(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            profileProvider.NotificationData[index].type == 2
                                                ? Container(
                                                    width: MediaQuery.of(context).size.width * .7,
                                                    child: Text(
                                                      profileProvider.NotificationData[index].courseName ?? '',
                                                      maxLines: 5,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto Medium',
                                                          color: Colors.black54,
                                                          fontSize: 16),
                                                    ),
                                                  )
                                                : SizedBox(),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width * .7,
                                              child: Text(
                                                profileProvider.NotificationData[index].message ?? '',
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
                  }),
                )
        ],
      ),
    ));
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
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    GFToast.showToast(
                      "Can not launch this url",
                      context,
                      toastPosition: GFToastPosition.BOTTOM,
                    );
                  }
                },
                // onLinkTap: (url, ctx, attributes, element) async {
                //   print(url);
                //   Uri uri = Uri.parse(url);
                //   if (await canLaunchUrl(uri)) {
                //     await launchUrl(uri);
                //   } else {
                //     GFToast.showToast(
                //       "Can not launch this url",
                //       context,
                //       toastPosition: GFToastPosition.BOTTOM,
                //     );
                //   }
                // },
                // style: {
                //   "body": Style(
                //       // padding: EdgeInsets.only(top: 5),
                //       // margin: EdgeInsets.zero,
                //       // color: Color(0xff000000),
                //       // textAlign: TextAlign.left,
                //       // fontSize: FontSize(18),
                //       )
                // },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
