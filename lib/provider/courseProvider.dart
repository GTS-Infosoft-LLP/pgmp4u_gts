import 'dart:convert';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pgmp4u/Screens/Tests/local_handler/hive_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Models/mockListmodel.dart';
import '../Models/mockquestionanswermodel.dart';
import '../Models/pptCateModel.dart';
import '../Models/pptDetailsModel.dart';
import '../Models/restartModel.dart';
import '../Screens/MockTest/model/courseModel.dart';
import '../Screens/MockTest/model/flashCardModel.dart';
import '../Screens/MockTest/model/flashCateModel.dart';
import '../Screens/MockTest/model/masterdataModel.dart';
import '../Screens/MockTest/model/testDataModel.dart';
import '../Screens/MockTest/model/testDetails.dart';
import '../Screens/MockTest/model/videoCateModel.dart';
import '../Screens/MockTest/model/videoModel.dart';
import '../api/apis.dart';

class CourseProvider extends ChangeNotifier {
  SharedPreferences prefs;

  initSharePreferecne() async {
    prefs = await SharedPreferences.getInstance();
  }

  List<MasterDetails> masterList = [];
  List<CourseDetails> course = [];

  List<CourseDetails> mockCrsDropList = [];
  List<CourseDetails> crsDropList = [];
  List<CourseDetails> cancelSubsList = [];
  List<CourseDetails> chatCrsDropList = [];
  List<String> crsLable = [];
  List<VideoCateDetails> videoCate = [];
  List<VideoDetails> Videos = [];
  List<FlashCateDetails> flashCate = [];
  List<FlashCardDetails> FlashCards = [];

  List<FlashCardDetails> FlashOfflineList = [];
//TestDataDetails
  List<TestDetails> testDetails = [];
  List<TestDataDetails> testData = [];

  List<AvailableAttempts> aviAttempts = [];

  List<PPTCateDetails> pptCategoryList = [];
  List<PPTDataDetails> pptDataList = [];

  List<RestartModel> restartDataList = [];

  setToRestartList(String display, int attempptNum, int quesNum) {
    restartDataList.add(RestartModel(displayTime: display, quesNum: quesNum, restartAttempNum: attempptNum));
  }

  int firstCourse = 0;
  int firstMaster = 0;
  int firstFlashCate = 0;
  int firstFlshData = 0;

  ///

  int videoPresent = 1;

  int selectedCourseId;
  int selectedMasterId;

  int selectedFlashCategory;
  String selectedCourseName;
  String selectedCourseLable;

  String notiSelectCrsLable;

  String notSubmitedMockID;

  int isInAppPurchaseOn;
  void setInAppPurchaseValue(int val) {
    Future.delayed(Duration.zero, () {
      isInAppPurchaseOn = val;
      notifyListeners();
    });
  }

  List<String> pendingMocksId = [];
  addToPendingMockList(String id) {
    if (pendingMocksId.contains(id)) {
    } else {
      pendingMocksId.add(id);
    }
    notifyListeners();
  }

  removeFromPendingMockList(String id) {
    if (pendingMocksId.contains(id)) {
      pendingMocksId.remove(id);
    }

    notifyListeners();
  }

  void setnotSubmitedMockID(String val) {
    Future.delayed(Duration.zero, () {
      notSubmitedMockID = val;
      notifyListeners();
    });
  }

  String selectedCancelSubsLable;

  String selectedTimeSubs;
  void setSelectedSubsTime(String val) {
    Future.delayed(Duration.zero, () {
      selectedTimeSubs = val;
      notifyListeners();
    });
  }

  List<String> subsTime = ["1 Month", "3 Months", "6 Months", "1 Year"];

  setSelectedCancelSubsCrsLable(String val) {
    Future.delayed(Duration.zero, () {
      selectedCancelSubsLable = val;
      notifyListeners();
    });
  }

  int selectedCancelSubsId;
  setSelectedCancelSubsId(int id) {
    Future.delayed(Duration.zero, () {
      selectedCancelSubsId = id;
      notifyListeners();
    });
  }

  setSelectedNotiCrsLable(String val) {
    Future.delayed(Duration.zero, () {
      notiSelectCrsLable = val;
      notifyListeners();
    });
  }

  int checkInternet = 0;

  List<Map> restartList = [];

  int tapOnce = 0;
  changeonTap(int val) {
    Future.delayed(Duration.zero, () async {
      tapOnce = val;
      notifyListeners();
    });
  }

