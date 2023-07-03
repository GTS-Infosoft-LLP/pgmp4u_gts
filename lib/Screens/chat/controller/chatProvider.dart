import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:pgmp4u/Screens/chat/chatHandler.dart';
import 'package:pgmp4u/Screens/chat/model/chatModel.dart';
import 'package:pgmp4u/Screens/chat/model/singleGroupModel.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/utils/user_object.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChatProvider extends ChangeNotifier {
  SharedPreferences prefs;

  initSharePreferecne() async {
    prefs = await SharedPreferences.getInstance();
  }

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

  sendGroupMessage({String message, String chatRoomId}) {
    ChatModel chatModel = ChatModel(
      messageId: '',
      messageType: 0,
      sentAt: DateTime.now().millisecondsSinceEpoch.toString(),
      sentBy: getUser().uid,
      text: message,
      senderName: getUser().displayName,
      profileUrl: getUser().photoURL,
    );
    FirebaseChatHandler.sendGroupMessage(
      chat: chatModel,
      chatRoomId: chatRoomId,
      adminId: getUser().uid,
      userId: reciverUserId,
    );
  }

  bool discussionGroupLoader = false;
  updateDiscussionGroupLoader(bool v) {
    discussionGroupLoader = v;
    notifyListeners();
  }

  Future createDiscussionGroup(String title, List<String> opss, BuildContext context) async {
    updateDiscussionGroupLoader(true);
    var body = {
      "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
      "createdBy": getUser().displayName,
      "ownerId": getUser().uid,
      "title": title,
      "groupId": '',
      "options": opss
    };

    // don't post same question again
    // check with id and question
    bool isQuesExists = await FirebaseChatHandler.isQuestionAlreadyPostedByMe(body);

    if (isQuesExists) {
      updateDiscussionGroupLoader(false);
      GFToast.showToast(
        'You have already posted this question.',
        context,
        toastPosition: GFToastPosition.BOTTOM,
      );
      return;
    }

    // 1. create the group if not exists
    // 2. send notification
    // 3. send the question in same group as first message
    await FirebaseChatHandler.createDiscussionGroup(body).then((value) async {
      updateDiscussionGroupLoader(false);

      if (value == null) {
        return;
      }
      sendNotification(title: 'New Discussion added', message: 'New Discussion has been created');
      // send the question as first message in group
      String questionToPost = title;
      for (int i = 0; i < opss.length; i++) {
        questionToPost += "\n\n${i + 1} ${opss[i]} \n";
      }

      print('Question to Post : $questionToPost');
      await sendDisscussionGroupMessage(groupId: value, message: questionToPost);
    }).whenComplete(() {
      updateDiscussionGroupLoader(false);
    });
  }

  Future sendDisscussionGroupMessage({String message, String groupId}) async {
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
    await FirebaseChatHandler.sendDiscussionGroupMessage(chat: chatModel, gropuId: groupId);
  }

  /// sigle chat /////

  /// if called first time then new group will be created
  ///
  /// second time
  initiatePersonalChat({MyUserInfo user1, MyUserInfo user2}) {
    generateRoomId();
    FirebaseChatHandler.createPersonalChatRoom(user1: user1, user2: user2);
  }

  String singleChatRoomId = '';
  String reciverUserId = '';
  setChatRoomId(String roomId) {
    singleChatRoomId = roomId;
    notifyListeners();
  }

  generateRoomId({String reciverId}) {
    reciverUserId = reciverId;
    String id = createRoomId(getUser().uid, reciverId);

    setChatRoomId(id);
  }

  /// create room id for single chat room
  /// param: reciver id, sender id
  static String createRoomId(String id1, String id2) {
    String chatId = "";
    if (id1.hashCode > id2.hashCode) {
      chatId = id1 + "-" + id2;
    } else {
      chatId = id2 + "-" + id1;
    }
    return chatId;
  }

  sendNotification({String title, String message}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print(stringValue);
    http.Response response;
    response = await http.post(Uri.parse(sendChatUserNotification),
        headers: {'Content-Type': 'application/json', 'Authorization': stringValue},
        body: jsonEncode({"title": title, "message": message}));

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
    } else {
      print('error while calling api');
      print(jsonDecode(response.body));
    }
  }

  bool isChatAdmin() {
    bool isChatAdmin = prefs.getBool('isChatAdmin');

    // print("isChatAdmin : $isChatAdmin");
    if (isChatAdmin == null) {
      return false;
    }
    return isChatAdmin;
  }

  bool isChatSubscribed() {
    bool isChatSubscribed = prefs.getBool('isChatSubscribed');

    print("isChatSubscribed : $isChatSubscribed");
    if (isChatSubscribed == null) {
      return false;
    }
    return isChatSubscribed;
  }
}
