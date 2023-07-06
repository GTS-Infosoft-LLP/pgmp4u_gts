import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircularCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final Color borderColor;
  final double borderWidth;

  const CircularCachedNetworkImage({
    this.imageUrl,
    this.size,
    this.borderColor = Colors.black,
    this.borderWidth = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width: size - (2 * borderWidth),
          height: size - (2 * borderWidth),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
