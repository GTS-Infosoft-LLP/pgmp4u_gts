import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/courseProvider.dart';
import '../tool/ShapeClipper.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  Widget build(BuildContext context) {
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
                      width: MediaQuery.of(context).size.width * .65,
                      child: Text(
                        "Subscription",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontFamily: "Roboto Regular",
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                  ],
                ),
              );
            }),
          ]),
        ],
      )),
    );
  }
}
