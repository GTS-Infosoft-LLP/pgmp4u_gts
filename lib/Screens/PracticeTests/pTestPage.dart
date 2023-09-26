// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:pgmp4u/Screens/PracticeTests/practiceTextProvider.dart';
// import 'package:provider/provider.dart';
// import 'dart:convert' as convert;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:sizer/sizer.dart';
// import '../../api/apis.dart';
// import '../../tool/ShapeClipper.dart';
// import '../Tests/provider/category_provider.dart';

// class PtestPage extends StatefulWidget {
//   const PtestPage({Key key}) : super(key: key);

//   @override
//   State<PtestPage> createState() => _PtestPageState();
// }

// class _PtestPageState extends State<PtestPage> {
//   @override

// bool _show=true;
//  int _quetionNo = 0;
//   int selectedAnswer;
//   int realAnswer;
//   String stringResponse;
//   List listResponse;


//     Color _colorfromhex(String hexColor) {
//     final hexCode = hexColor.replaceAll('#', '');
//     return Color(int.parse('FF$hexCode', radix: 16));
//   }

//   var currentIndex;

//   PracticeTextProvider practiceProvider;
//   CategoryProvider categoryProvider;


//   @override
//   void initState() {

//  practiceProvider = Provider.of(context, listen: false);
//  categoryProvider = Provider.of(context, listen: false);

// callApi();

 
//     super.initState();
//   }


//     Future callApi() async {
//     await practiceProvider.apiCall(
//         categoryProvider.subCategoryId, categoryProvider.type);
//   }


//    Future apiCall2() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String stringValue = prefs.getString('token');
//     print(stringValue);
//     http.Response response;    
//     response = await http.get(Uri.parse(REVIEWS_MOCK_TEST + "/22/4"), headers: {
//       'Content-Type': 'application/json',
//       'Authorization': stringValue
//     });

//     if (response.statusCode == 200) {
//       print(convert.jsonDecode(response.body));
//       setState(() {
//         var _mapResponse = convert.jsonDecode(response.body);

//         listResponse = _mapResponse["data"];
//       });
//       // print(convert.jsonDecode(response.body));
//     }
//   }






//   Widget build(BuildContext context) {
//    PageController pageController = PageController();
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;
//     final arguments = ModalRoute.of(context).settings.arguments as Map;


//     return Sizer(builder:(context,Orientation,DeviceType){
//         Scaffold(
//        body: Consumer<PracticeTextProvider>(
//          builder: (context,data,child) {
//            return Container(
//             color: _colorfromhex("#FCFCFF"),
//             child: Stack(
//               children: [

//                 Container(
//                   child: Column(
//                     children: [
//                       Container(
//                         height: SizerUtil.deviceType == DeviceType.mobile
//                             ? 195
//                             : 250,
//                         width: width,
//                          decoration: BoxDecoration(
//                           image: DecorationImage(
//                             image: AssetImage("assets/bg_layer2.png"),
//                             fit: BoxFit.cover,
//                           ),
//                         ),

//                         child: Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.start,
                           
                          
//                           children: [


//                              Row(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () => {Navigator.of(context).pop()},
//                                     child: Icon(
//                                       Icons.arrow_back_ios,
//                                       size: width * (24 / 420),
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   Text(
//                                     arguments != null
//                                         ? '  Review'
//                                         : '  Practice Questions',
//                                     style: TextStyle(
//                                         fontFamily: 'Roboto Medium',
//                                         fontSize: width * (18 / 420),
//                                         color: Colors.white,
//                                         letterSpacing: 0.3),
//                                   ),
//                                 ],
//                               ),



//                           ],
//                           )
//                           ),
                        
                        
                        
                        
//                         // )
//                     ],
//                   ),
//                 )


//               ],
//             ),

//            );
//          }
//        ),



//         );
//     });
//   }
// }