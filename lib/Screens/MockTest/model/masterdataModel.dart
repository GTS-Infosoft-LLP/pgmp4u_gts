class MasterDetails {
  int id;
  String name;
  String type;
  int position;
  String label;
  int courseId;
  int status;
  int deleteStatus;
 

  MasterDetails.fromjson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    type = json["type"];
    position = json["position"];
    label = json["lable"];
    courseId = json["courseId"];
    status = json["status"];
    deleteStatus = json["deleteStatus"];
  }
}
