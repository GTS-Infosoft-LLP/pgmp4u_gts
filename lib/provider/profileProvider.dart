import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/mockquestionanswermodel.dart';
import '../Screens/MockTest/model/pracTestModel.dart';
import '../Screens/MockTest/model/showNotifiModel.dart';
import 'dart:convert' as convert;

class ProfileProvider extends ChangeNotifier {
  int _pageIndex = 0;
  int _totalRec = 0;
  List<NotifiModel> NotificationData = [];

  List<Optionss> quesDayOption = [];

  List<PracTestModel> QuesDayList = [];

  String quesDayQues;
  int quesDayId;

  int selectedNotifiId;

  setNotifiId(int val) {
    selectedNotifiId = val;
    print("selectedNotifiId=====$selectedNotifiId");
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
      Uri.parse("https://apivcarestage.vcareprojectmanagement.com/api/notificationList"),
      headers: {"Content-Type": "application/json", 'Authorization': stringValue},
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

      // print("notifiaction list========>$NotificationData");
      // print("notifiaction list========>${NotificationData.length}");

      for (int i = 0; i < NotificationData.length; i++) {
        print("************************************************************");
        print("notifiaction list qId========>${NotificationData[i].questionId}");
      }
      notifyListeners();
    }
  }

  Future<void> submitQuesDay(int ques, int typ, String ans) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"question": ques, "type": typ, "answer": ans};

    var response = await http.post(
      Uri.parse("https://apivcarestage.vcareprojectmanagement.com/api/submitQuestionOfTheDay"),
      headers: {"Content-Type": "application/json", 'Authorization': stringValue},
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

  var successValue;
  var Subsmsg;
  var subsPrice;

  bool isChatSubscribed;
  bool subscriptionApiCalling = false;
  updateSubApi(bool v) {
    subscriptionApiCalling = v;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  Future<void> subscriptionStatus(String type) async {
    updateSubApi(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"type": type};

    var response = await http.post(
      Uri.parse("https://apivcarestage.vcareprojectmanagement.com/api/getsubscriptionStatus"),
      headers: {"Content-Type": "application/json", 'Authorization': stringValue},
      body: json.encode(request),
    );
    print("https://apivcarestage.vcareprojectmanagement.com/api/getsubscriptionStatus");

    print("response.statusCode===${response.body}");
    print("response.statusCode===${response.statusCode}");

    var resDDo = json.decode(response.body);
    var resStatus = (resDDo["status"]);

    print("respponse=== ${response.body}");
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
      print("mapResponse==========$mapResponse");

      successValue = mapResponse["success"];

      print("successValue============$successValue");

      Map<String, dynamic> temp1 = mapResponse["data"];

      subsPrice = mapResponse["data"]["price"];
      print("priveeeee=====$subsPrice");
      print("temp list===$temp1");
      // masterList = temp1.map((e) => MasterDetails.fromjson(e)).toList();

      print('isChatSubscribed condition ${mapResponse["success"]}');
      if (mapResponse["success"] == true) {
        isChatSubscribed = true;
      } else {
        isChatSubscribed = false;
      }
      updateSubApi(false);

      return;
    }
    if (resStatus == 400) {
      isChatSubscribed = false;
      updateSubApi(false);

      return;
    } else {
      isChatSubscribed = false;
      updateSubApi(false);
    }
  }

  Future callCreateOrder(int selectedId, String categoryType) async {
    print("selectedId===================$selectedId");
    print("categoryType===============$categoryType");
    categoryType = categoryType.replaceAll(" ", "");
    print("categoryType==============$categoryType");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    http.Response response;
    var createOrder = "https://apivcarestage.vcareprojectmanagement.com/api/createOrder/";
    response = await http.get(Uri.parse("$createOrder$selectedId/$categoryType"),
        headers: {'Content-Type': 'application/json', 'Authorization': stringValue});

    print("Url :=> ${Uri.parse("$createOrder$selectedId/$categoryType")}");

    log("API Response MOCK_TEST ; $stringValue => ${response.request.url}; ${response.body}");
    print("API Response ; $stringValue => ${response.request.url}; ${response.body}");

    if (response.statusCode == 200) {
      // print(convert.jsonDecode(response.body));

      notifyListeners();
    }
  }
}
