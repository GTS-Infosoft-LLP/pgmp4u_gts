import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/chat/model/chatModel.dart';

class ReactionsOnMessage extends StatefulWidget {
  ReactionsOnMessage({Key key, @required this.chatModel}) : super(key: key);
  ChatModel chatModel;

  @override
  State<ReactionsOnMessage> createState() => _ReactionsOnMessageState();
}

class _ReactionsOnMessageState extends State<ReactionsOnMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: widget.chatModel.reactions.length,
        itemBuilder: (context, index) {
          if (widget.chatModel.reactions[index].senderid.length == 0) return SizedBox();
          return emote(widget.chatModel.reactions[index]);
        },
      ),
    );
  }

  Widget emote(ReactionModel reaction) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: reaction.senderid.length == 1 ? BoxShape.circle : BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 18,
              width: 18,
              child: Image.asset(reactionIcons[getReaction(reaction.reactionType)]),
            ),
            reaction.senderid.length == 1
                ? SizedBox()
                : Container(
                    height: 18,
                    width: 18,
                    alignment: Alignment.center,
                    child: Text(
                      reaction.senderid.length.toString(),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
