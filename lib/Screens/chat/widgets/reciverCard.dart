import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/chat/controller/chatProvider.dart';
import 'package:pgmp4u/Screens/chat/model/chatModel.dart';
import 'package:pgmp4u/Screens/chat/widgets/profileUrl.dart';
import 'package:pgmp4u/Screens/chat/widgets/reaction_on_message.dart';
import 'package:pgmp4u/Screens/chat/widgets/senderCard.dart';
import 'package:pgmp4u/utils/extensions.dart';
import 'package:provider/provider.dart';

class RecivedMessageCard extends StatefulWidget {
  RecivedMessageCard({key, this.chatModel, this.animationController});
  ChatModel chatModel;
  AnimationController animationController;

  @override
  State<RecivedMessageCard> createState() => _RecivedMessageCardState();
}

class _RecivedMessageCardState extends State<RecivedMessageCard> with SingleTickerProviderStateMixin {
  final layerLink = LayerLink();

  // Animation<double> _animation;
  @override
  void initState() {
    super.initState();

    // widget.animationController = AnimationController(
    //   duration: Duration(seconds: 1),
    //   vsync: this,
    // );

    // _animation = CurvedAnimation(
    //   parent: widget.animationController,
    //   curve: Curves.easeInOut,
    // );
  }

  @override
  void dispose() {
    // widget.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GestureDetector(
              onLongPress: () {
                showOverLay(
                  context,
                  widget.chatModel,
                  layerLink,
                  false,
                );
                context.read<ChatProvider>().updateisShowDeleteIcon(true);
                context.read<ChatProvider>().updateSelectedMessage(widget.chatModel);
              },
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
                          bottomRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          topRight: Radius.circular(16)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.chatModel.senderName.capitalizeFirstLetter() ?? '',
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
            ),
          ),
          Positioned(
            bottom: 2,
            left: 50,
            child: ReactionsOnMessage(chatModel: widget.chatModel),
          ),
        ],
      ),
    );
  }
}
