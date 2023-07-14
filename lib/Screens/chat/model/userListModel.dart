// To parse this JSON data, do
//
//     final upadateLocationResponseModel = upadateLocationResponseModelFromJson(jsonString);

import 'dart:convert';

UserListResponseModel upadateLocationResponseModelFromJson(String str) =>
    UserListResponseModel.fromJson(json.decode(str));

String upadateLocationResponseModelToJson(UserListResponseModel data) => json.encode(data.toJson());

class UserListResponseModel {
  final bool success;
  List<Users> data;
  final int count;
  final int pages;
  final String message;

  UserListResponseModel({
    this.success,
    this.data,
    this.count,
    this.pages,
    this.message,
  });

  factory UserListResponseModel.fromJson(Map<String, dynamic> json) => UserListResponseModel(
        success: json["success"],
        data: List<Users>.from(json["data"].map((x) => Users.fromJson(x))),
        count: json["count"],
        pages: json["pages"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "count": count,
        "pages": pages,
        "message": message,
      };
}

class Users {
  final int userId;
  final String name;
  final String uuid;
  final int isChatAdmin;

  Users({
    this.userId,
    this.name,
    this.uuid,
    this.isChatAdmin,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        userId: json["user_id"],
        name: json["name"],
        uuid: json["uuid"] ?? '',
        isChatAdmin: json["isChatAdmin"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "uuid": uuid,
        "isChatAdmin": isChatAdmin,
      };
}
