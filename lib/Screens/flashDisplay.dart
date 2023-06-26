import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/courseProvider.dart';
import '../provider/response_provider.dart';
import '../tool/ShapeClipper.dart';

class FlashDisplay extends StatefulWidget {
  String heding;
  FlashDisplay({Key key, this.heding}) : super(key: key);

  @override
  State<FlashDisplay> createState() => _FlashDisplayState();
}

class _FlashDisplayState extends State<FlashDisplay> {
  @override
  ResponseProvider responseProvider;

  LinearGradient liGrdint;

  void initState() {
    responseProvider = Provider.of(context, listen: false);
    CourseProvider courseProvider = Provider.of(context, listen: false);

    print("length of flash list ==>> ${courseProvider.FlashCards.length}");

    callCardDetailsApi();
    super.initState();
  }

  callCardDetailsApi() async {
    await responseProvider.getCardDetails();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: <Widget>[
                      ClipPath(
                        clipper: ShapeClipper(),
                        // CardPageClipper(),
                        child: Container(
                          // height: MediaQuery.of(context).size.height*.25,
                          height: 150,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(40, 50, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                    border: Border.all(color: Colors.white, width: 1)),
                                child: Center(
                                    child: IconButton(
                                        icon: Icon(Icons.arrow_back, color: Colors.white),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }))),
                            SizedBox(width: 20),
                            Center(
                                child: Text(
                              widget.heding,
                              style: TextStyle(
                                  fontSize: 22, color: Colors.white, fontFamily: "Roboto", fontWeight: FontWeight.bold),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Consumer<CourseProvider>(builder: (context, courseProvider, child) {
                    return Container(
                      // color: Colors.amber,
                      height: MediaQuery.of(context).size.height * .8,
                      child: PageView.builder(
                          itemCount: courseProvider.FlashCards.length,
                          itemBuilder: (context, index) {
                            if (index % 4 == 0) {
                              liGrdint = LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xffF3924D), Color(0xffECAB8E)]);
                            } else if (index % 3 == 0) {
                              liGrdint = LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xff5082BC), Color(0xff8AA1C9)]);
                            } else if (index % 2 == 0) {
                              liGrdint = LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xff8E8BE6), Color(0xffA8B1FC)]);
                            } else {
                              liGrdint = LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xff4195B7), Color(0xff76ACC2)]);
                            }

                            return Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: liGrdint,
                                  // color: Colors.deepPurpleAccent,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Center(
                                      child: Text(
                                        courseProvider.FlashCards[index].title,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                      child: Text(
                                        courseProvider.FlashCards[index].description,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 24, fontFamily: "NunitoSans", color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    );
                  })
                ],
              ),
            )),
      ),
    );
  }
}
