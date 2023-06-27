class CourseDetails {
  int id;
  String course;
  String description;
  String exam_Time;
  String lable;
  int skip_content_progress;
  int status;
  int deleteStatus;
 

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
