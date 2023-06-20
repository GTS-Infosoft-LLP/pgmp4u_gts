
class FlashCardDetails {
  int id;
  int position;
  int categoryId; 
  String description;
  String title;
  String thumbnail;
  int status;
  int deleteStatus;
 

  FlashCardDetails.fromjson(Map<String, dynamic> json) {
    id = json["id"];
    position = json["position"];
    categoryId = json["categoryId"];
    description = json["description"];
    title = json["title"];
    thumbnail = json["thumbnail"];
    status = json["status"];
    deleteStatus = json["deleteStatus"];
  }
}
