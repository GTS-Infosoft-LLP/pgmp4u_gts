import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pgmp4u/Screens/Domain/screens/domainProvider.dart';
import 'package:provider/provider.dart';

class ImageDispalyScreen extends StatefulWidget {
  String quesImages;
  ImageDispalyScreen({Key key, this.quesImages = ""}) : super(key: key);

  @override
  State<ImageDispalyScreen> createState() => _ImageDispalyScreenState();
}

class _ImageDispalyScreenState extends State<ImageDispalyScreen> {
  @override
  void initState() {
    print("quesImages:::::::::::${widget.quesImages}");
    super.initState();
    _setOrientation([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  _setOrientation(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }

  @override
  void dispose() {
    super.dispose();
    _setOrientation([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    DomainProvider dp = Provider.of(context, listen: false);
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          child: InkWell(
            onTap: () {},
            child: Container(
              height: DeviceOrientation == Orientation.landscape
                  ? MediaQuery.of(context).size.height * .7
                  : MediaQuery.of(context).size.height * .7,
              width: MediaQuery.of(context).size.width * .9,
              // width: DeviceOrientation == Orientation.landscape
              //     ? MediaQuery.of(context).size.height * .9
              //     : MediaQuery.of(context).size.height * .8,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                // color: Colors.black38,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: InteractiveViewer(
                  child: CachedNetworkImage(
                    imageUrl: widget.quesImages.isNotEmpty
                        ? widget.quesImages
                        : dp.TaskDetailList[0].Image != null
                            ? dp.TaskDetailList[0].Image
                            : '',
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 78.0, vertical: 28),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey[400],
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                        height: MediaQuery.of(context).size.width * .4, child: Center(child: Icon(Icons.error))),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(16.0), bottomLeft: Radius.circular(16.0)),
          gradient: LinearGradient(
              colors: [
                Color(0xff4B5BE2),
                Color(0xff2135D9),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
      ),
      title: Center(
          child: Text(
        "",
        // widget.quesImages.isNotEmpty ? "" : 'Flow Diagram      ',
        style: TextStyle(color: Colors.white),
      )),
    );
  }
}
