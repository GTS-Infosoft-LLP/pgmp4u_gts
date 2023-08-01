import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pgmp4u/Screens/chat/controller/chatProvider.dart';

import 'package:pgmp4u/Screens/chat/model/discussionGroupModel.dart';
import 'package:pgmp4u/Screens/chat/screen/discussionChatPage.dart';
import 'package:pgmp4u/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../../../provider/profileProvider.dart';

class GroupListTile extends StatefulWidget {
  GroupListTile({Key key, this.index, this.color, this.group});
  int index;
  Color color;
  DisscussionGropModel group;

  @override
  State<GroupListTile> createState() => _GroupListTileState();
}

class _GroupListTileState extends State<GroupListTile> {
  onTapOfGroup(BuildContext context) {
    print("groupId: ${widget.group.groupId}");
    var chatPay;
    ProfileProvider pp = Provider.of(context, listen: false);
    bool a = pp.isChatSubscribed;
    print("value of a=====$a");
    if (a == false) {
      //show blur
      chatPay = 1;
    } else if (a == true) {
      chatPay = 0;
      // chatPay = 1;
    }
    context.read<ChatProvider>().setGroupId(widget.group.groupId, GroupType.groupChat);

    // create messaging in user_chat
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DisscussionChatPage(
                  group: widget.group,
                  chatPayment: chatPay,
                )));
  }

  onLongPressOfGroup(BuildContext context) {
    print("onLognPress groupId: ${widget.group.groupId}");
    context.read<ChatProvider>().isChatAdmin()
        ? showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  elevation: 20,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    // side: BorderSide(color: _colorfromhex("#3A47AD"), width: 0)
                  ),
                  title: Column(
                    children: [
                      Text("Are you sure you want to delete this discussion?",
                          // textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Roboto Medium',
                            fontWeight: FontWeight.w200,
                            color: Colors.black,
                          )),
                    ],
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width * .15,
                                // constraints: BoxConstraints(minWidth: 100),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    gradient: LinearGradient(
                                        colors: [
                                          Color(0xff3A47AD),
                                          Color(0xff5163F3),
                                        ],
                                        begin: const FractionalOffset(0.0, 0.0),
                                        end: const FractionalOffset(1.0, 0.0),
                                        stops: [0.0, 1.0],
                                        tileMode: TileMode.clamp)),
                                child: Center(
                                  child: Text(
                                    "No",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ))),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () async {
                            await context.read<ChatProvider>().deleteDiscussionGroup(context, widget.group.groupId);
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 35,
                            width: MediaQuery.of(context).size.width * .15,
                            // constraints: BoxConstraints(minWidth: 100),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xff3A47AD),
                                      Color(0xff5163F3),
                                    ],
                                    begin: const FractionalOffset(0.0, 0.0),
                                    end: const FractionalOffset(1.0, 0.0),
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp)),
                            child: Center(
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ],
                ))
        : null;
  }

  getString(int value) {
    if (value >= 10000000) {
      return "${(value / 10000000).toStringAsFixed(2)}" + " C";
    } else if (value >= 100000) {
      return "${(value / 100000).toStringAsFixed(2)}" + " L";
    } else if (value >= 1000) {
      return "${(value / 1000)}" + " k";
    } else {
      return value.toString();
    }
  }

  @override
  void initState() {
    // context.read<CourseProvider>().setMasterListType("Chat");
    // context.read<ProfileProvider>().subscriptionApiCalling
    //     ? null
    //     : context.read<ProfileProvider>().subscriptionStatus("Chat");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(int.tryParse(widget.group.createdAt));
    String timeToShow = Jiffy(time).fromNow();
    // FieldValue.serverTimestamp();
    Color newColor = Colors.grey.withOpacity(0.4);
    Color newTextColor = Colors.black54;

    return GestureDetector(
      onTap: () => onTapOfGroup(context),
      onLongPress: () => onLongPressOfGroup(context),
      child: Container(
        // height: MediaQuery.of(context).size.height * 0.17,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        padding: EdgeInsets.only(top: 20, bottom: 20, left: 16, right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          gradient: new LinearGradient(stops: [0.015, 0.015], colors: [widget.color, Colors.white]),
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
                  radius: 14,
                  // backgroundColor: color,
                  backgroundColor: newColor,
                  child: Text(
                    getString(widget.index + 1).toString(),
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      // color: Colors.white,
                      color: newTextColor,
                      fontSize: 10,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Text(
                  widget.group.title ?? '',
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18, fontFamily: 'Roboto Medium'),
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
            SizedBox(height: 18),
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
                      Text(widget.group.createdBy.capitalizeFirstLetter() ?? '',
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
                  width: 10,
                ),
                Text(
                  timeToShow,
                  style: TextStyle(fontSize: 12, fontFamily: 'Roboto Medium', color: Color(0XFF63697B)),
                ),
                Spacer(),
                SizedBox(width: 20),
                _myIcons(icon: Icons.chat_rounded, count: getString(widget.group.commentsCount)),
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
