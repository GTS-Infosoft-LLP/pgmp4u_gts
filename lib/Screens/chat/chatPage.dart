import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/chat/chatHandler.dart';
import 'package:pgmp4u/Screens/chat/widgets/chatTextField.dart';
import 'package:pgmp4u/Screens/chat/widgets/senderCard.dart';

import 'model/chatModel.dart';

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
    FirebaseChatHandler.printCollection();
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.v1 ?? 'Chat',
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
      bottomSheet: ChatTextField(size: size, chatController: chatController),
      resizeToAvoidBottomInset: true,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseChatHandler.getAllGroupMessage(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('data length: ${snapshot.data.docs}');
              return ListView.builder(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: ClampingScrollPhysics(),
                  reverse: true,
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (context, indexMain) {
                    int index = (snapshot.data.docs.length - 1) - indexMain;

                    SenderMessageCard();

                    // MessageModel messageModel = MessageModel(
                    //   receiverId:
                    //       snapshot.data?.docs[index].get("receiverId") ??
                    //           "",
                    //   senderId:
                    //       snapshot.data?.docs[index].get("senderId") ?? "",
                    //   time: snapshot.data?.docs[index]
                    //           .get("time")
                    //           .toString() ??
                    //       "",
                    //   // Jiffy(time).Hm,
                    //   message:
                    //       snapshot.data?.docs[index].get("message") ?? "",
                    //   senderUserType: snapshot.data?.docs[index]
                    //           .get("senderUserType")
                    //           .toString() ??
                    //       '',
                    //   profileLink:
                    //       snapshot.data?.docs[index].get("profileLink") ??
                    //           "",
                    //   messageId:
                    //       snapshot.data?.docs[index].get('messageId'),
                    //   deletedBy:
                    //       snapshot.data?.docs[index].get('deletedBy'),
                    //   messageType:
                    //       snapshot.data?.docs[index].get('messageType') ??
                    //           1,
                    //   deleteLink:
                    //       snapshot.data?.docs[index].get('deleteLink') ??
                    //           '',
                    //   subtitle:
                    //       snapshot.data?.docs[index].get('subtitle') ?? '',
                    // );

                    //  if (messageModel.senderId ==
                    //       HiveConfig.getUserHive()!.userId.toString()) {
                    //     return SenderMessageCard(
                    //         );
                    //   } else {
                    //     return RecivedMessageCard(

                    //     );

                    // }
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget senderChatWidget(ChatModel chatModel) {
    final Size size = MediaQuery.of(context).size;
    var d = DateTime.fromMillisecondsSinceEpoch(chatModel.messageDate ?? 0);
    return Container(
      width: size.width,
      alignment: chatModel.sendBy == 1 ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.blue,
        ),
        child: Text(
          chatModel.message,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}


// child: ListView.builder(
            //     itemCount: 2,
            //     itemBuilder: ((context, index) {
            //       return ListTile(
            //         // leading: Container(
            //         //   height: 55,
            //         //   width: 55,
            //         //   decoration: BoxDecoration(
            //         //       color: Colors.green,
            //         //       borderRadius: BorderRadius.circular(100)),
            //         // ),
            //         title: index % 2 == 0
            //             ? Container(
            //                 // height: 50,
            //                 decoration: BoxDecoration(
            //                   color: Colors.amber,
            //                   borderRadius: BorderRadius.only(
            //                     topRight: Radius.circular(40.0),
            //                     bottomRight: Radius.circular(40.0),
            //                     topLeft: Radius.circular(40.0),
            //                     // bottomLeft: Radius.circular(40.0)
            //                   ),
            //                 ),
            //                 child: Padding(
            //                   padding: const EdgeInsets.only(top: 8.0),
            //                   child: Column(
            //                     children: [
            //                       Padding(
            //                         padding: const EdgeInsets.symmetric(
            //                             horizontal: 18.0),
            //                         child: Row(
            //                           mainAxisAlignment:
            //                               MainAxisAlignment.spaceBetween,
            //                           children: [
            //                             Text("saloni"),
            //                             Text("5:40"),
            //                           ],
            //                         ),
            //                       ),
            //                       Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Text(
            //                           "eyJhbGciOiJIUjoxMjM4LCiwicTYiOiIiLCJlbWFpbF9zZW50IjowLCJzdGF0dXMiOjEsImRlbGV0ZVN0YXR1cyI6MX0sImmTsfilTfQcSCI-3b0z8_8jhuPyPOSWcX2xAjMONU",
            //                           maxLines: 5,
            //                         ),
            //                       )
            //                     ],
            //                   ),
            //                 ))
            //             : Container(
            //                 height: 50,
            //                 decoration: BoxDecoration(
            //                   color: Colors.grey,
            //                   borderRadius: BorderRadius.only(
            //                       topRight: Radius.circular(40.0),
            //                       // bottomRight: Radius.circular(40.0),
            //                       topLeft: Radius.circular(40.0),
            //                       bottomLeft: Radius.circular(40.0)),
            //                 ),
            //               ),
            //         trailing: Container(
            //           height: 55,
            //           width: 55,
            //           decoration: BoxDecoration(
            //               color: Colors.green,
            //               borderRadius: BorderRadius.circular(100)),
            //         ),
            //       );
            //       // Container(
            //       //   height: 100,
            //       //   color: Colors.blue,
            //       //   child: Row(
            //       //     children: [
            //       //       Container(
            //       //         height: 60,
            //       //         width: 60,
            //       //         decoration: BoxDecoration(
            //       //             color: Colors.green,
            //       //             borderRadius: BorderRadius.circular(100)),
            //       //       ),
            //       //       SizedBox(width: 10),
            //       //       Container(
            //       //         height: 80,
            //       //         decoration: BoxDecoration(
            //       //           color: Colors.amber,
            //       //           borderRadius: BorderRadius.only(
            //       //             topRight: Radius.circular(40.0),
            //       //             bottomRight: Radius.circular(40.0),
            //       //             topLeft: Radius.circular(40.0),
            //       //             // bottomLeft: Radius.circular(40.0)
            //       //           ),
            //       //         ),
            //       //       ),
            //       //     ],
            //       //   ),
            //       // );
            //     })),