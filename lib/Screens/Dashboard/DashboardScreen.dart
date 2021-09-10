import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  String photoUrl;
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('photo');
    print('stringValue');
    setState(() {
      photoUrl = stringValue;
    });
  }

  @override
  void initState() {
    super.initState();
    getValue();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        color: _colorfromhex("#FCFCFF"),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: width,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(40.0)),
                gradient: LinearGradient(
                    colors: [
                      _colorfromhex('#3846A9'),
                      _colorfromhex('#5265F8')
                    ],
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.menu,
                          size: width * (24 / 420),
                          color: Colors.white,
                        ),
                        Row(
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(right: width * (16 / 420)),
                              child: Icon(
                                Icons.search,
                                size: width * (24 / 420),
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.notifications,
                              size: width * (24 / 420),
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
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
                                  Text(
                                    'Hello, ',
                                    style: TextStyle(
                                      fontFamily: 'Roboto Regular',
                                      fontSize: width * (16 / 420),
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Ravi',
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
                        photoUrl != null
                            ? Container(
                                width: width * (80 / 420),
                                height: width * (80 / 420),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        'https://lh3.googleusercontent.com/a-/AOh14GgQe2OLjeeulfhR5C2plfKAvYguBhIreVdlrWoOYA'),
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
            Container(
              height: height - 285,
              width: width,
              margin: EdgeInsets.only(
                  top: height * (24 / 800),
                  bottom: height * (20 / 800),
                  left: width * (21 / 420)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        'Dashboard',
                        style: TextStyle(
                          fontFamily: 'Roboto Bold',
                          fontSize: width * (18 / 420),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
