import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pgmp4u/api/apis.dart';
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
  bool notificationLoader = false;

  updateNotificationLoader(bool value) {
    Future.delayed(Duration.zero, () async {
      notificationLoader = value;
      notifyListeners();
    });
  }

  Future showNotification({bool isFirstTime = false}) async {
    if (isFirstTime) {
      updateNotificationLoader(true);
    }

    if (!isFirstTime) {
      if (NotificationData.length >= _totalRec) {
        updateNotificationLoader(false);
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

    try {
      var res = await http.post(
        Uri.parse(NOTIFICATION_LIST),
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
          // print("************************************************************");
          print("notifiaction list qId========>${NotificationData[i].questionId}");
        }
      }
    } on Exception {
      // TODO
      updateNotificationLoader(false);
    }

    updateNotificationLoader(false);
  }

  Future<void> submitQuesDay(int ques, int typ, String ans) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"question": ques, "type": typ, "answer": ans};

    var response = await http.post(
      Uri.parse(SUBMIT_QUESTION_OF_THE_DAY),
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

  bool isChatSubscribed = false;
  bool subscriptionApiCalling = false;
  updateSubApi(bool v) {
    subscriptionApiCalling = v;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  var avgScore = "";
  var dayDiff = "";

  Future<void> getReminder(int couseId) async {
    print("*--**********getReminder ********************");

    print("couseId=======>>$couseId");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued  get reminderrrr===$stringValue");
    var request = {
      "courseId": couseId,
    };

    try {
      var response = await http.post(
        Uri.parse(GET_REMINDER),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );
      avgScore = "";
      dayDiff = "";
      // print("response.statusCode===${response.body}");
      print("response.statusCode===${response.statusCode}");
      var resDDo = json.decode(response.body);
      print("respponse=== $resDDo");
      print("resDDo=====${resDDo['data']['daysDiff']}");
      print("resDDo=====${resDDo['data']['averageScore']}");
      avgScore = resDDo['data']['daysDiff'].toString();
      dayDiff = resDDo['data']['averageScore'].toString();
      notifyListeners();
    } catch (e) {
      // TODO
      print("---- EXCEPTION OCCURED WHILE CHECKING FOR CHATSUBSCRIPTION ----");
      print(e.toString());
    }
  }

  Future<void> setReminder(String studyReminder, String examDate, int couseId, int type) async {
    print("studyReminder=======>>$studyReminder");
    print("examDate=======>>$examDate");
    print("couseId=======>>$couseId");
    print("type=======>>$type");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"courseId": couseId, "type": type, "studyReminder": studyReminder, "examDate": examDate};

    try {
      var response = await http.post(
        Uri.parse(SET_REMINDER),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      // print("response.statusCode===${response.body}");
      print("response.statusCode===${response.statusCode}");

      var resDDo = json.decode(response.body);
      var resStatus = (resDDo["status"]);

      print("respponse=== ${response.body}");
    } catch (e) {
      // TODO
      print("---- EXCEPTION OCCURED WHILE CHECKING FOR CHATSUBSCRIPTION ----");
      print(e.toString());
    }
  }

  Future<void> subscriptionStatus(String type) async {
    successValue=true;
    updateSubApi(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"type": type};

    try {
      var response = await http
          .post(
        Uri.parse(GET_SUBSCRIPTION_STATUS),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      )
          .timeout(Duration(seconds: 5), onTimeout: () {
        updateSubApi(false);
      });

      // print("response.statusCode===${response.body}");
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
    } catch (e) {
      // TODO
      print("---- EXCEPTION OCCURED WHILE CHECKING FOR CHATSUBSCRIPTION ----");
      print(e.toString());
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
    var createOrder = CREATE_ORDER + "/";
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
