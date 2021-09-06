import 'package:flutter/material.dart';

class TestsScreen extends StatefulWidget {
  const TestsScreen({Key key}) : super(key: key);

  @override
  _TestsScreenState createState() => _TestsScreenState();
}

class _TestsScreenState extends State<TestsScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    Color _colorfromhex(String hexColor) {
      final hexCode = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    }

    return Container(
      child: Column(
        children: [
          Container(
            height: 149,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg_layer.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(
                  left: width * (20 / 420),
                  right: width * (20 / 420),
                  top: height * (16 / 800)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.menu,
                        size: width * (24 / 420),
                        color: Colors.white,
                      ),
                      Text(
                        '  Test',
                        style: TextStyle(
                            fontFamily: 'Roboto Medium',
                            fontSize: width * (16 / 420),
                            color: Colors.white,
                            letterSpacing: 0.3),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: width * (16 / 420)),
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
          ),
          Container(
              margin: EdgeInsets.only(
                  left: width * (18 / 420), right: width * (18 / 420)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tests4U',
                      style: TextStyle(
                          fontFamily: 'Roboto Bold',
                          fontSize: width * (18 / 420),
                          color: Colors.black,
                          letterSpacing: 0.3),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pushNamed('/practice-test'),
                      child: Container(
                        margin: EdgeInsets.only(
                            top: height * (22 / 800),
                            bottom: height * (32 / 800)),
                        width: width,
                        padding: EdgeInsets.only(
                            top: height * (25 / 800),
                            bottom: height * (47 / 800)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(bottom: height * (12 / 800)),
                              padding: EdgeInsets.all(width * (14 / 420)),
                              decoration: BoxDecoration(
                                color: _colorfromhex("#72A258"),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Image.asset('assets/Vector-2.png'),
                            ),
                            Text(
                              'Test your Knowledge',
                              style: TextStyle(
                                  fontFamily: 'Roboto Medium',
                                  fontSize: width * (12 / 420),
                                  color: _colorfromhex("#ABAFD1"),
                                  letterSpacing: 0.3),
                            ),
                            Container(
                              height: height * (2 / 800),
                            ),
                            Text(
                              'Practice Test',
                              style: TextStyle(
                                  fontFamily: 'Roboto Medium',
                                  fontSize: width * (22 / 420),
                                  color: Colors.black,
                                  letterSpacing: 0.3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          {Navigator.of(context).pushNamed('/mock-test')},
                      child: Container(
                        margin: EdgeInsets.only(
                            top: height * (22 / 800),
                            bottom: height * (32 / 800)),
                        width: width,
                        padding: EdgeInsets.only(
                            top: height * (25 / 800),
                            bottom: height * (47 / 800)),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.only(bottom: height * (12 / 800)),
                              padding: EdgeInsets.all(width * (14 / 420)),
                              decoration: BoxDecoration(
                                color: _colorfromhex("#463B97"),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Image.asset('assets/Vector-3.png'),
                            ),
                            Text(
                              'Test your Exam Readiness',
                              style: TextStyle(
                                  fontFamily: 'Roboto Medium',
                                  fontSize: width * (12 / 420),
                                  color: _colorfromhex("#ABAFD1"),
                                  letterSpacing: 0.3),
                            ),
                            Container(
                              height: height * (2 / 800),
                            ),
                            Text(
                              'Mock Test',
                              style: TextStyle(
                                  fontFamily: 'Roboto Medium',
                                  fontSize: width * (22 / 420),
                                  color: Colors.black,
                                  letterSpacing: 0.3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
