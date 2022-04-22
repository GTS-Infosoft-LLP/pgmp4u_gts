import 'package:flutter/material.dart';

class ShapeClipperMirrored extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    print(">>>>>> size $size");
    final Path path = Path();
    print(">>>>>> path ${path}");
    path.lineTo(0.0, size.height - 80.0);

    print("line ${size.height - 80}");
    var firstEndPoint = Offset(size.width * .5, size.height - 30.0);
    var firstControlpoint = Offset(size.width * 0.25, size.height - 10);
    path.quadraticBezierTo(firstControlpoint.dx, firstControlpoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height);
    var secondControlPoint = Offset(size.width * .75, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
