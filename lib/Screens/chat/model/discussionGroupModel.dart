class DisscussionGropModel {
  String title;
  String groupId;
  String createdAt;
  String createdBy;
  String viewedBy;

  DisscussionGropModel({
    this.title,
    this.createdAt,
    this.createdBy,
    this.groupId,
    this.viewedBy,
  });

  DisscussionGropModel.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? "";
    createdAt = json['createdAt'] ?? "0";
    createdBy = json['createdBy'] ?? "";
    groupId = json['groupId'] ?? "";
    viewedBy = json['viewedBy'] ?? "0";
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "messageType": createdAt,
        "createdAt": createdAt,
        "createdBy": createdBy,
        "groupId": groupId,
        "viewedBy": viewedBy
      };
}
