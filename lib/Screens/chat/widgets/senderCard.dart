import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/chat/controller/chatProvider.dart';
import 'package:pgmp4u/Screens/chat/model/chatModel.dart';
import 'package:pgmp4u/Screens/chat/widgets/profileUrl.dart';
import 'package:pgmp4u/Screens/chat/widgets/reaction_overlay.dart';
import 'package:pgmp4u/utils/app_color.dart';
import 'package:pgmp4u/utils/extensions.dart';
import 'package:provider/provider.dart';

class SenderMessageCard extends StatefulWidget {
  SenderMessageCard({key, this.chatModel});
  ChatModel chatModel;

  @override
  State<SenderMessageCard> createState() => _SenderMessageCardState();
}

class _SenderMessageCardState extends State<SenderMessageCard> {
  final LayerLink layerLink = LayerLink();
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GestureDetector(
              onTap: () {},
              onLongPress: () => showOverLay(context, widget.chatModel, layerLink),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.0),
                    decoration: BoxDecoration(
                      gradient: AppColor.appGradient,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16), bottomLeft: Radius.circular(16), topRight: Radius.circular(16)),
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
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    )),
                            Text(widget.chatModel.sentAt.toTimeOfDay().format(context) ?? '',
                                style: Theme.of(context).textTheme.titleSmall.copyWith(
                                      color: Colors.white,
                                    )),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(widget.chatModel.text ?? '',
                            style: Theme.of(context).textTheme.titleSmall.copyWith(
                                  color: Colors.white,
                                )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 0.0),
                    child: SizedBox(width: 24, height: 24, child: ProfilePic(image: widget.chatModel.profileUrl)),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 50,
            // child: widget.chatModel.reaction != null ? Icon(_getReactionIcon(widget.message.reaction!)) : const SizedBox(),
            child: Container(
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}

void showOverLay(BuildContext context, ChatModel message, LayerLink layerLink) {
  double overlayWidth = 200;
  context.read<ChatProvider>().reactionOverlayState = Overlay.of(context);
  final renderBox = context.findRenderObject() as RenderBox;

  final size = renderBox.size;

  context.read<ChatProvider>().reactionOverlayEntry = OverlayEntry(
    maintainState: true,
    builder: (context) {
      return Positioned(
        width: overlayWidth,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: const Offset(50, -20),
          child: ReactionOverlay(context: context, message: message, overlayWidth: overlayWidth),
        ),
      );
    },
  );

  context.read<ChatProvider>().reactionOverlayState.insert(context.read<ChatProvider>().reactionOverlayEntry);
}
