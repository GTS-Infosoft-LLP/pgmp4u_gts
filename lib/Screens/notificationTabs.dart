import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/profileProvider.dart';
import '../tool/ShapeClipper.dart';
import 'Profile/notifications.dart';

class NotificationTabs extends StatefulWidget {
  const NotificationTabs({Key key}) : super(key: key);

  @override
  State<NotificationTabs> createState() => _NotificationTabsState();
}

class _NotificationTabsState extends State<NotificationTabs>
// with SingleTickerProviderStateMixin
{
  // final _tabController = TabController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1, //optional, starts from 0, select the tab by default
      length: 2,
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
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
                            pp.tabIndex == 1 ? "Announcements" : "Notifications",
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
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  child: TabBar(
                    onTap: (vall) {
                      print("TAB INDEX $vall");
                      ProfileProvider pp = Provider.of(context, listen: false);
                      pp.setTabIndex(vall);
                    },
                    tabs: [
                      Tab(
                        text: "Notifications",
                      ),
                      Tab(
                        text: "Announcements",
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
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * .70,
                  child: Scaffold(
                    body: TabBarView(children: [
                      Notifications(),
                      Notifications()
                      // Announcements(),
                      // Container(
                      //   color: Colors.white,
                      //   height: 100,
                      // ),
                      // Container(
                      //   color: Colors.white,
                      //   height: 100,
                      // ),
                    ]),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
