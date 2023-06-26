import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/mockquestionanswermodel.dart';
import '../Screens/MockTest/model/showNotifiModel.dart';
import 'dart:convert' as convert;

class ProfileProvider extends ChangeNotifier {
  int _pageIndex = 0;
  int _totalRec = 0;
  List<NotifiModel> NotificationData = [];

  List<Optionss> quesDayOption = [];

  String quesDayQues;
  int quesDayId;

 int selectedNotifiId;

  setNotifiId(int val){
selectedNotifiId=val;
print("selectedNotifiId=====${selectedNotifiId}");
notifyListeners();
  }

//QuestionDetail

  Future showNotification({bool isFirstTime = false}) async {
    if (!isFirstTime) {
      if (NotificationData.length >= _totalRec) {
        return;
      }
    } else {
      _pageIndex = 0;
      _totalRec = 0;
      NotificationData.clear();
    }
    _pageIndex++;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print("page index============$_pageIndex");
    var request = {"page": _pageIndex};
    var res = await http.post(
      Uri.parse(
          "https://apivcarestage.vcareprojectmanagement.com/api/notificationList"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': stringValue
      },
      body: json.encode(request),
    );
    print("response===$res");
    // print("${res.body.}");

    if (res.statusCode == 200) {
      Map<String, dynamic> mapResponse = convert.jsonDecode(res.body);
      List temp1 = mapResponse["data"];

      _totalRec = mapResponse["count"];
      print("total rs=======$_totalRec");
      print("temp 1 list before set to main list===$temp1");

      var respList = temp1.map((e) => NotifiModel.fromjson(e)).toList();
      print("notifiaction response list========>$respList");
      NotificationData = NotificationData + respList;
      print("************************************************************");
      print("notifiaction list========>$NotificationData");
      print("notifiaction list========>${NotificationData.length}");

      notifyListeners();
    }
  }

  Future<void> submitQuesDay(int ques, int typ, String ans) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"question": ques, "type": typ, "answer": ans};

    var response = await http.post(
      Uri.parse(
          "https://apivcarestage.vcareprojectmanagement.com/api/submitQuestionOfTheDay"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': stringValue
      },
      body: json.encode(request),
    );

    print("response.statusCode===${response.body}");
    print("response.statusCode===${response.statusCode}");

    var resDDo = json.decode(response.body);
    var resStatus = (resDDo["status"]);

    if (resStatus == 400) {
      // masterList = [];
      // videoPresent = 0;

      notifyListeners();
      return;
    }

    // print("val of vid present===$videoPresent");

    if (response.statusCode == 200) {
      // masterList.clear();
      Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);

      List temp1 = mapResponse["data"];
      print("temp list===$temp1");
      // masterList = temp1.map((e) => MasterDetails.fromjson(e)).toList();

      notifyListeners();
    }
    print("respponse=== ${response.body}");
  }

  Future<void> getQuesDay(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": 17532};

    var response = await http.post(
      Uri.parse(
          "https://apivcarestage.vcareprojectmanagement.com/api/getQuestionOfTheDay"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': stringValue
      },
      body: json.encode(request),
    );

    print("response.statusCode===${response.body}");
    print("response.statusCode===${response.statusCode}");

    var resDDo = json.decode(response.body);
    var resStatus = (resDDo["status"]);

    if (resStatus == 400) {
      // masterList = [];
      // videoPresent = 0;

      notifyListeners();
      return;
    }

    // print("val of vid present===$videoPresent");

    if (response.statusCode == 200) {
      // masterList.clear();
      Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
      List temp = mapResponse["data"]["Options"];
      print("map response question====${mapResponse["data"]["question"]}");
      // print("map response option list====${mapResponse["data"]["Options"]}");

      print("temp liist==============>$temp");

      quesDayQues = mapResponse["data"]["question"];
      quesDayOption = temp.map((e) => Optionss.fromjsons(e)).toList();

      print("ques options list======${quesDayOption[0].question_option}");
      print("length of option list======${quesDayOption.length}");

      // quesDayOption
      // List temp1 = mapResponse["data"];
      // print("temp list===$temp1");
      // masterList = temp1.map((e) => MasterDetails.fromjson(e)).toList();

      notifyListeners();
    }
    print("respponse=== ${response.body}");
  }
}
