import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pgmp4u/Models/get_video_by_type_response.dart';
import 'package:pgmp4u/provider/player_provider.dart';
import 'package:pgmp4u/provider/response_provider.dart';
import 'package:pgmp4u/utils/app_color.dart';
import 'package:pgmp4u/utils/appimage.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../tool/ShapeClipper2.dart';
import '../../../utils/sizes.dart';

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
    print(" call playlist screen");
    print(" video type ${widget.videoType}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ResponseProvider responseProvider =
        Provider.of(context, listen: false);
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
                  children: <Widget>[
                    ClipPath(
                      clipper: ShapeClipperMirrored(),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xff3643a3), Color(0xff5468ff)],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 40, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(width: 15,),
                          Flexible(
                            child: Center(
                              child: Text(
                                widget.title,
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontFamily: "Raleway",
                                    fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: Center(
                              child: IconButton(
                                icon:
                                    Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
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
                    "Videos 4 U",
                    style: TextStyle(
                        fontSize: 24,
                        color: AppColor.darkText,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                    child: FutureBuilder<GetVideoByType>(
                  future:
                      responseProvider.getCardVideoTypeApi(widget.videoType),
                  builder: (ctx, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text("kamal none");
                      case ConnectionState.waiting:
                        return Container(
                            height: MediaQuery.of(context).size.height * .5,
                            child:
                                Center(child: new CircularProgressIndicator()));

                      case ConnectionState.active:
                        return Text("data");
                      case ConnectionState.done:
                     if (snapshot.hasData) {
                      return VideoList(snapshot.data.videoListing);
                    } else {
                      return Container(
                          height: MediaQuery.of(context).size.height * .5,
                          child:
                              Center(child: Text("No Data Found",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)));
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
    return ListView.builder(
      shrinkWrap: true,
      itemCount: getVideoListing == null ? 0 : getVideoListing.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        GetVideoByTypeListing list = getVideoListing[index];
        return new Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (context) => new VideoPlay(
                    url: "${list.videoURl}",
                    videoDuration: "${list.videoDuration}",
                  ),
                ),
              );
              // SystemChrome.setPreferredOrientations([
              //   // DeviceOrientation.portraitUp,
              //   DeviceOrientation.portraitDown
              // ]);
            },
            child: Card(
              margin: EdgeInsets.only(bottom: 1),
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
                              list.thunnailUrl,
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
                          child: Image.asset(
                            AppImage.playIcon,
                            height: 55,
                            width: 55,
                          ),
                        )
                      ]),
                    ),
                    SizedBox(height: 10),
                    Text(
                      list.title,
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
            ),
          ),
        );
      },
    );
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
  VideoPlayerController _controller;
  bool isPauseVisible;
  bool isIconVisible = true;

//  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // setLandScape();

    _controller = VideoPlayerController.network(
      widget.url,
    )..initialize().then((_) {
        // setState(() {});
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        // Future.delayed(Duration(seconds: 2)).then((value) {
        //   setState(() {});
        // });

        playVideo();
        count();
      });

    // playerProvider = Provider.of(context, listen: false);
    isPauseVisible = true;
    // if (_controller.value.isPlaying) {
    //   isIconVisible = false;
    // }

    setState(() {});
    VideoProgressIndicator(_controller, allowScrubbing: true);
    // _controller.initialize();
    _controller.setLooping(true);
    super.initState();
  }

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
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
         await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
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
                      child: 
                      Stack(
                        children: [
                          _controller.value.isInitialized
                              ? Center(
                                  child: AspectRatio(
                                    child: VideoPlayer(_controller),
                                    aspectRatio: _controller.value.aspectRatio + 0.5,
                                  ),
                                )
                              : Positioned(
                                  top: 50,
                                  bottom: 50,
                                  left: 50,
                                  right: 50,
                                  child: Center(
                                      child:
                                          CircularProgressIndicator.adaptive()),
                                ),
                          Positioned(
                            top: 50,
                            bottom: 50,
                            left: 50,
                            right: 50,
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  if (_controller.value.isPlaying) {
                                    isPauseVisible = false;
                                  } else {
                                    isPauseVisible = true;
                                  }
                                  playVideo();
                                  count();
                                  // setState(() {});
                                },
                                child: isIconVisible
                                    ? isPauseVisible
                                        ? Image.asset(
                                            AppImage.pauseIcon,
                                            height: 45,
                                            width: 45,
                                            color: Colors.white,
                                          )
                                        : Image.asset(AppImage.playIcon,
                                            height: 45,
                                            width: 45,
                                            color: Colors.white)
                                    : SizedBox(),
                              ),
                            ),
                            
                          ) ,  Positioned(
                              top: 40,
                              right: 15,
                              child: 
                              IconButton(onPressed: () async {
                                 isLandScape = await setOrientation(context);
                                    print("issssssLandScapesssssss$isLandScape");
                                    setState(() {});

                              }, icon : Image.asset("assets/rotate_icon.png",height: 22,)),
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
                                  child: BackButton(onPressed: ()async{
                                     await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
           await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
             Navigator.pop(context);
                                  },color: Colors.white,))),
                        
                        Positioned(bottom: 10,child:
                           Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(controller: _controller),
                       
                      ]),
                )
                         ),
                         Positioned(bottom: 10,right: 3,child: 
                         Text("${widget.videoDuration}",
                            style: TextStyle
                            (
                              color: Colors.white,
                            )

                            )
                         )
                        ],
                      ),
                    ),
                  )),
                ),
                _controller.value.isInitialized
                    ? VideoProgressIndicator(_controller, allowScrubbing: true)
                    : SizedBox(),
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
    _controller.dispose();

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

  playVideo() {
    _controller.value.isPlaying ? _controller.pause() : _controller.play();
    setState(() {});
  }

  // hideIcon(bool isIconVisible) {
  //   Future.delayed(Duration(seconds: 3), () {
  //     if (isIconVisible) {
  //       isIconVisible = false;
  //     }
  //   });
  // }
}

Future<bool> setOrientation(BuildContext context) async {
  bool isLandScape =
      MediaQuery.of(context).orientation == Orientation.landscape;
  print("isLandScapeeeeeeee//////// ${isLandScape}");
  if (isLandScape) {
    
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
       await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    return false;
  } else {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      await SystemChrome.setEnabledSystemUIOverlays([]);
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
  final duration =
      Duration(milliseconds: _controller.value.position.inMilliseconds.round());
  return [duration.inMinutes, duration.inSeconds]
      .map((e) => e.remainder(60).toString().padLeft(2, "0"))
      .join(":");
}
