import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Screens/MockTest/model/courseModel.dart';
import '../provider/Subscription/subscriptionPage.dart';

Widget HomeListTile(Color clr, BuildContext context, CourseDetails storedCourse) {
  return ListTile(
    leading: Container(
        height: 70,
        width: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: clr,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(FontAwesomeIcons.graduationCap, color: Colors.white),
        )),
    title: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          storedCourse.lable,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Text(
          storedCourse.course,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ],
    ),
    trailing: storedCourse.isSubscribed == 0
        ? InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Subscriptionpg()));
            },
            child: Chip(
                label: Text(
                  "Join",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                backgroundColor: Color(0xff3F9FC9)),
          )
        : Chip(
            label: Text(
              "Enrolled",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            backgroundColor: Color(0xff3F9FC9)),
  );
}
