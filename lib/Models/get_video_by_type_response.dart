class GetVideoByType {
  List<GetVideoByTypeListing> videoListing = [];

  GetVideoByType.fromJson(Map<String, dynamic> json) {
    videoListing = List<GetVideoByTypeListing>.from(
        json["videoList"].map((x) => GetVideoByTypeListing.fromJson(x)));
  }
}

class GetVideoByTypeListing {
  int id;
  int videoType;
  String videoURl;
  String thunnailUrl;
  String videoDuration;
  int deleteStatus;
  int status;
  String title;

  GetVideoByTypeListing.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    videoType = json["videoType"] ?? 0;
    videoURl = json["videoUrl"] ?? "";
    thunnailUrl = json["thumbnailUrl"] ?? "";
    videoDuration = json["videoDuration"] ?? "";
    deleteStatus = json["deleteStatus"] ?? 0;
    status = json["status"] ?? 0;
    title = json["title"] ?? "";
  }
}
