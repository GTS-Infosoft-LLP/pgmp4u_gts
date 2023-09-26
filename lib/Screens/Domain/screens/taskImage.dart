import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pgmp4u/Screens/Domain/screens/taskDetails.dart';
import 'package:provider/provider.dart';

import 'domainProvider.dart';

class TaskImage extends StatefulWidget {
  int index;
  TaskImage({Key key, this.index}) : super(key: key);

  @override
  State<TaskImage> createState() => _TaskImageState();
}

class _TaskImageState extends State<TaskImage> {
  _setOrientation(List<DeviceOrientation> orientations) {
    SystemChrome.setPreferredOrientations(orientations);
  }

  @override
  void initState() {
    _setOrientation([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    print("dis is called");
    _setOrientation([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    DomainProvider dp = Provider.of(context, listen: false);
    return OrientationBuilder(
      builder: (context, orientation) {
        print("orientationnnn====$orientation");
        return orientation == Orientation.landscape ? landscapeView(context, dp) : potraitView(context, dp);
        // return orientation == Orientation.portrait ? simpelWidget() : simpelWidget();
      },
    );
  }

  simpelWidget() {
    return Text("hi");
  }

  Padding landscapeView(BuildContext context, DomainProvider dp) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25,
          ),
          Text(
            "  Flow Diagram",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: 'Roboto Regular',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10),
            child: InkWell(
              onTap: () {
                showImage(context, dp.TaskDetailList[0].Image);
              },
              child: Container(
                // width: MediaQuery.of(context).size.width * .92,
                // height: MediaQuery.of(context).size.height * .2,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: dp.TaskDetailList[0].Image != null ? dp.TaskDetailList[0].Image : '',
                    fit: BoxFit.cover,
                    // width: MediaQuery.of(context).size.width * .92,
                    // height: MediaQuery.of(context).size.height * .2,
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
        ],
      ),
    );
  }

  Padding potraitView(BuildContext context, DomainProvider dp) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25,
          ),
          Text(
            "  Flow Diagram",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: 'Roboto Regular',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10),
            child: InkWell(
              onTap: () {
                showImage(context, dp.TaskDetailList[0].Image);
              },
              child: Container(
                // width: MediaQuery.of(context).size.width * .92,
                // height: MediaQuery.of(context).size.height * .2,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: dp.TaskDetailList[0].Image != null ? dp.TaskDetailList[0].Image : '',
                    fit: BoxFit.cover,
                    // width: MediaQuery.of(context).size.width * .92,
                    // height: MediaQuery.of(context).size.height * .2,
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
        ],
      ),
    );
  }
}
