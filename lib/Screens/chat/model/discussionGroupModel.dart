class DisscussionGropModel {
  String title;
  String groupId;
  String createdAt;
  String createdBy;
  int commentsCount;
  String ownerId;
  String courseName;
  List<String> ops;

  DisscussionGropModel({
    this.title,
    this.createdAt,
    this.createdBy,
    this.ownerId,
    this.groupId,
    this.commentsCount,
    this.courseName,
    this.ops,
  });

  DisscussionGropModel.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? "";
    createdAt = json['createdAt'] ?? "0";
    createdBy = json['createdBy'] ?? "";
    groupId = json['groupId'] ?? "";
    courseName = json['courseName'] ?? "";
    commentsCount = json['commentsCount'] ?? 0;
    ownerId = json['ownerId'] ?? "";
    List<dynamic> olist = json['options'] ?? [];
    ops = olist.map((item) => item.toString()).toList();
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "messageType": createdAt,
        "createdAt": createdAt,
        "createdBy": createdBy,
        "groupId": groupId,
        "commentsCount": commentsCount,
        "ownerId": ownerId,
        "courseName":courseName
      };
}
