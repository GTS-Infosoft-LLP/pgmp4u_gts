import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/chat/chatHandler.dart';
import 'package:pgmp4u/Screens/chat/controller/chatProvider.dart';
import 'package:pgmp4u/Screens/chat/model/chatModel.dart';
import 'package:pgmp4u/Screens/chat/widgets/chatTextField.dart';
import 'package:pgmp4u/Screens/chat/widgets/reciverCard.dart';
import 'package:pgmp4u/Screens/chat/widgets/senderCard.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  var v1;
  ChatPage({Key key, this.v1}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController chatController = TextEditingController();
  ScrollController chatListController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    String chatRoomId = context.watch<ChatProvider>().singleChatRoomId;
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.v1 ?? 'Discussion',
          style: TextStyle(
            //  fontSize: width * (18 / 420),
            fontFamily: 'Roboto Medium',
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  _colorfromhex("#3A47AD"),
                  _colorfromhex("#5163F3"),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
      ),
      bottomSheet: ChatTextField(
        size: size,
        chatController: chatController,
        sendMessage: () async {
          if (chatController.text.trim() == '') return;
          await context
              .read<ChatProvider>()
              .sendGroupMessage(message: chatController.text.trim(), chatRoomId: chatRoomId);

          chatController.clear();
        },
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: EdgeInsets.only(bottom: size.height * 0.10),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseChatHandler.getAllGroupMessage(chatRoomId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: ClampingScrollPhysics(),
                    reverse: true,
                    itemCount: snapshot.data?.docs.length ?? 0,
                    itemBuilder: (context, indexMain) {
                      var data = snapshot.data.docs[indexMain].data();

                      // ChatModel chatModel = ChatModel(
                      //   messageId: data.containsKey('messageId') ? data['messageId'] ?? '' : '',
                      //   text: data['text'] ?? '',
                      //   sentBy: data['sentBy'] ?? '',
                      //   sentAt: data['sentAt'] ?? "0",

                      // );
                      ChatModel chatModel = ChatModel.fromJson(data);

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
}
