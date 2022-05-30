import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pgmp4u/Models/constants.dart';
import 'package:pgmp4u/provider/purchase_provider.dart';
import 'package:provider/provider.dart';

import '../../tool/ShapeClipper.dart';
import 'VideoLibrary/Playlist.dart';
import 'VideoLibrary/RandomPage.dart';

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
      body: Consumer<PurchaseProvider>(builder: (context, purchaseProvider, child) {
        return Container(
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
                      isShowPremium: false,
                      iconBackground: Color(0xff72a258),
                      icon: Icon(
                        FontAwesomeIcons.edit,
                        size: 50,
                        color: Colors.white,
                      ),
                      text: "PgMP Prep",
                      onTap: () {
                        if(purchaseProvider.videoLibraryStatus)
                        {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => new PlaylistPage(
                              videoType: 1,
                              title: "PgMP Prep",
                            ),
                          ),
                        );
                        }
                        else{
                  //         purchaseProvider.products.forEach((e) {
                  //   print("Product id => ${e.id}");
                  //   if (e.id == videoLibraryLearningPrograms) {
                  //     purchaseProvider.buy(e);
                  //   }
                  // });
                        }
                       
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
                      isShowPremium: true,
                      onTap: () {
                        if(purchaseProvider.videoLibraryStatus)
                        {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => PlaylistPage(
                              title: "PgMP Success Stories",
                              videoType: 2,
                            ),
                          ),
                        );
                        }else{
                  //         purchaseProvider.products.forEach((e) {
                  //   print("Product id => ${e.id}");
                  //   if (e.id == videoLibraryLearningPrograms) {
                  //     purchaseProvider.buy(e);
                  //   }
                  // });
                        }
                     
                      },
                      onPremiumTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => RandomPage(index: 2,),
                            ));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
      },)
    );
  }
}

class Options extends StatelessWidget {
  Options(
      {@required this.iconBackground,
      @required this.icon,
      @required this.text,
      @required this.isShowPremium,
      @required this.onPremiumTap,
      @required this.onTap});
  final Color iconBackground;
  final Icon icon;
  final String text;
  final bool isShowPremium;
  Function onTap;
  Function onPremiumTap;
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
          height: 210,
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
                  SizedBox(height: 13),
                  SingleChildScrollView(
                    child: Column(
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
                        SizedBox(
                          height: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            isShowPremium
                                ? GestureDetector(
                                  onTap: onPremiumTap,
                                    child: Text(
                                    "Premium",
                                    style: TextStyle(
                                      fontSize: 18,
                                        decoration: TextDecoration.underline),
                                  ))
                                : SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
