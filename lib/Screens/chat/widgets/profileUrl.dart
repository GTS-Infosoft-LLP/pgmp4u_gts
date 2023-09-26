import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pgmp4u/utils/app_color.dart';

class ProfilePic extends StatefulWidget {
  ProfilePic({Key key, this.image}) : super(key: key);
  String image;

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        height: 40,
        width: 40,
        child: CachedNetworkImage(
          imageUrl: widget.image,
          placeholder: (context, url) => CircularProgressIndicator.adaptive(
            backgroundColor: AppColor.purpule,
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
