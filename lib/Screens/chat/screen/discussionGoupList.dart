import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/chat/chatHandler.dart';
import 'package:pgmp4u/Screens/chat/controller/chatProvider.dart';
import 'package:pgmp4u/Screens/chat/model/discussionGroupModel.dart';
import 'package:pgmp4u/Screens/chat/screen/personalChatGroupList.dart';
import 'package:pgmp4u/Screens/chat/screen/usersList.dart';
import 'package:pgmp4u/Screens/chat/widgets/groupListTile.dart';
import 'package:pgmp4u/utils/app_color.dart';
import 'package:provider/provider.dart';

import '../../../provider/courseProvider.dart';
import '../../MockTest/model/courseModel.dart';
import '../../dropdown.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({Key key}) : super(key: key);

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  List<Color> colors = [
    Color(0xff0096C7),
    Color(0xffE76F51),
    Color(0xff6A994E),
    Color(0xff42D865),
    Color(0xff9D6B53),
  ];

  @override
  void initState() {
    CourseProvider cp = Provider.of(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Container(
            width: 60,
            height: 60,
            child: Icon(
              Icons.add_rounded,
              size: 40,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColor.appGradient,
            ),
          ),
          onPressed: () => addDiscussion(context),
        ),
        body: Consumer<CourseProvider>(builder: (context, cp, child) {
          return Column(
            children: [
              _appBar(),
              Container(
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width * .35,
                child: CustomDropDown<CourseDetails>(
                  selectText: cp.selectedCourseLable ?? "Select",
                  itemList: cp.course ?? [],
                  isEnable: true,
                  title: "",
                  value: null,
                  onChange: (val) {
                    print("val.course=========>${val.course}");
                    print("val.course=========>${val.lable}");
                    cp.setSelectedCourseLable(val.lable);
                    cp.setSelectedCourseId(val.id);
                    setState(() {});
                  },
                ),
              ),
              _groups(),
            ],
          );
        }));
  }

  Expanded _groups() {
    print("this is clledddd");
    print("dhfjdf====${context.read<CourseProvider>().selectedCourseLable.toLowerCase()}");
    if ("pmp®" == context.read<CourseProvider>().selectedCourseLable.toLowerCase()) {
      print("they are equalll");
    } else {
      print("this is  print(this is clleddddclledddd");
    }
    return Expanded(
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseChatHandler.getAllDiscussionGroups(
              context.read<CourseProvider>().selectedCourseLable.toLowerCase()),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (context, index) {
                    DisscussionGropModel group = DisscussionGropModel.fromJson(snapshot.data?.docs[index].data());
                    return GroupListTile(
                      index: index,
                      color: colors[index % colors.length],
                      group: group,
                    );
                  });
            } else {
              return const Center(child: CircularProgressIndicator.adaptive());
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
            SizedBox(
              width: 50,
            ),
            Spacer(),
            Text(
              "Discussion Forum",
              style: TextStyle(fontSize: 22, fontFamily: 'Roboto Medium', color: Colors.white),
            ),
            Spacer(),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalChats(),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UsersList(),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.groups_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                )
                // MyPopupMenu(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  addDiscussion(BuildContext context) async {
    print('dis');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,

      // barrierColor: Colors.amber,
      builder: (context) {
        return AddDiscussionBottomSheet();
      },
    );
  }
}

class MyPopupMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<int>>[
          PopupMenuItem<int>(
            value: 1,
            child: Text('Users'),
          ),
        ];
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
      ),
      icon: Icon(Icons.supervised_user_circle_sharp, color: Colors.white),
      onSelected: (int value) {
        // Handle menu item selection
        switch (value) {
          case 1:
            // Option 1 selected
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UsersList(),
                ));
            break;
        }
      },
    );
  }
}

class AddDiscussionBottomSheet extends StatelessWidget {
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Text(
                  'Add Discussion',
                  style: TextStyle(fontSize: 18, fontFamily: 'Roboto Medium', color: Colors.black),
                ),
                Spacer(),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: Color.fromRGBO(165, 156, 180, 1),
                    )),
              ],
            ),
          ),
          Divider(
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              maxLines: 5,
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Enter Discussion Title Here",
                hintStyle: TextStyle(fontSize: 18, color: Color.fromRGBO(148, 148, 148, 1)),
                border: InputBorder.none,
              ),
            ),
          ),
          _publishButton(context),
        ],
      ),
    );
  }

  Widget _publishButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, bottom: 20, right: 40, top: 10),
      child: InkWell(
        onTap: () => onTapOfPublish(context),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: AppColor.appGradient,
          ),
          alignment: Alignment.center,
          child: context.watch<ChatProvider>().discussionGroupLoader
              ? CircularProgressIndicator.adaptive()
              : Text(
                  'PUBLISH',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Roboto Medium',
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
        ),
      ),
    );
  }

  onTapOfPublish(BuildContext context) async {
    // print('title: ${titleController.text}');

    List<String> mtyList = [];
    if (titleController.text.trim().isNotEmpty) {
      await context
          .read<ChatProvider>()
          .createDiscussionGroup(titleController.text.trim(), mtyList, context, isFromBottomSheet: true)
          .whenComplete(() {
        titleController.clear();

        Navigator.pop(context);
      });
    }
  }
}
