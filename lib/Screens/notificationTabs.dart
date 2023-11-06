import 'package:flutter/material.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:provider/provider.dart';

import '../provider/profileProvider.dart';
import '../tool/ShapeClipper.dart';
import 'MockTest/model/courseModel.dart';
import 'Profile/notifications.dart';
import 'dropdown.dart';

class NotificationTabs extends StatefulWidget {
  int fromSplash;
  NotificationTabs({Key key, this.fromSplash = 0}) : super(key: key);

  @override
  State<NotificationTabs> createState() => _NotificationTabsState();
}

class _NotificationTabsState extends State<NotificationTabs> with TickerProviderStateMixin {
  TabController _controller;
  ProfileProvider _dshbrdProvider;
  // final _tabController = TabController();
  @override
  void initState() {
    CourseProvider cp = Provider.of(context, listen: false);
    cp.setSelectedNotiCrsLable(null);

    // TODO: implement initState
    super.initState();
    _dshbrdProvider = Provider.of(context, listen: false);
    _dshbrdProvider.showNotification(isFirstTime: true);
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _dshbrdProvider.resetPageIndex();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        initialIndex: 1, //optional, starts from 0, select the tab by default
        length: 2,
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
              Consumer<ProfileProvider>(builder: (context, pp, child) {
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
                                    print("widget.fromSplash:::${widget.fromSplash}");
                                    if (widget.fromSplash == 1) {
                                      Navigator.pop(context);
                                      // Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (r) => false);
                                    } else {
                                      Navigator.pop(context);
                                    }
                                    // Navigator.pop(context);
                                  }))),
                      SizedBox(width: 20),
                      Center(
                          child: Container(
                              // color: Colors.amber,
                              width: MediaQuery.of(context).size.width * .65,
                              child: RichText(
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                    text: _controller.index == 1 ? "Notifications" : "Announcements",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Roboto"),
                                  )
                                ]),
                              )
                              //  Text(
                              //   _controller.index == 1 ? "Notifications" : "Announcements",
                              //   maxLines: 2,
                              //   overflow: TextOverflow.ellipsis,
                              //   style: TextStyle(
                              //       fontSize: 22, color: Colors.white, fontFamily: "Roboto", fontWeight: FontWeight.bold),
                              // ),

                              )),
                    ],
                  ),
                );
              }),
            ]),
            SizedBox(height: 20),
            Center(
              child: Consumer<CourseProvider>(builder: (context, cp, child) {
                return Container(
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width * .35,
                  child: CustomDropDown<CourseDetails>(
                    selectText: cp.notiSelectCrsLable ?? "Select",
                    itemList: cp.course ?? [],
                    isEnable: true,
                    title: "",
                    value: null,
                    onChange: (val) {
                      print("val.course=========>${val.course}");
                      print("val.course=========>${val.lable}");
                      cp.setSelectedNotiCrsLable(val.lable);
                      cp.setSelectedCourseLable(val.lable);
                      cp.setSelectedCourseId(val.id);
                      ProfileProvider pp = Provider.of(context, listen: false);
                      pp.showNotification(crsId: cp.selectedCourseId);
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TabBar(
                controller: _controller,
                onTap: (vall) {
                  print("_controller====${_controller.index}");
                  print("TAB INDEX $vall");
                  context.read<ProfileProvider>().setTabIndex(vall);
                },
                tabs: [
                  Tab(
                    text: "Announcements",
                  ),
                  Tab(
                    text: "Notifications",
                  ),
                ],
                unselectedLabelStyle: TextStyle(fontSize: 16, color: Colors.black),
                labelStyle: TextStyle(fontSize: 16, color: Colors.black),
                unselectedLabelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Color(0xff3643a3),
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TabBarView(controller: _controller, children: [
                  Notifications(type: 1, fromSplash: widget.fromSplash),
                  Notifications(type: 0, fromSplash: widget.fromSplash),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
