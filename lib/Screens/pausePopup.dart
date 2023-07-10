import 'package:flutter/material.dart';

Future<void> commingSoonDialog(BuildContext context,
    {bool dismissable = true, String appString = "", int isFullAccess = 0}) async {
  await showDialog(
      barrierDismissible: dismissable,
      context: context,
      builder: (context) => AlertDialog(
            elevation: 20,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.cancel)),
                  ],
                ),
                SizedBox(height: 15),
                Text("Test is currently paused \n Press the button to resume the test ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    )),
              ],
            ),
            actions: <Widget>[
              InkWell(
                  onTap: () {
                    // _stopWatchTimer.onExecute.add(StopWatchExecute.start);
                  },
                  child: Text("Resume Test"))
              // customBlueButton(
              //     context: context,
              //     text1:  tr(LocaleKeys.additionText_viewPln),
              //     onTap1: () {
              //           Navigator.pop(context);
              //           Navigator.push(context, MaterialPageRoute(
              //             builder: (context) {
              //               return ViewPremium();
              //             },
              //           ));
              //     },
              //     colour: Color(0xff2A3C6A)
              // ),
            ],
          ));
}
