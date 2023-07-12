/*
{
  "messageId": "",
  "messageType": 0,
  "sentAt": 1688978670855,
  "sentBy": "NT1FkEp254PFw1HwcNOoL7Ih91y1",
  "text": "Hi there",
  "senderName": "muhanish Chouhan",
  "profileUrl": "https://lh3.googleusercontent.com/a/AAcHTtdxeMHKcFfFuYnOMjlsXPxs7U0CP88QncU90NP6=s96-c",
  "reactions": [
    {
      "reactionType": "like",
      "count": 5,
      "senderid": ["sender1", "sender2"]
    },
    {
      "reactionType": "love",
      "count": 2,
      "senderid": ["sender3"]
    }
  ]
}
*/

import 'package:flutter/material.dart';

enum Reaction { favorite, laugh, thumbsDown, thumbsUp }

Reaction getReaction(String reactionString) {
  Reaction reaction =
      Reaction.values.firstWhere((r) => r.toString().split('.').last == reactionString, orElse: () => null);

  switch (reaction) {
    case Reaction.favorite:
      print("The reaction is favorite");
      return Reaction.favorite;
      break;
    case Reaction.laugh:
      print("The reaction is laugh");
      return Reaction.laugh;
      break;
    case Reaction.thumbsDown:
      print("The reaction is thumbsDown");
      return Reaction.thumbsDown;
      break;
    case Reaction.thumbsUp:
      print("The reaction is thumbsUp");
      return Reaction.thumbsUp;
      break;

    default:
      print("invalid reaction");
      return Reaction.thumbsUp;
  }
}

final Map<Reaction, String> reactionIcons = {
  Reaction.favorite: "assets/emoji_heart.png",
  Reaction.laugh: "assets/emoji_laugh.png",
  Reaction.thumbsDown: "assets/emoji_thumbs_down.png",
  Reaction.thumbsUp: "assets/emoji_thumbs_up.png",
};

class ChatModel {
  String text;
  String messageId;
  String sentAt;
  int messageType;
  String sentBy;
  String senderName;
  String profileUrl;
  List<ReactionModel> reactions;

  ChatModel({
    @required this.messageId,
    @required this.messageType,
    @required this.sentAt,
    @required this.sentBy,
    @required this.senderName,
    @required this.profileUrl,
    @required this.text,
    @required this.reactions,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    messageId = json['messageId'] ?? "";
    messageType = json['messageType'] ?? "";
    sentAt = json['sentAt'] ?? "";
    sentBy = json['sentBy'] ?? "";
    text = json['text'] ?? "";
    profileUrl = json['profileUrl'];
    senderName = json['senderName'] ?? '';
    List<dynamic> temp = json["reactions"] ?? [];
    reactions =
        temp != null || temp.isNotEmpty ? List<ReactionModel>.from(temp.map((x) => ReactionModel.fromJson(x))) : [];
  }

  Map<String, dynamic> toJson() => {
        "messageId": messageId,
        "messageType": messageType,
        "sentAt": sentAt,
        "sentBy": sentBy,
        "text": text,
        "senderName": senderName,
        "profileUrl": profileUrl,
        "reactions": List<dynamic>.from(reactions.map((x) => x.toJson())),
      };
}

class ReactionModel {
  String reactionType;
  int count;
  List<String> senderid;

  ReactionModel({
    this.reactionType,
    this.count,
    this.senderid,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) => ReactionModel(
        reactionType: json["reactionType"],
        count: json["count"],
        senderid: List<String>.from(json["senderid"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "reactionType": reactionType,
        "count": count,
        "senderid": List<dynamic>.from(senderid.map((x) => x)),
      };
}
