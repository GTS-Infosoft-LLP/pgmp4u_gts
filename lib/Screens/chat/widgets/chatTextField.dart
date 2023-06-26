import 'package:flutter/material.dart';

class ChatTextField extends StatelessWidget {
  const ChatTextField({
    Key key,
    @required this.size,
    @required this.chatController,
  }) : super(key: key);

  final Size size;
  final TextEditingController chatController;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

