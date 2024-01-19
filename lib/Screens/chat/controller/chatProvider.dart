import 'dart:convert';
import 'dart:convert' as convert;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pgmp4u/Screens/chat/chatHandler.dart';
import 'package:pgmp4u/Screens/chat/model/chatModel.dart';
import 'package:pgmp4u/Screens/chat/model/singleGroupModel.dart';
import 'package:pgmp4u/Screens/chat/model/userListModel.dart';
import 'package:pgmp4u/Services/globalcontext.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:pgmp4u/utils/extensions.dart';
import 'package:pgmp4u/utils/user_object.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Tests/local_handler/hive_handler.dart';

class ChatProvider extends ChangeNotifier {
  SharedPreferences prefs;

  initSharePreferecne() async {
    prefs = await SharedPreferences.getInstance();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String bodyyyy;
  CourseProvider cp = Provider.of(GlobalVariable.navState.currentContext, listen: false);

  String getUserUID() {
    final User user = _auth.currentUser;
    if (user != null) {
      final uid = user.uid;
      // print('User UID: $uid');
      return uid;
    }
  }

  User getUser() {
    final User user = _auth.currentUser;
    if (user != null) {
      final uid = user.uid;
      // print('User UID: $uid');
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
      image: "",
      options: [],
      question: "",
      senderName: getUser().displayName,
      profileUrl: getUser().photoURL,
      reactions: [],
    );

    FirebaseChatHandler.sendGroupMessage(
      chat: chatModel,
      chatRoomId: chatRoomId,
    );
  }

  bool discussionGroupLoader = false;
  updateDiscussionGroupLoader(bool v) {
    discussionGroupLoader = v;
    notifyListeners();
  }

  Future createDiscussionGroup(String title, List<String> opss, String img, BuildContext context,
      {String testName = '', bool isFromBottomSheet = false, String crsName}) async {
    if (img == null) {
      img = "";
    }
    CourseProvider cp = Provider.of(context, listen: false);
    if (cp.course.length == 1) {
      crsName = cp.course[0].lable;
    }
    print("crsName============$crsName");
    print("question image===:::::$img");
    updateDiscussionGroupLoader(true);
    var body = {
      "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
      "createdBy": getUser().displayName,
      "ownerId": getUser().uid,
      "title": title,
      "image": img,
      "groupId": '',
      "options": opss,
      "courseName": crsName.toLowerCase()
    };

    print("body====$body");

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
      // send the question as first message in group if not from bottom sheet
      isFromBottomSheet ? null : await sendMessage(title, opss, img, testName, value);
    }).whenComplete(() {
      updateDiscussionGroupLoader(false);
    });
  }

  Future deleteDiscussionGroup(BuildContext context, String groupId) async {
    print("-- delete group: $groupId -- ");
    bool isDone = await FirebaseChatHandler.deleteDiscussionGroup(groupId);
    if (isDone) {
      GFToast.showToast(
        'Discussion Deleted successfully',
        context,
        toastPosition: GFToastPosition.BOTTOM,
      );
    } else {
      GFToast.showToast(
        'An Exception occured while deleting.',
        context,
        toastPosition: GFToastPosition.BOTTOM,
      );
    }
  }

  Future<void> sendMessage(String title, List<String> opss, String img, String testName, String value) async {
    String questionToPost = title;
    for (int i = 0; i < opss.length; i++) {
      String initial = '';
      try {
        initial = i.toAlphabet();
      } on Exception catch (e) {
        print('Exception Occured: ${e.toString()}');
      }
      questionToPost += "\n\n$initial.  ${opss[i]} \n";
    }
    questionToPost += "\n$testName";

    print('Question to Post : $questionToPost');
    await sendDisscussionGroupMessage(groupId: value, message: questionToPost, img: img, ops: opss, ques: title);
  }

  Future sendDisscussionGroupMessage({String message, String groupId, String img, ques, ops}) async {
    // print('This is the message sent : ${getUser().photoURL}');
    ChatModel chatModel = ChatModel(
      messageId: '',
      messageType: 0,
      sentAt: DateTime.now().millisecondsSinceEpoch.toString(),
      image: img,
      question: ques,
      options: ops,
      sentBy: getUserUID(),
      text: message,
      senderName: getUser().displayName,
      profileUrl: getUser().photoURL,
      reactions: [],
    );
    await FirebaseChatHandler.sendDiscussionGroupMessage(chat: chatModel, gropuId: groupId);
  }

  /// sigle chat /////

  /// if called first time then new group will be created
  ///
  /// second time
  Future<bool> initiatePersonalChat({MyUserInfo reciver}) async {
    String roomId = createRoomId(getUser().uid, reciver.id);
    setChatRoomId(roomId);

    return await FirebaseChatHandler.createPersonalChatRoom(
            chatRoomId: roomId,
            me: MyUserInfo(id: getUser().uid, isAdmin: isChatAdmin() ? 1 : 0, name: getUser().displayName),
            reciver: reciver)
        .then((value) {
      return value;
    });
  }

  String singleChatRoomId = '';
  String reciverUserId = '';

  // this method only calls from signle group
  setChatRoomId(String roomId) {
    singleChatRoomId = roomId;

    // to set for emoji
    setGroupId(roomId, GroupType.singleChat);
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
    bool checkConn = await checkInternetConn();
    if (checkConn) {
      bodyyyy = HiveHandler.getNotSubmittedMock(keyName: cp.notSubmitedMockID);
      if (bodyyyy == null) {
        bodyyyy = "";
      }
      if (bodyyyy.isNotEmpty) {
        Response response = await http
            .post(
          Uri.parse(SUBMIT_MOCK_TEST),
          headers: {"Content-Type": "application/json", 'Authorization': stringValue},
          body: bodyyyy,
        )
            .whenComplete(() async {
          await cp.getTestDetails(cp.selectedMockId);
          await cp.apiCall(cp.selectedTstPrcentId);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/${cp.selectedTstPrcentId}'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), cp.setPendindIndex.toString());
          }
        });
        if (response.statusCode == 200) {
          HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
          cp.setnotSubmitedMockID("");
          cp.setToBeSubmitIndex(1000);
        }
      }
    }

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
    bool isChatAdmin = false;

    try {
      isChatAdmin = prefs.getBool('isChatAdmin');
    } on Exception {
      print("Exception occured while geting isChatAdmin");
    }

    if (isChatAdmin == null) {
      return false;
    }
    print("isChatAdmin : $isChatAdmin");
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

  OverlayState reactionOverlayState;
  OverlayEntry reactionOverlayEntry;

  void removeOverlay() {
    // print("-- remove overlay method called--");
    // if (controller != null) {
    //   print("-- remove overlay >  controller.reset();--");
    //   controller.reset();
    // }
    if (reactionOverlayEntry != null && reactionOverlayEntry.mounted) {
      // print("-- removing overlay --");

      reactionOverlayEntry.remove();
      reactionOverlayEntry = null;
    }
  }

  // to set the current group id
  // set the current groupt type
  //
  String currentGroupId;
  GroupType currentGroupType;
  setGroupId(String groupId, GroupType type) {
    currentGroupId = groupId;
    currentGroupType = type;
    notifyListeners();
  }

  void setReaction(ChatModel message, Reaction reaction) {
    updateisShowDeleteIcon(false);
    FirebaseChatHandler.sendEmoji(
        chatModel: message, groupId: currentGroupId, newReaction: reaction, senderId: getUser().uid);
    // notifyListeners();
  }

  // to handle delete icon
  bool isShowDeleteIcon = false;
  updateisShowDeleteIcon(bool value) {
    isShowDeleteIcon = value;
    notifyListeners();
  }

  // selected Message
  ChatModel selectedChat;
  updateSelectedMessage(ChatModel chatModel) {
    selectedChat = chatModel;
    notifyListeners();
  }

  bool isShowDelete(ChatModel message) {
    if (currentGroupType == GroupType.groupChat) {
      // user is admin
      if (isChatAdmin()) {
        return true;
      } else {
        // if message is sent by me
        if (message.sentBy == getUser().uid) {
          return true;
        } else {
          return false;
        }
      }
    } else if (currentGroupType == GroupType.singleChat) {
      if (message.sentBy == getUser().uid) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void deleteGroupMessage() {
    print("-- deleteGroupMessage -- ");
    FirebaseChatHandler.deleteMessageInDiscussion(currentGroupId, selectedChat);
  }

  void deleteSingleMessage() {
    print("-- deleteSingleMessage -- ");
    FirebaseChatHandler.deleteMessageInSingleChat(singleChatRoomId, selectedChat);
  }

  void deleteMessage() {
    print("-- Current Group type : $currentGroupType, id: $currentGroupId -- ");
    if (currentGroupType == GroupType.groupChat) {
      deleteGroupMessage();
    } else {
      deleteSingleMessage();
    }
  }

  bool getUserListApiCalling = false;
  updateGetUserListApiCalling(bool value) {
    getUserListApiCalling = value;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  bool isPagging = false;
  updateIsPagging(bool value) {
    isPagging = value;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  UserListResponseModel userListResponse;
  int currentPageIndex = 1;

  resetPagination() {
    currentPageIndex = 1;
  }

  getUserList({@required bool isFirstTime}) async {
    if (isFirstTime) {
      resetPagination();
      updateGetUserListApiCalling(true);
    } else {
      if (isPagging) {
        return;
      }

      print("currentPageIndex $currentPageIndex,userListResponse.pages: ${userListResponse.pages}");
      if (currentPageIndex > userListResponse.pages) {
        print("all pages are get");
        return;
      }

      print(
          "userListResponse.data.length  ${userListResponse.data.length}, userListResponse.count: ${userListResponse.count}");
      if (userListResponse.data.length >= userListResponse.count) {
        print("all data is get");
        return;
      }
      updateIsPagging(true);
    }

    String stringValue = prefs.getString('token');
    print(stringValue);
    http.Response response;
    bool checkConn = await checkInternetConn();
    if (checkConn) {
      bodyyyy = HiveHandler.getNotSubmittedMock(keyName: cp.notSubmitedMockID);
      if (bodyyyy == null) {
        bodyyyy = "";
      }
      if (bodyyyy.isNotEmpty) {
        Response response = await http
            .post(
          Uri.parse(SUBMIT_MOCK_TEST),
          headers: {"Content-Type": "application/json", 'Authorization': stringValue},
          body: bodyyyy,
        )
            .whenComplete(() async {
          await cp.getTestDetails(cp.selectedMockId);
          await cp.apiCall(cp.selectedTstPrcentId);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/${cp.selectedTstPrcentId}'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), cp.setPendindIndex.toString());
          }
        });
        if (response.statusCode == 200) {
          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
          cp.setnotSubmitedMockID("");
          cp.setToBeSubmitIndex(1000);
        }
      }
    }
    try {
      response = await http.post(Uri.parse(chatUserListApi),
          headers: {'Content-Type': 'application/json', 'Authorization': stringValue},
          body: jsonEncode({"page": currentPageIndex}));

      print("resqust: ${jsonEncode({"page": currentPageIndex})} ");
      print("response do status codeeee>>${response.statusCode}");
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        UserListResponseModel userListResponseTemp = UserListResponseModel.fromJson(jsonDecode(response.body));

        if (currentPageIndex == 1) {
          userListResponse = userListResponseTemp;
        } else {
          userListResponse.data.addAll(userListResponseTemp.data);
        }

        currentPageIndex++;

        // filter list if user's uuid is null or empty
        userListResponse.data.removeWhere((user) => user.uuid.isEmpty || user.uuid == null);

        /// remove my self
        userListResponse.data.removeWhere((user) => user.uuid == getUser().uid);

        // only shows admin if i'm normal user
        print("isChatAdmin() in userList: ${isChatAdmin()} ");
        isChatAdmin() ? null : userListResponse.data.removeWhere((user) => user.isChatAdmin == 0);

        /// if after filter data is less than 10 then call again
        if (userListResponse.data.length < 10) {
          getUserList(isFirstTime: false);
        }

        updateGetUserListApiCalling(false);
        updateIsPagging(false);
      } else {
        updateGetUserListApiCalling(false);
        updateIsPagging(false);
        print('error while calling api');
        print(jsonDecode(response.body));
      }
    } on Exception {
      updateGetUserListApiCalling(false);
      updateIsPagging(false);
      print('error while calling api');
    }
  }

  Future checkInternetConn() async {
    bool result = await InternetConnectionChecker().hasConnection;
    print("result while call fun $result");
    if (result == false) {
      Future.delayed(Duration(seconds: 1), () async {
        //  await EasyLoading.showToast("Internet Not Connected",toastPosition: EasyLoadingToastPosition.bottom);
      });
      return result;
    } else {}
    return result;
  }
}

enum GroupType { singleChat, groupChat }
