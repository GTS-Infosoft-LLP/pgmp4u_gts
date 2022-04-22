import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../tool/ShapeClipper.dart';
import 'VideoLibrary/Playlist.dart';

class VideoLibraryPage extends StatefulWidget {
  @override
  _VideoLibraryPageState createState() => _VideoLibraryPageState();
}

class _VideoLibraryPageState extends State<VideoLibraryPage> {
  Color _darkText = Color(0xff424b53);
  Color _lightText = Color(0xff989d9e);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xfff7f7f7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                          colors: [Color(0xff3643a3), Color(0xff5468ff)]),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 50, 0, 0),
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
                      SizedBox(width: 20),
                      Center(
                          child: Text(
                        "Video Library",
                        style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),

                  //Text("Flash Cards", style: TextStyle(fontSize: 28,color: Colors.white,fontFamily: "Raleway", fontWeight: FontWeight.bold),)
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "VideoLibrary4U",
                style: TextStyle(
                    fontSize: 24,
                    color: _darkText,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Options(
                      iconBackground: Color(0xff72a258),
                      icon: Icon(
                        FontAwesomeIcons.edit,
                        size: 50,
                        color: Colors.white,
                      ),
                      text: "PgMP Prep",
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => new PlaylistPage(
                              url:
                                  "https://thawing-plateau-67981.herokuapp.com/",
                              title: "PgMP Prep",
                            ),
                          ),
                        );
                      },
                    ),
                    Options(
                      iconBackground: Color(0xff463b97),
                      icon: Icon(
                        FontAwesomeIcons.splotch,
                        size: 50,
                        color: Colors.white,
                      ),
                      text: "Pgmp Success Stories",
                      onTap: () {
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context) => new PlaylistPage(
                        //       url: "https://pgmp2.herokuapp.com/",
                        //       title: "PgMP Success Stories",
                        //     ),
                        //   ),
                        // );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Options extends StatelessWidget {
  Options(
      {@required this.iconBackground,
      @required this.icon,
      @required this.text,
      this.onTap});
  final Color iconBackground;
  final Icon icon;
  final String text;
  Function onTap;

  final Color _darkText = Color(0xff424b53);
  final Color _lightText = Color(0xff989d9e);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.all(12),
        elevation: 2,
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.all(12),
          height: 200,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 100.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                        color: iconBackground,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: icon,
                      //child: Container(child: Image.asset(icon),width: 60,height: 60,),
                    ),
                  ),
                  SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Video Library",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Lato-Regular',
                              color: _lightText)),
                      Text(text,
                          style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato-Regular',
                              color: _darkText)),
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
