import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pgmp4u/Screens/home_view/VideoLibrary/RandomPage.dart';
import 'package:pgmp4u/Screens/home_view/flash_card_item.dart';
import 'package:pgmp4u/Screens/home_view/video_library.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/provider/purchase_provider.dart';
import 'package:pgmp4u/provider/response_provider.dart';
import 'package:pgmp4u/utils/appimage.dart';
import 'package:pgmp4u/Screens/home_view/flashcarddbuttn.dart';
import 'package:provider/provider.dart';
import '../../Models/apppurchasestatusmodel.dart';
import '../../Models/hideshowmodal.dart';
import '../../Models/options_model.dart';
import '../../tool/ShapeClipper2.dart';
import '../../utils/app_color.dart';
import '../../utils/app_textstyle.dart';
import '../../utils/user_object.dart';
import '../Dashboard/DashboardScreen.dart';
import 'package:http/http.dart' as http;
import 'application_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;

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
  initState() {
    PurchaseProvider purchaseProvider = Provider.of(context, listen: false);
    purchaseProvider.updateStatusNew();
    //   maintainStatus=purchaseProvider.latestStatus;
    print("initcalling");
    _getData();
    callFlashCardHideShowApi();
    print("object");
    super.initState();
  }

  HideShowResponse hideShowRes = HideShowResponse();
  Future callFlashCardHideShowApi() async {
    print("test111111111");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    http.Response response;

    print("test12222222222");

    try {
      response = await http.get(Uri.parse(getHideShowStatus), headers: {
        'Content-Type': 'application/json',
      }
          //'Authorization': "Bearer "+stringValue
          );
      print("testt333333333");

      if (response.statusCode == 200) {
        print(convert.jsonDecode(response.body));

        await prefs.setString('useStatus', response.body);
        _getData();
      }
    } catch (e) {
      _getData();
    }
  }
//     Future apiCall() async {

//       print("apiCALL");
//       ModelStatus maintainStatus;
//   //  print("Get Status of FlashCard  ${mapResponse}");
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//   print("apiCALL1");
//     // SharedPreferences prefs = await SharedPreferences.getInstance();
//    String stringValue = prefs.getString('token');
//    print(stringValue);
//   print("apiCALL2");
//    try {

//   var  response = await get(Uri.parse("http://18.119.55.81:3003/api/checkStatus"), headers: {
//       'Content-Type': 'application/json',
//       'Authorization': "Bearer "+stringValue
//     }).catchError((error){
//        print("apiCALL5");
//     });
//     print("apiCALL3 ${response.body}");
//     if (response.statusCode == 200) {
//       print("Calling successfull");
//       print(convert.jsonDecode(response.body));
//       setState(() {
//         mapResponse = convert.jsonDecode(response.body);
//         PurchaseProvider purchaseProvider = Provider.of(context,listen: false);
//         print("datadatdtdatdatdasdtasdasdt>>>>>>>>>>$mapResponse");
//         purchaseProvider.setStatus(ModelStatus.fromjson(mapResponse["data"]));
//         maintainStatus = purchaseProvider.getLatestStatus();
//         print("real valuee of flash card status  ${maintainStatus.flashCardStatus}");
//         print("real valuee of video library status  ${maintainStatus.videoLibStatus}");
//       });
//       // print(convert.jsonDecode(response.body));
//     }
//    }catch(e){
//      print("apiCALL4");
// print(">>>> api error $e");
//    }

//   }
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
          isShow: hideShowRes?.is_applicationsupport == 1 ? true : false,
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
                        height: 5,
                      ),
                      Text(
                        "${user.name}",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      //Text("Course Name"),
                      Text(
                        "PgMp",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
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
                  return options[index].isShow == true
                      ? Card(
                          margin: EdgeInsets.symmetric(
                            vertical: 0.5,
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Consumer<PurchaseProvider>(
                                builder: (context, purchaseProvider, child) {
                                  var maintainStatus =
                                      purchaseProvider.latestStatus;
                                  return ListTile(
                                    onTap: () {
                                      var _screen;
                                      switch (item.screen) {
                                        case homeOption.application:
                                          _screen = ApplicationSupportPage();
                                          break;
                                        case homeOption.videoLab:
                                          _screen = VideoLibraryPage();
                                          break;
                                        case homeOption.flashCard:
                                          if (maintainStatus?.flashCardStatus ==
                                              0) {
                                            _screen = RandomPage(
                                              index: 1,
                                            );
                                            // 1 for flash card plan only enum  for index
                                            break;
                                          }
                                          _screen = FlashCardItem();
                                          break;

                                        case homeOption.domainWise:
                                          _screen = ApplicationSupportPage();
                                          break;
                                        case homeOption.challengers:
                                          _screen = DashboardScreen(
                                              selectedId: () =>
                                                  {print('object')});
                                          break;
                                        case homeOption.lissonsLearn:
                                          _screen = ApplicationSupportPage();
                                          break;
                                        case homeOption.about:
                                          _screen = ApplicationSupportPage();
                                          break;
                                        default:
                                          _screen = ApplicationSupportPage();
                                          break;
                                      }
                                      if (_screen != null) {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return _screen;
                                          },
                                        ));
                                      }
                                    },
                                    leading: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: index % 2 == 0
                                              ? AppColor.purpule
                                              : AppColor.green,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Icon(item.iconImage,
                                              color: Colors.white),
                                        )),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          item.name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyle.titleTile,
                                        ),
                                      ],
                                    ),
                                    //  Text(
                                    //   item.name,
                                    //   maxLines: 2,
                                    //   overflow: TextOverflow.ellipsis,
                                    //   style: AppTextStyle.titleTile,
                                    // ),
                                    trailing: item.btntxt.isEmpty
                                        ? SizedBox()
                                        : item.name == "Flash Cards" &&
                                                maintainStatus
                                                        ?.flashCardStatus ==
                                                    1
                                            ? SizedBox()
                                            : item.name == "Video Library" &&
                                                    maintainStatus
                                                            ?.videoLibStatus ==
                                                        1
                                                ? SizedBox()
                                                : SizedBox(
                                                    width: 100,
                                                    child: OutlinedButton(
                                                      //   onPressed: (){
                                                      //     if(item.name== "Flash Cards"){
                                                      //    Navigator.push(context, MaterialPageRoute(
                                                      //  builder: (BuildContext context) => RandomPage(
                                                      //    index: 1),
                                                      //  ));
                                                      //     }

                                                      //   },
                                                      child: Text(
                                                        item.btntxt,
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff484C71),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Color(
                                                                    0xffF1EFF0)),
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18.0),
                                                            side: BorderSide(
                                                              color: Color(
                                                                  0xffDDDDDD),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                    // subtitle: Row(
                                    //   children:<Widget> [
                                    //     ElevatedButton(
                                    //       onPressed: (){},
                                    //       child: Text("US19",style: TextStyle(color: Colors.amberAccent),),
                                    //     )
                                    //   ]
                                    //   ),
                                  );
                                },
                              )),
                        )
                      : SizedBox();
                },
              )
            ],
          ),
        )
      ],
    );
  }

  Future<void> _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String action = await prefs.getString('useStatus');
      print("SharedPreffffff   check   ${action}");

      hideShowRes = HideShowResponse.fromjson(convert.jsonDecode(action));

      setState(() {});
    } catch (e) {}
  }
}

//class SharedPreferences {}
