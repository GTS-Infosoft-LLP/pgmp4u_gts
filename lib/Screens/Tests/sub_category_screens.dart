import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pgmp4u/Screens/Tests/provider/category_provider.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'model/category_model.dart';
import 'model/sub_category_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pgmp4u/Screens/Profile/paymentScreen.dart';
import 'package:pgmp4u/Screens/Tests/testsScreen.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/utils/appimage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

class SubCategoryScreen extends StatefulWidget {
  int id;
  String type;

  SubCategoryScreen({
    this.id,
    this.type
  });

  @override
  _SubCategoryScreenState createState() =>
      _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
   CategoryProvider provider;
  Color _colorfromhex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

String photoUrl;
  String displayName;
 

  getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('photo');

    print(stringValue);
    setState(() {
      photoUrl = stringValue;
      displayName = prefs.getString('name');
    });
  }

  @override
  void initState() {
    super.initState();
    provider = Provider.of(context, listen: false);
    getCategory();
    getValue();


  }

   Future getCategory() async {
    await provider.callGetSubCateogory(id: widget.id, type: widget.type);
  }
 

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    print(MediaQuery.of(context).padding.top);
    return Scaffold(
      
      body:Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: _colorfromhex("#F7F7FA"),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: SizerUtil.deviceType == DeviceType.mobile ? 180 : 330,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(40.0)),
                      gradient: LinearGradient(
                          colors: [
                            _colorfromhex('#3846A9'),
                            _colorfromhex('#5265F8')
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: width * (20 / 420),
                              right: width * (20 / 420),
                              top: height * (16 / 800)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /* Icon(
                            Icons.menu,
                            size: width * (24 / 420),
                            color: Colors.white,
                          ),
                          Row(
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.only(right: width * (16 / 420)),
                                child: Icon(
                                  Icons.search,
                                  size: width * (24 / 420),
                                  color: Colors.white,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => {},
                                child: Icon(
                                  Icons.notifications,
                                  size: width * (24 / 420),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),*/
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: height * (30 / 800),
                              left: width * (28 / 420),
                              right: width * (34 / 420)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 7),
                                    child: Row(
                                      children: [
                                       InkWell(
                                         onTap: (){Navigator.pop(context);},
                                       child: Icon(Icons.arrow_back_ios,color: Colors.white,)),
                                        Text(
                                          'Hello, ',
                                          style: TextStyle(
                                            fontFamily: 'Roboto Regular',
                                            fontSize: width * (16 / 420),
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          displayName != null ? displayName : '',
                                          style: TextStyle(
                                            fontFamily: 'Roboto Bold',
                                            fontSize: width * (16 / 420),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Find a test you',
                                        style: TextStyle(
                                          fontFamily: 'Roboto Bold',
                                          fontSize: width * (20 / 420),
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'want to learn',
                                        style: TextStyle(
                                          fontFamily: 'Roboto Bold',
                                          fontSize: width * (20 / 420),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              photoUrl != null && photoUrl != ""
                                  ? Container(
                                      width: width * (80 / 420),
                                      height: width * (80 / 420),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(photoUrl),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(80),
                                      ),
                                    )
                                  : Container(
                                      width: width * (80 / 420),
                                      height: width * (80 / 420),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(80),
                                      ),
                                    )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  
                   Expanded(
                     child: Consumer<CategoryProvider>(
                        builder: (context, value, child) {
                          print("list length  is ${value.subCategoryList}");
                          return value.subCategoryLoader
                              ? Container(
                                
                                margin: EdgeInsets.only(top: 50)
                                ,child: Center(child: CircularProgressIndicator()))
                              : Container(
                                  height: MediaQuery.of(context).size.height,
                                  child: value.subCategoryList.isNotEmpty ? ListView.builder(
                                    itemCount: value.subCategoryList.length,
                                    itemBuilder: (context, index) {
                                      return categoryWidget(
                                          value.subCategoryList[index],
                                          isPremium: true);
                                    },
                                  ):Center(
                                    child: Text("No Data Found"),
                                  ),
                                );
                     
                        },
                      ),
                   )
                  
                
              
                  
              
                  
                ],
              ),
            )
          
          
      // WillPopScope(
        //  onWillPop: _onWillPop,
          //child:
           
          //)
          );
          
    
  }


  Widget categoryWidget(SubCategoryListModel data, {isPremium = false}) {
    Color _colorfromhex(String hexColor) {
      final hexCode = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    }

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
      
    String img = "assets/Vector-3.png";
   

    return GestureDetector(
      onTap: () async {
        switch(widget.type){
          case 'Practice Test':
          Navigator.of(context).pushNamed('/practice-test');
          break;
          case 'Mock Test':
          Navigator.of(context).pushNamed('/mock-test');
          break;
        }
       
      },
      child: Container(
        margin: EdgeInsets.only(
            top: height * (22 / 800), bottom: height * (32 / 800)),
        width: width,
        padding: EdgeInsets.only(top: height * (25 / 800)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: height * (12 / 800)),
              padding: EdgeInsets.all(width * (14 / 420)),
              decoration: BoxDecoration(
                color: _colorfromhex("#463B97"),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.asset('$img'),
            ),
            Text(
              '',
              style: TextStyle(
                  fontFamily: 'Roboto Medium',
                  fontSize: width * (12 / 420),
                  color: _colorfromhex("#ABAFD1"),
                  letterSpacing: 0.3),
            ),
            Container(
              height: height * (2 / 800),
            ),
            Text(
              '${data.testName}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Roboto Medium',
                  fontSize: width * (22 / 420),
                  color: Colors.black,
                  letterSpacing: 0.3),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                isPremium
                    ? SizedBox()
                    : Expanded(
                        flex: 1,
                        child: Text(
                          "Premium",
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                          textAlign: TextAlign.end,
                        ),
                      ),
                SizedBox(
                  width: 18,
                )
              ],
            ),
            SizedBox(
              height: 18,
            )
          ],
        ),
      ),
    );
  }
}

