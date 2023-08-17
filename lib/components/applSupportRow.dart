import 'package:flutter/material.dart';

Widget AppSupportRow(String txt, context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6.0),
    child: Container(
      width: MediaQuery.of(context).size.width * .8,
      child: Row(
        children: [
          CircleAvatar(
            maxRadius: 4,
            backgroundColor: Colors.black,
          ),
          SizedBox(
            width: 6,
          ),
          Container(width: MediaQuery.of(context).size.width * .7, child: Text(txt))
        ],
      ),
    ),
  );
}
