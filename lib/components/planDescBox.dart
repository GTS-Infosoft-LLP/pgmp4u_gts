import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pgmp4u/components/subscriptionGreyBox.dart';
import 'package:pgmp4u/provider/Subscription/subscriptionProvider.dart';
import 'package:provider/provider.dart';

Widget planDescBox(
  BuildContext context,
  String planTyp,
  List showList,
  int itmCnt,
  int iVal,
) {
  SubscriptionProvider sp = Provider.of(context, listen: false);
  print("i values is:::: $iVal");
  print("itmCnt===$itmCnt");
  print("plan type::::$planTyp");
  if (iVal == 1) {
    planTyp = "Silver Plan";
  }
  if (iVal == 2) {
    planTyp = "Gold Plan";
  }
  if (iVal == 3) {
    planTyp = "Platinum Plan";
  }

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
    width: MediaQuery.of(context).size.width * 0.80,
    height: MediaQuery.of(context).size.height * 0.32,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 22),
          child: Center(
            child: Text(
              planTyp,
              style: TextStyle(
                fontFamily: 'Roboto Bold',
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        height: 0.25,
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.25,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: itmCnt,
                itemBuilder: (context, index) {
                  return customGreyRedRow(
                      FontAwesomeIcons.tableColumns,
                      // sp.SubscritionPackList[sp.selectedIval].description[index] ?? "",
                      showList[index],
                      context,
                      planTyp,
                      index);
                })),
      ),
    ]),
  );
}
