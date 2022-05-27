import 'package:flutter/material.dart';

import '../Screens/home_view/home.dart';

enum homeOption {
  application,
  videoLab,
  flashCard,
  domainWise,
  lissonsLearn,
  about
}

class OptionsItem {
  final String name;
  final IconData iconImage;
  final homeOption screen;
  final String btntxt;
  OptionsItem({this.iconImage, this.name, this.screen,this.btntxt});
}
