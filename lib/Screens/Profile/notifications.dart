import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/profileProvider.dart';
import '../../tool/ShapeClipper.dart';
import '../../utils/app_color.dart';
import '../QuesOfDay.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  ScrollController scrollcontrol = ScrollController();

  @override
  bool _isShow = true;
  void initState() {
    ProfileProvider _dshbrdProvider = Provider.of(context, listen: false);
    _dshbrdProvider.showNotification(isFirstTime: true);
    scrollcontrol.addListener(() {
      if (scrollcontrol.position.pixels == scrollcontrol.position.maxScrollExtent) {
        print("call again api");
        _dshbrdProvider.showNotification();
      }
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Color(0xfff7f7f7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
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
                  padding: EdgeInsets.fromLTRB(20, 50, 0, 0),
                  child: Row(children: [
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
                      "Notifications",
                      style: TextStyle(
                          fontSize: 28, color: Colors.white, fontFamily: "Raleway", fontWeight: FontWeight.bold),
                    )),
                  ]),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Consumer<ProfileProvider>(builder: (context, profileProvider, child) {
                  return Container(
                    // color: Colors.amber,
                    height: MediaQuery.of(context).size.height * .8,
                    child: ListView.builder(
                        itemCount: profileProvider.NotificationData.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 18.0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: InkWell(
                                onTap: () {
                                  print("question id========${profileProvider.NotificationData[index].questionId}");
                                  var quesId = profileProvider.NotificationData[index].questionId;
                                  profileProvider.setNotifiId(profileProvider.NotificationData[index].id);

                                  // Future.delayed(Duration(milliseconds: 600), () {
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) => QuesOfDay(
                                  //                 seltedId: quesId,
                                  //               )));
                                  // });

                                  setState(() {
                                    _isShow = !_isShow;
                                  });
                                },
                                child: Container(
                                    width: MediaQuery.of(context).size.width * .7,
                                    decoration: BoxDecoration(
                                        // color: Colors.blue,
                                        border: Border(
                                      // top: BorderSide(width: 16.0, color: Colors.lightBlue.shade600),
                                      bottom: BorderSide(color: Colors.grey[300]),
                                    )),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8),
                                              color: index % 2 == 0 ? AppColor.purpule : AppColor.green,
                                              // gradient: LinearGradient(
                                              //     begin: Alignment.topLeft,
                                              //     end: Alignment.bottomRight,
                                              //     colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                                            ),

                                            // color: Colors.black,
                                            child: Icon(
                                              Icons.notifications_active,
                                              color: Colors.white,
                                            )
                                            // Icons.edit,color: Colors.white),
                                            ),
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
                                                // color: Colors.amber,
                                                child: Text(
                                                  profileProvider.NotificationData[index].title,
                                                  maxLines: 5,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(color: Colors.black, fontSize: 18),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            // _isShow?

                                            profileProvider.NotificationData[index].id ==
                                                    profileProvider.selectedNotifiId
                                                ? Container(
                                                    width: MediaQuery.of(context).size.width * .7,
                                                    child: Text(
                                                      profileProvider.NotificationData[index].message,
                                                      // maxLines: 2,
                                                      // overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(color: Colors.black, fontSize: 14),
                                                    ),
                                                  )
                                                : Container(
                                                    width: MediaQuery.of(context).size.width * .7,
                                                    child: Text(
                                                      profileProvider.NotificationData[index].message,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(color: Colors.black, fontSize: 14),
                                                    ),
                                                  ),
                                            // : Container(
                                            //     width: MediaQuery.of(context).size.width * .7,
                                            //     child: Text(
                                            //       profileProvider.NotificationData[index].message,
                                            //       style: TextStyle(color: Colors.black, fontSize: 14),
                                            //     ),
                                            //   ),

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
                        }),
                  );
                })
              ],
            ),
          )
        ],
      ),
    ));
  }
}
