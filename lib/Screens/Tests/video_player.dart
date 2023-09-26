
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerDemo extends StatefulWidget {
  final String videoid;
  const YoutubePlayerDemo({Key key,  this.videoid}) : super(key: key);
  
  @override
  _YoutubePlayerDemoState createState() => _YoutubePlayerDemoState();
}
class _YoutubePlayerDemoState extends State<YoutubePlayerDemo> {
   YoutubePlayerController _ytbPlayerController;
  @override
  void initState() {
    super.initState();
    _setOrientation([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _ytbPlayerController = YoutubePlayerController(
          
          initialVideoId: widget.videoid,

          params: const YoutubePlayerParams(
            showFullscreenButton: true,
          ),
        );
      });
    });
  }
  @override
  void dispose() {
    super.dispose();
    _setOrientation([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _ytbPlayerController.close();
  }
  _setOrientation(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _ytbPlayerController.mute();
        _ytbPlayerController.close();
        Navigator.pop(context);
        return true;
      },
      child: _ytbPlayerController != null
          ? YoutubePlayerIFrame(controller: _ytbPlayerController)
          : const Center(child: CircularProgressIndicator()),
    );
  }
}