import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pgmp4u/Screens/chat/chatHandler.dart';
import 'package:pgmp4u/Screens/chat/controller/chatProvider.dart';
import 'package:pgmp4u/Screens/chat/model/chatModel.dart';
import 'package:pgmp4u/Screens/chat/model/discussionGroupModel.dart';
import 'package:pgmp4u/Screens/chat/model/userProfileModel.dart';
import 'package:pgmp4u/Screens/chat/widgets/chatTextField.dart';
import 'package:pgmp4u/Screens/chat/widgets/reciverCard.dart';
import 'package:pgmp4u/Screens/chat/widgets/senderCard.dart';
import 'package:provider/provider.dart';

class DisscussionChatPage extends StatefulWidget {
  DisscussionChatPage({Key key, this.group}) : super(key: key);

  DisscussionGropModel group;

  @override
  State<DisscussionChatPage> createState() => _DisscussionChatPageState();
}

class _DisscussionChatPageState extends State<DisscussionChatPage> {
  TextEditingController chatController = TextEditingController();
  ScrollController chatListController = ScrollController();

  List<UserProfileModel> userProfileList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    DateTime time = DateTime.fromMillisecondsSinceEpoch(int.tryParse(widget.group.createdAt));
    String timeToShow = Jiffy(time).fromNow();
  

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.group.title ?? '',
              style: TextStyle(
                //  fontSize: width * (18 / 420),
                fontFamily: 'Roboto Medium',
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Text(
                  'Posted: ',
                  style: TextStyle(
                    //  fontSize: width * (18 / 420),
                    fontSize: 14,
                    fontFamily: 'Roboto Medium',
                    color: Color(0xff63697B),
                  ),
                ),
                Text(
                  "${widget.group.createdBy}   " ?? '',
                  style: TextStyle(
                    //  fontSize: width * (18 / 420),
                    fontSize: 14,
                    fontFamily: 'Roboto Medium',
                    color: Colors.black,
                  ),
                ),
                Text(
                  timeToShow ?? '',
                  style: TextStyle(
                    //  fontSize: width * (18 / 420),
                    fontSize: 14,
                    fontFamily: 'Roboto Medium',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
        leadingWidth: 30,
        backgroundColor: Colors.white,
      ),
      bottomSheet: ChatTextField(
        size: size,
        chatController: chatController,
        sendMessage: () async {
          if (chatController.text.trim() == '') return;
          await context
              .read<ChatProvider>()
              .sendDisscussionGroupMessage(message: chatController.text.trim(), groupId: widget.group.groupId);
          // sendDisscussionGroupMessage();
          chatController.clear();
        },
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: EdgeInsets.only(bottom: size.height * 0.10),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseChatHandler.getAllDiscussionGroupMessage(groupId: widget.group.groupId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: ClampingScrollPhysics(),
                    reverse: true,
                    itemCount: snapshot.data?.docs?.length ?? 0,
                    itemBuilder: (context, indexMain) {
                      var data = snapshot.data.docs[indexMain].data();

                      // print("get images ${getImg(data['sentBy'])}");

                      ChatModel chatModel = ChatModel(
                        messageId: data.containsKey('messageId') ? data['messageId'] ?? '' : '',
                        text: data['text'] ?? '',
                        sentBy: data['sentBy'] ?? '',
                        sentAt: data['sentAt'] ?? "0",
                        profileUrl: data['profileUrl'] ?? "",
                        senderName: data.containsKey('senderName') ? data['senderName'] ?? '' : '',
                      );

                      if (chatModel.sentBy == context.read<ChatProvider>().getUserUID()) {
                        return SenderMessageCard(
                          chatModel: chatModel,
                        );
                      } else {
                        return RecivedMessageCard(
                          chatModel: chatModel,
                        );
                      }
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  Future<String> getImg(String id) async {
    if (id.isEmpty) {
      return '';
    }

    DocumentSnapshot snapshot;
    try {
      snapshot = await FirebaseFirestore.instance.collection(FirebaseConstant.usersCollection).doc(id).get();
    } on Exception {}
    if (snapshot == null) {
      print('doc not found');
      return '';
    }
    Map<String, dynamic> userMap = snapshot.data();
    print('userMap: ${userMap['image']}');

    if (!userProfileList.contains(UserProfileModel(profilePic: userMap['image'], uid: id))) {
      userProfileList.add(UserProfileModel(profilePic: userMap['image'], uid: id));
    } else {}

    return userMap['image'];
  }

  imageContains() {
    userProfileList.forEach((element) {
      if (element.profilePic.isNotEmpty && element.uid.isNotEmpty) {}
    });
  }
}
