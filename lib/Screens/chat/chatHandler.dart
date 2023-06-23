import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseChatHandler {
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;
  static CollectionReference userChatCollectionRef =
      FirebaseFirestore.instance.collection(FirebaseConstant.userChatCollection);

  static Stream<QuerySnapshot<Map<String, dynamic>>> reference() {
    return userChatCollectionRef.doc('mVax4zbwnAONkHNtOWh0').collection(FirebaseConstant.messages).snapshots();
  }

  static void printCollection() async {
    // var user = userChatCollectionRef.doc('mVax4zbwnAONkHNtOWh0').collection(FirebaseConstant.messages);
    FirebaseFirestore.instance
        .collection("user_chats")
        .doc("mVax4zbwnAONkHNtOWh0")
        .collection("messages")
        .snapshots()
        .map((event) {
      print("got from firestore: ${event.docs.length}");
    });
    print("got from firestore:");
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllGroupMessage() {
    return userChatCollectionRef.doc("mVax4zbwnAONkHNtOWh0").collection(FirebaseConstant.messages).snapshots();
  }
}

class FirebaseConstant {
  static String messages = 'messages';

  static String userChatCollection = 'user_chats';
  static String usersCollection = 'users';
}
