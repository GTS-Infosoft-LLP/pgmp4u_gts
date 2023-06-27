import 'package:flutter/material.dart';

class ProfilePic extends StatefulWidget {
  ProfilePic({Key key, this.image}) : super(key: key);
  String image;

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  @override
  Widget build(BuildContext context) {
    
    return Container(
      // height: height,
      // width: width,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: NetworkImage(widget.image))),
      ),
    );
  }
}
