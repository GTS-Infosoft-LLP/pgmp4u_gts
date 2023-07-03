import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/chat/chatHandler.dart';
import 'package:pgmp4u/Screens/chat/screen/chatPage.dart';
import 'package:pgmp4u/Screens/chat/controller/chatProvider.dart';
import 'package:pgmp4u/Screens/chat/model/singleGroupModel.dart';
import 'package:pgmp4u/utils/extensions.dart';
import 'package:provider/provider.dart';

class PersonalChats extends StatefulWidget {
  const PersonalChats({Key key}) : super(key: key);

  @override
  State<PersonalChats> createState() => _PersonalChatsState();
}

class _PersonalChatsState extends State<PersonalChats> {
  List<Color> colors = [
    Color(0xff0096C7),
    Color(0xffE76F51),
    Color(0xff6A994E),
    Color(0xff42D865),
    Color(0xff9D6B53),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        _appBar(),
        _groups(),
      ],
    ));
  }

  Widget _userListTile(PersonalGroupModel personal) {
    String name = '';
    personal.members.forEach((member) {
      if (member.id != context.read<ChatProvider>().getUser().uid) {
        print('member name: ${member.name}');
        name = member.name;

        if (member.isAdmin == 1) {
          name += "  (Admin)";
        }
      }
    });

    return InkWell(
      onTap: () {
        context.read<ChatProvider>().setChatRoomId(personal.groupId);
        // create a admin-user chat group
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(),
            ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              child: Text(
                // user.name.characters.first.toUpperCase(),
                name.characters.first.toUpperCase() ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.capitalizeFirstLetter() ?? "",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  personal.lastMessage ?? "",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Expanded _groups() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseChatHandler.getAllPersonalChatGroups(myUUID: context.read<ChatProvider>().getUser().uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('legth: ${snapshot.data.docs.length}');
              return ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (context, index) {
                    PersonalGroupModel group = PersonalGroupModel.fromJson(snapshot.data?.docs[index].data());

                    return _userListTile(group);
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget _appBar() {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(16.0), bottomLeft: Radius.circular(16.0)),
        gradient: LinearGradient(
            colors: [
              Color(0xff4B5BE2),
              Color(0xff2135D9),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
              ),
            ),
            Spacer(),
            Text(
              "Personal Chats",
              style: TextStyle(fontSize: 22, fontFamily: 'Roboto Medium', color: Colors.white),
            ),
            SizedBox(
              width: 34,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
