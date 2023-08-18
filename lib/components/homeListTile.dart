import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Screens/MockTest/model/courseModel.dart';

Widget HomeListTile(Color clr, BuildContext context, CourseDetails storedCourse) {
  return ListTile(
    leading: Container(
        // color: Colors.blueAccent,
        height: 80,
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
              // Navigator.push(context, MaterialPageRoute(builder: (context) => Subscriptionpg()));
            },
            child: Container(
              height: 80,
              // color: Colors.amber,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 30,
                    child: Chip(
                        label: Text(
                          "Join",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: Color(0xff3F9FC9)),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  // Text("Platinum")
                ],
              ),
            ),
          )
        : Container(
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 35,
                  child: Chip(
                      label: Text(
                        "Enrolled",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      backgroundColor: Color(0xff3F9FC9)),
                ),
                SizedBox(
                  height: 5,
                ),
                storedCourse.subscriptionType == 1
                    ? Text("Silver",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ))
                    : storedCourse.subscriptionType == 2
                        ? Text("Gold",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ))
                        : storedCourse.subscriptionType == 3
                            ? Text("Platinum",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ))
                            : storedCourse.subscriptionType == 4
                                ? Text("3 Days Trial",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ))
                                : Text("")
              ],
            ),
          ),
  );
}
