import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pgmp4u/utils/app_color.dart';

import '../../../tool/ShapeClipper2.dart';
import '../../../utils/sizes.dart';

class PlaylistPage extends StatefulWidget {
  PlaylistPage({Key key, this.title, this.url}) : super(key: key);

  String title;
  String url;

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  Future<List> getData() async {
    final response = await http.get(Uri.parse(widget.url));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
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
                          Text(
                            widget.title,
                            style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontFamily: "Raleway",
                                fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
                FutureBuilder<List>(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? new VideoList(list: snapshot.data)
                        : Container(
                            height: MediaQuery.of(context).size.height * .5,
                            child:
                                Center(child: new CircularProgressIndicator()));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VideoList extends StatelessWidget {
  List list;
  VideoList({@required this.list});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, index) {
        return new Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () => {
              Navigator.of(context).push(
                new MaterialPageRoute(
                  builder: (BuildContext context) => new VideoPlay(
                    url:
                        "https://youtube.com/embed/${list[index]['contentDetails']['videoId']}",
                  ),
                ),
              ),
            },
            child: Card(
              margin: EdgeInsets.only(bottom: 1),
              elevation: 2,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 210,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(list[index]['snippet']
                                ['thumbnails']['high']['url']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        list[index]['snippet']['title'],
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
          ),
        );
      },
    );
  }
}

class VideoPlay extends StatelessWidget {
  final String url;
  VideoPlay({@required this.url});
  @override
  Widget build(BuildContext context) {
    return Center(
        // child: WebviewScaffold(
        //   url: url,
        // ),
        );
  }
}
