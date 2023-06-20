
class VideoCateDetails {
  int id;
  String name;
  int position;
  int courseId;
  int masterList;
  int payment_status;
  String price;
  int status;
  int deleteStatus;
 

  VideoCateDetails.fromjson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    position = json["position"];
    courseId = json["courseId"];
    masterList = json["masterList"];
    payment_status = json["payment_status"];
    price = json["price"];
    status = json["status"];
    deleteStatus = json["deleteStatus"];
  }
}
