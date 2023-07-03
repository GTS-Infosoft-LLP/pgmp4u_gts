class PersonalGroupModel {
  String groupId;
  String createdAt;

  String lastMessage;

  List<MyUserInfo> members;
  List<dynamic> membersId;

  PersonalGroupModel({
    this.createdAt,
    this.groupId,
    this.lastMessage,
    this.members,
    this.membersId,
  });

  PersonalGroupModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'] ?? "0";
    groupId = json['groupId'] ?? "";

    lastMessage = json['lastMessage'] ?? '';
    membersId = json['membersId'] ?? [];

    if (json['members'] == null) {
      members = [];
    }
    members = List<MyUserInfo>.from(json['members'].map((x) => MyUserInfo.fromJson(x)));
  }

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt,
        "groupId": groupId,
        "lastMessage": lastMessage,
        "members": List<Map>.from(members.map((x) => x.toJson())),
        "membersId": membersId
      };
}

class MyUserInfo {
  final String id;
  final String name;
  final int isAdmin;

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
