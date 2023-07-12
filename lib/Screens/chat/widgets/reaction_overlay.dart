import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/chat/controller/chatProvider.dart';
import 'package:pgmp4u/Screens/chat/model/chatModel.dart';
import 'package:pgmp4u/Screens/chat/widgets/reaction_pop_up_emote.dart';
import 'package:provider/provider.dart';

class ReactionOverlay extends StatefulWidget {
  ReactionOverlay({
    Key key,
    @required this.context,
    @required this.message,
    @required this.overlayWidth,
  }) : super(key: key);

  final BuildContext context;
  final ChatModel message;
  double overlayWidth;

  @override
  State<ReactionOverlay> createState() => _ReactionOverlayState();
}

class _ReactionOverlayState extends State<ReactionOverlay> {
  // List animations = [];

  @override
  void initState() {
    super.initState();

    // for (int i = 3; i > 0; i--) {
    //   animations.add(
    //     Tween(begin: 0.0, end: 1.0).animate(
    //       CurvedAnimation(
    //         parent: widget.animationController,
    //         curve: Interval(0.2 * i, 1.0, curve: Curves.ease),
    //       ),
    //     ),
    //   );
    // }

    // widget.animationController.addListener(() {
    //   if (mounted) {
    //     setState(() {});
    //   }
    // });
    // widget.animationController
    //   ..reset()
    //   ..forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // widget.animationController.removeListener(() {});
    // widget.animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
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
            onPressed: () => onTapOfReaction(Reaction.favorite),
          ),
          ReactionPopUp(
            reaction: Reaction.laugh,
            onPressed: () => onTapOfReaction(Reaction.laugh),
          ),
          ReactionPopUp(
            reaction: Reaction.thumbsDown,
            onPressed: () => onTapOfReaction(Reaction.thumbsDown),
          ),
          ReactionPopUp(
            reaction: Reaction.thumbsUp,
            onPressed: () => onTapOfReaction(Reaction.thumbsUp),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(right: 4),
              width: 24,
              height: 24,
              child: Center(
                child: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  onTapOfReaction(Reaction raction) {
    context.read<ChatProvider>().setReaction(widget.message, raction);
    context.read<ChatProvider>().removeOverlay();
  }
}
