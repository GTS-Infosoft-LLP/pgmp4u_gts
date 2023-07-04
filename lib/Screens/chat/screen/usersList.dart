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
  int currentPageIndex = 1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    getUser();
    _scrollController.addListener(_scrollListener);
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
        headers: {'Content-Type': 'application/json', 'Authorization': stringValue},
        body: jsonEncode({"page": currentPageIndex}));

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      UpadateLocationResponseModel userListResponseTemp =
          UpadateLocationResponseModel.fromJson(jsonDecode(response.body));

      if (currentPageIndex == 1) {
        userListResponse = userListResponseTemp;
      } else {
        userListResponse.data.addAll(userListResponseTemp.data);
      }

      // filter list if user's uuid is null or empty
      userListResponse.data.removeWhere((user) => user.uuid.isEmpty || user.uuid == null);

      /// remove my self
      userListResponse.data.removeWhere((user) => user.uuid == context.read<ChatProvider>().getUser().uid);

      // only shows admin if i'm normal user
      context.read<ChatProvider>().isChatAdmin()
          ? null
          : userListResponse.data.removeWhere((user) => user.isChatAdmin == 0);

      isLoading = false;

      currentPageIndex++;
      setState(() {});
    } else {
      isLoading = false;
      setState(() {});
      print('error while calling api');
      print(jsonDecode(response.body));
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      print('_listener called');
      getUser();
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
                      controller: _scrollController,
                      itemCount: userListResponse.data.length,
                      itemBuilder: (context, index) {
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
        // context.read<ChatProvider>().generateRoomId(reciverId: user.userId.toString());
        bool isRoomCreated = await context
            .read<ChatProvider>()
            .initiatePersonalChat(reciver: MyUserInfo(id: user.uuid, name: user.name, isAdmin: user.isChatAdmin));

        String name = '';
        name = user.name;
        name += user.isChatAdmin == 1 ? " (Admin)" : '';
        if (isRoomCreated) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(v1: name),
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
            user.isChatAdmin == 1
                ? Text(
                    "  (Admin)" ?? "",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  )
                : SizedBox(),
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
