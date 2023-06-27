import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pgmp4u/Screens/chat/model/userListModel.dart';
import 'package:pgmp4u/api/apis.dart';
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

    //response i.e {success: true, cnt: 0, data: {paid_status: 0}}
    if (response.statusCode == 200) {
      // Future.delayed(Duration(seconds: 1)).then((value) {
      //   setState(() {
      //     mapResponse = convert.jsonDecode(response.body);
      //   });
      // });

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
              ? Center(child: CircularProgressIndicator.adaptive())
              : userListResponse.data.length == 0
                  ? Center(child: Text('No User Found'))
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: userListResponse.data.length,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) => _userListTile(userListResponse.data[index])),
        ],
      ),
    );
  }

  Widget _userListTile(Users user) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Text(
        user.name ?? "",
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
    // return ListTile(
    //   // leading: CircleAvatar(
    //   //   radius: 24,
    //   //   child: Text(
    //   //     '1',
    //   //     style: TextStyle(
    //   //       fontWeight: FontWeight.bold,
    //   //       fontSize: 18,
    //   //     ),
    //   //   ),
    //   // ),
    //   title: Text(
    //     user.name ?? "",
    //     style: TextStyle(
    //       fontSize: 16,
    //     ),
    //   ),
    //   // subtitle: Text(
    //   //   Jiffy(notificationProvider
    //   //           .notificationList[index].createdAt)
    //   //       .fromNow(),
    //   //   style: TextStyle(
    //   //     fontSize: 12,
    //   //     fontFamily: AppFont.poppinsRegular,
    //   //   ),
    //   // ),
    // );
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
          children: [
            Spacer(),
            Text(
              "Users",
              style: TextStyle(fontSize: 22, fontFamily: 'Roboto Medium', color: Colors.white),
            ),
            Spacer(),

            // InkWell(
            //   onTap: () => MyPopupMenu(),
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            // child: Icon(
            //   Icons.more_vert_rounded,
            //   color: Colors.white,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}