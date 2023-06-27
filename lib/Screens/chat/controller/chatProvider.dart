import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/chat/chatHandler.dart';
import 'package:pgmp4u/Screens/chat/model/chatModel.dart';
import 'package:pgmp4u/utils/user_object.dart';

class ChatProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String getUserUID() {
    final User user = _auth.currentUser;
    if (user != null) {
      final uid = user.uid;
      print('User UID: $uid');
      return uid;
    }
  }

  User getUser() {
    final User user = _auth.currentUser;
    if (user != null) {
      final uid = user.uid;
      print('User UID: $uid');
      return user;
    }
  }

  createFirebaseUser(FirestoreUserModel user) {
    FirebaseChatHandler.createFirestoreUser(user);
  }

  addUserToDiscussionGroup(String uid) {
    FirebaseChatHandler.addUserToDiscussionGroup(uid: uid);
  }

  sendGroupMessage({String message}) {
    ChatModel chatModel = ChatModel(
        messageId: '',
        messageType: 0,
        sentAt: DateTime.now().millisecondsSinceEpoch.toString(),
        sentBy: getUserUID(),
        text: message);
    FirebaseChatHandler.sendGroupMessage(chat: chatModel);
  }

  bool discussionGroupLoader = false;
  updateDiscussionGroupLoader(bool v) {
    discussionGroupLoader = v;
    notifyListeners();
  }

  Future createDiscussionGroup(String title) async {
    updateDiscussionGroupLoader(true);
    var body = {
      "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
      "createdBy": getUser().displayName,
      "title": title,
      "viewedBy": "0",
      "groupId": ''
    };

    await FirebaseChatHandler.createDiscussionGroup(body).whenComplete(() => updateDiscussionGroupLoader(false));
  }

  sendDisscussionGroupMessage({String message, String groupId}) {
    print('>>>>>>>>>>>>  g ${getUser().photoURL}');
    ChatModel chatModel = ChatModel(
      messageId: '',
      messageType: 0,
      sentAt: DateTime.now().millisecondsSinceEpoch.toString(),
      sentBy: getUserUID(),
      text: message,
      senderName: getUser().displayName,
      profileUrl: getUser().photoURL,
    );
    FirebaseChatHandler.sendDiscussionGroupMessage(chat: chatModel, gropuId: groupId);
  }
}
