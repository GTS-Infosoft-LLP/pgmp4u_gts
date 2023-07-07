import 'dart:convert';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/Tests/local_handler/hive_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Models/mockListmodel.dart';
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

  // const _BASE_URL ="https://apivcarestage.vcareprojectmanagement.com/api/";

  ///

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

  int checkInternet = 0;

  setSelectedCourseName(String val) {
    selectedCourseName = val;
    notifyListeners();
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
    selectedCourseId = val;
    print("selectedCourseId========>>>>>>>$selectedCourseId");
    notifyListeners();
  }

  List<MasterDetails> tempListMaster = [];
  List<MasterDetails> masterTemp = [];

  Future<void> getMasterData(int id) async {
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
      videoPresent = 1;
      if (response.statusCode == 400) {
        print("statussssssss");
        masterList = [];
        tempListMaster = [];
        // HiveHandler.addMasterData(tempListMaster, keyName: id.toString());
        videoPresent = 0;

        notifyListeners();
        return;
      }

      print("val of vid present===$videoPresent");

      if (response.statusCode == 200) {
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

            // Future.delayed(Duration(microseconds: 800), () {
            //   List<MasterDetails> tempList = HiveHandler.getMasterDataList(key: id.toString()) ?? [];

            //   masterTemp = HiveHandler.getMasterDataList(key: id.toString()) ?? [];
            //   print("*************************************************");
            //   print("tempList==========$tempList");
            // });
          } catch (e) {
            print("errorr===========>>>>>> $e");
          }

          // if (masterList.isNotEmpty) {

          // } else {
          //   tempListMaster = [];
          //   HiveHandler.addMasterData(tempListMaster, keyName: id.toString());
          // }
        }

        if (masterList.isNotEmpty) {
          print("masterList 0=== ${masterList[0].name}");
        }
      }
      print("respponse=== ${response.body}");
    } on Exception {}
    notifyListeners();
  }

  List<FlashCateDetails> flashCateTempList = [];
  Future<void> getFlashCate(int id) async {
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
        print("status 400");
        flashCate = [];
        // HiveHandler.addFlashCateData(flashCate, id.toString());

        notifyListeners();
        return;
      }

      // if (mapResponse["status"] == 400) {
      // } else {}
    } else {}
    print("respponse=== ${response.body}");
  }

  Future<void> getVideoCate(int id) async {
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
      videoPresent = 0;

      notifyListeners();
    }
    print("videoPresent=======$videoPresent");

    print("response.statusCode===${response.statusCode}");
    if (response.statusCode == 200) {
      videoCate.clear();
      Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);

      List temp1 = mapResponse["data"];
      print("temp list===$temp1");
      videoCate = temp1.map((e) => VideoCateDetails.fromjson(e)).toList();

      notifyListeners();

      if (videoCate.isNotEmpty) {
        print("videoCate 0=== ${videoCate[0].name}");
      }
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
    print("http://3.227.35.115:1011/api/getVideos");

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};
    try {
      var response = await http.post(
        Uri.parse("http://3.227.35.115:1011/api/getFlashCards"),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      if (response.statusCode == 200) {
        FlashCards.clear();
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);

        List temp1 = mapResponse["data"];
        int stsVal = mapResponse["status"];
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
  // Future<void> getFlashCards(int id, String strr) async {
  //   successValueFlash = true;
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String stringValue = prefs.getString('token');

  //   print("token valued===$stringValue");
  //   var request = {"id": id};

  //   var response = await http
  //       .post(
  //     Uri.parse("http://3.227.35.115:1011/api/getFlashCards"),
  //     headers: {"Content-Type": "application/json", 'Authorization': stringValue},
  //     body: json.encode(request),
  //   )
  //       .onError((error, stackTrace) {
  //     print("erroeee===>>$error");
  //     flashTempDisplay = [];
  //     flashTempDisplay = HiveHandler.getflashCardsList(keyName: id.toString()) ?? [];

  //     if (flashTempDisplay.isEmpty) {
  //       FlashCards = [];
  //       HiveHandler.addFlash(FlashCards, KeyName: id.toString());
  //     }

  //     flashTempDisplay = [];
  //   });

  //   var resDDo = json.decode(response.body);
  //   print("resDDo=========$resDDo");
  //   print("success valueee====>>>>${resDDo['success']}");
  //   successValueFlash = resDDo['success'];
  //   if (successValueFlash == false) {
  //     print(":this valueee=====??");

  //     return;
  //   }
  //   var resStatus = (resDDo["status"]);
  //   videoPresent = 1;
  //   if (resStatus == 400) {
  //     FlashCards = [];
  //     // videoPresent = 0;

  //     notifyListeners();
  //     return;
  //   }

  //   print("response.statusCode===${response.statusCode}");
  //   if (response.statusCode == 200) {
  //     FlashCards.clear();
  //     Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);

  //     List temp1 = mapResponse["data"];
  //     int stsVal = mapResponse["status"];
  //     if (stsVal == 200) {
  //       print("stsValstsValstsVal=====200");
  //     } else {
  //       print("stsValstsValstsVal=====400");
  //     }
  //     print("temp list===$temp1");
  //     FlashCards = temp1.map((e) => FlashCardDetails.fromjson(e)).toList();

  //     print("FlashCards=========$FlashCards");

  //     try {
  //       HiveHandler.addFlash(FlashCards, KeyName: id.toString());

  //       Future.delayed(Duration(microseconds: 800), () {
  //         List<FlashCardDetails> tempList = HiveHandler.getflashCardsList(keyName: id.toString()) ?? [];
  //         print("*************************************************");
  //         FlashOfflineList = HiveHandler.getflashCardsList() ?? [];
  //         flashTempDisplay = HiveHandler.getflashCardsList() ?? [];
  //         print("tempList==========$tempList");
  //         print("FlashOfflineList==========$FlashOfflineList");
  //       });
  //     } catch (e) {
  //       print("errorr===========>>>>>>$e");
  //     }

  //     // final List<FlashCardDetails> storedFlashess =
  //     //         value.get("categoryKey");

  //     notifyListeners();

  //     if (FlashCards.isNotEmpty) {
  //       print("FlashCards 0=== ${FlashCards[0].title}");
  //     }
  //   }
  //   print("respponse=== ${response.body}");
  // }

  var valOfSuccess;
  Future<void> getTestDetails(int id) async {
    valOfSuccess = true;
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

    try {
      var response = await http.post(
        Uri.parse("http://3.227.35.115:1011/api/gettestDetails"),
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
        Uri.parse("http://3.227.35.115:1011/api/gettest"),
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
        Uri.parse("https://apivcarestage.vcareprojectmanagement.com/api/updateDeviceToken"),
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
}
