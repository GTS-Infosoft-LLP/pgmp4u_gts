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
  List<MasterDetails> masterList = [];
  List<CourseDetails> course = [];
  List<VideoCateDetails> videoCate = [];
  List<VideoDetails> Videos = [];
  List<FlashCateDetails> flashCate = [];
  List<FlashCardDetails> FlashCards = [];

  List<FlashCardDetails> FlashOfflineList = [];

  List<TestDetails> testDetails = [];
  List<TestDataDetails> testData = [];

  // const _BASE_URL ="https://apivcarestage.vcareprojectmanagement.com/api/";

  int videoPresent = 1;

  int selectedCourseId;
  int selectedMasterId;

  int selectedFlashCategory;
  String selectedCourseName;

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

  List<MasterDetails> masterTemp = [];
  Future<void> getMasterData(int id) async {
    print("idddd=========>>>>>>>>>>>>>>>$id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

    var response = await http
        .post(
      Uri.parse("http://3.227.35.115:1011/api/getMasterData"),
      headers: {"Content-Type": "application/json", 'Authorization': stringValue},
      body: json.encode(request),
    )
        .onError((error, stackTrace) {
      print("errore======>>>>$error");
      masterTemp = [];
      return;
    });

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
      masterList.clear();
      Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);

      List temp1 = mapResponse["data"];
      print("temp list===$temp1");
      masterList = temp1.map((e) => MasterDetails.fromjson(e)).toList();
      print("master list=========$masterList");

      if (masterList.isNotEmpty) {
        try {
          print("id.toString=====${id.toString}");
          HiveHandler.addMasterData(masterList, keyName: id.toString());

          Future.delayed(Duration(microseconds: 800), () {
            List<MasterDetails> tempList = HiveHandler.getMasterDataList(key: id.toString()) ?? [];

            masterTemp = HiveHandler.getMasterDataList(key: id.toString()) ?? [];
            print("*************************************************");
            print("tempList==========$tempList");
          });
        } catch (e) {
          print("errorr===========>>>>>>$e");
        }
      }

      notifyListeners();

      if (masterList.isNotEmpty) {
        print("masterList 0=== ${masterList[0].name}");
      }
    }
    print("respponse=== ${response.body}");
  }

  List<FlashCateDetails> flashCateTempList = [];
  Future<void> getFlashCate(int id) async {
    print("flash category iddd=====$id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

    var response = await http
        .post(
      Uri.parse("http://3.227.35.115:1011/api/getFlashCategories"),
      headers: {"Content-Type": "application/json", 'Authorization': stringValue},
      body: json.encode(request),
    )
        .onError((error, stackTrace) {
      print("error========>>$error");
      flashCateTempList = [];
      // return;
    });

    print("response.statusCode===${response.statusCode}");
    if (response.statusCode == 200) {
      flashCate.clear();
      Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
      print("mapResponse=========$mapResponse");
      if (mapResponse["status"] == 400) {
        flashCate = [];
        notifyListeners();
        return;
      } else {
        List temp1 = mapResponse["data"];
        print("temp list===$temp1");
        flashCate = temp1.map((e) => FlashCateDetails.fromjson(e)).toList();

        print("flashCate================${flashCate.length}");

        try {
          HiveHandler.addFlashCateData(flashCate, id.toString());

          Future.delayed(Duration(microseconds: 800), () {
            List<FlashCateDetails> tempList = HiveHandler.getFlashCateDataList(key: id.toString()) ?? [];
            flashCateTempList = HiveHandler.getFlashCateDataList(key: id.toString()) ?? [];
            print("*************************************************");
            print("tempList==========$flashCateTempList");
          });
        } catch (e) {
          print("errorr===========>>>>>>$e");
        }

        notifyListeners();

        if (flashCate.isNotEmpty) {
          print("flashCate name 0=== ${flashCate[0].name}");
        }
      }
    }
    print("respponse=== ${response.body}");
  }

  Future<void> getVideoCate(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

    var response = await http.post(
      Uri.parse("http://3.227.35.115:1011/api/getVideoCategories"),
      headers: {"Content-Type": "application/json", 'Authorization': stringValue},
      body: json.encode(request),
    );

    print("http://3.227.35.115:1011/api/getVideoCategories");
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

  List<CourseDetails> tempList = [];
  Future<void> getCourse() async {
    print("getCourse api calllllllll");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");

    var response = await http.get(
      Uri.parse("http://3.227.35.115:1011/api/getCourse"),
      headers: {"Content-Type": "application/json", 'Authorization': stringValue},
    ).onError((error, stackTrace) {
      print("error====>>$error");
      tempList = [];
    });

    print("response.statusCode===${response.statusCode}");
    if (response.statusCode == 200) {
      course.clear();
      Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
      List temp1 = mapResponse["data"];
      print("temp list===$temp1");
      course = temp1.map((e) => CourseDetails.fromjson(e)).toList();

      try {
        // print("id.toString=====${id.toString}");
        HiveHandler.addCourseData(course);

        Future.delayed(Duration(microseconds: 800), () {
          tempList = HiveHandler.getCourseDataList();

          notifyListeners();
          print("*************************************************");
          print("tempList==========$tempList");
        });
      } catch (e) {
        print("errorr===========>>>>>>$e");
      }

      notifyListeners();
      print("course lkengrtht=====${course.length}");
      if (course.isNotEmpty) {
        print("course 0=== ${course[0].description}");
      }
    }
    print("respponse=== ${response.body}");
  }

  Future<void> getVideos(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

    var response = await http.post(
      Uri.parse("http://3.227.35.115:1011/api/getVideos"),
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

  List<FlashCardDetails> flashTemp = [];
  Future<void> getFlashCards(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

    var response = await http
        .post(
      Uri.parse("http://3.227.35.115:1011/api/getFlashCards"),
      headers: {"Content-Type": "application/json", 'Authorization': stringValue},
      body: json.encode(request),
    )
        .onError((error, stackTrace) {
      print("erroeee===>>$error");
      flashTemp = [];
    });

    var resDDo = json.decode(response.body);
    var resStatus = (resDDo["status"]);
    videoPresent = 1;
    if (resStatus == 400) {
      FlashCards = [];
      // videoPresent = 0;

      notifyListeners();
      return;
    }

    print("response.statusCode===${response.statusCode}");
    if (response.statusCode == 200) {
      FlashCards.clear();
      Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);

      List temp1 = mapResponse["data"];
      print("temp list===$temp1");
      FlashCards = temp1.map((e) => FlashCardDetails.fromjson(e)).toList();

      print("FlashCards=========$FlashCards");

      try {
        HiveHandler.addFlash(FlashCards, KeyName: id.toString());

        Future.delayed(Duration(microseconds: 800), () {
          List<FlashCardDetails> tempList = HiveHandler.getflashCardsList(keyName: id.toString()) ?? [];
          print("*************************************************");
          FlashOfflineList = HiveHandler.getflashCardsList() ?? [];
          flashTemp = HiveHandler.getflashCardsList() ?? [];
          print("tempList==========$tempList");
          print("FlashOfflineList==========$FlashOfflineList");
        });
      } catch (e) {
        print("errorr===========>>>>>>$e");
      }

      // final List<FlashCardDetails> storedFlashess =
      //         value.get("categoryKey");

      notifyListeners();

      if (FlashCards.isNotEmpty) {
        print("FlashCards 0=== ${FlashCards[0].title}");
      }
    }
    print("respponse=== ${response.body}");
  }

  Future<void> getTestDetails(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

    var response = await http.post(
      Uri.parse("http://3.227.35.115:1011/api/gettestDetails"),
      headers: {"Content-Type": "application/json", 'Authorization': stringValue},
      body: json.encode(request),
    );

    print("response.statusCode===${response.statusCode}");
    if (response.statusCode == 200) {
      testDetails.clear();
      Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);

      List temp1 = mapResponse["data"]["list"];
      print("temp list===$temp1");
      testDetails = temp1.map((e) => TestDetails.fromjson(e)).toList();

      notifyListeners();

      if (FlashCards.isNotEmpty) {
        print("testDetails 0=== ${testDetails[0].testName}");
      }
    }
    print("respponse=== ${response.body}");
  }

  List<TestDataDetails> testListTemp = [];
  Future<void> getTest(int id) async {
    print("id valueeee===========>>>>>>>>>>>$id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

    var response = await http
        .post(
      Uri.parse("http://3.227.35.115:1011/api/gettest"),
      headers: {"Content-Type": "application/json", 'Authorization': stringValue},
      body: json.encode(request),
    )
        .onError((error, stackTrace) {
      print("erroroe=====>>>>>$error");
      testListTemp = [];
    });

    print("response.statusCode===${response.statusCode}");
    if (response.statusCode == 200) {
      testData.clear();
      Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);

      print("mapResponse===========$mapResponse");

      if (mapResponse["status"] == 400) {
        testData = [];
        notifyListeners();
      } else {
        List temp1 = mapResponse["data"];
        print("temp list===$temp1");
        testData = temp1.map((e) => TestDataDetails.fromjson(e)).toList();

        try {
          HiveHandler.addTestMpData(testData, id.toString());

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
      }
    }
    print("respponse=== ${response.body}");
  }

  Future<void> updateDeviceToken(String Devtoken) async {
    print("=======================device tokwn=====>$Devtoken");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"deviceToken": Devtoken};

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
  }

  MockData mockData;
  Future apiCall(int selectedIdNew) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    http.Response response;
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
      notifyListeners();
    }
  }
}
