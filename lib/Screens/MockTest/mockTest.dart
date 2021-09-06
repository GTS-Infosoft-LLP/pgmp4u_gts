import 'package:flutter/material.dart';

class MockTest extends StatefulWidget {
  const MockTest({Key key}) : super(key: key);

  @override
  _MockTestState createState() => _MockTestState();
}

class _MockTestState extends State<MockTest> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    Color _colorfromhex(String hexColor) {
      final hexCode = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                            '  Mock Test',
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
                      Container(
                        margin: EdgeInsets.only(bottom: height * (22 / 800)),
                        child: Text(
                          'Mock Tests 4U',
                          style: TextStyle(
                            fontFamily: 'Roboto Bold',
                            fontSize: width * (18 / 420),
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: 12,
                          bottom: 14,
                          left: width * (14 / 320),
                          right: width * (14 / 320),
                        ),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    padding: EdgeInsets.all(17),
                                    decoration: BoxDecoration(
                                        color: _colorfromhex("#72A258"),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: Center(
                                        child: Text('1'),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: width * (17 / 420)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Mock Test 1',
                                          style: TextStyle(
                                            fontFamily: 'Roboto Medium',
                                            fontWeight: FontWeight.w600,
                                            fontSize: width * (17 / 420),
                                            color: _colorfromhex("171726"),
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top:14),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 25,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                  color: _colorfromhex("#E4FFE6"),
                                                  border: Border.all(
                                                    color:
                                                        _colorfromhex("#04AE0B"),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(3.0),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '80%',
                                                    style: TextStyle(
                                                      fontFamily: 'Roboto Medium',
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 8,
                                                      color: _colorfromhex(
                                                          "#04AE0B"),
                                                      letterSpacing: 0.3,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.east,
                              size: 30,
                              color: _colorfromhex("#ABAFD1"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
