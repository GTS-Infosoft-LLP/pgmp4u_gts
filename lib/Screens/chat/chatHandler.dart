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

  ///// single chat work   ////

  /// create single chat room
  static createPersonalChatRoom({MyUserInfo user1 , MyUserInfo user2}) {
    PersonalGroupModel groupModel = PersonalGroupModel(
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
      groupId: "",
      lastMessage: "",
      members: [user1, user2],
    );

    print('group body: ${groupModel.toJson()}');

    groupsCollectionRef.add(groupModel.toJson()).then((value) {
      groupsCollectionRef.doc(value.id).update({'groupId': value.id});
      print('New Group created');
    }).catchError((error) => print('Add failed: $error'));
  }

  // personal chat group list
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllPersonalChatGroups({String myUUID}) {
    return groupsCollectionRef
        .orderBy('createdAt', descending: true)
        .where("members", arrayContains: myUUID)
        .snapshots();
  }

  // personal chat group messages
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllGroupMessage(String chatRoomId) {
    return userChatCollectionRef
        .doc(chatRoomId)
        .collection(FirebaseConstant.messages)
        .orderBy('sentAt', descending: true)
        .snapshots();
  }

  // send message in personal chat group
  static sendGroupMessage({ChatModel chat, String chatRoomId, String adminId, String userId}) async {
    Map jsonChat = chat.toJson();
    print('message sent: ${chat.toJson()}');

    /// if doc does not exist in user_chat create one
    bool isDocExistsInUserChat = await checkIfDocExistsInColl(docId: chatRoomId, collection: userChatCollectionRef);
    if (!isDocExistsInUserChat) {
      await userChatCollectionRef.doc(chatRoomId).set({"createdAt": DateTime.now().millisecondsSinceEpoch}).then((_) {
        print('New Group created In UserChat');
      }).catchError((error) => print('Add failed: $error'));
    }
    // add message to collection
    await userChatCollectionRef.doc(chatRoomId).collection(FirebaseConstant.messages).add(chat.toJson()).then((value) {
      userChatCollectionRef.doc(chatRoomId).collection(FirebaseConstant.messages).doc(value.id).update({
        "messageId": value.id,
      });
    });

    // create a new group with chatRoomId
    if (await checkIfDocExistsInColl(docId: chatRoomId, collection: groupsCollectionRef)) {
      groupsCollectionRef.doc(chatRoomId).update({"lastMessage": chat.text});

      return;
    } else {
      PersonalGroupModel groupModel = PersonalGroupModel(
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        groupId: chatRoomId,
        lastMessage: chat.text,
        members: [MyUserInfo(), MyUserInfo()],
      );

      print('group body: ${groupModel.toJson()}');
      groupsCollectionRef
          .doc(chatRoomId)
          .set(groupModel.toJson(), SetOptions(merge: true))
          .then((_) => print('New Group created'))
          .catchError((error) => print('Add failed: $error'));
    }
  }

  ///// disussion group work   ////

  /// create a new disscuesion group
  ///
  static Future<String> createDiscussionGroup(Map<String, dynamic> body) async {
    return await discussionCollectionRef.add(body).then((value) {
      discussionCollectionRef.doc(value.id).update({
        'groupId': value.id,
      });

      print('Disscussion Group: ${value.id} created');
      return value.id;
    }).onError((error, stackTrace) {
      return null;
    });
  }

  // list of disscussion groups
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllDiscussionGroups() {
    return discussionCollectionRef.orderBy('createdAt', descending: true).snapshots();
  }

  // discussion group message
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllDiscussionGroupMessage({String groupId}) {
    return userChatCollectionRef
        .doc(groupId)
        .collection(FirebaseConstant.messages)
        .orderBy('sentAt', descending: true)
        .snapshots();
  }

  // send message in disscussion
  static sendDiscussionGroupMessage({ChatModel chat, String gropuId}) async {
    Map jsonChat = chat.toJson();
    print('message sent: ${chat.toJson()}');

    await userChatCollectionRef
        .doc(gropuId)
        .collection(FirebaseConstant.messages)
        .add(chat.toJson())
        .then((value) async {
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

  ///// extra   ////

  static Future<bool> checkIfDocExistsInColl({String docId, CollectionReference collection}) async {
    try {
      var doc = await collection.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
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
    QuerySnapshot groups = await discussionCollectionRef
        .where("ownerId", isEqualTo: body['ownerId'])
        .where('title', isEqualTo: body['title'])
        .get();

    print('length of groups: .. ${groups.docs.isNotEmpty}');
    isExists = groups.docs.isNotEmpty ?? false;

    return isExists;
  }

  static Future<void> findDocumentWithArrayElement(String userUUID) async {
    CollectionReference collection = FirebaseFirestore.instance.collection('your_collection');

    QuerySnapshot snapshot = await collection.where('members', arrayContains: {'name': userUUID}).get();

    if (snapshot.docs.isNotEmpty) {
      // The document(s) containing the array element with the matching name exist
      for (DocumentSnapshot doc in snapshot.docs) {
        print(doc.id); // Output: Document ID(s) with the matching array element
      }
    } else {
      // No document(s) found with the matching array element
      print('No documents found');
    }
  }
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
