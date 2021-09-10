import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:intro_slider/scrollbar_behavior_enum.dart';

class Test extends StatefulWidget {
  const Test({Key key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

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
        centerWidget: Image.asset('assets/Vector2.png'),
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

  Widget renderNextBtn() {
    return Text('Next');
  }

  Widget renderDoneBtn() {
    return Text('Done');
  }

  Widget renderSkipBtn() {
    return Text('Skip');
  }

  

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return IntroSlider(
      // List slides
      slides: this.slides,

      // Skip button
      renderSkipBtn: this.renderSkipBtn(),
     
     

      // Next button
      renderNextBtn: this.renderNextBtn(),



      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      
      

      // Dot indicator
      colorDot: _colorfromhex("#F1F1FE"),
      colorActiveDot:  _colorfromhex("#4849DF"),
      sizeDot: 13.0,

      // Show or hide status bar
      hideStatusBar: true,
      backgroundColorAllSlides: Colors.grey,

      // Scrollbar
      verticalScrollbarBehavior: scrollbarBehavior.SHOW_ALWAYS,
    );
  }
}
