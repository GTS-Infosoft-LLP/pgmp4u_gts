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
  // print("i values is:::: $iVal");
  // print("itmCnt===$itmCnt");
  // print("plan type::::$planTyp");
  if (iVal == 1) {
    planTyp = sp.SubscritionPackList[0].title;
  }
  if (iVal == 2) {
    planTyp = sp.SubscritionPackList[1].title;
  }
  if (iVal == 3) {
    planTyp = sp.SubscritionPackList[2].title;
  }

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
    width: MediaQuery.of(context).size.width * 0.80,
    height: MediaQuery.of(context).size.height * 0.33,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 0),
          child: Container(
            width: MediaQuery.of(context).size.width * .7,
            // color: Colors.amber,
            child: Center(
                child: RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: planTyp,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontFamily: 'Roboto Bold',
                          // fontWeight: FontWeight.w100
                        ),
                      ),
                    ]))),
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
                physics: BouncingScrollPhysics(),
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
