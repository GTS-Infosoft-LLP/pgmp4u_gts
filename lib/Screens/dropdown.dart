import 'package:flutter/material.dart';

class CustomDropDown<T> extends StatelessWidget {
  CustomDropDown({
    Key key,
    this.onChange,
    this.value,
    this.itemList,
    this.title,
    this.mandatoryField = false,
    this.isEnable,
    this.selectText = "Select",
    this.isGrey = true,
    this.color,
    this.selecttextcolor,
    this.fontfamily,
    this.width,
  }) : super(key: key);
  final Function(T value) onChange;
  final T value;
  final List<T> itemList;
  final String title;
  final bool mandatoryField;
  final bool isEnable;
  bool isGrey;
  String selectText;

  final color;
  final selecttextcolor;
  final fontfamily;
  final width;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
              boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 0))],
              color: Colors.white,
              // border: Border.all(
              //   color: Colors.red,
              // ),
              // gradient: LinearGradient(
              //     colors: [_colorfromhex('#3846A9'), _colorfromhex('#5265F8')],
              //     begin: const FractionalOffset(0.0, 0.0),
              //     end: const FractionalOffset(1.0, 0.0),
              //     stops: [0.0, 1.0],
              //     tileMode: TileMode.clamp),
              borderRadius: BorderRadius.circular(28)),
          height: 56,
          width: width,
          child: Center(
            child: DropdownButton<T>(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              focusColor: Colors.blueAccent,
              value: value,
              //elevation: 5,
              style: TextStyle(color: Colors.red),
              items: itemList.map<DropdownMenuItem<T>>((T value) {
                return DropdownMenuItem<T>(
                    //alignment: Alignment.bottomCenter,

                    value: value,
                    child: Container(
                      margin: EdgeInsets.only(top: 10.0),
                      width: double.maxFinite,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              (value as DropDownModel).getOptionName(),
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black87))),
                            width: double.maxFinite,
                          ),
                        ],
                      ),
                    ));
              }).toList(),
              isExpanded: true,
              underline: const SizedBox(),
              hint: Text(
                selectText,
                style: TextStyle(
                    color: isGrey ? Colors.black : Colors.black,
                    fontSize: 15,
                    fontFamily: fontfamily,
                    fontWeight: FontWeight.bold),
              ),

              dropdownColor: Colors.white,

              onChanged: !isEnable
                  ? null
                  : (T value) {
                      // setState(() {
                      onChange(value);

                      // });
                    },
            ),
          ),
        ),
      ],
    );
  }

  _colorfromhex(String s) {
    final hexCode = s.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}

class DropDownModel {
  String getOptionName() {}
}

class CourseTypeModl implements DropDownModel {
  final String title;
  final String typeId;

  CourseTypeModl({
    this.title,
    this.typeId,
  });

  @override
  String getOptionName() {
    return title;
  }
}
