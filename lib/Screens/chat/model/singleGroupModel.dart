class PersonalGroupModel {
  String groupId;
  String createdAt;
  String ownerId;
  String lastMessage;
  List<dynamic> members;

  PersonalGroupModel({
    this.createdAt,
    this.ownerId,
    this.groupId,
    this.lastMessage,
    this.members,
  });

  PersonalGroupModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'] ?? "0";
    groupId = json['groupId'] ?? "";
    ownerId = json['ownerId'] ?? "";
    lastMessage = json['lastMessage'] ?? '';
    members = json['members'] ?? '';
  }

  Map<String, dynamic> toJson() =>
      {"createdAt": createdAt, "groupId": groupId, "ownerId": ownerId, "lastMessage": lastMessage, "members": members};
}
