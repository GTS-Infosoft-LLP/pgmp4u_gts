import 'package:hive/hive.dart';
  part 'courseModel.g.dart';

@HiveType(typeId: 13)
class CourseDetails {
  @HiveField(0)
  int id;
  @HiveField(1)
  String course;
  @HiveField(2)
  String description;
  @HiveField(3)
  String exam_Time;
  @HiveField(4)
  String lable;
  @HiveField(5)
  int skip_content_progress;
  @HiveField(6)
  int status;
  @HiveField(7)
  int deleteStatus;

  CourseDetails();

  CourseDetails.fromjson(Map<String, dynamic> json) {
    id = json["id"];
    course = json["course"];
    description = json["description"];
    lable = json["lable"];
    exam_Time = json["exam_Time"];
    skip_content_progress = json["skip_content_progress"];
    status = json["status"];
    deleteStatus = json["deleteStatus"];
  }
}
