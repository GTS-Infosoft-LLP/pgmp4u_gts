import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:pgmp4u/Screens/chat/model/singleGroupModel.dart';
import 'package:pgmp4u/Screens/chat/screen/chatPage.dart';
import 'package:pgmp4u/Screens/chat/controller/chatProvider.dart';
import 'package:pgmp4u/Screens/chat/model/userListModel.dart';
import 'package:provider/provider.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key key}) : super(key: key);

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  bool isLoading = false;
  ChatProvider _chatProvider;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);

    if (_chatProvider.userListResponse != null && _chatProvider.userListResponse.data.length > 0) {
    } else {
      context.read<ChatProvider>().getUserList(isFirstTime: true);
    }

    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    print("controller is listeningggggg......");
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      print('_listener called');
      context.read<ChatProvider>().getUserListApiCalling
          ? null
          : context.read<ChatProvider>().getUserList(isFirstTime: false);
    }
  }

  @override
  void dispose() {
    // _chatProvider.resetPagination();
    scrollController.removeListener(() {});
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserListResponseModel userListResponse = context.watch<ChatProvider>().userListResponse;
    return Scaffold(
      body: Column(
        children: [
          Expanded(flex: 2, child: _appBar()),
          context.watch<ChatProvider>().getUserListApiCalling
              ? Expanded(flex: 13, child: Center(child: CircularProgressIndicator.adaptive()))
              : userListResponse == null || userListResponse.data.length == 0
                  ? Expanded(flex: 13, child: Center(child: Text('No User Found')))
                  : Expanded(
                      flex: 13,
                      child: ListView.builder(
                          shrinkWrap: true,
                          controller: scrollController,
                          itemCount: context.watch<ChatProvider>().isPagging
                              ? userListResponse.data.length + 1
                              : userListResponse.data.length,
                          itemBuilder: (context, index) {
                            if (index < userListResponse.data.length) {
                              return _userListTile(userListResponse.data[index]);
                            } else {
                              return Container(
                                height: 50,
                                margin: EdgeInsets.all(8.0),
                                child: Center(
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                              );
                            }
                          }),
                    ),
        ],
      ),
    );
  }

  Widget _userListTile(Users user) {
    return InkWell(
      onTap: () async {
        // create a admin-user chat group
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
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ))),
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
                context.watch<ChatProvider>().getUserListApiCalling
                    ? "Users... "
                    : "Users (${context.watch<ChatProvider>().userListResponse.data.length})",
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
