
class VideoDetails {
  int id;
  int videoType;
  int categoryId; 
  String videoUrl;
  String title;
  String thumbnailUrl;
  String videoDuration;
  int status;
  int deleteStatus;
 

  VideoDetails.fromjson(Map<String, dynamic> json) {
    id = json["id"];
    videoType = json["videoType"];
    categoryId = json["categoryId"];
    videoUrl = json["videoUrl"];
    title = json["title"];
    thumbnailUrl = json["thumbnailUrl"];
    videoDuration = json["videoDuration"];
    status = json["status"];
    deleteStatus = json["deleteStatus"];
  }
}
