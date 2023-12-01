import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget customGreyRedRow(IconData icn, String txt, BuildContext context, String planType, int index) {
  IconData icnn;
  // print("index====$index");
  if (index == 0) {
    icnn = Icons.text_fields_sharp;
    if (planType == "Silver Plan") {
      icnn = Icons.text_fields_sharp;
    } else if (planType == "Gold Plan") {
      icnn = Icons.diamond;
    } else if (planType == "Platinum Plan") {
      icnn = Icons.diamond;
    }
    // icnn = FontAwesomeIcons.tableColumns;
  } else if (index == 1) {
    icnn = Icons.numbers_outlined;
    // icnn = Icons.text_fields_sharp;
    if (planType == "Silver Plan") {
      icnn = Icons.numbers_outlined;
    } else if (planType == "Gold Plan") {
      icnn = Icons.chat;
    } else if (planType == "Platinum Plan") {
      icnn = FontAwesomeIcons.video;
    }
  } else if (index == 2) {
    // icnn = FontAwesomeIcons.question;
    icnn = FontAwesomeIcons.book;
    if (planType == "Silver Plan") {
      icnn = FontAwesomeIcons.book;
    } else if (planType == "Gold Plan") {
      icnn = FontAwesomeIcons.userGraduate;
    } else if (planType == "Platinum Plan") {
      icnn = FontAwesomeIcons.userGraduate;
    }
  } else if (index == 3) {
    icnn = Icons.chat;
    if (planType == "Silver Plan") {
      icnn = FontAwesomeIcons.bookOpenReader;
    } else if (planType == "Gold Plan") {
      icnn = FontAwesomeIcons.laptopFile;
    } else if (planType == "Platinum Plan") {
      icnn = Icons.lock_clock;
    }
  } else if (index == 4) {
    icnn = FontAwesomeIcons.userGraduate;
    if (planType == "Silver Plan") {
      icnn = FontAwesomeIcons.userGraduate;
    } else if (planType == "Gold Plan") {
      icnn = Icons.lock_clock;
    } else if (planType == "Platinum Plan") {
      icnn = Icons.account_tree_rounded;
    }
  } else if (index == 5) {
    icnn = Icons.numbers_outlined;
  } else if (index == 6) {
    icnn = FontAwesomeIcons.bookOpenReader;
  } else if (index == 7) {
    icnn = FontAwesomeIcons.artstation;
  } else if (index == 8) {
    icnn = FontAwesomeIcons.deezer;
  } else if (index == 9) {
    icnn = FontAwesomeIcons.renren;
  } else if (index == 10) {
    icnn = FontAwesomeIcons.xing;
  } else if (index == 11) {
    icnn = FontAwesomeIcons.accusoft;
  } else if (index == 12) {
    icnn = FontAwesomeIcons.handBackFist;
  }
  return Padding(
    padding: const EdgeInsets.only(top: 2),
    child: Container(
      width: MediaQuery.of(context).size.width * .85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // SizedBox(
          //   width: 10,
          // ),

          // Container(
          //   height: 18,
          //   child: Image.asset(
          //     "assets/CheckIcon.png",
          //     // color: Color.fromARGB(136, 8, 6, 6),
          //   ),
          // ),

          SizedBox(
              // width: 10,
              ),
          Icon(
            icnn,
            color: Color.fromARGB(136, 8, 6, 6),
            // color: Colors.grey[400]
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .53,
            child:
                // RichText(
                //   text: TextSpan(children: <TextSpan>[
                //     TextSpan(
                //       text: txt,
                //       style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w600),
                //     )
                //   ]),
                // ),

                Html(
              data: txt,
              style: {
                "body": Style(
                  color: Colors.black,
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto Medium',
                  lineHeight: LineHeight.number(1),
                  fontSize: FontSize(16),
                )
              },
            ),
          ),
        ],
      ),
    ),
  );
}
