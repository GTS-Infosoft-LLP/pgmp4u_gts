
import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/chat/model/chatModel.dart';

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
          padding: const EdgeInsets.all(4.0),
          child: ClipOval(
            child: Container(
              height: 24,
              width: 24,
              child: Image.asset(reactionIcons[reaction]),
            ),
          )),
    );
  }
}
