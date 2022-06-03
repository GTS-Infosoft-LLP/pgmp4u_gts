import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentAndroid extends StatefulWidget {
  final String token;
 int statusFlash1videoLibrary2;
   PaymentAndroid({Key key, this.token,this.statusFlash1videoLibrary2}) : super(key: key);

  @override
  State<PaymentAndroid> createState() => _PaymentWithStripeState();
}

class _PaymentWithStripeState extends State<PaymentAndroid> {
  @override
  void initState() {
    super.initState();
  }

  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    print("open url ${widget.token}");
    print(">>>> token");
    print(">>>> token ${widget.token}");
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, false);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
          ),
          body: InAppWebView( 
            initialUrlRequest:
                URLRequest(url:
                 Uri.parse(
                   widget.statusFlash1videoLibrary2==1? "http://18.119.55.81:3003/api/createOrderNew?planType=2&deviceType=A"
                   : "http://18.119.55.81:3003/api/createOrderNew?planType=3&deviceType=A"
                   ), 
                    headers: {
              'Content-Type': 'application/json',
              'Authorization': widget.token,
            },
            
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;
            },
            onLoadStart: (InAppWebViewController controller, Uri url) {
              print("current url >>>>>>  ${url}");
            },
            onLoadStop: (InAppWebViewController controller, Uri url) {},
            onConsoleMessage: (InAppWebViewController _controller,
                ConsoleMessage consoleMessage) async {
              print("console message: ${consoleMessage}");
              _controller.addJavaScriptHandler(
                  handlerName: "pgmp4u",
                  callback: (args) {
                    // Here you receive all the arguments from the JavaScript side
                    // that is a List<dynamic>
                    print("From the JavaScript side:");
                    print(args);
                    var paymentStatus = args[0];
                    if ("success" == paymentStatus) {
                      naviagteBack(context, true);
                    } else {
                      naviagteBack(context, false);
                    }
                  });
            },
          ),
        ));
  }

  naviagteBack(BuildContext context, bool stats) {
    Future.delayed(Duration(seconds: 3)).then((value) {
      Navigator.pop(context, stats);
    });
  }
}
