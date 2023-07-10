import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/chat/controller/chatProvider.dart';
import 'package:pgmp4u/Screens/chat/model/chatModel.dart';
import 'package:provider/provider.dart';

class ReactionOverlay extends StatefulWidget {
  ReactionOverlay({Key key, @required this.context, @required this.message, @required this.overlayWidth})
      : super(key: key);

  final BuildContext context;
  final ChatModel message;
  double overlayWidth;

  @override
  State<ReactionOverlay> createState() => _ReactionOverlayState();
}

class _ReactionOverlayState extends State<ReactionOverlay> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
      width: widget.overlayWidth,
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 4.0,
            spreadRadius: 0.0,
            offset: Offset(2.0, 2.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ReactionPopUp(
            reaction: Reaction.favorite,
            onPressed: () {
              context.read<ChatProvider>().setReaction(widget.message, Reaction.favorite);
              context.read<ChatProvider>().removeOverlay();
            },
          ),
          ReactionPopUp(
            reaction: Reaction.thumbsDown,
            onPressed: () {
              context.read<ChatProvider>().setReaction(widget.message, Reaction.thumbsDown);

              context.read<ChatProvider>().removeOverlay();
            },
          ),
          ReactionPopUp(
            reaction: Reaction.thumbsUp,
            onPressed: () {
              context.read<ChatProvider>().setReaction(widget.message, Reaction.thumbsUp);

              context.read<ChatProvider>().removeOverlay();
            },
          ),
        ],
      ),
    ));
  }
}

class ReactionPopUp extends StatelessWidget {
  final Reaction reaction;
  final VoidCallback onPressed;

  const ReactionPopUp({@required this.reaction, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          reactionIcons[reaction],
          size: 26.0,
          color: Colors.black,
        ),
      ),
    );
  }
}
