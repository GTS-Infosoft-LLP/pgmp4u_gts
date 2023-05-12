import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pgmp4u/Screens/Tests/provider/category_provider.dart';
import 'package:pgmp4u/Screens/Tests/sub_category_screens.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'model/category_model.dart';

class TestsScreen extends StatefulWidget {
  const TestsScreen({Key key}) : super(key: key);

  @override
  _TestsScreenState createState() {
    print("TestsScreen createState");
    return _TestsScreenState();
  }
}

class _TestsScreenState extends State<TestsScreen> {
  Map mapResponse;
  CategoryProvider provider;

  @override
  void initState() {
    provider = Provider.of(context, listen: false);
    getCategory();
    super.initState();
    apiCall();
    // if (selectedIdNew == "result") {
    //   apiCall2();
    // } else {
    //   apiCall();
    // }
  }

  Future apiCall() async {
    print("Build_TestScreen Api Called ${mapResponse}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print(stringValue);
    http.Response response;
    response = await http.get(Uri.parse(CHECK_USER_PAYMENT_STATUS), headers: {
      'Content-Type': 'application/json',
      'Authorization': stringValue
    });

    if (response.statusCode == 200) {
      print(convert.jsonDecode(response.body));
     Future.delayed(Duration(seconds: 0),(){
       setState(() {
        print("response of payymmeenntt   stattusss ${response}");
        mapResponse = convert.jsonDecode(response.body);
      });
     });
      // print(convert.jsonDecode(response.body));
    }
  }

  Future getCategory() async {
    await provider.callGetCategory();
  }

  @override
  Widget build(BuildContext context) {
    print("Build_TestScreen render  ${mapResponse}");
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    Color _colorfromhex(String hexColor) {
      final hexCode = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    }

    print("width => $width ; Height => $height");

    var isPremium = mapResponse != null && mapResponse.containsKey("data")
        ? mapResponse["data"]["paid_status"] == 1
        : false;
    //var isPremium = true;
    //print("mapResponse => $mapResponse; Status => ${mapResponse["data"]["paid_status"] == 1}");

    return Expanded(
      flex: 1,
      child: mapResponse != null
          ? Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: width * (18 / 420), right: width * (18 / 420)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        // Text(
                        //   'Tests4U',
                        //   style: TextStyle(
                        //       fontFamily: 'Roboto Bold',
                        //       fontSize: width * (18 / 420),
                        //       color: Colors.black,
                        //       letterSpacing: 0.3),
                        // ),
                        Consumer<CategoryProvider>(
                          builder: (context, value, child) {
                            print("list length ${value.CategoryList.length}");
                            return value.loader ? 
                            
                              Center(child: 
                                    CircularProgressIndicator()):
                             Container(
                              height: MediaQuery.of(context).size.height,
                              child: ListView.builder(
                                itemCount: value.CategoryList.length,
                                itemBuilder: (context, index) {
                                  return categoryWidget(value.CategoryList[index],isPremium: isPremium);
                              },),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ))
              ],
            )
          : Container(
              width: width,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(_colorfromhex("#4849DF")),
                ),
              )),
    );
  }

  Widget categoryWidget(CategoryListModel data, {isPremium = false}) {
    print("call details");
    Color _colorfromhex(String hexColor) {
      final hexCode = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    }

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    bool isPremiumCategory = data.paymentStatus == 1;
    String img="assets/Vector-3.png";
    print("data is >> ${data.mainCategory}");
    switch(data.type){
        case "Practice Test":
        img="assets/Vector-2.png";
        break;

        case "Mock Test":
        img="assets/Vector-3.png";
        break;


    }

    return GestureDetector(
      onTap: () async {
        if (isPremiumCategory && !isPremium) {
          var result = await Navigator.of(context).pushNamed('/payment');
          print("Result from Payment => $result");
          apiCall();
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => SubCategoryScreen(
            id: data.id,
            type: data.type,
          )));
          // if (isPremium && isPremiumCategory) {
          //     Navigator.of(context).pushNamed('/mock-test');
          // }
        // } else {
        //   var result = await Navigator.of(context)
        //       .pushNamed('/payment');
        //   print("Result from Payment => $result");
        //   apiCall();
        // }
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
              '${data.mainCategory}',
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
