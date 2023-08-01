import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pgmp4u/Screens/chat/chatHandler.dart';
import 'package:pgmp4u/Screens/chat/controller/chatProvider.dart';
import 'package:pgmp4u/Screens/chat/model/chatModel.dart';
import 'package:pgmp4u/Screens/chat/model/discussionGroupModel.dart';
import 'package:pgmp4u/Screens/chat/model/userProfileModel.dart';
import 'package:pgmp4u/Screens/chat/widgets/chatTextField.dart';
import 'package:pgmp4u/Screens/chat/widgets/reciverCard.dart';
import 'package:pgmp4u/Screens/chat/widgets/senderCard.dart';
import 'package:pgmp4u/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../../../components/blurView.dart';
import '../../../provider/courseProvider.dart';
import '../../../provider/profileProvider.dart';
import '../../../utils/app_color.dart';
import '../../home_view/VideoLibrary/RandomPage.dart';

class DisscussionChatPage extends StatefulWidget {
  DisscussionChatPage({Key key, this.group, this.chatPayment}) : super(key: key);

  DisscussionGropModel group;
  int chatPayment;

  @override
  State<DisscussionChatPage> createState() => _DisscussionChatPageState();
}

class _DisscussionChatPageState extends State<DisscussionChatPage> {
  TextEditingController chatController = TextEditingController();
  ScrollController chatListController = ScrollController();

  List<UserProfileModel> userProfileList = [];

