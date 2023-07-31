import 'package:flutter/material.dart';

Widget customGreyRedRow(IconData icn, String txt, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6.0),
    child: Container(
      width: MediaQuery.of(context).size.width * .85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // SizedBox(
          //   width: 10,
          // ),

          // Container(
          //   height: 23,
          //   child: Image.asset("assets/CheckIcon.png"),
          // ),

          SizedBox(
            width: 10,
          ),
          Icon(
            icn,
            color: Color.fromARGB(136, 8, 6, 6),
          ),
          SizedBox(
            width: 20,
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
