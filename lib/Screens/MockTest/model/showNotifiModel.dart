class NotifiModel {
  int id;
  String title;
  String message;
  int type;
  int questionId;
  int userId;
  int isAdmin;
  int deleteStatus;
  String courseName;
  String createdAt;
  String announcementDetails;

  NotifiModel.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
    type = json['type'];
    questionId = json['questionId'] ?? -1;
    userId = json['userId'];
    isAdmin = json['isAdmin'];
    deleteStatus = json['deleteStatus'];
    createdAt = json['createdAt'];
        courseName = json['courseName'];
    announcementDetails = json['announcementDetails'];
    //courseName
  }
}
