import 'package:flutter/material.dart';

class CustomDropDown<T> extends StatefulWidget {
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
  double width;

  @override
  State<CustomDropDown<T>> createState() => _CustomDropDownState<T>();
}

class _CustomDropDownState<T> extends State<CustomDropDown<T>> {
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
              //   color: Colors.grey,
              // ),
              borderRadius: BorderRadius.circular(28)),
          height: 56,
          width: widget.width,
          child: DropdownButton<T>(
            alignment: Alignment.centerLeft,

            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
            focusColor: Colors.blueAccent,
            value: widget.value,

            // elevation: 10,
            style: TextStyle(color: Colors.red),
            items: widget.itemList.map<DropdownMenuItem<T>>((T value) {
              return DropdownMenuItem<T>(
                //alignment: Alignment.bottomCenter,

                value: value,
                child: Container(
                  margin: EdgeInsets.only(top: 10.0),
                  width: double.maxFinite,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey),
                    ),
                  ),
                  child: Text(
                    (value as DropDownModel).getOptionName(),
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }).toList(),
            isExpanded: true,
            underline: const SizedBox(),
            hint: Text(
              widget.selectText,
              style: TextStyle(
                  color: widget.isGrey ? Colors.black : Colors.black,
                  fontSize: 15,
                  fontFamily: widget.fontfamily,
                  fontWeight: FontWeight.bold),
            ),
            dropdownColor: Colors.white,
            onChanged: !widget.isEnable
                ? null
                : (T value) {
                    // setState(() {
                    widget.onChange(value);

                    // });
                  },
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
