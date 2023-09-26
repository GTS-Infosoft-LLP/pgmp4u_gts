import 'dart:ui';

import 'package:flutter/material.dart';

Widget blurView({Widget child}) {
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
    child: child,
  );
}
