import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pgmp4u/Screens/chat/model/chatModel.dart';
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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllGroupMessage() {
    return userChatCollectionRef
        .doc("qT95cU2W4UuuHHL5YSju")
        .collection(FirebaseConstant.messages)
        .orderBy('sentAt', descending: true)
        .snapshots();
  }

  /* 
  {
    "messageId": "",
    "sentAt": DateTime.now().millisecondsSinceEpoch,
    "sentBy": "user_id_02",
    "text": chat.text
  }  
  */
  static sendGroupMessage({ChatModel chat}) {
    Map jsonChat = chat.toJson();
    print('message sent: ${chat.toJson()}');
    userChatCollectionRef
        .doc("qT95cU2W4UuuHHL5YSju")
        .collection(FirebaseConstant.messages)
        .add(chat.toJson())
        .then((value) {
      userChatCollectionRef.doc("qT95cU2W4UuuHHL5YSju").collection(FirebaseConstant.messages).doc(value.id).update({
        "messageId": value.id,
      });
    });
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

    userChatCollectionRef.doc(gropuId).collection(FirebaseConstant.messages).add(chat.toJson()).then((value) {
      userChatCollectionRef.doc(gropuId).collection(FirebaseConstant.messages).doc(value.id).update({
        "messageId": value.id,
      });
    });
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
