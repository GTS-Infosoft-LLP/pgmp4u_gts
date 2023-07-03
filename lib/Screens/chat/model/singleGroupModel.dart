class PersonalGroupModel {
  String groupId;
  String createdAt;

  String lastMessage;

  List<MyUserInfo> members;

  PersonalGroupModel({
    this.createdAt,
    this.groupId,
    this.lastMessage,
    this.members,
  });

  PersonalGroupModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'] ?? "0";
    groupId = json['groupId'] ?? "";

    lastMessage = json['lastMessage'] ?? '';

    if (json['members'] == null) {
      members = [];
    }
    members = List<MyUserInfo>.from(json['members'].map((x) => MyUserInfo.fromJson(x)));
  }

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt,
        "groupId": groupId,
        "lastMessage": lastMessage,
        "members": members,
      };
}

class MyUserInfo {
  final String id;
  final String name;
  final bool isAdmin;

  MyUserInfo({this.id, this.name, this.isAdmin});

  factory MyUserInfo.fromJson(Map<String, dynamic> json) => MyUserInfo(
        id: json["id"],
        name: json["name"],
        isAdmin: json["isAdmin"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isAdmin": isAdmin,
      };
}
