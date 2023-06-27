import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/chat/model/chatModel.dart';
import 'package:pgmp4u/Screens/chat/widgets/profileUrl.dart';
import 'package:pgmp4u/utils/extensions.dart';

class RecivedMessageCard extends StatefulWidget {
  RecivedMessageCard({key, this.chatModel});
  ChatModel chatModel;

  @override
  State<RecivedMessageCard> createState() => _RecivedMessageCardState();
}

class _RecivedMessageCardState extends State<RecivedMessageCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 4.0, bottom: 8.0),
            child: SizedBox(width: 24, height: 24, child: ProfilePic(image: widget.chatModel.profileUrl)),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(16), bottomLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.chatModel.senderName ?? '',
                        style: Theme.of(context).textTheme.titleSmall.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            )),
                    Text(widget.chatModel.sentAt.toTimeOfDay().format(context) ?? '',
                        style: Theme.of(context).textTheme.titleSmall.copyWith(
                              color: Colors.black,
                              fontSize: 12,
                            )),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Text(widget.chatModel.text ?? '',
                    style: Theme.of(context).textTheme.titleSmall.copyWith(
                          color: Color(0xff63697B),
                        )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
