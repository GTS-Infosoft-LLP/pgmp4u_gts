import 'package:flutter/material.dart';

import '../../tool/ShapeClipper.dart';

class ApplicationSupportPage extends StatefulWidget {
  @override
  _ApplicationSupportPageState createState() => _ApplicationSupportPageState();
}

class _ApplicationSupportPageState extends State<ApplicationSupportPage> {
  String text1 =
      '''Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Epsum factorial non deposit quid pro quo hic escorol. ''';
  String text2 =
      '''Olypian quarrels et gorilla congolium sic ad nauseum. Souvlaki ignitus carborundum e pluribus unum. Defacto lingo est igpay atinlay. Marquee selectus non provisio incongruous feline nolo contendre. ''';
  String text3 =
      '''Quote meon an estimate et non interruptus stadium. Sic tempus fugit esperanto hiccup estrogen. Glorious baklava ex librus hup hey ad infinitum. ''';
  String text4 =
      '''Non sequitur condominium facile et geranium incognito. Epsum factorial non deposit quid pro quo hic escorol. Marquee selectus non provisio incongruous feline nolo contendre Olypian quarrels et gorilla congolium sic ad nauseum. Souvlaki ignitus carborundum e pluribus unum. ''';

  Color _darkText = Color(0xff424b53);
  Color _lightText = Color(0xff424b53);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(children: <Widget>[
            Stack(
              children: <Widget>[
                ClipPath(
                    clipper: ShapeClipper(),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xff5468ff), Color(0xff3643a3)]),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 50, 0, 0),
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                              border:
                                  Border.all(color: Colors.white, width: 1)),
                          child: Center(
                              child: IconButton(
                                  icon: Icon(Icons.arrow_back,
                                      color: Colors.white),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }))),
                      SizedBox(width: 30),
                      Center(
                          child: Text(
                        "Application Support",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Raleway",
                          fontSize: 22,
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: 25),
                child: Center(
                    child: Text(
                  "Application Service Comes With",
                  style: TextStyle(
                      color: _darkText,
                      fontWeight: FontWeight.bold,
                      fontFamily: "NunitoSans",
                      fontSize: 20),
                ))),
            SizedBox(height: 10),
            Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 22, 22, 22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.arrow_forward,
                      color: Color(0xff5468ff),
                      size: 30,
                    ),
                    Expanded(
                        child: Text(
                      text1,
                      style: TextStyle(
                        color: _lightText,
                        fontFamily: "NunitoSans",
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1000,
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 22, 22, 22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.arrow_forward,
                      color: Color(0xff5468ff),
                      size: 30,
                    ),
                    Expanded(
                        child: Text(
                      text2,
                      style: TextStyle(
                        color: _lightText,
                        fontFamily: "NunitoSans",
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1000,
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 22, 22, 22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.arrow_forward,
                      color: Color(0xff5468ff),
                      size: 30,
                    ),
                    Expanded(
                        child: Text(
                      text3,
                      style: TextStyle(
                        color: _lightText,
                        fontFamily: "NunitoSans",
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1000,
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 22, 22, 22),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.arrow_forward,
                      color: Color(0xff5468ff),
                      size: 30,
                    ),
                    Expanded(
                        child: Text(
                      text4,
                      style: TextStyle(
                        color: _lightText,
                        fontFamily: "NunitoSans",
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1000,
                    )),
                  ],
                ),
              )
            ])
          ]),
        ),
      ),
    );
  }
}
