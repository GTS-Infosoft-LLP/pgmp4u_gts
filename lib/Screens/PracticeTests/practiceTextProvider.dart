import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/PracticeTests/practice_test_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../MockTest/model/pracTestModel.dart';

class PracticeTextProvider extends ChangeNotifier {
  bool practiceApiLoader = false;
  PracitceTextResponseModelList pracitceTextResponseModel;
  List<PracitceTextResponseModel> questionsList = [];

  List<PracitceTextResponseModelList> pracQuesList = [];

  List<PracTestModel> pList = [];

  updateLoader(bool val) {
    practiceApiLoader = val;
  }

  Future apiCall(int id, String type) async {
    updateLoader(true);
    Map body = {"id": id, "type": type};
    // print("body of pratice $body");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print("stringValue  $stringValue");
    // http.Response response;
    // response = await http.post(Uri.parse(getSubCategoryDetails),
    var response = await http.get(
      Uri.parse(
          "https://apivcarestage.vcareprojectmanagement.com/api/MockTestQuestions/124"),

      headers: {
        'Content-Type': 'application/json',
        'Authorization': stringValue
      },
      // body: convert.jsonEncode(body)
    );

    print(
        "calling this api========>>>.https://apivcarestage.vcareprojectmanagement.com/api/MockTestQuestions/124");
    // print("body=========>$body");

    if (response.statusCode == 200) {
      print(convert.jsonDecode(response.body));
      var _mapResponse = convert.jsonDecode(response.body);

      print("map respoanse========$_mapResponse");
      print("map resposne datat=====>>>${_mapResponse["data"]}");

      List temp = _mapResponse["data"];

      pList = temp.map((e) => PracTestModel.fromJson(e)).toList();
      practiceApiLoader = false;
      print("pList=============$pList");

      if (pList.isNotEmpty) {
        print("pList[0]============${pList[0].ques.options[1].questionOption}");
      }

      // if()

      // pracQuesList =
      //     temp.map((e) => PracitceTextResponseModelList.fromJson(e)).toList();

      // print("pracQuesList==================================$pracQuesList");

      // pracitceTextResponseModel =
      //     PracitceTextResponseModelList.fromJson(_mapResponse["data"]);

      // updateLoader(false);

      // questionsList = pracitceTextResponseModel.list;

      notifyListeners();
      // print(convert.jsonDecode(response.body));
    }
  }
}
