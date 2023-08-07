import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget customGreyRedRow(IconData icn, String txt, BuildContext context, int index) {
  IconData icnn;
  if (index == 0) {
    // icnn = FontAwesomeIcons.tableColumns;
    // icnn = FontAwesomeIcons.medal;
    // icnn = FontAwesomeIcons.tick;
  } else if (index == 1) {
    icnn = Icons.text_fields_sharp;
  } else if (index == 2) {
    icnn = FontAwesomeIcons.question;
  } else if (index == 3) {
    icnn = Icons.chat;
  } else if (index == 4) {
    icnn = Icons.book;
  } else if (index == 5) {
    icnn = Icons.numbers_outlined;
  } else if (index == 6) {
    icnn = FontAwesomeIcons.bookOpenReader;
  } else if (index == 7) {
    icnn = FontAwesomeIcons.bookOpenReader;
  }
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: Container(
      width: MediaQuery.of(context).size.width * .85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // SizedBox(
          //   width: 10,
          // ),

          Container(
            height: 18,
            child: Image.asset(
              "assets/CheckIcon.png",
              // color: Color.fromARGB(136, 8, 6, 6),
            ),
          ),

          SizedBox(
              // width: 10,
              ),
          // Icon(
          //   icnn,
          //   color: Color.fromARGB(136, 8, 6, 6),
          //   // color: Colors.grey[400]
          // ),
          SizedBox(
            width: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .53,
            child: RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                  text: txt,
                  style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w600),
                )
              ]),
            ),
          ),
        ],
      ),
    ),
  );
}
