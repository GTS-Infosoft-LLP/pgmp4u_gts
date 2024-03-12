import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pgmp4u/Screens/Tests/provider/category_provider.dart';
import 'package:pgmp4u/Screens/Tests/video_player.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../utils/app_color.dart';
import '../../utils/sizes.dart';

import 'model/sub_category_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pgmp4u/Screens/Profile/paymentScreen.dart';
import 'package:pgmp4u/Screens/Tests/testsScreen.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/utils/appimage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

import 'model/videos_model.dart';

class VideosScreen extends StatefulWidget {
  int id;
  String type;

  VideosScreen({this.id, this.type});

  @override
  _VideosScreenState createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  CategoryProvider provider;
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  String photoUrl;
  String displayName;

  getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('photo');

    print(stringValue);
    setState(() {
      photoUrl = stringValue;
      displayName = prefs.getString('name');
    });
  }

  @override
  void initState() {
    super.initState();
    provider = Provider.of(context, listen: false);
    getVideos();
    getValue();
  }

  Future getVideos() async {
    await provider.getSubCategoryDetials(widget.id, widget.type);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    print(MediaQuery.of(context).padding.top);
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: _colorfromhex("#F7F7FA"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height:  180 ,
            width: width,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.only(bottomRight: Radius.circular(40.0)),
              gradient: LinearGradient(
                  colors: [_colorfromhex('#3846A9'), _colorfromhex('#5265F8')],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: width * (20 / 420),
                      right: width * (20 / 420),
                      top: height * (16 / 800)),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: height * (30 / 800),
                      left: width * (28 / 420),
                      right: width * (34 / 420)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 7),
                            child: Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    )),
                                Text(
                                  'Hello, ',
                                  style: TextStyle(
                                    fontFamily: 'Roboto Regular',
                                    fontSize: width * (16 / 420),
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  displayName != null ? displayName : '',
                                  style: TextStyle(
                                    fontFamily: 'Roboto Bold',
                                    fontSize: width * (16 / 420),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Find a test you',
                                style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  fontSize: width * (20 / 420),
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'want to learn',
                                style: TextStyle(
                                  fontFamily: 'Roboto Bold',
                                  fontSize: width * (20 / 420),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      photoUrl != null && photoUrl != ""
                          ? Container(
                              width: width * (80 / 420),
                              height: width * (80 / 420),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(photoUrl),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(80),
                              ),
                            )
                          : Container(
                              width: width * (80 / 420),
                              height: width * (80 / 420),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(80),
                              ),
                            )
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Consumer<CategoryProvider>(
              builder: (context, value, child) {
                return value.detailsLoader
                    ? Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Center(child: CircularProgressIndicator()))
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        child: value.videosList.isNotEmpty
                            ? ListView.builder(
                                itemCount: value.videosList.length,
                                itemBuilder: (context, index) {
                                  return categoryWidget(
                                      value.videosList[index],index);
                                },
                              )
                            : Center(
                                child: Text("No Videos Found"),
                              ),
                      );
              },
            ),
          )
        ],
      ),
    )

        // WillPopScope(
        //  onWillPop: _onWillPop,
        //child:

        //)
        );
  }

  Widget categoryWidget(VideosListApiModel data,int index) {
  print("is show play icon ${data.isShowPlay}");
    Color _colorfromhex(String hexColor) {
      final hexCode = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    }

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    String img = "assets/Vector-3.png";

    return Card(
      margin: EdgeInsets.only(bottom: 5).copyWith(left: 10, right: 10),
      elevation: 2,
      //color: Colors.grey,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 210,
              child: Stack(children: [
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.network(
                      "https://img.youtube.com/vi/${data.description}/maxresdefault.jpg",
                      fit: BoxFit.cover,
                      errorBuilder: (context, a, err) {
                        return Image.asset(
                          AppImage.picture_placeholder2,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  bottom: 50,
                  left: MediaQuery.of(context).size.width * 0.4,
                  child: InkWell(
                    onTap: ()  {
                    // context.read<CategoryProvider>().updatePlayValue(index);
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  YoutubePlayerDemo(videoid: data.description),));
                    },
                    child: Image.asset(
                      AppImage.playIcon,
                      height: 55,
                      width: 55,
                    ),
                  ),
                )
              ]),
            ),
            SizedBox(height: 10),
            Text(
              data.heading,
              maxLines: 5,
              style: TextStyle(
                  fontSize: Sizes.titleSize,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato-Regular',
                  color: AppColor.darkText),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
