import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pgmp4u/Services/globalcontext.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/get_reminder_model.dart';
import '../Models/mockquestionanswermodel.dart';
import '../Screens/MockTest/model/current_plan_model.dart';
import '../Screens/MockTest/model/pracTestModel.dart';
import '../Screens/MockTest/model/showNotifiModel.dart';
import 'dart:convert' as convert;

import '../Screens/Tests/local_handler/hive_handler.dart';
import 'courseProvider.dart';

class ProfileProvider extends ChangeNotifier {
  SharedPreferences prefs;
  initSharePreferecne() async {
    prefs = await SharedPreferences.getInstance();
  }

  int _pageIndex = 0;
  int _totalRec = 0;
  int totalRecords;
  PlanDetail planDetail;
  int tabIndex = 0;
  setTabIndex(int val) {
    tabIndex = val;
    notifyListeners();
  }

  resetPageIndex() {
    log("this is being called");
    Future.delayed(Duration.zero, () {
      _pageIndex = 0;
      NotificationData = [];
      Notifications = [];
      Announcements = [];

      notifyListeners();
    });
  }

  CourseProvider cp = Provider.of(GlobalVariable.navState.currentContext, listen: false);

  int selectedSubsBox = 0;
  setSelectedContainer(int val) {
    Future.delayed(Duration.zero, () async {
      selectedSubsBox = val;
      print("selectedSubsBox>>>>>>>.$selectedSubsBox");
      notifyListeners();
    });
  }

  List<NotifiModel> NotificationData = [];
  List<NotifiModel> Announcements = [];
  List<NotifiModel> Notifications = [];

  List<Optionss> quesDayOption = [];
  String body;

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

  Future showNotification({bool isFirstTime = false, dynamic crsId, int isFromAnn = 0}) async {
    log("isFromAnn====$isFromAnn");
    crsId.toString();
    print("crsId===1==$crsId");

    // if (crsId != null && crsId.toString().isNotEmpty) {
    //   _totalRec = 1;
    //   // NotificationData = [];
    // }
    CourseProvider cp = Provider.of(GlobalVariable.navState.currentContext, listen: false);
    if (isFirstTime) {
      updateNotificationLoader(true);
    }
    print("crsId===2==$crsId");
    if (!isFirstTime) {
      print("Notifications.length + Announcements.length====${Notifications.length + Announcements.length}");
      print("_totalRec=======$_totalRec");
      print("NotificationData.length ======${NotificationData.length}");
      print("Announcements.length ======${Announcements.length}");
      if (_totalRec == (Notifications.length + Announcements.length)) {
        print(" -- all notification get1 --");
        return;
      }
      if (NotificationData.length >= _totalRec) {
        print(" -- all notification get2 --");
        updateNotificationLoader(false);
        return;
      }
    } else {
      log("is first timee");
      Notifications = [];
      Announcements = [];
      NotificationData = [];
      _pageIndex = 0;
    }

    print("crsId===3==$crsId");
    _pageIndex++;
    CourseProvider crp = Provider.of(GlobalVariable.navState.currentContext, listen: false);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("page index============$_pageIndex");

    print("crsId===4==$crp.selectedCourseId");

    var request = {"page": _pageIndex, "courseId": crsId};
    print("Notification requesttttt======$request");

    try {
      var res = await http.post(
        Uri.parse(NOTIFICATION_LIST),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );
      print("response===$res");
      // print("res.body====${res.body}");
      print("status ciode ===${res.statusCode}");
      if (res.statusCode == 403) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        String stringValue = prefs.getString('token');
        log("string value token===$stringValue");

        Navigator.of(GlobalVariable.navState.currentContext)
            .pushNamedAndRemoveUntil('/start-screen', (Route<dynamic> route) => false);
      }
      if (res.statusCode == 200) {
        Map<String, dynamic> mapResponse = convert.jsonDecode(res.body);
        List temp1 = mapResponse["data"];
        _totalRec = mapResponse["count"];
        totalRecords = _totalRec;
        print("total totalRecords=======$totalRecords");

        print("total rs=======$_totalRec");

        var respList = temp1.map((e) => NotifiModel.fromjson(e)).toList();
        NotificationData = NotificationData + respList;
        print("NotificationData=======${NotificationData.length}");

        if (_totalRec == NotificationData.length) {
          updateLoader(false);
          // EasyLoading.showToast("No more data available");
        }
        if (mapResponse["count"] == 0) {
          updateNotificationLoader(false);
          updateLoader(false);
          EasyLoading.showToast(mapResponse["message"], toastPosition: EasyLoadingToastPosition.bottom);
          return;
        }

        for (int i = 0; i < respList.length; i++) {
          if (respList[i].type == 1) {
            Announcements.add(respList[i]);
          } else {
            Notifications.add(respList[i]);
          }
          notifyListeners();
        }
        print("Notifications======= ${Notifications.length}");
        print("Announcements======= ${Announcements.length}");

        if (((Notifications.length < 10) || (Announcements.length < 10)) ||
            (Notifications.length == 10 && Announcements.length == 10)) {
          print('----- call again ----');
          if (isFromAnn == 1) {
            showNotification(crsId: "", isFromAnn: 1, isFirstTime: false);
          } else {
            showNotification(crsId: cp.selectedCourseId, isFirstTime: false);
          }
        }
      } else {
        Notifications = [];
        Announcements = [];
      }
    } on Exception {
      updateNotificationLoader(false);
    }

