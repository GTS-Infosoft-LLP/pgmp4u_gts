import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pgmp4u/Screens/chat/model/chatModel.dart';
import 'package:pgmp4u/Screens/chat/model/singleGroupModel.dart';
import 'package:pgmp4u/utils/user_object.dart';

class FirebaseChatHandler {
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static CollectionReference userChatCollectionRef =
      FirebaseFirestore.instance.collection(FirebaseConstant.userChatCollection);
  static CollectionReference userCollectionRef =
      FirebaseFirestore.instance.collection(FirebaseConstant.usersCollection);
  static CollectionReference groupsCollectionRef =
      FirebaseFirestore.instance.collection(FirebaseConstant.groupsCollection);

  static CollectionReference discussionCollectionRef =
      FirebaseFirestore.instance.collection(FirebaseConstant.discussionsCollection);

  static Stream<QuerySnapshot<Map<String, dynamic>>> reference() {
    return userChatCollectionRef.doc('mVax4zbwnAONkHNtOWh0').collection(FirebaseConstant.messages).snapshots();
  }

   static Stream<QuerySnapshot<Map<String, dynamic>>> getAllPersonalChatGroups() {
    return groupsCollectionRef.orderBy('createdAt', descending: true)
    .where("members",arrayContains: '1246')
    .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllGroupMessage(String chatRoomId) {
    return userChatCollectionRef
        .doc(chatRoomId)
        .collection(FirebaseConstant.messages)
        .orderBy('sentAt', descending: true)
        .snapshots();
  }

  static sendGroupMessage({ChatModel chat, String chatRoomId, String adminId, String userId }) async {
    Map jsonChat = chat.toJson();
    print('message sent: ${chat.toJson()}');

    /// if doc does not exist in user_chat create one
    bool isDocExistsInUserChat = await checkIfDocExistsInColl(docId: chatRoomId, collection: userChatCollectionRef);
    if (!isDocExistsInUserChat) {
      await userChatCollectionRef.doc(chatRoomId).set({"createdAt": DateTime.now().millisecondsSinceEpoch}).then((_) {
        print('New Group created In UserChat');
        // a message to collection
        userChatCollectionRef.doc(chatRoomId).collection(FirebaseConstant.messages).add(chat.toJson()).then((value) {
          userChatCollectionRef.doc(chatRoomId).collection(FirebaseConstant.messages).doc(value.id).update({
            "messageId": value.id,
          });
        });
      }).catchError((error) => print('Add failed: $error'));
    } else {
      // a message to collection
      userChatCollectionRef.doc(chatRoomId).collection(FirebaseConstant.messages).add(chat.toJson()).then((value) {
        userChatCollectionRef.doc(chatRoomId).collection(FirebaseConstant.messages).doc(value.id).update({
          "messageId": value.id,
        });
      });
    }

    // create a new group with chatRoomId
    if (await checkIfDocExistsInColl(docId: chatRoomId, collection: groupsCollectionRef)) {
      groupsCollectionRef.doc(chatRoomId).update({"lastMessage": chat.text});

      return;
    } else {
      PersonalGroupModel groupModel = PersonalGroupModel(
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        groupId: chatRoomId,
        lastMessage: chat.text,
        ownerId: '',
        members: [
          adminId, userId
        ],
      );

      print('group body: ${groupModel.toJson()}');
      groupsCollectionRef
          .doc(chatRoomId)
          .set(groupModel.toJson(), SetOptions(merge: true))
          .then((_) => print('New Group created'))
          .catchError((error) => print('Add failed: $error'));
    }
  }

  static Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      // var collectionRef = FirebaseFirestore.instance.collection('collectionName');

      var doc = await groupsCollectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  static Future<bool> checkIfDocExistsInColl({String docId, CollectionReference collection}) async {
    try {
      // Get reference to Firestore collection
      // var collectionRef = FirebaseFirestore.instance.collection('collectionName');

      var doc = await collection.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  static addUserToDiscussionGroup({String uid}) {
    groupsCollectionRef.doc("qT95cU2W4UuuHHL5YSju").update({
      FirebaseConstant.groupMembers: FieldValue.arrayUnion([uid]),
    });
  }

  static createFirestoreUser(FirestoreUserModel user) {
    Map jsonChat = user.toJson();
    print('user on Firestore: ${user.toJson()}');
    // userCollectionRef.add(user.toJson());
    userCollectionRef.doc(user.userId).set(user.toJson()).onError((error, stackTrace) {
      print('error occured while create firestore user: $error');
    });
  }

  static Future<bool> isQuestionAlreadyPostedByMe(Map<String, dynamic> body) async {
    bool isExists = false;

    // check if a doc exists with same owner id and question
    discussionCollectionRef.get().then((value) {
      value.docs.firstWhere((disGroup) {
        Map group = disGroup.data();
        if (group['ownerId'] == body['ownerId'] && group['title'] == body["title"]) {
          isExists = true;
        }
      });
    }).onError((error, stackTrace) {
      isExists = false;
    });

    return isExists;
  }

  /// create a new disscuesion group
  ///
  /// todo: send notification to all paid users
  static Future createDiscussionGroup(Map<String, dynamic> body) async {
    await discussionCollectionRef.add(body).then((value) {
      discussionCollectionRef.doc(value.id).update({
        'groupId': value.id,
      });
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllDiscussionGroups() {
    return discussionCollectionRef.orderBy('createdAt', descending: true).snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllDiscussionGroupMessage({String groupId}) {
    return userChatCollectionRef
        .doc(groupId)
        .collection(FirebaseConstant.messages)
        .orderBy('sentAt', descending: true)
        .snapshots();
  }

  static sendDiscussionGroupMessage({ChatModel chat, String gropuId}) {
    Map jsonChat = chat.toJson();
    print('message sent: ${chat.toJson()}');

    userChatCollectionRef.doc(gropuId).collection(FirebaseConstant.messages).add(chat.toJson()).then((value) async {
      // add the message id to message
      userChatCollectionRef.doc(gropuId).collection(FirebaseConstant.messages).doc(value.id).update({
        "messageId": value.id,
      });
      var count = await userChatCollectionRef.doc(gropuId).collection(FirebaseConstant.messages).get();
      // update message count
      discussionCollectionRef.doc(gropuId).update({
        "commentsCount": count.docs.length ?? 0,
      });
    });
  }

  // getAlldis() {
  //   bool isAdmin = true;
  //   if(admin){
  //     FirebaseFirestore.instance.collection()
  //   }
  // }
}

class FirebaseConstant {
  static String messages = 'messages';

  // root collections
  static String userChatCollection = 'user_chats';
  static String messagesCollection = 'messages';
  static String groupsCollection = 'groups';
  static String usersCollection = 'users';
  static String discussionsCollection = 'discussions';

  // groupFields
  static String groupMembers = "members";

  // message fields
  static String messageId = "messageId";
  static String sentAt = "sentAt";
  static String sentBy = "sentBy";
  static String text = "text";
}
