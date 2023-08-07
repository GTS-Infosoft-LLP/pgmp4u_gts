import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pgmp4u/components/subscriptionGreyBox.dart';
import 'package:pgmp4u/provider/Subscription/subscriptionProvider.dart';
import 'package:provider/provider.dart';

Widget planDescBox(
  BuildContext context,
  String planTyp,
  int itmCnt,
) {
  SubscriptionProvider sp = Provider.of(context, listen: false);

  List<String> showList = [];
  if (planTyp == "Silver Plan") {
    showList = sp.sliverList;
  }
  if (planTyp == "Gold Plan") {
    showList = sp.GoldList;
  }
  if (planTyp == "Platinum Plan") {
    showList = sp.platinumList;
  }

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
    width: MediaQuery.of(context).size.width * 0.80,
    height: MediaQuery.of(context).size.height * 0.30,
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 22),
        child: Text(
          planTyp,
          style: TextStyle(
            fontFamily: 'Roboto Bold',
            fontSize: 22,
          ),
        ),
      ),
      Container(
        
        height: MediaQuery.of(context).size.height * 0.25,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: ListView.builder(
                itemCount: itmCnt,
                itemBuilder: (context, index) {
                  return customGreyRedRow(
                      FontAwesomeIcons.tableColumns,
                      // sp.SubscritionPackList[sp.selectedIval].description[index] ?? "",
                      showList[index],
                      context,
                      index);
                })),
      ),
    ]),
  );
}
