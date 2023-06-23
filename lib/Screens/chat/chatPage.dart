import 'package:flutter/material.dart';

import 'chatModel.dart';

class ChatPage extends StatefulWidget {
  var v1;
  ChatPage({Key key, this.v1}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  TextEditingController chatController = TextEditingController();
  ScrollController chatListController = ScrollController();

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.v1,
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
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: size.height / 1.25,
            width: size.width,
            // color: Colors.amber,

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
          ),
          Container(
            height: size.height / 10,
            width: size.width,
            alignment: Alignment.center,
            // color: Colors.blue,
            child: Container(
              height: size.height / 15,
              width: size.width / 1.1,
              decoration: BoxDecoration(
                  // color: Colors.amber,
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Container(
                      height: size.height / 17,
                      width: size.width / 1.3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 18.0),
                        child: TextField(
                          controller: chatController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "   Type your message here...",
                            // border: OutlineInputBorder(
                            //     // borderRadius: BorderRadius.circular(8),
                            //     )
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.send,
                      ),
                      onPressed: () {}),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget senderChatWidget(ChatModel chatModel) {
    final Size size = MediaQuery.of(context).size;
    var d = DateTime.fromMillisecondsSinceEpoch(chatModel.messageDate ?? 0);
    return Container(
      width: size.width,
      alignment:
          chatModel.sendBy == 1 ? Alignment.centerRight : Alignment.centerLeft,
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
