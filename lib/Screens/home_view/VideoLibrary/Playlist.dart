import 'dart:async';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pgmp4u/Models/get_video_by_type_response.dart';
import 'package:pgmp4u/provider/player_provider.dart';
import 'package:pgmp4u/provider/response_provider.dart';
import 'package:pgmp4u/utils/app_color.dart';
import 'package:pgmp4u/utils/appimage.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../provider/courseProvider.dart';
import '../../../tool/ShapeClipper.dart';
import '../../../utils/sizes.dart';
import '../../Tests/video_player.dart';

class PlaylistPage extends StatefulWidget {
  PlaylistPage({Key key, this.title, this.videoType}) : super(key: key);

  final String title;
  final int videoType;

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  // Future<List> getData() async {
  //   final response = await http.get(Uri.parse(widget.url));
  //   return json.decode(response.body);
  // }
  @override
  void initState() {
    print("titleee======>>>.${widget.title}");
    print(" call playlist screen");
    print(" video type ${widget.videoType}");

    CourseProvider cp = Provider.of(context, listen: false);
    print("videos===${cp.Videos}");
    // print("video url===${cp.Videos[0].videoUrl}");

    // print(
    //   "https://img.youtube.com/vi/${cp.Videos[0].videoUrl}/hqdefault.jpg",
    // );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ResponseProvider responseProvider = Provider.of(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            color: Color(0xfff7f7f7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
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
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 50, 0, 0),
                        child: Consumer<CourseProvider>(builder: (context, cp, child) {
                          return Row(children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                // size: width * (24 / 420),
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Center(
                                child: Container(
                                    width: MediaQuery.of(context).size.width * .72,
                                    child: RichText(
                                        //textAlign: TextAlign.center,
                                        // maxLines: 2,
                                        // overflow: TextOverflow.ellipsis,
                                        text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                        text: cp.selectedCourseLable,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontFamily: "Raleway",
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]))
                                    )),
                          ]);
                        }),
                      ),
                    )
                  ],
                ),

                // Stack(
                //   children: <Widget>[
                //     ClipPath(
                //       clipper: ShapeClipperMirrored(),
                //       child: Container(
                //         height: 150,
                //         decoration: BoxDecoration(
                //           gradient: LinearGradient(
                //             begin: Alignment.topLeft,
                //             end: Alignment.bottomRight,
                //             colors: [Color(0xff3643a3), Color(0xff5468ff)],
                //           ),
                //         ),
                //       ),
                //     ),
                //     Container(
                //       padding: EdgeInsets.fromLTRB(20, 40, 10, 0),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.end,
                //         children: <Widget>[
                //           SizedBox(
                //             width: 15,
                //           ),
                //           Flexible(
                //             child: Center(
                //               child: Text(
                //                 "",
                //                 style: TextStyle(
                //                     fontSize: 22,
                //                     color: Colors.white,
                //                     fontFamily: "Raleway",
                //                     fontWeight: FontWeight.bold),
                //                 maxLines: 2,
                //                 overflow: TextOverflow.ellipsis,
                //               ),
                //             ),
                //           ),
                //           SizedBox(width: 10),
                //           Container(
                //             width: 40,
                //             height: 40,
                //             decoration: BoxDecoration(
                //               shape: BoxShape.circle,
                //               color: Colors.transparent,
                //               border: Border.all(color: Colors.white, width: 1),
                //             ),
                //             child: Center(
                //               child: IconButton(
                //                 icon: Icon(Icons.arrow_back, color: Colors.white),
                //                 onPressed: () {
                //                   Navigator.pop(context);
                //                 },
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),

                //       //Text("Flash Cards", style: TextStyle(fontSize: 28,color: Colors.white,fontFamily: "Raleway", fontWeight: FontWeight.bold),)
                //     ),
                //   ],
                // ),
                SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RichText(
                        //textAlign: TextAlign.center,
                        // maxLines: 2,
                        // overflow: TextOverflow.ellipsis,
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: widget.title,
                        style: TextStyle(
                            color: AppColor.darkText,
                            fontSize: 24,
                            // fontFamily:  "Raleway",
                            fontWeight: FontWeight.bold),
                      ),
                    ]))),
                Container(
                    child: FutureBuilder<GetVideoByType>(
                  future: responseProvider.getCardVideoTypeApi(widget.videoType),
                  builder: (ctx, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text("kamal none");
                      case ConnectionState.waiting:
                        return Container(
                            height: MediaQuery.of(context).size.height * .5,
                            child: Center(child: new CircularProgressIndicator()));

                      case ConnectionState.active:
                        return Text("data");
                      case ConnectionState.done:
                        if (snapshot.hasData) {
                          return VideoList(snapshot.data.videoListing);
                        } else {
                          return Container(
                              height: MediaQuery.of(context).size.height * .5,
                              child: Center(
                                  child: Text(
                                "No Data Found",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              )));
                        }
                      // return snapshot.data.videoListing.isNotEmpty
                      //     ? VideoList(snapshot.data?.videoListing)
                      //     : Text("No data found");
                    }
                    // print(" error ${snapshot.error}");
                    // if (snapshot.hasData) {
                    //   return VideoList(snapshot.data.videoListing);
                    // } else {
                    //   return Container(
                    //       height: MediaQuery.of(context).size.height * .5,
                    //       child:
                    //           Center(child: new CircularProgressIndicator()));
                    // }
                    // if (snapshot.hasError) print(snapshot.error);
                  },
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VideoList extends StatelessWidget {
  final List<GetVideoByTypeListing> getVideoListing;

  VideoList(this.getVideoListing);

  @override
  Widget build(BuildContext context) {
    print("length of list ${getVideoListing.length}");
    print("playing videoo link ${getVideoListing[0].videoURl}");
    return Consumer<CourseProvider>(builder: (context, courseProvider, child) {
      List videoList = courseProvider.Videos;
      return courseProvider.Videos.isNotEmpty
          ? ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: videoList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * .9,
                          height: 210,
                          child: Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * .9,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13),
                                  child: Image.network(
                                    courseProvider.Videos[index].videoType == 1
                                        ? courseProvider.Videos[index].thumbnailUrl
                                        : "https://img.youtube.com/vi/${courseProvider.Videos[index].videoUrl}/hqdefault.jpg",
                                    //  "https://pgmp4ubucket.s3.amazonaws.com/uploads/document/thumb/",
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
                                left: MediaQuery.of(context).size.width * 0.38,
                                child: InkWell(
                                  onTap: () {
                                    print("Videos[index].videoUrl===${courseProvider.Videos[index].videoUrl}");
                                    print("");
                                    print("Videos[index].videoUrl===${courseProvider.Videos[index].videoUrl}");
                                    print(
                                        "in this condition videoType value::::::::: ${courseProvider.Videos[index].videoType}");
                                    if (courseProvider.Videos[index].videoType == 2) {
                                      print("in this condition:::::::::");
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => YoutubePlayerDemo(
                                                videoid: courseProvider.Videos[index].videoUrl,
                                              )));
                                    } else {
                                      print("in this condition videoType:::::::::");
                                      try {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => VideoPlay(
                                              url: courseProvider.Videos[index].videoUrl,
                                              videoDuration: "",
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        print("errrorororoorr::::$e");
                                      }
                                    }
                                  },
                                  child: Center(
                                    child: Image.asset(
                                      AppImage.playIcon,
                                      // color: Colors.white,
                                      height: 55,
                                      width: 55,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                        child: Container(
                            // color: Colors.amber,
                            child: RichText(
                                //textAlign: TextAlign.center,
                                // maxLines: 2,
                                // overflow: TextOverflow.ellipsis,
                                text: TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: courseProvider.Videos[index].title,
                            style: TextStyle(
                                color: AppColor.darkText,
                                fontSize: Sizes.titleSize,
                                fontFamily: 'Lato-Regular',
                                fontWeight: FontWeight.bold),
                          ),
                        ]))),
                      ),
                      // Divider(
                      //   color: Colors.grey,
                      // )
                    ],
                  ),
                );
              })
          : Container(
              height: 150,
              child: Center(
                  child: Text(
                "No Data Found",
                style: TextStyle(fontSize: 18),
              )),
            );
    });
    // ListView.builder(
    //   shrinkWrap: true,
    //   itemCount: getVideoListing == null ? 0 : getVideoListing.length,
    //   physics: NeverScrollableScrollPhysics(),
    //   itemBuilder: (context, index) {
    //     GetVideoByTypeListing list = getVideoListing[index];
    //     return new Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: InkWell(
    //         onTap: () {
    //           Navigator.of(context).push(
    //             new MaterialPageRoute(
    //               builder: (context) => new VideoPlay(
    //                 url: "${list.videoURl}",
    //                 videoDuration: "${list.videoDuration}",
    //               ),
    //             ),
    //           );
    //           // SystemChrome.setPreferredOrientations([
    //           //   // DeviceOrientation.portraitUp,
    //           //   DeviceOrientation.portraitDown
    //           // ]);
    //         },
    //         child: Card(
    //           margin: EdgeInsets.only(bottom: 1),
    //           elevation: 2,
    //           //color: Colors.grey,
    //           child: Padding(
    //             padding: EdgeInsets.all(10),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: <Widget>[
    //                 Container(
    //                   height: 210,
    //                   child: Stack(children: [
    //                     Container(
    //                       child: ClipRRect(
    //                         borderRadius: BorderRadius.circular(13),
    //                         child: Image.network(
    //                           list.thunnailUrl,
    //                           fit: BoxFit.cover,
    //                           errorBuilder: (context, a, err) {
    //                             return Image.asset(
    //                               AppImage.picture_placeholder2,
    //                               fit: BoxFit.cover,
    //                               width: MediaQuery.of(context).size.width,
    //                             );
    //                           },
    //                         ),
    //                       ),
    //                     ),
    //                     Positioned(
    //                       top: 50,
    //                       bottom: 50,
    //                       left: MediaQuery.of(context).size.width * 0.4,
    //                       child: Image.asset(
    //                         AppImage.playIcon,
    //                         height: 55,
    //                         width: 55,
    //                       ),
    //                     )
    //                   ]),
    //                 ),
    //                 SizedBox(height: 10),
    //                 Text(
    //                   list.title,
    //                   maxLines: 5,
    //                   style: TextStyle(
    //                       fontSize: Sizes.titleSize,
    //                       fontWeight: FontWeight.bold,
    //                       fontFamily: 'Lato-Regular',
    //                       color: AppColor.darkText),
    //                 ),
    //                 SizedBox(height: 10),
    //               ],
    //             ),
    //           ),
    //         ),

    //       ),
    //     );
    //   },
    // );
  }
}

