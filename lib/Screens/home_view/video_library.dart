import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:pgmp4u/provider/purchase_provider.dart';
import 'package:provider/provider.dart';
import '../../tool/ShapeClipper.dart';
import '../../utils/app_color.dart';
import 'VideoLibrary/Playlist.dart';

class VideoLibraryPage extends StatefulWidget {
  String title;
  VideoLibraryPage({Key key, this.title}) : super(key: key);

  @override
  _VideoLibraryPageState createState() => _VideoLibraryPageState();
}

class _VideoLibraryPageState extends State<VideoLibraryPage> {
  Color _darkText = Color(0xff424b53);
  Color _lightText = Color(0xff989d9e);
  Map mapResponse;
  bool isShowPremiumOrNot;
//ModelStatus maintainStatus;
  @override
  void initState() {
    print("title============${widget.title}");
    super.initState();
    //apiCall();
    // if (selectedIdNew == "result") {
    //   apiCall2();
    // } else {
    //   apiCall();
    // }
  }

  // Future apiCall() async {
  //   print("Get Status of FlashCard  ${mapResponse}");
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String stringValue = prefs.getString('token');
  //   print(stringValue);
  //   http.Response response;
  //   response = await http.get(Uri.parse(""), headers: {
  //     'Content-Type': 'application/json',
  //     'Authorization': stringValue
  //   });

