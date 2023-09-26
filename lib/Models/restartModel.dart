import 'package:hive_flutter/hive_flutter.dart';
part 'restartModel.g.dart';

@HiveType(typeId: 18)
class RestartModel {
  @HiveField(0)
  int restartAttempNum;
  @HiveField(1)
  String displayTime;
  @HiveField(2)
  int quesNum;
  @HiveField(3)
  List<Map<String, dynamic>> answersMapp;
  @HiveField(4)
  List<dynamic> atempedData;
  RestartModel({this.restartAttempNum, this.displayTime, this.quesNum, this.answersMapp, this.atempedData});

  RestartModel.fromjson(Map<String, dynamic> jsn) {
    restartAttempNum = jsn["restartAttempNum"];
    displayTime = jsn["displayTime"];
    quesNum = jsn["quesNum"];
    answersMapp = jsn["answersMapp"];
    atempedData = jsn["atempedData"];
  }
}