class VideoPlay extends StatefulWidget {
  final String url;
  final String videoDuration;

  VideoPlay({@required this.url, @required this.videoDuration});

  @override
  State<VideoPlay> createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  PlayerProvider playerProvider;
  // VideoPlayerController _controller;
  bool isPauseVisible = true;
  bool isIconVisible = true;
  final FijkPlayer player = FijkPlayer();

//  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // setLandScape();
    var _url =
        "https://pgmp4ubucket.s3.amazonaws.com/uploads/document/3PgMPVBCChapter3Introduction202004212hrs1min.mp4";

    player.setDataSource(widget.url, autoPlay: true);
    // player.pause();
    // player.p

    // _controller = VideoPlayerController.networkUrl(
    //   Uri.parse(_url),
    // )..initialize().then((_) {
    // setState(() {
    //   try {
    //     print("means it works fine.....");
    //     _controller.play();
    //   } catch (e) {
    //     print("catching errors::::$e");
    //   }
    // });
    // // setState(() {});
    // // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    // // Future.delayed(Duration(seconds: 2)).then((value) {
    // //   setState(() {});
    // // });

    //   playVideo();
    //   count();
    // }).onError((error, stackTrace) {
    //   print("errore:::::::$error");
    //   print("stackTrace:::::::$stackTrace");
    // });

