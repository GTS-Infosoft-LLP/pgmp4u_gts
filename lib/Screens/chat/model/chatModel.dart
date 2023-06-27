// class ChatModel {
//   String userName;
//   String message;
//   int messageDate;
//   int messageType;
//   int sendBy;
//   int userId;

//   ChatModel({
//     this.userName,
//     this.message,
//     this.messageDate,
//     this.messageType,
//     this.sendBy,
//     this.userId,
//   });

//   ChatModel.fromJson(Map<String, dynamic> json) {
//     userName = json['firstName'] ?? "";
//     message = json['message'] ?? "";
//     messageDate = json['messageDate'] ?? 0;
//     messageType = json['messageType'] ?? 0;
//     sendBy = json['sendBy'] ?? 0;
//     userId = json['userId'] ?? 0;
//   }
// }

class ChatModel {
  String text;
  String messageId;
  String sentAt;
  int messageType;
  String sentBy;
  String senderName;
  String profileUrl;

  ChatModel({
    this.messageId,
    this.messageType,
    this.sentAt,
    this.sentBy,
    this.senderName,
    this.profileUrl,
    this.text,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    messageId = json['messageId'] ?? "";
    messageType = json['messageType'] ?? "";
    sentAt = json['sentAt'] ?? "";
    sentBy = json['sentBy'] ?? "";
    text = json['text'] ?? "";
    profileUrl = json['profileUrl'];
    senderName = json['senderName'] ?? '';
  }

  Map<String, dynamic> toJson() => {
        "messageId": messageId,
        "messageType": messageType,
        "sentAt": sentAt,
        "sentBy": sentBy,
        "text": text,
        "senderName": senderName,
        "profileUrl": profileUrl
      };
}