  setSelectedCourseName(String val) {
    selectedCourseName = val;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  setSelectedCourseLable(String val) {
    Future.delayed(Duration.zero, () {
      selectedCourseLable = val;
      // print("selectedCourseLable:::: $selectedCourseLable");
      notifyListeners();
    });
  }

  setSelectedFlashCategory(int val) {
    selectedFlashCategory = val;
    print("selectedFlashCategory===========$selectedFlashCategory");
    notifyListeners();
  }

  setSelectedMasterId(int val) {
    Future.delayed(Duration.zero, () async {
      selectedMasterId = val;
      print("selectedMasterId===========$selectedMasterId");
      notifyListeners();
    });
  }

  int selectedPlanType;
  setSelectedPlanType(int val) {
    Future.delayed(Duration.zero, () async {
      selectedPlanType = val;
      print("selectedPlanType========>>>>>>>$selectedPlanType");
      notifyListeners();
    });
  }

  setSelectedCourseId(int val) {
    Future.delayed(Duration.zero, () async {
      selectedCourseId = val;
      print("selectedCourseId========>>>>>>>$selectedCourseId");
      notifyListeners();
    });
  }

  List<Map<String, dynamic>> mokQuesAnsMap = [];
  addToList(int quesNo, List selAns) {
    // print("")
    print("mokQuesAnsMap::::==== $mokQuesAnsMap");
    if (mokQuesAnsMap.isEmpty) {
      Map<String, dynamic> map = {
        "questionNumber": quesNo,
        "selectedAnswers": selAns,
      };
      mokQuesAnsMap.add(map);
    } else {
      for (int i = 0; i < mokQuesAnsMap.length; i++) {
        if (mokQuesAnsMap[i].containsKey(quesNo)) {
          mokQuesAnsMap[i] = {
            "questionNumber": quesNo,
            "selectedAnswers": selAns,
          };
        } else {
          Map<String, dynamic> map = {
            "questionNumber": quesNo,
            "selectedAnswers": selAns,
          };
          mokQuesAnsMap.add(map);
        }
      }
      print("mokQuesAnsMap======== $mokQuesAnsMap");
    }
  }

  int showFloatButton = 0;

  setFloatButton(int val) {
    print("calll");
    Future.delayed(Duration(seconds: 0), () async {
      showFloatButton = val;
      print("showFloatButton========>>>>>>>$showFloatButton");
      notifyListeners();
    });
  }

  int toPage;
  int allowScroll = 1;
  setScroll(int val, int pageNum) {
    print("pageNum======$pageNum");
    Future.delayed(Duration.zero, () {
      allowScroll = val;
      toPage = pageNum;
      print("allowScroll==========$allowScroll");
      notifyListeners();
    });
  }

  var totalTime = 0;
  var pauseTime;
  setPauseTime(var disTime, var ansmp, {int question, List atmpData}) {
    Future.delayed(Duration.zero, () {
      var hrs;
      var mins;
      var secs;
      pauseTime = disTime;
      var minSec = pauseTime.split(":");
      print("minsecccc====$minSec");
      if (int.parse(minSec[0]) != 00) {
        print("hr vale===${minSec[0]}");
        hrs = int.parse(minSec[0]) * 60 * 60;
      }
      if (int.parse(minSec[1]) != 00) {
        print("minss vale===${minSec[1]}");
        mins = int.parse(minSec[1]) * 60;
      }
      if (int.parse(minSec[2]) != 00) {
        print("sec  vale===${minSec[2]}");
        secs = (int.parse(minSec[2]));
      }
      // if(){

      // }
      print("==hrs$hrs");
      if (hrs != null) {
        totalTime = (hrs + mins + secs) * 1000;
      } else if (mins != null) {
        totalTime = (mins + secs) * 1000;
      } else if (secs != null) {
        totalTime = (secs) * 1000;
      }

      print("milisecondss value====$totalTime");

      print("allowScroll==========$allowScroll");

      HiveHandler.addToRestartBox(
          selectedMockId.toString(),
          RestartModel(
              displayTime: totalTime.toString(),
              quesNum: toPage,
              restartAttempNum: selectedAttemptNumer,
              answersMapp: ansmp,
              atempedData: atmpData));
      notifyListeners();
    });
  }

  List<MasterDetails> tempListMaster = [];
  List<MasterDetails> masterTemp = [];

  bool masterDataApiCall = false;
  bool flashCateDataApiCall = false;
  bool videoListApiCall = false;
  bool pptDataListApiCall = false;

  updatePPTDataListApiCall(bool val) {
    pptDataListApiCall = val;
    notifyListeners();
  }

  updatevideoListApiCall(bool val) {
    videoListApiCall = val;
    notifyListeners();
  }

  updateMasterDataApiCall(bool val) {
    masterDataApiCall = val;
    notifyListeners();
  }

  updateFlashCateDataApiCall(bool val) {
    flashCateDataApiCall = val;
    notifyListeners();
  }

  //pptDataList
  String body;
  String pptUrlLink = "";
  PPTDataDetails oflinePptDtail;

  setOflinePptDetail(PPTDataDetails val) {
    oflinePptDtail = val;
    notifyListeners();
  }

  var successValuePPT;
  Future<void> getPpt(int id) async {
    successValuePPT = true;
    updatePPTDataListApiCall(true);
    print("callinggg this function");
    pptDataList = [];
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};
    bool checkConn = await checkInternetConn();
    if (checkConn) {
      body = HiveHandler.getNotSubmittedMock(keyName: notSubmitedMockID);
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
          HiveHandler.removeFromSubmitMockBox(notSubmitedMockID);
          HiveHandler.removeFromRestartBox(notSubmitedMockID);
          await getTestDetails(allTestListIdOfline);

          Response response = await http.get(Uri.parse(MOCK_TEST + '/$attempListIdOffline'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), attempListIdOffline.toString());
          }
        });
        if (response.statusCode == 200) {
          // remove
          setnotSubmitedMockID("");
          setToBeSubmitIndex(1000);
        }
      }
    }
    try {
      var response = await http.post(
        Uri.parse(GET_PPT),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );
      print("response.statusCode===${response.body}");
      print("response.statusCode===${response.statusCode}");

      var resDDo = json.decode(response.body);
      var resStatus = (resDDo["status"]);
      if (response.statusCode == 400) {
        updatePPTDataListApiCall(false);
        print("statussssssss");
        pptDataList = [];
        notifyListeners();
        return;
      }
      if (response.statusCode == 200) {
        updatePPTDataListApiCall(false);
        pptDataList.clear();
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        print("mapResponse['success']=====${mapResponse['success']}");
        successValuePPT = mapResponse['success'];
        print("sucesssvalue======$successValuePPT");
        if (successValuePPT == false) {
          print("value is falseeee");
          successValuePPT = false;
          notifyListeners();
          return;
        }

        if (mapResponse['status'] == 400) {
          pptDataList = [];
          HiveHandler.addpptDataBox(jsonEncode(pptDataList), id.toString());
          return;
        }

        if (mapResponse["status"] == 200) {
          List temp1 = mapResponse["data"];
          print("mapResponse[data]::::::${mapResponse["data"]}");
          print("mapResponse[data]length::::::${temp1.length}");
          if (temp1.length == 1) {
            pptUrlLink = mapResponse["data"][0]["filename"];
            print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>pptUrlLink::::::$pptUrlLink");
          }
          print("idddddd::::::$id");
          print("mapResponse[data]urllll:::${mapResponse["data"][0]["filename"]}");
          HiveHandler.addpptDataBox(jsonEncode(mapResponse["data"]), id.toString());
          print("temp list===$temp1");
          pptDataList = temp1.map((e) => PPTDataDetails.fromjson(e)).toList();
        } else {
          pptDataList = [];
          HiveHandler.addpptDataBox(jsonEncode(pptDataList), id.toString());
        }
      }
    } on Exception {
      updatePPTDataListApiCall(false);
    }
    notifyListeners();
  }

  bool isPPTLoading = false;

  updateIsPPLoading(bool value) {
    isPPTLoading = value;
    notifyListeners();
  }

  Future<void> getPptCategory(int id) async {
    updateIsPPLoading(true);
    pptCategoryList = [];
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

    bool checkConn = await checkInternetConn();
    if (checkConn) {
      body = HiveHandler.getNotSubmittedMock(keyName: notSubmitedMockID);
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
          HiveHandler.removeFromSubmitMockBox(notSubmitedMockID);
          HiveHandler.removeFromRestartBox(notSubmitedMockID);
          await getTestDetails(allTestListIdOfline);
          // await apiCall(attempListIdOffline);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/$attempListIdOffline'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          print("response.statusCode >>>>>>>=====************<<<<<<<<<<<${response.statusCode}");
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), attempListIdOffline.toString());
            HiveHandler.removeFromSubmitMockBox(notSubmitedMockID);
          }
        });
        if (response.statusCode == 200) {
          HiveHandler.removeFromSubmitMockBox(notSubmitedMockID);
          HiveHandler.removeFromRestartBox(notSubmitedMockID);
          setnotSubmitedMockID("");
          setToBeSubmitIndex(1000);
        }
      }
    }

    try {
      var response = await http.post(
        Uri.parse(GET_PPT_CATEGORIES),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );
      print("response.statusCode===${response.body}");
      print("response.statusCode===${response.statusCode}");

      var resDDo = json.decode(response.body);
      var resStatus = (resDDo["status"]);
      print("resStatus====$resStatus");
      if (resStatus == 400) {
        print("statussssssss");
        pptCategoryList = [];
        updateIsPPLoading(false);

        return;
      }
      if (response.statusCode == 200) {
        pptCategoryList.clear();
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);

        if (mapResponse['status'] == 400) {
          pptCategoryList = [];
          HiveHandler.addpptCateData(jsonEncode(pptCategoryList), id.toString());
          return;
        }

        if (mapResponse["status"] == 200) {
          List temp1 = mapResponse["data"];
          print("temp list===$temp1");
          HiveHandler.addpptCateData(jsonEncode(mapResponse["data"]), id.toString());
          print("temp list===$temp1");
          pptCategoryList = temp1.map((e) => PPTCateDetails.fromjson(e)).toList();
          print("master list=========$pptCategoryList");
        } else {
          pptCategoryList = [];
          HiveHandler.addpptCateData(jsonEncode(pptCategoryList), id.toString());
        }
        updateIsPPLoading(false);
      }
    } on Exception {
      updateIsPPLoading(false);
    }
  }

  Future<void> getMasterData(int id) async {
    updateMasterDataApiCall(true);
    tempListMaster = [];
    print("idddd=========>>>>>>>>>>>>>>>$id");

    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};
    bool checkConn = await checkInternetConn();
    if (checkConn) {
      print("api caliing after internet>>>$notSubmitedMockID");
      body = HiveHandler.getNotSubmittedMock(keyName: notSubmitedMockID);
      print("bodyy>>>>::::::::::::::$body");
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
          HiveHandler.removeFromSubmitMockBox(notSubmitedMockID);
          HiveHandler.removeFromRestartBox(notSubmitedMockID);

          await getTestDetails(allTestListIdOfline);
          // await apiCall(attempListIdOffline);
          print("api boddddydyydydydyd>>>.${MOCK_TEST + '/$attempListIdOffline'}");
          Response response = await http.get(Uri.parse(MOCK_TEST + '/$attempListIdOffline'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          print("responseeee");
          print("responseeee>>>>><<<<<<<%%%%%%%%%%>>>>>>>>>>>>>>${response.statusCode}");
          print("responseeee BODY>>>>><<<<<<<%%%%%%%%%%>>>>>>>>>>>>>>${response.body}");
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), attempListIdOffline.toString());
          }
        });
        if (response.statusCode == 200) {
          setnotSubmitedMockID("");
          setToBeSubmitIndex(1000);
        }
      }
    }
    try {
      var response = await http.post(
        Uri.parse(GET_MASTER_DATA),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      // print("response.statusCode===${response.body}");
      // print("response.statusCode===${response.statusCode}");

      var resDDo = json.decode(response.body);
      var resStatus = (resDDo["status"]);
      print("response status code>>>>>> ${response.statusCode}");

      if (response.statusCode == 400) {
        updateMasterDataApiCall(false);
        print("statussssssss");
        masterList = [];
        tempListMaster = [];
        notifyListeners();
        return;
      }

      // print("val of vid present===$videoPresent");

      if (response.statusCode == 200) {
        updateMasterDataApiCall(false);
        masterList.clear();
        print("");
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        // print("mapResponse====${mapResponse['status']}");
        if (mapResponse['status'] == 400) {
          tempListMaster = [];
          HiveHandler.addMasterData(jsonEncode(tempListMaster), keyName: id.toString());
          return;
        }

        if (mapResponse["status"] == 200) {
          List temp1 = mapResponse["data"];
          print("temp list===$temp1");
          masterList = temp1.map((e) => MasterDetails.fromjson(e)).toList();
          print("master list=========$masterList");

          try {
            HiveHandler.addMasterData(jsonEncode(mapResponse["data"]), keyName: id.toString());
          } catch (e) {
            print("errorr===========>>>>>> $e");
          }
        } else {
          masterList = [];
          HiveHandler.addMasterData(jsonEncode(masterList), keyName: id.toString());
        }
      }
      // print("respponse=== ${response.body}");
    } on Exception catch (e) {
      print("errorr>>>>>>>$e");

      updateMasterDataApiCall(false);
    }
    notifyListeners();
  }

  List<Queans> mockDomainList = [];
  Future<void> getReviewTestDomain(int id, int atmptCount, String domainName) async {
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id, "attempt": atmptCount, "domain": domainName};

    bool checkConn = await checkInternetConn();
    if (checkConn) {
      body = HiveHandler.getNotSubmittedMock(keyName: notSubmitedMockID);
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
          HiveHandler.removeFromSubmitMockBox(notSubmitedMockID);
          HiveHandler.removeFromRestartBox(notSubmitedMockID);
          await getTestDetails(allTestListIdOfline);
          // await apiCall(attempListIdOffline);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/$attempListIdOffline'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), attempListIdOffline.toString());
          }
        });
        if (response.statusCode == 200) {
          setnotSubmitedMockID("");
          setToBeSubmitIndex(1000);
        }
      }
    }

    try {
      var response = await http.post(
        Uri.parse(REVIEW_MOCK_DOMAIN),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      print("response.statusCode===${response.body}");
      print("response.statusCode===${response.statusCode}");

      if (response.statusCode == 400) {
        print("statussssssss");
        mockDomainList = [];
        notifyListeners();
        return;
      }

      if (response.statusCode == 200) {
        mockDomainList.clear();
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        print("mapResponse====${mapResponse['status']}");
        if (mapResponse['status'] == 400) {
          mockDomainList = [];
          return;
        }
        if (mapResponse["status"] == 200) {
          List temp1 = mapResponse["data"];
          print("temp list===$temp1");
          mockDomainList = temp1.map((e) => Queans.fromjss(e)).toList();
          print("master list=========$mockDomainList");
        }
      }
    } on Exception {}
    notifyListeners();
  }

  List<FlashCateDetails> flashCateTempList = [];

  Future<void> getFlashCate(int id) async {
    updateFlashCateDataApiCall(true);
    // checkInternet = 0;
    print("flash category iddd=====$id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

    bool checkConn = await checkInternetConn();
    if (checkConn) {
      body = HiveHandler.getNotSubmittedMock(keyName: notSubmitedMockID);
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
          HiveHandler.removeFromSubmitMockBox(notSubmitedMockID);
          HiveHandler.removeFromRestartBox(notSubmitedMockID);
          await getTestDetails(allTestListIdOfline);
          // await apiCall(attempListIdOffline);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/$attempListIdOffline'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), attempListIdOffline.toString());
          }
        });
        if (response.statusCode == 200) {
          setnotSubmitedMockID("");
          setToBeSubmitIndex(1000);
        }
      }
    }

    try {
      var response = await http.post(
        Uri.parse(GET_FLASH_CATEGORIES),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      print("response.statusCode===${response.statusCode}");
      print("response.statusCode===${response.body}");

      if (response.statusCode == 200) {
        updateFlashCateDataApiCall(false);
        flashCate.clear();
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        print("mapResponse=========$mapResponse");

        if (mapResponse["status"] == 200) {
          List temp1 = mapResponse["data"];

          flashCate = temp1.map((e) => FlashCateDetails.fromjson(e)).toList();

          print("flashCate================${flashCate.length}");
          if (flashCate == null || flashCate.isEmpty) {
            flashCate = [];
          }
          try {
            HiveHandler.addFlashCateData(jsonEncode(mapResponse["data"]), id.toString());
          } catch (e) {
            print("errorr===========>>>>>>$e");
          }

          notifyListeners();
        } else {
          // HiveHandler.addFlashCateData(jsonEncode(mapResponse["data"]), id.toString());
          updateFlashCateDataApiCall(false);
          print("status 400");
          flashCate = [];

          HiveHandler.addFlashCateData(jsonEncode(flashCate), id.toString());
          notifyListeners();
          return;
        }

        // if (mapResponse["status"] == 400) {
        // } else {}
      } else {
        updateFlashCateDataApiCall(false);
      }
    } on Exception {
      updateFlashCateDataApiCall(false);
    }
    notifyListeners();
  }

  Future<void> getVideoCate(int id) async {
    updatevideoListApiCall(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

    bool checkConn = await checkInternetConn();
    if (checkConn) {
      body = HiveHandler.getNotSubmittedMock(keyName: notSubmitedMockID);
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
          HiveHandler.removeFromSubmitMockBox(notSubmitedMockID);
          HiveHandler.removeFromRestartBox(notSubmitedMockID);
          await getTestDetails(allTestListIdOfline);
          // await apiCall(attempListIdOffline);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/$attempListIdOffline'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), attempListIdOffline.toString());
          }
        });
        if (response.statusCode == 200) {
          setnotSubmitedMockID("");
          setToBeSubmitIndex(1000);
        }
      }
    }

    try {
      var response = await http.post(
        Uri.parse(GET_VIDEO_CATEGORIES),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      print(GET_VIDEO_CATEGORIES);
      print("response====${response.body}");
      var resp = response.body;

      var resDDo = json.decode(response.body);
      var resStatus = (resDDo["status"]);
      videoPresent = 1;
      if (resStatus == 400) {
        updatevideoListApiCall(false);
        videoPresent = 0;
      }
      print("videoPresent=======$videoPresent");

      print("response.statusCode===${response.statusCode}");
      if (response.statusCode == 200) {
        videoCate.clear();
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);

        List temp1 = mapResponse["data"];

        videoCate = temp1.map((e) => VideoCateDetails.fromjson(e)).toList();

        updatevideoListApiCall(false);
      } else {
        updatevideoListApiCall(false);
      }

      print("respponse=== *9*9${response.body}");
    } on Exception {
      // TODO
      updatevideoListApiCall(false);
    }
  }

  List<CourseDetails> tempListCourse = [];
  bool getCourseApiCalling = false;
  updateGetCourseApiCalling(bool val) {
    getCourseApiCalling = val;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  List<int> enrolledId = [];
  Future<void> getCourse() async {
    updateGetCourseApiCalling(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    bool checkConn = await checkInternetConn();
    if (checkConn) {
      body = HiveHandler.getNotSubmittedMock(keyName: notSubmitedMockID);
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
          HiveHandler.removeFromSubmitMockBox(notSubmitedMockID);
          HiveHandler.removeFromRestartBox(notSubmitedMockID);
          await getTestDetails(allTestListIdOfline);
          // await apiCall(attempListIdOffline);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/$attempListIdOffline'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), attempListIdOffline.toString());
          }
        });
        if (response.statusCode == 200) {
          setnotSubmitedMockID("");
          setToBeSubmitIndex(1000);
        }
      }
    }
    try {
      var response = await http.get(
        Uri.parse(GET_COURSES),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
      );

      if (response.statusCode == 200) {
        course.clear();
        crsDropList.clear();
        chatCrsDropList.clear();
        mockCrsDropList.clear();
        cancelSubsList.clear();

        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        List temp1 = mapResponse["data"];
        print("temp list course === $temp1");
        course = temp1.map((e) => CourseDetails.fromjson(e)).toList();
        for (int i = 0; i < course.length; i++) {
          print("::::length of mock list>>>>>..${course[i].Mocktests.length}");
          print("::::isSubscribed value>>>>>..${course[i].isSubscribed}");
          if (course[i].Mocktests.length > 0 || course[i].isSubscribed == 1) {
            print("either if the provided condition is true");
            mockCrsDropList.add(course[i]);
          }
          if (course[i].isSubscribed == 1) {
            crsDropList.add(course[i]);
          }
          if (course[i].isCancelSubscription == 0) {
            cancelSubsList.add(course[i]);
          }

          if (course[i].isChatSubscribed == 1 || course[i].isSubscribed == 1) {
            chatCrsDropList.add(course[i]);
          }
          print("crsDropList=======$crsDropList");
        }
        print("course=========$course");

        try {
          HiveHandler.addCourseData(jsonEncode(mapResponse["data"]));

          Future.delayed(Duration(microseconds: 10), () {
            // tempListCourse
            List<CourseDetails> res = HiveHandler.getCourseDataList();

            notifyListeners();
          });
        } catch (e) {
          print("errorr===========>>>>>>$e");
        }
        updateGetCourseApiCalling(false);

        print("course lkengrtht=====${course.length}");
      } else {
        print("status codeee====>>>>${response.statusCode}");
        course = [];
        crsDropList = [];
        chatCrsDropList = [];

        HiveHandler.addCourseData(jsonEncode(course));
        updateGetCourseApiCalling(false);
      }
      print("787878 ${response.body}");
    } on Exception {
      // TODO
      updateGetCourseApiCalling(false);
    }
  }

  var vedioStatusValue;

  Future<void> restoreCourse(int id) async {
    Map restoreBody = {"courseId": id};
    updateLoader(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print("token valueddfdfdf===$stringValue");
    bool checkConn = await checkInternetConn();
    if (checkConn) {
      body = HiveHandler.getNotSubmittedMock(keyName: notSubmitedMockID);
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
          HiveHandler.removeFromRestartBox(notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(notSubmitedMockID);
          await getTestDetails(allTestListIdOfline);
          // await apiCall(attempListIdOffline);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/$attempListIdOffline'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), attempListIdOffline.toString());
          }
        });
        if (response.statusCode == 200) {
          HiveHandler.removeFromRestartBox(notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(notSubmitedMockID);
          setnotSubmitedMockID("");
          setToBeSubmitIndex(1000);
        }
      }
    }
    try {
      var response = await http.post(Uri.parse(RESTORE_SUBSCRIPTION),
          headers: {
            "Content-Type": "application/json",
            'Authorization': stringValue,
          },
          body: json.encode(restoreBody));
      print("restoreBody>>>> $restoreBody");

      if (response.statusCode == 200) {
        getCourse().then((value) {
          updateLoader(false);
          EasyLoading.showInfo("Course Restored Successfully");
        });
      } else {
        updateLoader(false);
        EasyLoading.showToast("Something went wrong...");
      }
    } catch (e) {
      updateLoader(false);
      print("errrorororr====$e");
    }
  }

  Future<void> getVideos(int id) async {
    vedioStatusValue = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

    bool checkConn = await checkInternetConn();
    if (checkConn) {
      body = HiveHandler.getNotSubmittedMock(keyName: notSubmitedMockID);
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
          HiveHandler.removeFromSubmitMockBox(notSubmitedMockID);
          HiveHandler.removeFromRestartBox(notSubmitedMockID);
          await getTestDetails(allTestListIdOfline);
          // await apiCall(attempListIdOffline);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/$attempListIdOffline'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), attempListIdOffline.toString());
          }
        });
        if (response.statusCode == 200) {
          // HiveHandler.removeFromRestartBox();
          setnotSubmitedMockID("");
          setToBeSubmitIndex(1000);
        }
      }
    }

    var response = await http.post(
      Uri.parse(GET_VIDEOS),
      headers: {"Content-Type": "application/json", 'Authorization': stringValue},
      body: json.encode(request),
    );

    print("response.statusCode===${response.statusCode}");
    print("response.body===${response.body}");

    var resDDo = json.decode(response.body);
    var resStatus = (resDDo["status"]);
    videoPresent = 1;
    if (resStatus == 400) {
      Videos = [];
      videoPresent = 0;
      notifyListeners();
      return;
    }

    if (response.statusCode == 200) {
      Videos.clear();
      Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
      print("mapResponse=======$mapResponse");

      vedioStatusValue = mapResponse['success'];
      if (vedioStatusValue == false) {
        print("vedioStatusValue=======$vedioStatusValue");
        return;
      }
      List temp1 = mapResponse["data"];
      print("temp list===$temp1");
      Videos = temp1.map((e) => VideoDetails.fromjson(e)).toList();

      notifyListeners();

      if (Videos.isNotEmpty) {
        print("videoCate 0=== ${Videos[0].title}");
      }
    }
    print("respponse=== ${response.body}");
  }

  var successValueFlash;
  var flashPrice;

  Future<void> getFlashCards(int id, String strr) async {
    successValueFlash = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

    bool checkConn = await checkInternetConn();
    if (checkConn) {
      body = HiveHandler.getNotSubmittedMock(keyName: notSubmitedMockID);
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
          HiveHandler.removeFromRestartBox(notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(notSubmitedMockID);
          await getTestDetails(allTestListIdOfline);
          // await apiCall(attempListIdOffline);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/$attempListIdOffline'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), attempListIdOffline.toString());
          }
        });
        if (response.statusCode == 200) {
          setnotSubmitedMockID("");
          setToBeSubmitIndex(1000);
        }
      }
    }

    try {
      var response = await http.post(
        Uri.parse(GET_FLASH_CARDS),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      if (response.statusCode == 200) {
        FlashCards.clear();
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        print("mapResponse====$mapResponse");

        List temp1 = mapResponse["data"];
        int stsVal = mapResponse["status"];
        print("stsVal=======$stsVal");
        successValueFlash = mapResponse['success'];
        print("sucesssvalue======$successValueFlash");
        if (successValueFlash == false) {
          successValueFlash = false;
          return;
        }

        FlashCards = temp1.map((e) => FlashCardDetails.fromjson(e)).toList();

        print("FlashCards=========$FlashCards");
        if (stsVal == 200) {
          try {
            HiveHandler.addFlashDisplayData(jsonEncode(mapResponse["data"]), id.toString());
          } catch (e) {
            print("errorr===========>>>>>>$e");
          }
        }
      }
    } on Exception {}
  }

  List<FlashCardDetails> flashTempDisplay = [];

  var valOfSuccess;
  Future<void> getTestDetails(int id) async {
    valOfSuccess = true;
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};
    bool checkConn = await checkInternetConn();
    if (checkConn) {
      body = HiveHandler.getNotSubmittedMock(keyName: notSubmitedMockID);
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
          HiveHandler.removeFromRestartBox(notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(notSubmitedMockID);
          await getTestDetails(allTestListIdOfline);
          // await apiCall(attempListIdOffline);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/$attempListIdOffline'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), attempListIdOffline.toString());
          }
        });
        if (response.statusCode == 200) {
          setnotSubmitedMockID("");
          setToBeSubmitIndex(1000);
        }
      }
    }

    try {
      var response = await http.post(
        Uri.parse(GET_TEST_DETAILS),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      // print("response.statusCode===${response.statusCode}");
      if (response.statusCode == 200) {
        testDetails.clear();
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        print("mapResponse======$mapResponse");
        valOfSuccess = mapResponse['success'];
        print("valOfSuccess========>>$valOfSuccess");
        if (valOfSuccess == false) {
          return;
        }
        List temp1 = mapResponse["data"]["list"];
        testDetails = temp1.map((e) => TestDetails.fromjson(e)).toList();
        try {
          if (testDetails.isNotEmpty) {
            HiveHandler.setMockPercentdata(key: id.toString(), value: temp1);
          }
        } catch (e) {
          print("errororororor======$e");
        }
        notifyListeners();
        if (testDetails.isNotEmpty) {
          print("testDetails 0=== ${testDetails[0].testName}");
        }
      }
      print("respponse===45665 ${response.body}");
    } on Exception {
      // TODO
    }
  }

  int firstTestDataMock = 0;
  int firstTestDataPractice = 0;
  List<TestDataDetails> testListTemp = [];
  bool isMockTestLoading = false;

  updateisMockTestLoading(bool value) {
    isMockTestLoading = value;
    notifyListeners();
  }

  // for mock tests list
  Future<void> getTest(int id, String testType) async {
    testData.clear();
    updateisMockTestLoading(true);
    print("id valueeee===========>>>>>>>>>>>$id");

    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};
    bool checkConn = await checkInternetConn();
    if (checkConn) {
      body = HiveHandler.getNotSubmittedMock(keyName: notSubmitedMockID);
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
          HiveHandler.removeFromRestartBox(notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(notSubmitedMockID);
          await getTestDetails(allTestListIdOfline);
          // await apiCall(attempListIdOffline);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/$attempListIdOffline'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), attempListIdOffline.toString());
          }
        });
        if (response.statusCode == 200) {
          setnotSubmitedMockID("");
          setToBeSubmitIndex(1000);
        }
      }
    }
    try {
      var response = await http.post(
        Uri.parse(GET_TEST),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );
      print("respponse=== 54545454${response.body}");
      print("testData>>>>>>$testData");

      if (response.statusCode == 200) {
        testData.clear();
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        print("mapResponse===========$mapResponse");
        print('mapResponse["data"]>>>>>>>>>${mapResponse["data"]}');
        if (mapResponse["data"] == {}) {
          print("this is data and it is empthyyyyyyyyy");
        }

        if (mapResponse["status"] == 200) {
          List temp1 = mapResponse["data"];
          print("temp list===$temp1");
          testData = temp1.map((e) => TestDataDetails.fromjson(e)).toList();
          try {
            HiveHandler.addTestMpData(jsonEncode(mapResponse["data"]), id.toString());
            Future.delayed(Duration(microseconds: 100), () {
              List<TestDataDetails> tempList = HiveHandler.getTestDataList(key: id.toString());
              testListTemp = HiveHandler.getTestDataList(key: id.toString());
            });
          } catch (e) {
            print("errorr===========>>>>>>$e");
          }
          notifyListeners();
          if (testData.isNotEmpty) {
            print("testData 0=== ${testData[0].test_name}");
          }
        } else {
          print("in this conditionnnnnn");
          testData = [];
          print("jason encode test data>>>>>${jsonEncode(testData)}");
          HiveHandler.addTestMpData(jsonEncode(testData), id.toString());

          notifyListeners();
        }
        updateisMockTestLoading(false);
      } else {
        updateisMockTestLoading(false);
      }
    } on Exception {
      updateisMockTestLoading(false);
      // TODO
    }
  }

  Future<void> updateDeviceToken(String Devtoken) async {
    print("=======================device tokwn=====>$Devtoken");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"deviceToken": Devtoken};
    bool checkConn = await checkInternetConn();
    if (checkConn) {
      body = HiveHandler.getNotSubmittedMock(keyName: notSubmitedMockID);
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
          HiveHandler.removeFromRestartBox(notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(notSubmitedMockID);
          await getTestDetails(allTestListIdOfline);
          // await apiCall(attempListIdOffline);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/$attempListIdOffline'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), attempListIdOffline.toString());
          }
        });
        if (response.statusCode == 200) {
          setnotSubmitedMockID("");
          setToBeSubmitIndex(1000);
        }
      }
    }
    try {
      var response = await http.post(
        Uri.parse(UPDATE_DEVICE_TOKEN),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      print("response.statusCode===${response.body}");
      print("response.statusCode===${response.statusCode}");

      var resDDo = json.decode(response.body);
      var resStatus = (resDDo["status"]);
      videoPresent = 1;
      if (resStatus == 400) {
        masterList = [];
        videoPresent = 0;
        notifyListeners();
        return;
      }
      print("val of vid present===$videoPresent");

      if (response.statusCode == 200) {
        print("respponse device token === ${response.body}");
        notifyListeners();
      }
    } on Exception {
      // TODO
    }
  }

  MockData mockData;

  Future apiCall(int selectedIdNew) async {
    print("selectedIdNew==========$selectedIdNew");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    http.Response response;
    bool checkConn = await checkInternetConn();
    if (checkConn) {
      body = HiveHandler.getNotSubmittedMock(keyName: notSubmitedMockID);
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
          HiveHandler.removeFromRestartBox(notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(notSubmitedMockID);
          await getTestDetails(allTestListIdOfline);

          // Response response = await http.get(Uri.parse(MOCK_TEST + '/$attempListIdOffline'),
          //     headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          // Map getit;
          // if (response.statusCode == 200) {
          //   getit = convert.jsonDecode(response.body);
          //   print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
          //   await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), attempListIdOffline.toString());
          // }
        });
        if (response.statusCode == 200) {
          // HiveHandler.removeFromRestartBox(notSubmitedMockID);
          // HiveHandler.removeFromSubmitMockBox(notSubmitedMockID);
          setnotSubmitedMockID("");
          setToBeSubmitIndex(1000);
        }
      }
    }
    try {
      response = await http.get(Uri.parse(MOCK_TEST + '/$selectedIdNew'),
          headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
      // print("Url :=> ${Uri.parse(MOCK_TEST + "/$selectedIdNew")}");
      // print("header :=> ${{'Content-Type': 'application/json', 'Authorization': stringValue}}");
      // print("API Response MOCK_TEST ; $stringValue => ${response.request.url}; ${response.body}");
      // print("API Response ; $stringValue => ${response.request.url}; ${response.body}");

      Map getit;
      if (response.statusCode == 200) {
        print(convert.jsonDecode(response.body));

        getit = convert.jsonDecode(response.body);
        print("mock data==================>>>>>>>>>>${getit["data"]}");

        mockData = MockData.fromjd(getit["data"]);
      }
    } on Exception {
      // TODO
    }
    notifyListeners();
  }

  int selectedMockPercentId;
  void setMockTestPercentId(int id) {
    selectedMockPercentId = id;
    print("selectedMockPercentId============$selectedMockPercentId");
    notifyListeners();
  }

  String selectedMasterType;
  void setMasterListType(String type) {
    selectedMasterType = type;
    print("selectedMasterType=======$selectedMasterType");
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  bool showLoader;

  int selectedMokAtmptCnt;

  void setSelectedMokAtemptCnt(int numAttemptesCnts) {
    selectedMokAtmptCnt = numAttemptesCnts;
    print("selectedMokAtmptCnt=========$selectedMokAtmptCnt");
    notifyListeners();
  }

  int selectedAtemptListLength;
  void setSelectedAttemptListLenght(int length) {
    selectedAtemptListLength = length;
    print("selectedAtemptListLength====$selectedAtemptListLength");
    notifyListeners();
  }

  var selectedTestName;
  void setSelectedTestName(String testName) {
    selectedTestName = testName;
    notifyListeners();
  }

  bool timerValue = false;

  resPauseTimer() {
    timerValue = !timerValue;
    notifyListeners();
  }

  int selectedAttemptNumer;
  void setSelectedAttemptNumer(int attempt) {
    selectedAttemptNumer = attempt;
    notifyListeners();
  }

  int selectedMockId;
  void setSelectedMockId(int id) {
    selectedMockId = id;
    notifyListeners();
  }

  int allTestListIdOfline;

  void setAllTestListIdOfline(int id) {
    allTestListIdOfline = id;
    notifyListeners();
  }

  int attempListIdOffline;

  void setAttempListIdOffline(int id) {
    attempListIdOffline = id;
    notifyListeners();
  }

  int setPendindIndex = 1000;

  void setToBeSubmitIndex(int index) {
    Future.delayed(Duration.zero, () {
      setPendindIndex = index;
      notifyListeners();
    });
  }

  int selectedTstPrcentId;
  void setSelectedTestPercetId(index) {
    Future.delayed(Duration.zero, () {
      selectedTstPrcentId = index;
      notifyListeners();
    });
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

  bool loader = false;
  updateLoader(bool status) async {
    loaderUpdate(status);

    loader = status;
    await Future.delayed(Duration(seconds: 0));
    notifyListeners();
  }

  loaderUpdate(bool status) {
    if (status) {
      EasyLoading.show(status: "Loading", maskType: EasyLoadingMaskType.clear);
    } else {
      print("dismiss loader");
      EasyLoading.dismiss();
    }
  }
}
