import 'package:flutter/material.dart';

class UserObject {
  static UserModel userData;

  static setUser(UserModel user) {
    print("set user ${user.name}");
    userData = user;
    print(">>>>>>>>> test ${userData.name}");
  }

  UserModel get getUser {
    print("try get ${userData.name}");
    return userData;
  }
}

class UserModel {
  final String name;
  final String image;
  final String token;
  final String email;
  UserModel({@required this.image, @required this.token, @required this.name, @required this.email});
}

class FirestoreUserModel {
  final String name;
  final String email;
  final String image;
  final String userId;
  FirestoreUserModel({@required this.image, @required this.userId, @required this.name, @required this.email});

  Map<String, dynamic> toJson() => {"name": name, "email": email, "image": image, "userId": userId};
}