  //   if (response.statusCode == 200) {
  //     print(convert.jsonDecode(response.body));
  //     setState(() {
  //       mapResponse = convert.jsonDecode(response.body);
  //       maintainStatus=ModelStatus.fromjson(mapResponse);
  //     });
  //     // print(convert.jsonDecode(response.body));
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer<PurchaseProvider>(
      builder: (context, purchaseProvider, child) {
        if (purchaseProvider.latestStatus?.videoLibStatus == 0) {
          isShowPremiumOrNot = true;
        } else {
          isShowPremiumOrNot = false;
        }

        return Consumer<CourseProvider>(builder: (context, courseProvider, child) {
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
                                  border: Border.all(color: Colors.white, width: 1)),
                              child: Center(
                                  child: IconButton(
                                      icon: Icon(Icons.arrow_back, color: Colors.white),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }))),
                          SizedBox(width: 20),
                          Center(
                              child: Container(
                            width: MediaQuery.of(context).size.width * .70,
                            // color: Colors.amberAccent,
                            child: Text(
                              courseProvider.selectedCourseName,
                              maxLines: 2,
                              // "Master Data",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: "Raleway",
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                        ],
                      ),

                      //Text("Flash Cards", style: TextStyle(fontSize: 28,color: Colors.white,fontFamily: "Raleway", fontWeight: FontWeight.bold),)
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    widget.title,
                    style: TextStyle(fontSize: 24, color: _darkText, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 15),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Consumer<CourseProvider>(builder: (context, courseProvider, child) {
                          return courseProvider.videoPresent == 1
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: courseProvider.videoCate.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        if (courseProvider.videoCate[index].payment_status == 0) {
                                          print("id:::: ${courseProvider.videoCate[index].id}");
                                          courseProvider.getVideos(courseProvider.videoCate[index].id);

                                          Future.delayed(const Duration(milliseconds: 400), () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => PlaylistPage(
                                                    title: courseProvider.videoCate[index].name,
                                                    videoType: 2,
                                                  ),
                                                ));
                                          });
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 18.0, left: 12, right: 12),
                                        child: Container(
                                          height: 70,
                                          decoration: BoxDecoration(
                                              // shape: BoxShape.circle,
                                              color: Colors.transparent,
                                              border: Border(
                                                bottom: BorderSide(width: 1.5, color: Colors.grey[300]),
                                              )),
                                          child: Row(children: [
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 5.0),
                                              child: Container(
                                                  height: 60,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: index % 2 == 0 ? AppColor.purpule : AppColor.green,
                                                  ),
                                                  child: Icon(
                                                    FontAwesomeIcons.video,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Video Library",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  courseProvider.videoCate[index].name,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ]),
                                        ),
                                      ),
                                    );

//                           Options(iconBackground: Color(0xff72a258), icon:  Icon(
//                         FontAwesomeIcons.video,
//                         size: 50,
//                         color: Colors.white,
//                       ), text: courseProvider.videoCate[index].name, isShowPremium:courseProvider.videoCate[index].payment_status==1?true:false, onPremiumTap: (){
//                          Navigator.push(context,MaterialPageRoute(builder: (context)=>RandomPage(index: 2,price:courseProvider.videoCate[index].price ,)));
//                       }, onTap: (){

//                    if(courseProvider.videoCate[index].payment_status==0){

//             print("id:::: ${courseProvider.videoCate[index].id}");
//                         courseProvider.getVideos(courseProvider.videoCate[index].id);

//  Future.delayed(const Duration(milliseconds: 400), () {

//         Navigator.push(context,MaterialPageRoute(builder: (context)=>PlaylistPage(
//                               title: "PgMP Recorded Program Premium",
//                               videoType: 2,
//                             ),));
//     });

//                    }

//                       });
                                  })
                              : Column(
                                  children: [
                                    SizedBox(
                                      height: 150,
                                    ),
                                    Center(
                                        child: Text("No Data Found",
                                            style: TextStyle(
                                                fontSize: 18, color: _darkText, fontWeight: FontWeight.normal))),
                                  ],
                                );
                        })

                        //         Options(
                        //           isShowPremium: false,
                        //           iconBackground: Color(0xff72a258),
                        //           icon: Icon(
                        //             FontAwesomeIcons.edit,
                        //             size: 50,
                        //             color: Colors.white,
                        //           ),
                        //           text: "PgMP Prep Free",
                        //           onTap: () {

                        //       CourseProvider courseProvider=Provider.of(context,listen: false);
                        // courseProvider.getVideos(4);
                        //           print("on tabbbb");
                        //               Navigator.push(
                        //               context,
                        //               MaterialPageRoute(
                        //                 builder: (BuildContext context) => new PlaylistPage(
                        //                   videoType: 1,
                        //                   title: "PgMP Prep Free",

                        //                 ),
                        //               ),
                        //             );

                        // //         purchaseProvider.products.forEach((e) {
                        // //   print("Product id => ${e.id}");
                        // //   if (e.id == videoLibraryLearningPrograms) {
                        // //     purchaseProvider.buy(e);
                        // //   }
                        // // });

                        //   },
                        // ),
                        //   Options(
                        //     iconBackground: Color(0xff463b97),
                        //     icon: Icon(
                        //       FontAwesomeIcons.splotch,
                        //       size: 50,
                        //       color: Colors.white,
                        //     ),
                        //     text: "PgMP Recorded Program Premium",
                        //     isShowPremium:isShowPremiumOrNot,

                        //     onTap: () {

                        //       //PurchaseProvider purchaseProvider = Provider.of(context,listen: false);

                        //       if(purchaseProvider.latestStatus?.videoLibStatus==1)
                        //       {
                        //         Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (BuildContext context) => PlaylistPage(
                        //             title: "PgMP Recorded Program Premium",
                        //             videoType: 2,
                        //           ),
                        //         ),
                        //       );
                        //       }else{
                        //            Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (BuildContext context) => RandomPage(index: 2,),
                        //           ));
                        // //         purchaseProvider.products.forEach((e) {
                        // //   print("Product id => ${e.id}");
                        // //   if (e.id == videoLibraryLearningPrograms) {
                        // //     purchaseProvider.buy(e);
                        // //   }
                        // // });
                        //       }

                        //     },
                        //     onPremiumTap: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (BuildContext context) => RandomPage(index: 2,),
                        //           ));
                        //     },
                        //   ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    ));
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
          height: 225,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
              Container(
                height: 90.0,
                width: 90.0,
                decoration: BoxDecoration(color: iconBackground, borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: icon,
                  //child: Container(child: Image.asset(icon),width: 60,height: 60,),
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Video Library",
                        style: TextStyle(fontSize: 16.0, fontFamily: 'Lato-Regular', color: _lightText)),
                    Text(text,
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold, fontFamily: 'Lato-Regular', color: _darkText)),
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
                                  style: TextStyle(fontSize: 18, decoration: TextDecoration.underline),
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
