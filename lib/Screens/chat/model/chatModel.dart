class ChatModel {
  String userName;
  String message;
  int messageDate;
  int messageType;
  int sendBy;
  int userId;

  ChatModel({
    this.userName,
    this.message,
    this.messageDate,
    this.messageType,
    this.sendBy,
    this.userId,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    userName = json['firstName'] ?? "";
    message = json['message'] ?? "";
    messageDate = json['messageDate'] ?? 0;
    messageType = json['messageType'] ?? 0;
    sendBy = json['sendBy'] ?? 0;
    userId = json['userId'] ?? 0;
  }
}
