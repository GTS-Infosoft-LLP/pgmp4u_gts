import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pgmp4u/Screens/home_view/flash_card_item.dart';
import 'package:pgmp4u/Screens/home_view/video_library.dart';
import 'package:pgmp4u/utils/appimage.dart';

import '../../Models/options_model.dart';
import '../../tool/ShapeClipper2.dart';
import '../../utils/app_color.dart';
import '../../utils/app_textstyle.dart';
import '../../utils/user_object.dart';
import 'application_support.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = UserObject().getUser;

    print(">>>>> name ${user.token}");
    final List<OptionsItem> options = [
      // OptionsItem(
      //     iconImage: FontAwesomeIcons.graduationCap,
      //     name: "Application Support",
      //     screen: homeOption.application),
      OptionsItem(
          iconImage: FontAwesomeIcons.video,
          name: "Video Library",
          screen: homeOption.videoLab),

      OptionsItem(
          iconImage: FontAwesomeIcons.tableColumns,
          name: "Flash Cards",
          screen: homeOption.flashCard),
      // OptionsItem(
      //     iconImage: FontAwesomeIcons.bookOpenReader,
      //     name: "Domain Wise Exam Tips",
      //     screen: homeOption.domainWise),
      // OptionsItem(
      //     iconImage: FontAwesomeIcons.users,
      //     name: "Lessons Learned - By PgMP Achievers!",
      //     screen: homeOption.lissonsLearn),
      // OptionsItem(
      //     iconImage: FontAwesomeIcons.circleInfo,
      //     name: "About PgMP",
      //     screen: homeOption.about),
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
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xff3643a3), Color(0xff5468ff)]),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: topHeight - topHeight / 1.4,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  child: Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      CircleAvatar(
                        radius: topHeight / 2,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: topHeight / 2 - 10,
                          backgroundColor: Colors.grey.withOpacity(0.6),
                          foregroundImage: NetworkImage(user.image),
                          backgroundImage:
                              AssetImage(AppImage.profile_placeholder),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "${user.name}",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text("Course Name"),
                    ]),
                  ),
                ),
              ),
              ListView.builder(
                itemCount: options.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  var item = options[index];
                  return Card(
                    margin: EdgeInsets.symmetric(
                      vertical: 0.5,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              switch (item.screen) {
                                case homeOption.application:
                                  return ApplicationSupportPage();
                                case homeOption.videoLab:
                                  return VideoLibraryPage();
                                case homeOption.flashCard:
                                  return FlashCardItem();
                                case homeOption.domainWise:
                                  return ApplicationSupportPage();
                                case homeOption.lissonsLearn:
                                  return ApplicationSupportPage();
                                case homeOption.about:
                                  return ApplicationSupportPage();
                                default:
                                  return ApplicationSupportPage();
                              }
                            },
                          ));
                        },
                        leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: index % 2 == 0
                                  ? AppColor.purpule
                                  : AppColor.green,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(item.iconImage, color: Colors.white),
                            )),
                        title: Text(
                          item.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.titleTile,
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        )
      ],
    );
  }
}

class SharedPreferences {}