  // AnimationController _animationController;
  int a = 1;
  @override
  void initState() {
    print("chat pay widget value======${widget.chatPayment}");
    // TODO: implement initState
    // _animationController = AnimationController(
    //   duration: Duration(seconds: 1),
    //   vsync: this,
    // );

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _animationController.removeListener(() {});
    // _animationController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    DateTime time = DateTime.fromMillisecondsSinceEpoch(int.tryParse(widget.group.createdAt));
    String timeToShow = Jiffy(time).fromNow();

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        toolbarHeight: 80,
        title: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => CustomDialog(
                group: widget.group,
                timeAgo: timeToShow,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.group.title ?? '',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  //  fontSize: width * (18 / 420),
                  fontFamily: 'Roboto Medium',
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Text(
                    'Posted: ',
                    style: TextStyle(
                      //  fontSize: width * (18 / 420),
                      fontSize: 14,
                      fontFamily: 'Roboto Medium',
                      color: Color(0xff63697B),
                    ),
                  ),
                  Text(
                    "${widget.group.createdBy}   " ?? '',
                    style: TextStyle(
                      //  fontSize: width * (18 / 420),
                      fontSize: 14,
                      fontFamily: 'Roboto Medium',
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    timeToShow ?? '',
                    style: TextStyle(
                      //  fontSize: width * (18 / 420),
                      fontSize: 14,
                      fontFamily: 'Roboto Medium',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
        leadingWidth: 40,
        backgroundColor: Colors.white,
      ),
      bottomSheet: widget.chatPayment == 1
          ? SizedBox()
          : ChatTextField(
              size: size,
              chatController: chatController,
              sendMessage: () async {
                if (chatController.text.trim() == '') return;
                String message = chatController.text.trim();
                chatController.clear();
                await context
                    .read<ChatProvider>()
                    .sendDisscussionGroupMessage(message: message, groupId: widget.group.groupId);
              },
            ),
      resizeToAvoidBottomInset: true,
      body: widget.chatPayment == 1
          ? blurChat(context, widget.group)
          : GestureDetector(
              onTap: () {
                context.read<ChatProvider>().removeOverlay();
              },
              child: Container(
                padding: EdgeInsets.only(bottom: size.height * 0.1),
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseChatHandler.getAllDiscussionGroupMessage(groupId: widget.group.groupId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                            physics: BouncingScrollPhysics(),
                            reverse: true,
                            itemCount: snapshot.data?.docs?.length ?? 0,
                            itemBuilder: (context, indexMain) {
                              var data = snapshot.data.docs[indexMain].data();

                              ChatModel chatModel = ChatModel.fromJson(data);

                              if (chatModel.sentBy == context.read<ChatProvider>().getUserUID()) {
                                return SenderMessageCard(
                                  chatModel: chatModel,
                                );
                              } else {
                                return RecivedMessageCard(
                                  chatModel: chatModel,
                                );
                              }
                            });
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
            ),
    );
  }

  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  Future<String> getImg(String id) async {
    if (id.isEmpty) {
      return '';
    }

    DocumentSnapshot snapshot;
    try {
      snapshot = await FirebaseFirestore.instance.collection(FirebaseConstant.usersCollection).doc(id).get();
    } on Exception {}
    if (snapshot == null) {
      print('doc not found');
      return '';
    }
    Map<String, dynamic> userMap = snapshot.data();
    print('userMap: ${userMap['image']}');

    if (!userProfileList.contains(UserProfileModel(profilePic: userMap['image'], uid: id))) {
      userProfileList.add(UserProfileModel(profilePic: userMap['image'], uid: id));
    } else {}

    return userMap['image'];
  }

  imageContains() {
    userProfileList.forEach((element) {
      if (element.profilePic.isNotEmpty && element.uid.isNotEmpty) {}
    });
  }
}

class CustomDialog extends StatelessWidget {
  DisscussionGropModel group;
  String timeAgo;
  CustomDialog({this.group, this.timeAgo});

  @override
  Widget build(BuildContext context) {
    List<String> options = [];

    for (int i = 0; i < group.ops.length; i++) {
      String initial = '';
      try {
        initial = i.toAlphabet();
        options.add("\n\n$initial.  ${group.ops[i]} \n");
      } on Exception catch (e) {
        print('Exception Occured: ${e.toString()}');
      }
    }
    return blurView(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Posted By: ${group.createdBy}"),
                SizedBox(height: 6),
                Text(timeAgo),
                SizedBox(height: 16),
                Text(
                  group.title ?? '',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.0),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      return Text(
                        options[index],
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16.0),

                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(),
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                //   child: Text('Close'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuyChat extends StatelessWidget {
  const BuyChat({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return blurView(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          child: Text("Subscribe the chat to continue.."),
        ),
      ),
    );
  }
}

Widget blurChat(BuildContext context, DisscussionGropModel group) {
  final Size size = MediaQuery.of(context).size;
  return Stack(
    children: [
      Container(
        padding: EdgeInsets.only(bottom: size.height * 0.1),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseChatHandler.getAllDiscussionGroupMessage(groupId: group.groupId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: BouncingScrollPhysics(),
                    reverse: true,
                    itemCount: snapshot.data?.docs?.length ?? 0,
                    itemBuilder: (context, indexMain) {
                      var data = snapshot.data.docs[indexMain].data();

                      ChatModel chatModel = ChatModel.fromJson(data);

                      if (chatModel.sentBy == context.read<ChatProvider>().getUserUID()) {
                        return SenderMessageCard(
                          chatModel: chatModel,
                        );
                      } else {
                        return RecivedMessageCard(
                          chatModel: chatModel,
                        );
                      }
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
      blurView(
          child: AlertDialog(
        elevation: 20,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        title: Column(
          children: [
            Text("You are not succribed to chat ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto Medium',
                  fontWeight: FontWeight.w200,
                  color: Colors.black,
                )),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RandomPage(
                              index: 4,
                              price: context.read<ProfileProvider>().subsPrice.toString(),
                              categoryType: context.read<CourseProvider>().selectedMasterType,
                              categoryId: 0,
                            )));
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: AppColor.appGradient,
                ),
                child: Center(
                    child: Text(
                  "Buy to Access",
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
          )
        ],
      )
          // child: Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 300.0),
          //   child: Dialog(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(8.0),
          //     ),
          //     child: Container(
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(10),
          //           gradient: AppColor.appGradient,
          //         ),
          //         child: Center(
          //             child: Text(
          //           "Buy to Access Chat",
          //           style: TextStyle(color: Colors.white),
          //         ))),
          //   ),
          // ),
          ),
    ],
  );
}
