class PPTDataDetails {
  int id;
  String title;

  int categoryId;
  String filename;
  int position;
  int status;
  int deleteStatus;

  PPTDataDetails.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    position = json['position'];
    categoryId = json['categoryId'];
    filename = json['filename']??"";
    status = json['status'];
    deleteStatus = json['deleteStatus'];
  }
}
