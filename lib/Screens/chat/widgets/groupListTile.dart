import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import 'package:pgmp4u/Screens/chat/model/discussionGroupModel.dart';
import 'package:pgmp4u/Screens/chat/screen/discussionChatPage.dart';
import 'package:pgmp4u/utils/extensions.dart';

class GroupListTile extends StatelessWidget {
  GroupListTile({Key key, this.index, this.color, this.group});
  int index;
  Color color;
  DisscussionGropModel group;

  onTapOfGroup(BuildContext context) {
    // create messaging in user_chat
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DisscussionChatPage(
                  group: group,
                )));
  }

  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(int.tryParse(group.createdAt));
    String timeToShow = Jiffy(time).fromNow();
    // FieldValue.serverTimestamp();
    Color newColor = Colors.grey.withOpacity(0.4);
    Color newTextColor = Colors.black54;

    return GestureDetector(
      onTap: () => onTapOfGroup(context),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.17,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        padding: EdgeInsets.only(top: 2, bottom: 2, left: 16, right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          gradient: new LinearGradient(stops: [0.015, 0.015], colors: [color, Colors.white]),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              offset: Offset(0, 5),
              spreadRadius: 4,
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //number | title | arrow
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12,
                  // backgroundColor: color,
                  backgroundColor: newColor,
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      // color: Colors.white,
                      color: newTextColor,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Text(
                  group.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 20, fontFamily: 'Roboto Medium'),
                )),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            // name | post time  | show | comments
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 29,
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.38),
                  padding: EdgeInsets.only(top: 4, bottom: 4, right: 8, left: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: newColor,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(group.createdBy.capitalizeFirstLetter() ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: newTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  width: 6,
                ),
                Text(
                  timeToShow,
                  style: TextStyle(fontSize: 12, fontFamily: 'Roboto Medium', color: Color(0XFF63697B)),
                ),
                Spacer(),
                SizedBox(width: 20),
                _myIcons(icon: Icons.chat_rounded, count: group.commentsCount.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _myIcons({IconData icon, String count}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          count,
          style: TextStyle(fontSize: 14, fontFamily: 'Roboto Medium'),
        ),
      ],
    );
  }
}
