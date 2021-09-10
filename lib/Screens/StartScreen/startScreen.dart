import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:intro_slider/scrollbar_behavior_enum.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  int _currentIndex = 1;
  List<Slide> slides = [];
  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "Learn Anytime",
        maxLineTitle: 2,
        styleTitle: TextStyle(
            color: Colors.black, fontSize: 30.0, fontFamily: 'Roboto Bold'),
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
        styleDescription: TextStyle(
            color: _colorfromhex("#76767E"),
            fontSize: 14.0,
            fontFamily: 'Roboto Regular'),
        marginDescription:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
        centerWidget: Container(
          margin: EdgeInsets.only(top: 80),
          child: Image.asset('assets/reading1.png'),
        ),
        directionColorBegin: Alignment.topLeft,
        backgroundColor: Colors.white,
        directionColorEnd: Alignment.bottomRight,
        onCenterItemPress: () {},
      ),
    );
    slides.add(
      new Slide(
        title: "Test Yourself",
        styleTitle: TextStyle(
            color: Colors.black, fontSize: 30.0, fontFamily: 'Roboto Bold'),
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
        styleDescription: TextStyle(
            color: _colorfromhex("#76767E"),
            fontSize: 14.0,
            fontFamily: 'Roboto Regular'),
        directionColorBegin: Alignment.topRight,
        backgroundColor: Colors.white,
        centerWidget: Image.asset('assets/exam1.png'),
        directionColorEnd: Alignment.bottomLeft,
      ),
    );
    slides.add(
      new Slide(
        title: "Huge Resources",
        styleTitle: TextStyle(
            color: Colors.black, fontSize: 30.0, fontFamily: 'Roboto Bold'),
        description:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
        styleDescription: TextStyle(
            color: _colorfromhex("#76767E"),
            fontSize: 14.0,
            fontFamily: 'Roboto Regular'),
        directionColorBegin: Alignment.topCenter,
        backgroundColor: Colors.white,
        centerWidget: Image.asset('assets/library1.png'),
        directionColorEnd: Alignment.bottomCenter,
        maxLineTextDescription: 3,
      ),
    );
  }

  void onDonePress() {
    // Do what you want
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomeScreen()),
    // );
  }

  Widget renderNextBtn(width) {
    return Text(
      'Next',
      style: TextStyle(
        color: Colors.black,
        fontSize: width * (18 / 420),
        fontFamily: 'Roboto Regular',
      ),
    );
  }

  Widget renderDoneBtn(width) {
    return GestureDetector(
        onTap: () => {Navigator.of(context).pushNamed('/login')},
        child: Text(
          'Done',
          style: TextStyle(
            color: Colors.black,
            fontSize: width * (18 / 420),
            fontFamily: 'Roboto Regular',
          ),
        ));
  }

  Widget renderSkipBtn(width) {
    return GestureDetector(
        onTap: () => {Navigator.of(context).pushNamed('/login')},
        child: Text(
          'Skip',
          style: TextStyle(
            color: Colors.black,
            fontSize: width * (18 / 420),
            fontFamily: 'Roboto Regular',
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              height: height,
              child: IntroSlider(
                // List slides
                slides: this.slides,

                // Skip button
                renderSkipBtn: this.renderSkipBtn(width),

                // Next button
                renderNextBtn: this.renderNextBtn(width),

                // Done button
                renderDoneBtn: this.renderDoneBtn(width),
                onDonePress: () => {Navigator.of(context).pushNamed('/login')},
                onSkipPress: () => {Navigator.of(context).pushNamed('/login')},
                // Dot indicator
                colorDot: _colorfromhex("#F1F1FE"),
                colorActiveDot: _colorfromhex("#4849DF"),
                sizeDot: width * (14 / 420),

                // Show or hide status bar
                hideStatusBar: true,

                // Scrollbar
                verticalScrollbarBehavior: scrollbarBehavior.SHOW_ALWAYS,
              ),
            ),
            Positioned(
              top: -30,
              left: -120,
              child: Container(
                child: Image.asset('assets/vector1.png'),
              ),
            ),
            Positioned(
              bottom: 0,
              left: -10,
              child: Container(
                height: 180,
                child: Image.asset('assets/Vector3.png'),
              ),
            ),
            Positioned(
              top: -30,
              right: -10,
              child: Container(
                height: 180,
                child: Image.asset('assets/Vector2.png'),
              ),
            ),
            Positioned(
              bottom: 35,
              right: 0,
              child: Container(
                height: 200,
                child: Image.asset('assets/Vector4.png'),
              ),
            ),
            // Positioned(
            //   bottom: height * (18 / 800),
            //   left: 20,
            //   right: 20,
            //   child: Container(
            //     width: width,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         GestureDetector(
            //           onTap: () => {Navigator.of(context).pushNamed('/login')},
            //           child: Text(
            //             "SKIP",
            //             style: TextStyle(
            //               fontSize: width * (18 / 420),
            //               fontFamily: 'Roboto Regular',
            //             ),
            //           ),
            //         ),
            //         GestureDetector(
            //           onTap: () {
            //             setState(() {
            //               _currentIndex++;
            //             });
            //           },
            //           child: Text(
            //             "NEXT",
            //             style: TextStyle(
            //               fontSize: width * (18 / 420),
            //               fontFamily: 'Roboto Regular',
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
