import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:pgmp4u/Screens/chat/controller/chatProvider.dart';
import 'package:pgmp4u/Screens/chat/model/chatModel.dart';
import 'package:pgmp4u/Screens/chat/widgets/profileUrl.dart';
import 'package:pgmp4u/Screens/chat/widgets/reaction_on_message.dart';
import 'package:pgmp4u/Screens/chat/widgets/reaction_overlay.dart';
import 'package:pgmp4u/utils/app_color.dart';
import 'package:pgmp4u/utils/extensions.dart';
import 'package:provider/provider.dart';

class SenderMessageCard extends StatefulWidget {
  SenderMessageCard({
    key,
    this.chatModel,
  });
  ChatModel chatModel;
  // AnimationController animationController;

  @override
  State<SenderMessageCard> createState() => _SenderMessageCardState();
}

class _SenderMessageCardState extends State<SenderMessageCard> with SingleTickerProviderStateMixin {
  final LayerLink layerLink = LayerLink();

  // List animations = [];

  @override
  void initState() {
    print("option:::::::::${widget.chatModel.options}");
    print("question:::::::::${widget.chatModel.question}");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void showOverLay1(BuildContext context, ChatModel message, LayerLink layerLink) {
  //   double overlayWidth = 200;

  //   OverlayState reactionOverlayState = Overlay.of(context);
  //   final renderBox = context.findRenderObject() as RenderBox;

  //   final size = renderBox.size;

  //   context.read<ChatProvider>().reactionOverlayEntry = OverlayEntry(
  //     maintainState: true,
  //     builder: (context) {
  //       return Positioned(
  //         width: overlayWidth,
  //         child: CompositedTransformFollower(
  //           link: layerLink,
  //           showWhenUnlinked: false,
  //           offset: const Offset(50, -20),
  //           child: Container(
  //             width: 200,
  //             height: 60,
  //             padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(10),
  //               color: Colors.white,
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.grey.withOpacity(0.5),
  //                   blurRadius: 4.0,
  //                   spreadRadius: 0.0,
  //                   offset: Offset(2.0, 2.0), // shadow direction: bottom right
  //                 )
  //               ],
  //             ),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 for (int i = 0; i < animations.length; i++)
  //                   ScaleTransition(
  //                     scale: animations[i],
  //                     child: ReactionPopUp(
  //                       reaction: Reaction.favorite,
  //                       onPressed: () {
  //                         // context.read<ChatProvider>().setReaction(widget.message, Reaction.favorite);
  //                         context.read<ChatProvider>().removeOverlay(controller: widget.animationController);
  //                       },
  //                     ),
  //                   )

  //                 //   ReactionPopUp(
  //                 //     reaction: Reaction.favorite,
  //                 //     onPressed: () {
  //                 //       context.read<ChatProvider>().setReaction(widget.message, Reaction.favorite);
  //                 //       context.read<ChatProvider>().removeOverlay();
  //                 //     },
  //                 //   ),
  //                 // ReactionPopUp(
  //                 //   reaction: Reaction.thumbsDown,
  //                 //   onPressed: () {
  //                 //     context.read<ChatProvider>().setReaction(widget.message, Reaction.thumbsDown);

  //                 //     context.read<ChatProvider>().removeOverlay();
  //                 //   },
  //                 // ),
  //                 // ReactionPopUp(
  //                 //   reaction: Reaction.thumbsUp,
  //                 //   onPressed: () {
  //                 //     context.read<ChatProvider>().setReaction(widget.message, Reaction.thumbsUp);

  //                 //     context.read<ChatProvider>().removeOverlay();
  //                 //   },
  //                 // ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );

  //   widget.animationController.addListener(() {
  //     reactionOverlayState.setState(() {});
  //   });
  //   widget.animationController
  //     ..reset
  //     ..forward();
  //   reactionOverlayState.insert(context.read<ChatProvider>().reactionOverlayEntry);
  // }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return CompositedTransformTarget(
      link: layerLink,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GestureDetector(
              onTap: () {},
              onLongPress: () {
                showOverLay(
                  context,
                  widget.chatModel,
                  layerLink,
                  true,
                );

                context.read<ChatProvider>().updateSelectedMessage(widget.chatModel);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 16.0),
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

                        Container(
                          margin: EdgeInsets.only(left: 8),
                          width: width - (width * (35 / 420) * 5),
                          child: Html(
                            data: widget.chatModel.question == null || widget.chatModel.question == ""
                                ? widget.chatModel.text
                                : widget.chatModel.question,
                            style: {
                              "body": Style(
                                padding: EdgeInsets.only(top: 5),
                                margin: EdgeInsets.zero,
                                color: Colors.white,
                                textAlign: TextAlign.left,
                                fontSize: FontSize(18),
                              )
                            },
                          ),
                        ),

                        widget.chatModel.image == null || widget.chatModel.image == ""
                            ? SizedBox()
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.chatModel.image,
                                    // mockQuestion[_quetionNo].questionDetail.image,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 78.0, vertical: 28),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                        height: MediaQuery.of(context).size.width * .4,
                                        child: Center(child: Icon(Icons.error))),
                                  ),
                                ),
                              ),

                        widget.chatModel.options.isEmpty
                            ? SizedBox()
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.chatModel.options.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    children: [
                                      Container(
                                        width: width * (25 / 420),
                                        height: width * 25 / 420,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            width * (25 / 420),
                                          ),
                                      
                                        ),
                                        child: Center(
                                          child: Text(
                                              index == 0
                                                  ? 'A'
                                                  : index == 1
                                                      ? 'B'
                                                      : index == 2
                                                          ? 'C'
                                                          : index == 3
                                                              ? 'D'
                                                              : 'E',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  .copyWith(color: Colors.white, fontSize: 15)),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 8),
                                        width: width - (width * (35 / 420) * 5),
                                        child: Html(
                                          data: widget.chatModel.options[index],
                                          style: {
                                            "body": Style(
                                              padding: EdgeInsets.only(top: 5),
                                              margin: EdgeInsets.zero,
                                              color: Colors.white,
                                              textAlign: TextAlign.left,
                                              fontSize: FontSize(18),
                                            )
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                })

                        //   Text(

                        //    widget.chatModel.options.,

                        // style: Theme.of(context).textTheme.titleSmall.copyWith(
                        //       color: Colors.white,
                        //     )),
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
            bottom: 2,
            right: 46,
            child: ReactionsOnMessage(chatModel: widget.chatModel),
          ),
        ],
      ),
    );
  }
}

