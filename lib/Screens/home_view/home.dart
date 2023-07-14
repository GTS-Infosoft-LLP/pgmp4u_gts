import 'dart:async';
import 'dart:convert' as convert;
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pgmp4u/Screens/MockTest/model/courseModel.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/provider/purchase_provider.dart';
import 'package:provider/provider.dart';
import '../../Models/hideshowmodal.dart';
import '../../Models/options_model.dart';
import '../../provider/courseProvider.dart';
import '../../tool/ShapeClipper2.dart';
import '../../utils/user_object.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Tests/local_handler/hive_handler.dart';
import '../masterPage.dart';

//import 'home_view/flashcardbuttn.dart';
class HomeView extends StatefulWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Map mapResponse;

//ModelStatus maintainStatus;
  @override
  Color clr;
  List<CourseDetails> tempList = [];
  List<CourseDetails> storedCourse = [];

  initState() {
    print("0======call init");
    PurchaseProvider purchaseProvider = Provider.of(context, listen: false);
    CourseProvider courseProvider = Provider.of(context, listen: false);
    purchaseProvider.updateStatusNew();

    courseProvider.getCourse();

    super.initState();
  }

  HideShowResponse hideShowRes = HideShowResponse();
  Future callFlashCardHideShowApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response;

    try {
      response = await http.get(Uri.parse(getHideShowStatus), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        print(convert.jsonDecode(response.body));

        await prefs.setString('useStatus', response.body);
        _getData();
      }
    } catch (e) {
      _getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = UserObject().getUser;
    final List<OptionsItem> options = [
      OptionsItem(
          isShow: true,
          iconImage: FontAwesomeIcons.userGraduate,
          name: "Application Support",
          title: "Get",
          screen: homeOption.application,
          btntxt: ""),
      OptionsItem(
        isShow: hideShowRes?.is_videoplan == 1 ? true : false,
        iconImage: FontAwesomeIcons.video,
        name: "Video Library",
        title: "Watch",
        screen: homeOption.videoLab,
        btntxt: "",
      ),
      OptionsItem(
          isShow: hideShowRes?.is_flashcard == 1 ? true : false,
          iconImage: FontAwesomeIcons.tableColumns,
          name: "Flash Cards",
          title: "Read",
          screen: homeOption.flashCard,
          btntxt: "US19"),
      OptionsItem(
          isShow: hideShowRes?.is_challangequiz == 1 ? true : false,
          iconImage: FontAwesomeIcons.book,
          name: "Challenger",
          title: "Test4U",
          screen: homeOption.challengers,
          btntxt: ""),
    ];
    final double topHeight = 150;

    return Stack(
      children: [
        ClipPath(
          clipper: ShapeClipperMirrored(),
          child: Container(
            height: topHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xff3643a3), Color(0xff5468ff)]),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Consumer<CourseProvider>(builder: (context, cp, child) {
            return Column(
              children: [
                SizedBox(
                  height: topHeight - topHeight / 1.4,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    child: Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        CircularCachedNetworkImage(
                          imageUrl: user.image,
                          size: (topHeight / 2) * 2,
                          borderColor: Colors.white,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${user.name}",
                          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ]),
                    ),
                  ),
                ),
                Container(
                  child: ValueListenableBuilder<Box<String>>(
                      valueListenable: HiveHandler.getCourseListener(),
                      builder: (context, value, child) {
                        if (value.containsKey(HiveHandler.CourseKey)) {
                          List masterDataList = jsonDecode(value.get(HiveHandler.CourseKey));
                          // print(">>> masterDataList :  $masterDataList");
                          storedCourse = masterDataList.map((e) => CourseDetails.fromjson(e)).toList();
                        } else {
                          storedCourse = [];
                        }

                        // print("storedMaster========================$storedCourse");

                        if (storedCourse == null) {
                          storedCourse = [];
                        }

                        return Consumer<CourseProvider>(builder: (context, courseProvider, child) {
                          return courseProvider.getCourseApiCalling && storedCourse.isEmpty
                              ? Container(
                                  height: MediaQuery.of(context).size.height * .55,
                                  child: Center(child: CircularProgressIndicator.adaptive()))
                              : storedCourse.isEmpty
                                  ? Center(child: Container(height: 400, child: Text("No Data Found")))
                                  : Container(
                                      height: MediaQuery.of(context).size.height * .55,
                                      child: ListView.builder(
                                          itemCount: storedCourse.length,
                                          itemBuilder: (context, index) {
                                            if (index % 4 == 0) {
                                              clr = Color(0xff3F9FC9);
                                            } else if (index % 3 == 0) {
                                              clr = Color(0xff3FC964);
                                            } else if (index % 2 == 0) {
                                              clr = Color(0xffDE682B);
                                            } else {
                                              clr = Color(0xffC93F7F);
                                            }
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 20),
                                              child: InkWell(
                                                onTap: () {
                                                  print("id Is======>>>${storedCourse[index].id}");
                                                  print("setSelectedCourseLable===${storedCourse[index].lable}");

                                                  courseProvider.setSelectedCourseId(storedCourse[index].id);

                                                  courseProvider.setSelectedCourseName(storedCourse[index].lable);
                                                  courseProvider.setSelectedCourseLable(storedCourse[index].course);

                                                  courseProvider.getMasterData(storedCourse[index].id);
                                                  Future.delayed(const Duration(milliseconds: 100), () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(builder: (context) => MasterListPage()));
                                                  });
                                                },
                                                child: ListTile(
                                                  leading: Container(
                                                      height: 70,
                                                      width: 65,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(8),
                                                        color: clr,
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(12),
                                                        child:
                                                            Icon(FontAwesomeIcons.graduationCap, color: Colors.white),
                                                      )),
                                                  title: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        storedCourse[index].lable,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      Text(
                                                        storedCourse[index].course,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }));
                        });
                      }),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            );
          }),
        )
      ],
    );
  }

  Future<void> _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String action = prefs.getString('useStatus');
      print("SharedPreffffff   check   $action");

      hideShowRes = HideShowResponse.fromjson(convert.jsonDecode(action));
      print("hideShowRes====$hideShowRes");

      setState(() {});
    } catch (e) {}
  }
}

Color _colorfromhex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

class CircularCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final Color borderColor;
  final double borderWidth;

  const CircularCachedNetworkImage({
    this.imageUrl,
    this.size,
    this.borderColor = Colors.black,
    this.borderWidth = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width: size - (2 * borderWidth),
          height: size - (2 * borderWidth),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
