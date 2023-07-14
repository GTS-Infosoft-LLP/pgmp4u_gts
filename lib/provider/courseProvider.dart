import 'dart:convert';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
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
    selectedCourseLable = val;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  setSelectedFlashCategory(int val) {
    selectedFlashCategory = val;
    print("selectedFlashCategory===========$selectedFlashCategory");
    notifyListeners();
  }

  setSelectedMasterId(int val) {
    selectedMasterId = val;
    print("selectedMasterId===========$selectedMasterId");
    notifyListeners();
  }

  setSelectedCourseId(int val) {
    Future.delayed(Duration.zero, () async {
      selectedCourseId = val;
      print("selectedCourseId========>>>>>>>$selectedCourseId");
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
  setPauseTime(var disTime) {
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

  var successValuePPT;
  Future<void> getPpt(int id) async {
    successValuePPT = true;
    updatePPTDataListApiCall(true);
    print("callinggg this function");
    pptDataList = [];
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};
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
          return;
        }

        if (mapResponse["status"] == 200) {
          List temp1 = mapResponse["data"];
          print("temp list===$temp1");
          pptDataList = temp1.map((e) => PPTDataDetails.fromjson(e)).toList();
          print("pptDataList=========$pptDataList");
        }
      }
    } on Exception {
      updatePPTDataListApiCall(false);
    }
    notifyListeners();
  }

  Future<void> getPptCategory(int id) async {
    pptCategoryList = [];
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};
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
      if (response.statusCode == 400) {
        print("statussssssss");
        pptCategoryList = [];
        notifyListeners();
        return;
      }
      if (response.statusCode == 200) {
        pptCategoryList.clear();
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);

        if (mapResponse['status'] == 400) {
          pptCategoryList = [];
          return;
        }

        if (mapResponse["status"] == 200) {
          List temp1 = mapResponse["data"];
          print("temp list===$temp1");
          pptCategoryList = temp1.map((e) => PPTCateDetails.fromjson(e)).toList();
          print("master list=========$pptCategoryList");
        }
      }
    } on Exception {}
    notifyListeners();
  }

  Future<void> getMasterData(int id) async {
    updateMasterDataApiCall(true);
    tempListMaster = [];
    print("idddd=========>>>>>>>>>>>>>>>$id");

    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

    try {
      var response = await http.post(
        Uri.parse(GET_MASTER_DATA),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      print("response.statusCode===${response.body}");
      print("response.statusCode===${response.statusCode}");

      var resDDo = json.decode(response.body);
      var resStatus = (resDDo["status"]);

      if (response.statusCode == 400) {
        updateMasterDataApiCall(false);
        print("statussssssss");
        masterList = [];
        tempListMaster = [];
        notifyListeners();
        return;
      }

      print("val of vid present===$videoPresent");

      if (response.statusCode == 200) {
        updateMasterDataApiCall(false);
        masterList.clear();
        print("");
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        print("mapResponse====${mapResponse['status']}");
        if (mapResponse['status'] == 400) {
          tempListMaster = [];
          // HiveHandler.addMasterData(tempListMaster, keyName: id.toString());
          return;
        }

        if (mapResponse["status"] == 200) {
          List temp1 = mapResponse["data"];
          print("temp list===$temp1");
          masterList = temp1.map((e) => MasterDetails.fromjson(e)).toList();
          print("master list=========$masterList");

          try {
            print("id.toString===== ${id.toString}");
            HiveHandler.addMasterData(jsonEncode(mapResponse["data"]), keyName: id.toString());
          } catch (e) {
            print("errorr===========>>>>>> $e");
          }
        }
      }
      print("respponse=== ${response.body}");
    } on Exception {
      updateMasterDataApiCall(false);
    }
    notifyListeners();
  }

  List<Queans> mockDomainList = [];
  Future<void> getReviewTestDomain(int id, int atmptCount, String domainName) async {
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id, "attempt": atmptCount, "domain": domainName};
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
    checkInternet = 0;
    print("flash category iddd=====$id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

    var response = await http
        .post(
      Uri.parse(GET_FLASH_CATEGORIES),
      headers: {"Content-Type": "application/json", 'Authorization': stringValue},
      body: json.encode(request),
    )
        .onError((error, stackTrace) {
      print("error========>>$error");
      if (error.toString() == "Connection failed") {
        print("Connection failed *** Connection failed *** Connection failed");
        checkInternet = 1;
      }
      flashCate = [];
      checkInternet = 1;
      flashCate = HiveHandler.getFlashCateDataList(key: id.toString()) ?? [];
      if (flashCate.isEmpty) {
        flashCate = [];
        // HiveHandler.addFlashCateData(flashCate, id.toString());
      }
      return;
    });

    print("response.statusCode===${response.statusCode}");
    if (response.statusCode == 200) {
      updateFlashCateDataApiCall(false);
      flashCate.clear();
      Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
      print("mapResponse=========$mapResponse");

      if (mapResponse["status"] == 200) {
        List temp1 = mapResponse["data"];
        print("temp list===$temp1");
        flashCate = temp1.map((e) => FlashCateDetails.fromjson(e)).toList();

        print("flashCate================${flashCate.length}");
        if (flashCate == null || flashCate.isEmpty) {
          flashCate = [];
        }
        try {
          HiveHandler.addFlashCateData(jsonEncode(mapResponse["data"]), id.toString());

          // Future.delayed(Duration(microseconds: 800), () {
          //   List<FlashCateDetails> tempList = HiveHandler.getFlashCateDataList(key: id.toString()) ?? [];
          //   flashCateTempList = HiveHandler.getFlashCateDataList(key: id.toString()) ?? [];
          //   print("*************************************************");
          //   print("tempList==========$flashCateTempList");
          // });
        } catch (e) {
          print("errorr===========>>>>>>$e");
        }

        notifyListeners();

        if (flashCate.isNotEmpty) {
          print("flashCate name 0=== ${flashCate[0].name}");
        }
      } else {
        updateFlashCateDataApiCall(false);
        print("status 400");
        flashCate = [];
        // HiveHandler.addFlashCateData(flashCate, id.toString());

        notifyListeners();
        return;
      }

      // if (mapResponse["status"] == 400) {
      // } else {}
    } else {
      updateFlashCateDataApiCall(false);
    }
    print("respponse=== ${response.body}");
  }

  Future<void> getVideoCate(int id) async {
    updatevideoListApiCall(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

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

      notifyListeners();
    }
    print("videoPresent=======$videoPresent");

    print("response.statusCode===${response.statusCode}");
    if (response.statusCode == 200) {
      updatevideoListApiCall(false);
      videoCate.clear();
      Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);

      List temp1 = mapResponse["data"];
      print("temp list===$temp1");
      videoCate = temp1.map((e) => VideoCateDetails.fromjson(e)).toList();

      notifyListeners();

      if (videoCate.isNotEmpty) {
        print("videoCate 0=== ${videoCate[0].name}");
      }
    } else {
      updatevideoListApiCall(false);
    }

    print("respponse=== ${response.body}");
  }

  List<CourseDetails> tempListCourse = [];
  Future<void> getCourse() async {
    print("getCourse api calllllllll");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");

    try {
      var response = await http.get(
        Uri.parse(GET_COURSES),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
      );

      if (response.statusCode == 200) {
        course.clear();
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        List temp1 = mapResponse["data"];
        print("temp list course === $temp1");
        course = temp1.map((e) => CourseDetails.fromjson(e)).toList();
        print("course=========$course");

        try {
          HiveHandler.addCourseData(jsonEncode(mapResponse["data"]));

          Future.delayed(Duration(microseconds: 800), () {
            // tempListCourse
            List<CourseDetails> res = HiveHandler.getCourseDataList();

            notifyListeners();
            print("*************************************************");
            print("tempList course get box========== $res");
          });
        } catch (e) {
          print("errorr===========>>>>>>$e");
        }

        notifyListeners();
        print("course lkengrtht=====${course.length}");
        if (course.isNotEmpty) {
          print("course 0=== ${course[0].description}");
        }
      } else {
        print("status codeee====>>>>${response.statusCode}");
        course = [];

        HiveHandler.addCourseData(jsonEncode(course));
      }
      print("respponse=== ${response.body}");
    } on Exception {
      // TODO
    }
  }

  var vedioStatusValue;
  Future<void> getVideos(int id) async {
    vedioStatusValue = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

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
        print("temp list===$temp1");
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
          print("value is falseeeeeee");
          return;
        }

        List temp1 = mapResponse["data"]["list"];
        print("temp list===>>> $temp1");
        testDetails = temp1.map((e) => TestDetails.fromjson(e)).toList();

        try {
          if (testDetails.isNotEmpty) {
            print("before set to boxxxxxxxxx");
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
      print("respponse=== ${response.body}");
    } on Exception {
      // TODO
    }
  }

  int firstTestDataMock = 0;
  int firstTestDataPractice = 0;
  List<TestDataDetails> testListTemp = [];

  // for mock tests list
  Future<void> getTest(int id, String testType) async {
    print("id valueeee===========>>>>>>>>>>>$id");

    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

    try {
      var response = await http.post(
        Uri.parse(GET_TEST),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );
      print("respponse=== ${response.body}");

      if (response.statusCode == 200) {
        testData.clear();
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);

        print("mapResponse===========$mapResponse");
        if (mapResponse["status"] == 200) {
          List temp1 = mapResponse["data"];
          print("temp list===$temp1");
          testData = temp1.map((e) => TestDataDetails.fromjson(e)).toList();

          try {
            HiveHandler.addTestMpData(jsonEncode(mapResponse["data"]), id.toString());

            Future.delayed(Duration(microseconds: 800), () {
              List<TestDataDetails> tempList = HiveHandler.getTestDataList(key: id.toString());
              testListTemp = HiveHandler.getTestDataList(key: id.toString());
              print("*************************************************");

              print("tempList==========$tempList");
            });
          } catch (e) {
            print("errorr===========>>>>>>$e");
          }

          notifyListeners();

          if (testData.isNotEmpty) {
            print("testData 0=== ${testData[0].test_name}");
          }
        } else {
          testData = [];
          notifyListeners();
        }
      } else {}
    } on Exception {
      // TODO
    }
  }

  Future<void> updateDeviceToken(String Devtoken) async {
    print("=======================device tokwn=====>$Devtoken");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"deviceToken": Devtoken};

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
    print("this api is callingggggg======");
    print("selectedIdNew==========$selectedIdNew");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    http.Response response;

    try {
      response = await http.get(Uri.parse(MOCK_TEST + '/$selectedIdNew'),
          headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
      print("Url :=> ${Uri.parse(MOCK_TEST + "/$selectedIdNew")}");
      print("header :=> ${{'Content-Type': 'application/json', 'Authorization': stringValue}}");
      print("API Response MOCK_TEST ; $stringValue => ${response.request.url}; ${response.body}");
      print("API Response ; $stringValue => ${response.request.url}; ${response.body}");

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
  void errorWidgetCall() {
    print("method called");
    showLoader = true;
    Future.delayed(Duration(seconds: 4), () {
      print("4 secondes after method called");
      showLoader = false;
      print("showLoader==============$showLoader");
      notifyListeners();
    });
  }

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
}