void showOverLay(BuildContext context, ChatModel message, LayerLink layerLink, bool isSentMessage) {
  // in discussion show only to admin user
  // in single chat to both user
  // bool isShowDelete = !(context.read<ChatProvider>().currentGroupType == GroupType.groupChat &&
  //         !context.read<ChatProvider>().isChatAdmin()) ||
  //     message.sentBy == context.read<ChatProvider>().getUser().uid;
  bool isShowDelete = context.read<ChatProvider>().isShowDelete(message);

  double overlayWidth = isShowDelete ? 230 : 170;
  context.read<ChatProvider>().reactionOverlayState = Overlay.of(context);

  final renderBox = context.findRenderObject() as RenderBox;
  final size = renderBox.size;

  context.read<ChatProvider>().removeOverlay();

  context.read<ChatProvider>().reactionOverlayEntry = OverlayEntry(
    // maintainState: true,
    builder: (context) {
      return Positioned(
        width: overlayWidth,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: Offset(isSentMessage ? 50 : 140, -20),
          child: ReactionOverlay(
            context: context,
            message: message,
            overlayWidth: overlayWidth,
            onReactionChaged: (reaction) {
              context.read<ChatProvider>().setReaction(message, reaction);
              context.read<ChatProvider>().removeOverlay();
            },
            isShowDelete: isShowDelete,
            onDelete: () {
              context.read<ChatProvider>().deleteMessage();
              context.read<ChatProvider>().removeOverlay();
            },
          ),
        ),
      );
    },
  );

  context.read<ChatProvider>().reactionOverlayState.insert(context.read<ChatProvider>().reactionOverlayEntry);
}
