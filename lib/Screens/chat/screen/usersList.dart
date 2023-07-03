import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:http/http.dart' as http;
import 'package:pgmp4u/Screens/chat/model/singleGroupModel.dart';
import 'package:pgmp4u/Screens/chat/screen/chatPage.dart';
import 'package:pgmp4u/Screens/chat/controller/chatProvider.dart';
import 'package:pgmp4u/Screens/chat/model/userListModel.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key key}) : super(key: key);

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  bool isLoading = false;
  UpadateLocationResponseModel userListResponse;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print(stringValue);
    http.Response response;
    response = await http.post(Uri.parse(chatUserListApi),
        headers: {'Content-Type': 'application/json', 'Authorization': stringValue}, body: jsonEncode({"page": 1}));

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      userListResponse = UpadateLocationResponseModel.fromJson(jsonDecode(response.body));
      isLoading = false;
      setState(() {});
    } else {
      isLoading = false;
      setState(() {});
      print('error while calling api');
      print(jsonDecode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _appBar(),
          isLoading
              ? Expanded(child: Center(child: CircularProgressIndicator.adaptive()))
              : userListResponse.data.length == 0
                  ? Expanded(child: Center(child: Text('No User Found')))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: userListResponse.data.length,
                      // separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) {
                        if (userListResponse.data[index].uuid.isEmpty || userListResponse.data[index].uuid == null) {
                          return SizedBox();
                        }
                        if (userListResponse.data[index].uuid == context.read<ChatProvider>().getUser().uid) {
                          return SizedBox();
                        }

                        return _userListTile(userListResponse.data[index]);
                      }),
        ],
      ),
    );
  }

  Widget _userListTile(Users user) {
    return InkWell(
      onTap: () async {
        // create a admin-user chat group
        context.read<ChatProvider>().generateRoomId(reciverId: user.userId.toString());
        bool isRoomCreated = await context
            .read<ChatProvider>()
            .initiatePersonalChat(reciver: MyUserInfo(id: user.uuid, name: user.name, isAdmin: user.isChatAdmin));

        if (isRoomCreated) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(v1: user.name),
              ));
        } else {
          GFToast.showToast(
            'Exception occured while initiating chat!',
            context,
            toastPosition: GFToastPosition.BOTTOM,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              child: Text(
                user.name.characters.first.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              user.name ?? "",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _appBar() {
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
          mainAxisAlignment: MainAxisAlignment.center,
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
            Expanded(
              child: Text(
                "Users",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontFamily: 'Roboto Medium', color: Colors.white),
              ),
            ),
            SizedBox(width: 34),
          ],
        ),
      ),
    );
  }
}
