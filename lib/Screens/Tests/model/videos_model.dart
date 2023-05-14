class VideoApiModel {
  List<VideosListApiModel> videolist = [];

  VideoApiModel.fromJson(Map<String, dynamic> json) {
    videolist = List<VideosListApiModel>.from(
        json['list'].map((x) => VideosListApiModel.fromJson(x)));
  }
}

class VideosListApiModel {
  int id;
  int course;
  String mainCategory;
  int category;
  String type;
  int premium;
  String heading;
  String subheading;
  String shortDescription;
  String description;
  String webDescription;
  String image;
  String inputs;
  String toolsAndTechniques;
  String outputs;
  int status;
  int deleteStatus;
  int position;
  String createdAt;

  VideosListApiModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    course = json['course'];
    mainCategory = json['main_category'];
    category = json['category'];
    type = json['type'];
    premium = json['premium'];
    heading = json['heading'];
    subheading = json['subheading'];
    shortDescription = json['shortDescription'];
    description = json['description'];
    webDescription = json['web_description'];
    image = json['image'];
    inputs = json['inputs'];
    toolsAndTechniques = json['tools_and_techniques'];
    outputs = json['outputs'];
    status = json['status'];
    deleteStatus = json['deleteStatus'];
    position = json['position'];
    createdAt = json['created_at'];
  }
}