    updateNotificationLoader(false);
  }

  Future<void> submitQuesDay(int ques, int typ, String ans) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"question": ques, "type": typ, "answer": ans};
    bool checkConn = await checkInternetConn();
    if (checkConn) {
      body = HiveHandler.getNotSubmittedMock(keyName: cp.notSubmitedMockID);
      if (body == null) {
        body = "";
      }
      if (body.isNotEmpty) {
        Response response = await http
            .post(
          Uri.parse(SUBMIT_MOCK_TEST),
          headers: {"Content-Type": "application/json", 'Authorization': stringValue},
          body: body,
        )
            .whenComplete(() async {
          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
          await cp.getTestDetails(cp.allTestListIdOfline);
          // await apiCall(attempListIdOffline);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/${cp.attempListIdOffline}'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          print("api url==$UPDATE_NOTIFICATION");
          if (response.statusCode == 403) {
            updateLoader(false);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            String stringValue = prefs.getString('token');
            log("string value token===$stringValue");

            Navigator.of(GlobalVariable.navState.currentContext)
                .pushNamedAndRemoveUntil('/start-screen', (Route<dynamic> route) => false);
          }
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), cp.attempListIdOffline.toString());
          }
        });
        if (response.statusCode == 200) {
          HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
          cp.setnotSubmitedMockID("");
          cp.setToBeSubmitIndex(1000);
        }
      }
    }
    var response = await http.post(
      Uri.parse(SUBMIT_QUESTION_OF_THE_DAY),
      headers: {"Content-Type": "application/json", 'Authorization': stringValue},
      body: json.encode(request),
    );

    print("response.statusCode===${response.body}");
    print("response.statusCode===${response.statusCode}");

    var resDDo = json.decode(response.body);
    var resStatus = (resDDo["status"]);
    if (response.statusCode == 403) {
      updateLoader(false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      String stringValue = prefs.getString('token');
      log("string value token===$stringValue");

      Navigator.of(GlobalVariable.navState.currentContext)
          .pushNamedAndRemoveUntil('/start-screen', (Route<dynamic> route) => false);
    }
    if (resStatus == 400) {
      // masterList = [];
      // videoPresent = 0;

      notifyListeners();
      return;
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
      List temp1 = mapResponse["data"];
      print("temp list===$temp1");
      notifyListeners();
    }
    print("respponse=== *********${response.body}");
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

  loaderUpdate(bool status) {
    if (status) {
      EasyLoading.show(status: "Loading", maskType: EasyLoadingMaskType.clear);
    } else {
      print("dismiss loader");
      EasyLoading.dismiss();
    }
  }

  bool loader = false;

  updateLoader(bool status) async {
    loaderUpdate(status);
    loader = status;
    await Future.delayed(Duration(seconds: 0));
    notifyListeners();
  }

  bool getRemiinderApiCall = false;

  updateReminderApiCall(bool val) {
    Future.delayed(Duration.zero, () async {
      getRemiinderApiCall = val;
      notifyListeners();
    });
  }

  CurrentSubscription currentSubsObj;

  var avgScore = "";
  var dayDiff = "";
  var isStudyRemAdded;
  var studyTime = "";

  Future<void> getReminder(int couseId) async {
    updateReminderApiCall(true);
    updateLoader(true);
    print("*--**********getReminder ********************");

    print("couseId=======>>$couseId");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    // print("token valued  get reminderrrr===$stringValue");
    var request = {
      "courseId": couseId,
    };

    bool checkConn = await checkInternetConn();
    // if (checkConn) {
    //   body = HiveHandler.getNotSubmittedMock(keyName: cp.notSubmitedMockID);
    //   if (body == null) {
    //     body = "";
    //   }
    //   if (body.isNotEmpty) {
    //     Response response = await http
    //         .post(
    //       Uri.parse(SUBMIT_MOCK_TEST),
    //       headers: {"Content-Type": "application/json", 'Authorization': stringValue},
    //       body: body,
    //     )
    //         .whenComplete(() async {
    //       HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
    //       HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
    //       await cp.getTestDetails(cp.allTestListIdOfline);
    //       // await apiCall(attempListIdOffline);
    //       Response response = await http.get(Uri.parse(MOCK_TEST + '/${cp.attempListIdOffline}'),
    //           headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
    //       Map getit;
    //       if (response.statusCode == 200) {
    //         getit = convert.jsonDecode(response.body);
    //         print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
    //         await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), cp.attempListIdOffline.toString());
    //       }
    //     });
    //     if (response.statusCode == 200) {
    //       HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
    //       HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
    //       cp.setnotSubmitedMockID("");
    //       cp.setToBeSubmitIndex(1000);
    //     }
    //   }
    // }
    print("start get reminder api--------$request");
    try {
      var response = await http.post(
        Uri.parse(GET_REMINDER),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );
      avgScore = "";
      dayDiff = "";

      print("resposse data---${response.body}");
      dev.log("response.statusCode getreminder-----${response.statusCode}");
      if (response.statusCode == 403) {
        updateLoader(false);
        updateReminderApiCall(false);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        String stringValue = prefs.getString('token');
        log("string value token===$stringValue");

        Navigator.of(GlobalVariable.navState.currentContext)
            .pushNamedAndRemoveUntil('/start-screen', (Route<dynamic> route) => false);
      }
      if (response.statusCode == 200) {
        updateReminderApiCall(false);
        studyTime = "";
        isStudyRemAdded = 0;
        print("response.statusCode getreminder===${response.statusCode}");
        var resDDo = json.decode(response.body);
        print("resDDo body----${resDDo['data']}");
        dev.log("resDDo['data']['currentSubscription']--${resDDo['data']['currentSubscription']}");
        currentSubsObj = CurrentSubscription.fromJson(resDDo['data']['currentSubscription']);
        HiveHandler.addTogetReminderBox(couseId.toString(), currentSubsObj);
        print("");
        print("resDDo getreminder====$resDDo");
        updateLoader(false);
        var remTime = resDDo['data']['studyReminder'];
        avgScore = resDDo['data']['daysDiff'].toString();
        dayDiff = resDDo['data']['averageScore'].toString();
        planDetail = PlanDetail.fromJson(resDDo['data']['currentSubscription']);
        print("_plandetailll>.${planDetail.title}");
        if (resDDo['data']['studyReminder'] == null) {
          remTime = "";
        }
        print("remTime======$remTime");
        if (remTime.isNotEmpty) {
          print("study time==${remTime.split(" ")[1]}");
          studyTime = remTime.split(" ")[1];
        }

        notiValue = resDDo['data']['notification'];
        print("notiValue*****=====>>>$notiValue");

        isStudyRemAdded = resDDo['data']['isStudyReminderAdded'];
        notifyListeners();
      } else {
        updateReminderApiCall(false);
        updateLoader(false);
      }
    } catch (e) {
      updateReminderApiCall(false);
      updateLoader(false);
      // TODO
      print("---- EXCEPTION OCCURED WHILE getReminder----");
      print(e.toString());
    }
  }

  Future<void> setReminder(String studyReminder, String examDate, int couseId, int type) async {
    updateLoader(true);
    print("studyReminder=======>>$studyReminder");
    print("examDate=======>>$examDate");
    print("couseId=======>>$couseId");
    print("type=======>>$type");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {
      "courseId": couseId,
      "type": type,
      "studyReminder": studyReminder,
      "examDate": examDate,
      "offset": DateTime.now().timeZoneOffset.inMilliseconds
    };
    bool checkConn = await checkInternetConn();
    if (checkConn) {
      body = HiveHandler.getNotSubmittedMock(keyName: cp.notSubmitedMockID);
      if (body == null) {
        body = "";
      }
      if (body.isNotEmpty) {
        Response response = await http
            .post(
          Uri.parse(SUBMIT_MOCK_TEST),
          headers: {"Content-Type": "application/json", 'Authorization': stringValue},
          body: body,
        )
            .whenComplete(() async {
          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
          await cp.getTestDetails(cp.allTestListIdOfline);
          // await apiCall(attempListIdOffline);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/${cp.attempListIdOffline}'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          print("api url==$UPDATE_NOTIFICATION");
          if (response.statusCode == 403) {
            updateLoader(false);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            String stringValue = prefs.getString('token');
            log("string value token===$stringValue");

            Navigator.of(GlobalVariable.navState.currentContext)
                .pushNamedAndRemoveUntil('/start-screen', (Route<dynamic> route) => false);
          }
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), cp.attempListIdOffline.toString());
          }
        });
        if (response.statusCode == 200) {
          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
          cp.setnotSubmitedMockID("");
          cp.setToBeSubmitIndex(1000);
        }
      }
    }
    try {
      print("requesttt>>>>>>$request");
      var response = await http.post(
        Uri.parse(SET_REMINDER),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );
      if (response.statusCode == 403) {
        updateLoader(false);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        String stringValue = prefs.getString('token');
        log("string value token===$stringValue");

        Navigator.of(GlobalVariable.navState.currentContext)
            .pushNamedAndRemoveUntil('/start-screen', (Route<dynamic> route) => false);
      }
      if (response.statusCode == 200) {
        print("response.statusCode===${response.statusCode}");
        var resDDo = json.decode(response.body);
        updateLoader(false);
        var resStatus = (resDDo["status"]);
      } else {
        updateLoader(false);
      }
    } catch (e) {
      updateLoader(false);
      // TODO
      print("---- EXCEPTION OCCURED WHILE setReminder ----");
      print(e.toString());
    }
  }

  Future<void> subscriptionStatus(String type, {int id}) async {
    successValue = true;
    updateSubApi(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"type": type, "courseId": id};
    print("request::::::$request");
    bool checkConn = await checkInternetConn();
    if (checkConn) {
      body = HiveHandler.getNotSubmittedMock(keyName: cp.notSubmitedMockID);
      if (body == null) {
        body = "";
      }
      if (body.isNotEmpty) {
        Response response = await http
            .post(
          Uri.parse(SUBMIT_MOCK_TEST),
          headers: {"Content-Type": "application/json", 'Authorization': stringValue},
          body: body,
        )
            .whenComplete(() async {
          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
          await cp.getTestDetails(cp.allTestListIdOfline);
          // await apiCall(attempListIdOffline);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/${cp.attempListIdOffline}'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          print("api url==$UPDATE_NOTIFICATION");
          if (response.statusCode == 403) {
            updateLoader(false);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            String stringValue = prefs.getString('token');
            log("string value token===$stringValue");

            Navigator.of(GlobalVariable.navState.currentContext)
                .pushNamedAndRemoveUntil('/start-screen', (Route<dynamic> route) => false);
          }
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), cp.attempListIdOffline.toString());
          }
        });
        if (response.statusCode == 200) {
          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
          cp.setnotSubmitedMockID("");
          cp.setToBeSubmitIndex(1000);
        }
      }
    }
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

      print("respponse===*/*/*/*/ ${response.body}");
      print("respponse  statusCode===*/*/*/*/ ${response.statusCode}");

      if (response.statusCode == 403) {
        updateLoader(false);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        String stringValue = prefs.getString('token');
        log("string value token===$stringValue");

        Navigator.of(GlobalVariable.navState.currentContext)
            .pushNamedAndRemoveUntil('/start-screen', (Route<dynamic> route) => false);
      }

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
    bool checkConn = await checkInternetConn();
    if (checkConn) {
      body = HiveHandler.getNotSubmittedMock(keyName: cp.notSubmitedMockID);
      if (body == null) {
        body = "";
      }
      if (body.isNotEmpty) {
        Response response = await http
            .post(
          Uri.parse(SUBMIT_MOCK_TEST),
          headers: {"Content-Type": "application/json", 'Authorization': stringValue},
          body: body,
        )
            .whenComplete(() async {
          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
          await cp.getTestDetails(cp.allTestListIdOfline);
          // await apiCall(attempListIdOffline);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/${cp.attempListIdOffline}'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          print("api url==$UPDATE_NOTIFICATION");
          if (response.statusCode == 403) {
            updateLoader(false);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            String stringValue = prefs.getString('token');
            log("string value token===$stringValue");

            Navigator.of(GlobalVariable.navState.currentContext)
                .pushNamedAndRemoveUntil('/start-screen', (Route<dynamic> route) => false);
          }
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), cp.attempListIdOffline.toString());
          }
        });
        if (response.statusCode == 200) {
          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
          cp.setnotSubmitedMockID("");
          cp.setToBeSubmitIndex(1000);
        }
      }
    }
    http.Response response;
    var createOrder = CREATE_ORDER + "/";
    response = await http.get(Uri.parse("$createOrder$selectedId/$categoryType"),
        headers: {'Content-Type': 'application/json', 'Authorization': stringValue});

    print("Url :=> ${Uri.parse("$createOrder$selectedId/$categoryType")}");

    dev.log("API Response MOCK_TEST ; $stringValue => ${response.request.url}; ${response.body}");
    print("API Response ; $stringValue => ${response.request.url}; ${response.body}");
    if (response.statusCode == 403) {
      updateLoader(false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      String stringValue = prefs.getString('token');
      log("string value token===$stringValue");

      Navigator.of(GlobalVariable.navState.currentContext)
          .pushNamedAndRemoveUntil('/start-screen', (Route<dynamic> route) => false);
    }
    if (response.statusCode == 200) {
      // print(convert.jsonDecode(response.body));

      notifyListeners();
    }
  }

  int notiValue;
  Future<void> updateNotification() async {
    updateLoader(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print("token valued===$stringValue");

    bool checkConn = await checkInternetConn();
    if (checkConn) {
      body = HiveHandler.getNotSubmittedMock(keyName: cp.notSubmitedMockID);
      if (body == null) {
        body = "";
      }
      if (body.isNotEmpty) {
        Response response = await http
            .post(
          Uri.parse(SUBMIT_MOCK_TEST),
          headers: {"Content-Type": "application/json", 'Authorization': stringValue},
          body: body,
        )
            .whenComplete(() async {
          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
          await cp.getTestDetails(cp.allTestListIdOfline);
          // await apiCall(attempListIdOffline);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/${cp.attempListIdOffline}'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;

          print("api url==$UPDATE_NOTIFICATION");
          if (response.statusCode == 403) {
            updateLoader(false);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            String stringValue = prefs.getString('token');
            log("string value token===$stringValue");

            Navigator.of(GlobalVariable.navState.currentContext)
                .pushNamedAndRemoveUntil('/start-screen', (Route<dynamic> route) => false);
          }
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), cp.attempListIdOffline.toString());
          }
        });
        if (response.statusCode == 200) {
          HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
          cp.setnotSubmitedMockID("");
          cp.setToBeSubmitIndex(1000);
        }
      }
    }
    try {
      var response = await http.get(
        Uri.parse(UPDATE_NOTIFICATION),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
      );
      print("api url==$UPDATE_NOTIFICATION");
      if (response.statusCode == 403) {
        updateLoader(false);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        String stringValue = prefs.getString('token');
        log("string value token===$stringValue");

        Navigator.of(GlobalVariable.navState.currentContext)
            .pushNamedAndRemoveUntil('/start-screen', (Route<dynamic> route) => false);
      }
      if (response.statusCode == 200) {
        print("response==UPDATE_NOTIFICATION=>>${response.body}");
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);

        updateLoader(false);
      } else {
        updateLoader(false);
      }
    } catch (e) {
      updateLoader(false);
      print("errrorororr====$e");
    }
  }

  Future<void> deleteAccount() async {
    updateLoader(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print("token valued===$stringValue");
    bool checkConn = await checkInternetConn();
    if (checkConn) {
      body = HiveHandler.getNotSubmittedMock(keyName: cp.notSubmitedMockID);
      if (body == null) {
        body = "";
      }
      if (body.isNotEmpty) {
        Response response = await http
            .post(
          Uri.parse(SUBMIT_MOCK_TEST),
          headers: {"Content-Type": "application/json", 'Authorization': stringValue},
          body: body,
        )
            .whenComplete(() async {
          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
          await cp.getTestDetails(cp.allTestListIdOfline);
          // await apiCall(attempListIdOffline);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/${cp.attempListIdOffline}'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          print("api url==$UPDATE_NOTIFICATION");
          if (response.statusCode == 403) {
            updateLoader(false);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            String stringValue = prefs.getString('token');
            log("string value token===$stringValue");

            Navigator.of(GlobalVariable.navState.currentContext)
                .pushNamedAndRemoveUntil('/start-screen', (Route<dynamic> route) => false);
          }
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), cp.attempListIdOffline.toString());
          }
        });
        if (response.statusCode == 200) {
          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
          cp.setnotSubmitedMockID("");
          cp.setToBeSubmitIndex(1000);
        }
      }
    }
    try {
      var response = await http.get(
        Uri.parse(DELETE_ACCOUNT),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
      );
      if (response.statusCode == 403) {
        updateLoader(false);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        String stringValue = prefs.getString('token');
        log("string value token===$stringValue");

        Navigator.of(GlobalVariable.navState.currentContext)
            .pushNamedAndRemoveUntil('/start-screen', (Route<dynamic> route) => false);
      }
      if (response.statusCode == 200) {
        EasyLoading.showSuccess("Account Deleted Successfully");
        updateLoader(false);
        //  HiveHandler.clearUser();
        await prefs.clear();

        Navigator.of(GlobalVariable.navState.currentContext)
            .pushNamedAndRemoveUntil('/start-screen', (Route<dynamic> route) => false);
      } else {
        updateLoader(false);
        EasyLoading.showToast("Something went wrong...");
      }
    } catch (e) {
      updateLoader(false);
      print("errrorororr====$e");
    }
  }

  Future checkInternetConn() async {
    bool result = await InternetConnectionChecker().hasConnection;
    print("result while call fun $result");
    if (result == false) {
      Future.delayed(Duration(seconds: 1), () async {
        //  await EasyLoading.showToast("Internet Not Connected",toastPosition: EasyLoadingToastPosition.bottom);
      });
      return result;
    } else {}
    return result;
  }
}