    // playerProvider = Provider.of(context, listen: false);
    // isPauseVisible = true;
    // if (_controller.value.isPlaying) {
    //   isIconVisible = false;
    // }

    setState(() {});

    // VideoProgressIndicator(_controller, allowScrubbing: true);

    // _controller.initialize();
    // _controller.setLooping(true);
    // codeForVideo();
    super.initState();
  }

  // codeForVideo() {
  //   print("call function");
  //   final arguments = [
  //     '-i', widget.url, // Input WebM file
  //     '-c:v', 'libx264', // Video codec for MP4
  //     '-c:a', 'aac', // Audio codec for MP4
  //     "${DateTime.now()}.mp4", // Output MP4 file
  //   ];
  //   FFmpegKit.executeWithArguments(arguments).then((value) async {
  //     print("value is >> ${await value.getOutput()}");
  //   });
  // }

  Timer _timer;

  count() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_timer.isActive) {
        isIconVisible = false;
        setState(() {});
        timer.cancel();
      }
    });
  }

  Future<bool> onwill() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    return true;
  }

  bool isLandScape = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onwill,
      child: Scaffold(
          backgroundColor: Colors.black,
          // appBar: AppBar(leading:
          //BackButton(onPressed: () async {
          //   await SystemChrome.setPreferredOrientations(
          // [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
          //   Navigator.pop(context);
          // },),
          //   backgroundColor: Colors.transparent,
          // ),
          // floatingActionButton: playVideo(_controller),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                      child: Center(
                    child: GestureDetector(
                      onTap: () {
                        isIconVisible = true;
                        setState(() {});
                        count();
                      },
                      child: Stack(
                        children: [
                          Center(
                            child: FijkView(
                              color: Colors.black,
                              player: player,
                            ),
                          ),
                          // : Positioned(
                          //     top: 50,
                          //     bottom: 50,
                          //     left: 50,
                          //     right: 50,
                          //     child: Center(child: CircularProgressIndicator.adaptive()),
                          //   ),
                          Positioned(
                            top: 50,
                            bottom: 50,
                            left: 50,
                            right: 50,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  print("playerr state${player.state.toString()}");
                                  print("player valueeeE::: ${player.value}");
                                  // player.

                                  isPauseVisible ? player.pause() : player.start();

                                  isPauseVisible = !isPauseVisible;

                                  // if (_controller.value.isPlaying) {
                                  //   isPauseVisible = false;
                                  // } else {
                                  //   isPauseVisible = true;
                                  // }
                                  // playVideo();
                                  // count();
                                  setState(() {});
                                },
                                child: isIconVisible
                                    ? isPauseVisible
                                        ? Image.asset(
                                            AppImage.pauseIcon,
                                            height: 45,
                                            width: 45,
                                            color: Colors.white,
                                          )
                                        : Image.asset(AppImage.playIcon, height: 45, width: 45, color: Colors.white)
                                    : SizedBox(),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 40,
                            right: 15,
                            child: IconButton(
                                onPressed: () async {
                                  isLandScape = await setOrientation(context);
                                  print("issssssLandScapesssssss$isLandScape");
                                  setState(() {});
                                },
                                icon: Image.asset(
                                  "assets/rotate_icon.png",
                                  height: 22,
                                )),
                          ),
                          Positioned(
                              top: 40,
                              left: 15,
                              child: InkWell(
                                  onTap: () async {
                                    isLandScape = await setOrientation(context);
                                    print("issssssLandScapesssssss$isLandScape");
                                    setState(() {});

                                    // if(AutoOrientation.landscapeLeftMode()){
                                    //    AutoOrientation.portraitUpMode();
                                    //}
                                  },
                                  child: BackButton(
                                    onPressed: () async {
                                      await SystemChrome.setPreferredOrientations(
                                          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
                                      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                                          overlays: SystemUiOverlay.values);
                                      Navigator.pop(context);
                                    },
                                    color: Colors.white,
                                  ))),
                          Positioned(
                              bottom: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // TextWidget(controller: _controller),
                                    ]),
                              )),
                          Positioned(
                              bottom: 10,
                              right: 3,
                              child: Text("${widget.videoDuration}",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )))
                        ],
                      ),
                    ),
                  )),
                ),
                // _controller.value.isInitialized
                //     ? VideoProgressIndicator(_controller, allowScrubbing: true)
                //     : SizedBox(),
                // Padding(
                //   padding: const EdgeInsets.all(12),
                //   child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         TextWidget(controller: _controller),
                //         Text("${widget.videoDuration}",
                //             style: TextStyle(
                //               color: Colors.white,
                //             ))
                //       ]),
                // )
              ],
            ),
          )

          // child: WebviewScaffold(
          //   url: url,
          // ),
          ),
    );
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    // _controller.dispose();
    player.release();

    super.dispose();
  }

  // Future setOrientation() async {
  //   bool isLandScape =
  //       MediaQuery.of(context).orientation == Orientation.landscape;
  //   if (isLandScape) {
  //     await SystemChrome.setPreferredOrientations(
  //         [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //   } else {
  //     await SystemChrome.setPreferredOrientations(
  //         [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  //   }
  // }

  // playVideo() {
  //   _controller.value.isPlaying ? _controller.pause() : _controller.play();
  //   setState(() {});
}

// hideIcon(bool isIconVisible) {
//   Future.delayed(Duration(seconds: 3), () {
//     if (isIconVisible) {
//       isIconVisible = false;
//     }
//   });
// }
// }

Future<bool> setOrientation(BuildContext context) async {
  bool isLandScape = MediaQuery.of(context).orientation == Orientation.landscape;
  print("isLandScapeeeeeeee//////// $isLandScape");
  if (isLandScape) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

    return false;
  } else {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return true;
  }
}

class TextWidget extends StatefulWidget {
  final VideoPlayerController controller;
  TextWidget({Key key, this.controller}) : super(key: key);

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  String timeDuration = "";
  @override
  void initState() {
    widget.controller.addListener(() {
      timeDuration = getPosition(widget.controller);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      timeDuration,
      style: TextStyle(color: Colors.white),
    );
  }
}

String getPosition(VideoPlayerController _controller) {
  final duration = Duration(milliseconds: _controller.value.position.inMilliseconds.round());
  return [duration.inMinutes, duration.inSeconds].map((e) => e.remainder(60).toString().padLeft(2, "0")).join(":");
}
