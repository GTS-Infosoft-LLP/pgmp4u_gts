import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:pgmp4u/Screens/MockTest/model/courseModel.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/provider/purchase_provider.dart';
import 'package:pgmp4u/utils/appimage.dart';
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

    if (tempList.isEmpty) {
      tempList = HiveHandler.getCourseDataList();
      print("*************************************************");
      print("tempList==========${tempList.length}");
    }
    //   maintainStatus=purchaseProvider.latestStatus;
    print("initcalling");
    // _getData();
    // callFlashCardHideShowApi();
    print("object");

    courseProvider.getCourse();
// getMasterData();

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
          isShow: true,
          // hideShowRes?.is_applicationsupport == 1 ? true : false,
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
                        CircleAvatar(
                          radius: topHeight / 2,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: topHeight / 2 - 10,
                            backgroundColor: Colors.grey.withOpacity(0.6),
                            foregroundImage: NetworkImage(user.image),
                            backgroundImage: AssetImage(AppImage.profile_placeholder),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${user.name}",
                          style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        //Text("Course Name"),
                        Text(
                          "",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
                // tempList.isNotEmpty
                //     ? Center(child: Container(height: 400, child: Text("No Data Found2222")))
                //     :

                Container(
                  child: ValueListenableBuilder<Box<List<CourseDetails>>>(
                      valueListenable: HiveHandler.getCourseListener(),
                      builder: (context, value, child) {
                       
                        print("*****************************>Sdwsfwefw  ${value.get("courseKey")}");
                        storedCourse = value.get("courseKey");

                        print("list has data......");
                        print("storedCourse========$storedCourse");

                        return Consumer<CourseProvider>(builder: (context, courseProvider, child) {
                          return storedCourse.isEmpty
                              ? Center(child: Container(height: 400, child: Text("No Data Found")))
                              : Container(
                                  decoration: BoxDecoration(
                                    // color: Colors.amber,
                                    border: Border(
                                        // top: BorderSide(width: 16.0, color: Colors.lightBlue.shade600),
                                        // bottom: BorderSide(
                                        //     width: 16.0, color: Colors.lightBlue.shade900),
                                        ),
                                  ),
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

                                              courseProvider.setSelectedCourseId(storedCourse[index].id);

                                              courseProvider.setSelectedCourseName(storedCourse[index].lable);

                                              courseProvider.getMasterData(storedCourse[index].id);
                                              Future.delayed(const Duration(milliseconds: 600), () {
                                                Navigator.push(
                                                    context, MaterialPageRoute(builder: (context) => MasterListPage()));
                                              });

                                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>MasterListPage  ()));
                                              //MasterListPage    VideoLibraryPage
                                            },
                                            child: ListTile(
                                              leading: Container(
                                                  height: 70,
                                                  width: 65,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8),
                                                    color: clr,
                                                    // index % 2 == 0
                                                    //     ? Color(0xff3F9FC9)
                                                    //     : Color(0xffDE682B),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(12),
                                                    child: Icon(FontAwesomeIcons.graduationCap, color: Colors.white),
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
                                      })

                                  // GridView.builder(
                                  //     itemCount: courseProvider.course.length,
                                  //     // shrinkWrap: true,
                                  //     // physics: ClampingScrollPhysics(),
                                  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  //       crossAxisCount: 3,
                                  //       // mainAxisExtent: 160,
                                  //       crossAxisSpacing: 0,
                                  //       mainAxisSpacing: 9,
                                  //     ),
                                  //     itemBuilder: (context, index) {
                                  //       return Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: InkWell(
                                  //           onTap: () {
                                  //             print(
                                  //                 "id Is======>>>${courseProvider.course[index].id}");

                                  //             courseProvider.getMasterData(
                                  //                 courseProvider.course[index].id);
                                  //             Future.delayed(const Duration(milliseconds: 600),
                                  //                 () {
                                  //               Navigator.push(
                                  //                   context,
                                  //                   MaterialPageRoute(
                                  //                       builder: (context) =>
                                  //                           MasterListPage()));
                                  //             });

                                  //             // Navigator.push(context, MaterialPageRoute(builder: (context)=>MasterListPage  ()));
                                  //             //MasterListPage    VideoLibraryPage
                                  //           },
                                  //           child: Container(
                                  //             height: 80,

                                  //             // color: Colors.amber,
                                  //             child: Column(
                                  //               crossAxisAlignment: CrossAxisAlignment.center,
                                  //               children: [
                                  //                 Padding(
                                  //                   padding: const EdgeInsets.only(
                                  //                       top: 15.0, left: 12),
                                  //                   child: Container(
                                  //                     height: 60,
                                  //                     width: 60,
                                  //                     decoration: BoxDecoration(
                                  //                       borderRadius: BorderRadius.circular(8),
                                  //                       color: index % 2 == 0
                                  //                           ? AppColor.purpule
                                  //                           : AppColor.green,
                                  //                     ),
                                  //                     child: Icon(
                                  //                         index % 2 == 0
                                  //                             ? FontAwesomeIcons.graduationCap
                                  //                             : FontAwesomeIcons.atom,
                                  //                         color: Colors.white),
                                  //                   ),
                                  //                 ),
                                  //                 SizedBox(
                                  //                   height: 5,
                                  //                 ),
                                  //                 Padding(
                                  //                   padding: const EdgeInsets.only(left: 10.0),
                                  //                   child: Container(
                                  //                     // color: Colors.amber,
                                  //                     child: Text(
                                  //                       courseProvider.course[index].course,
                                  //                       textAlign: TextAlign.center,
                                  //                       style: TextStyle(
                                  //                         fontSize: 18,
                                  //                         color: Colors.black,
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       );
                                  //     }),

                                  );
                        });
                      }),
                )

                // Text(
                //   course[index].course
                // );

                //     return Card(

                //              margin: EdgeInsets.symmetric(
                //                             vertical: 0.5,
                //                           ),

                //                       child: ListTile(

                //                                   leading: Container(
                //                                         decoration: BoxDecoration(
                //                                           borderRadius:
                //                                               BorderRadius.circular(8),
                //                                           color: index % 2 == 0
                //                                               ? AppColor.purpule
                //                                               : AppColor.green,
                //                                         ),
                //                                         child: Padding(
                //                                           padding: const EdgeInsets.all(12),
                //                                           child: Icon(FontAwesomeIcons.graduationCap,
                //                                               color: Colors.white),
                //                                         )),

                //                 title: Column(

                //                              crossAxisAlignment:
                //                                           CrossAxisAlignment.start,
                //                                       children: [
                //                                         Text(
                //                                           course[index].course,
                //                                           maxLines: 1,
                //                                           overflow: TextOverflow.ellipsis,
                //                                           style: TextStyle(
                //                                               fontSize: 14,
                //                                               color: Colors.grey,
                //                                               fontWeight: FontWeight.bold),
                //                                         ),
                //                                         Text(
                //                                          course[index].description,
                //                                           maxLines: 2,
                //                                           overflow: TextOverflow.ellipsis,
                //                                           style: AppTextStyle.titleTile,
                //                                         ),
                //                                       ],

                // ),

                // ),

                //     );

                // ListView.builder(
                //   // itemCount: options.length,
                //   itemCount: options.length,

                //   shrinkWrap: true,
                //   physics: ClampingScrollPhysics(),
                //   itemBuilder: (context, index) {
                //     var item = options[index];
                //     return options[index].isShow == true
                //         ? Card(
                //             margin: EdgeInsets.symmetric(
                //               vertical: 0.5,
                //             ),
                //             child: Padding(
                //                 padding: const EdgeInsets.all(8.0),
                //                 child: Consumer<PurchaseProvider>(
                //                   builder: (context, purchaseProvider, child) {
                //                     var maintainStatus =
                //                         purchaseProvider.latestStatus;
                //                     return ListTile(
                //                       onTap: () {
                //                         var _screen;
                //                         switch (item.screen) {
                //                           case homeOption.application:
                //                             _screen = ApplicationSupportPage();
                //                             break;
                //                           case homeOption.videoLab:
                //                             _screen = VideoLibraryPage();
                //                             break;
                //                           case homeOption.flashCard:
                //                             if (maintainStatus?.flashCardStatus ==
                //                                 0) {
                //                               _screen = RandomPage(
                //                                 index: 1,
                //                               );
                //                               // 1 for flash card plan only enum  for index
                //                               break;
                //                             }
                //                             _screen = FlashCardItem();
                //                             break;

                //                           case homeOption.domainWise:
                //                             _screen = ApplicationSupportPage();
                //                             break;
                //                           case homeOption.challengers:
                //                             _screen = DashboardScreen(
                //                                 selectedId: () =>
                //                                     {print('object')});
                //                             break;
                //                           case homeOption.lissonsLearn:
                //                             _screen = ApplicationSupportPage();
                //                             break;
                //                           case homeOption.about:
                //                             _screen = ApplicationSupportPage();
                //                             break;
                //                           default:
                //                             _screen = ApplicationSupportPage();
                //                             break;
                //                         }
                //                         if (_screen != null) {
                //                           Navigator.push(context,
                //                               MaterialPageRoute(
                //                             builder: (context) {
                //                               return _screen;
                //                             },
                //                           ));
                //                         }
                //                       },
                //                       leading: Container(
                //                           decoration: BoxDecoration(
                //                             borderRadius:
                //                                 BorderRadius.circular(8),
                //                             color: index % 2 == 0
                //                                 ? AppColor.purpule
                //                                 : AppColor.green,
                //                           ),
                //                           child: Padding(
                //                             padding: const EdgeInsets.all(12),
                //                             child: Icon(item.iconImage,
                //                                 color: Colors.white),
                //                           )),
                //                       title: Column(
                //                         crossAxisAlignment:
                //                             CrossAxisAlignment.start,
                //                         children: [
                //                           Text(
                //                             item.title,
                //                             maxLines: 1,
                //                             overflow: TextOverflow.ellipsis,
                //                             style: TextStyle(
                //                                 fontSize: 14,
                //                                 color: Colors.grey,
                //                                 fontWeight: FontWeight.bold),
                //                           ),
                //                           Text(
                //                             item.name,
                //                             maxLines: 2,
                //                             overflow: TextOverflow.ellipsis,
                //                             style: AppTextStyle.titleTile,
                //                           ),
                //                         ],
                //                       ),
                //                       //  Text(
                //                       //   item.name,
                //                       //   maxLines: 2,
                //                       //   overflow: TextOverflow.ellipsis,
                //                       //   style: AppTextStyle.titleTile,
                //                       // ),
                //                       trailing: item.btntxt.isEmpty
                //                           ? SizedBox()
                //                           : item.name == "Flash Cards" &&
                //                                   maintainStatus
                //                                           ?.flashCardStatus ==
                //                                       1
                //                               ? SizedBox()
                //                               : item.name == "Video Library" &&
                //                                       maintainStatus
                //                                               ?.videoLibStatus ==
                //                                           1
                //                                   ? SizedBox()
                //                                   : SizedBox(
                //                                       width: 100,
                //                                       child: OutlinedButton(
                //                                         //   onPressed: (){
                //                                         //     if(item.name== "Flash Cards"){
                //                                         //    Navigator.push(context, MaterialPageRoute(
                //                                         //  builder: (BuildContext context) => RandomPage(
                //                                         //    index: 1),
                //                                         //  ));
                //                                         //     }

                //                                         //   },
                //                                         child: Text(
                //                                           item.btntxt,
                //                                           style: TextStyle(
                //                                               color: Color(
                //                                                   0xff484C71),
                //                                               fontWeight:
                //                                                   FontWeight
                //                                                       .bold),
                //                                         ),
                //                                         style: ButtonStyle(
                //                                           backgroundColor:
                //                                               MaterialStateProperty
                //                                                   .all(Color(
                //                                                       0xffF1EFF0)),
                //                                           shape: MaterialStateProperty
                //                                               .all<
                //                                                   RoundedRectangleBorder>(
                //                                             RoundedRectangleBorder(
                //                                               borderRadius:
                //                                                   BorderRadius
                //                                                       .circular(
                //                                                           18.0),
                //                                               side: BorderSide(
                //                                                 color: Color(
                //                                                     0xffDDDDDD),
                //                                               ),
                //                                             ),
                //                                           ),
                //                                         ),
                //                                       ),
                //                                     ),

                //                       // subtitle: Row(
                //                       //   children:<Widget> [
                //                       //     ElevatedButton(
                //                       //       onPressed: (){},
                //                       //       child: Text("US19",style: TextStyle(color: Colors.amberAccent),),
                //                       //     )
                //                       //   ]
                //                       //   ),
                //                     );
                //                   },
                //                 )),
                //           )
                //         : SizedBox();
                //   },
                // )

                ,
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

//   Future<void> getCourse() async {

//  SharedPreferences prefs = await SharedPreferences.getInstance();
//     String stringValue = prefs.getString('token');

//     print("token valued===${stringValue}");

//   var response = await http.get(
//       Uri.parse("http://3.227.35.115:1011/api/getCourse"),
//       headers: {
//         "Content-Type": "application/json",
//         'Authorization': stringValue
//       },

//     );

// print("response.statusCode===${response.statusCode}");
//     if(response.statusCode==200){
//       course.clear();
//       Map<String, dynamic> mapResponse=convert.jsonDecode(response.body);
//     List temp1=mapResponse["data"];
//       print("temp list===${temp1}");
//       course=temp1.map((e)=>CourseDetails.fromjson(e)).toList();

// if(course.isNotEmpty){
//   print("course 0=== ${course[0].description}");
// }
//     }
//     print("respponse=== ${response.body}");

//   }
}

//class SharedPreferences {}
