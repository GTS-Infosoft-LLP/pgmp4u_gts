import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pgmp4u/Models/restartModel.dart';

import '../../../Models/mockListmodel.dart';
import '../../../Models/mockquestionanswermodel.dart';
import '../../MockTest/model/courseModel.dart';
import '../../MockTest/model/flashCardModel.dart';
import '../../MockTest/model/flashCateModel.dart';
import '../../MockTest/model/masterdataModel.dart';
import '../../MockTest/model/pracTestModel.dart';
import '../../MockTest/model/testDataModel.dart';
import '../../MockTest/model/testDetails.dart';
import '../model/categorymodel.dart';
import '../model/mock_test.dart';

class HiveHandler {
  static const String userDataBox = "categoryData";
  static const String userDataBoxKey = "categoryKey";

  static const String FlashCardBox = "flashData";
  static const String FlashDisplayBox = "flashDisplayBox";
  static const String FlashCardKey = "flashKey";

  static const String MockTestBox = "mockData";
  static const String MockTestKey = "mockKey";

  static const String PracticeTestBox = "practiceData";
  static const String PracticeTestKey = "practiceKey";

  static const String deviceTokenBox = "DeviceTokenBox";
  static const String deviceTokenKey = "deviceTokenKey";

  static const String MockQuesBox = "mockTestBox";
  static const String MockQuesKey = "mockTestKey";

  static const String MasterDataBox = "masterDataBox";
  static const String MasterDataKey = "masterDataKey";

  static const String MockRestartBoxKey = "mockRestartBox";
  static const String SubmitMockBoxKey = "mockSubmitBox";

  static const String CourseBox = "courseBox";
  static const String CourseKey = "courseKey";

  static const String FlashCateBox = "flashCateBox";

  static const String TestDataBox = "testListBox";
  static const String TestDataKey = "testListBox";

  static const String TestPercentBox = "testPercentBox";
  static const String TestPercentKey = "testPercentBox";

  static const String MockAttemptsBox = "moclAttemptBox";
  static const String MockQuestionBoxKey = "mockQuestionsBox";

  static Box<String> courseListBox;
  static Box<String> displayFlashBox;
  static Box<String> flashListCateBox;

  static Box<List<CategoryListModel>> categoryListBox;
  static Box<List<FlashCardDetails>> flashListBox;
  static Box<String> masterListBox;
  static Box<RestartModel> mockRestartBox;
  static Box<String> submitDataBox;

  static Box<List<MockTestListApiModel>> MockListBox;
  static Box<List<QuestionAnswerModel>> MockTextBox;
  static Box<String> MockQuestionBox;

  static Box<List<PracListModel>> PracTestBox;

  static Box<String> TestPMListBox;
  static Box<List<MockPercentModel>> TestPercentListBox;

  static Box<String> mockAttempList;

//MockPercentModel
  static Future hiveRegisterAdapter() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CategoryListModelAdapter());
    Hive.registerAdapter(FlashCardDetailsAdapter());
    Hive.registerAdapter(MasterDetailsAdapter());
    Hive.registerAdapter(MockTestListApiModelAdapter());
    Hive.registerAdapter(QuestionAnswerModelAdapter());
    Hive.registerAdapter(PracListModelAdapter());
    Hive.registerAdapter(CourseDetailsAdapter());
    Hive.registerAdapter(FlashCateDetailsAdapter());

    Hive.registerAdapter(TestDataDetailsAdapter());
    Hive.registerAdapter(MockDataDetailsAdapter());
    Hive.registerAdapter(RestartModelAdapter());

    courseListBox = await Hive.openBox<String>(CourseBox);
    displayFlashBox = await Hive.openBox<String>(FlashCardBox);
    flashListCateBox = await Hive.openBox<String>(FlashCateBox);
    categoryListBox = await Hive.openBox<List<CategoryListModel>>(userDataBox);
    // flashListBox = await Hive.openBox<List<FlashCardDetails>>(FlashCardBox);

    masterListBox = await Hive.openBox<String>(MasterDataBox);
    submitDataBox = await Hive.openBox<String>(SubmitMockBoxKey);

    // MockListBox = await Hive.openBox<List<MockTestListApiModel>>(MockTestBox);

    MockQuestionBox = await Hive.openBox<String>(MockQuestionBoxKey);
    PracTestBox = await Hive.openBox<List<PracListModel>>(PracticeTestBox);

    TestPMListBox = await Hive.openBox<String>(TestDataBox);

    mockAttempList = await Hive.openBox<String>(MockAttemptsBox);

    mockRestartBox = await Hive.openBox<RestartModel>(MockRestartBoxKey);

    await Hive.openBox("deviceTokenBox");

    await Hive.openBox("testPercentBox");
    await Hive.openBox("userDataBox");

    MockTextBox = await Hive.openBox<List<QuestionAnswerModel>>(MockQuesBox);
  }

  // TestPercentListBox start

  static setMockPercentdata({dynamic value, String key}) async {
    final box = Hive.box("testPercentBox");
    print("*********************************");
    print("incomimg valueeeeee=====>>>>$value");

    await box.put(key, jsonEncode(value));
  }

  static ValueListenable getMockPercentListener() {
    return Hive.box("testPercentBox").listenable();
  }

  static Future<dynamic> getMockTestPercent({String key}) async {
    final box = Hive.box("testPercentBox");
    return await box.get(key, defaultValue: "");
  }

  /// TestPercentListBox end

  static setstringdata({dynamic value, String key}) async {
    final box = Hive.box("deviceTokenBox");
    print("*********************************");
    print("incomimg valueeeeee=====>>>>$value");

    await box.put(key, jsonEncode(value));
  }

  // static setMockTestPercent({dynamic value, String key}) async {
  //   final box = Hive.box("categoryData");
  //   print("*********************************");
  //   print("incomimg valueeeeee=====>>>>$value");
  //   await box.put(key, jsonEncode(value));
  // }

  // static ValueListenable getMockPercentListener() {
  //   return Hive.box("categoryData").listenable();
  // }

  // static ValueListenable<Box<List<MockDataDetails>>> getMockAttemptListener() {
  //   return Hive.box<List<MockDataDetails>>(MockAttemptsBox).listenable();
  // }

  // static List<MockDataDetails> getMockAttemptList({String key}) {
  //   try {
  //     final List<MockDataDetails> storedMockAttemptData = mockAttempList.get(key);
  //     print("storedMockAttemptData list length ${storedMockAttemptData.length}");
  //     return storedMockAttemptData;
  //   } catch (e) {
  //     return [];
  //   }
  // }

  static Future<dynamic> getstringdata({String key}) async {
    final box = Hive.box("deviceTokenBox");
    return await box.get(key, defaultValue: "");
  }

  static ValueListenable getPracTestListener() {
    return Hive.box("deviceTokenBox").listenable();
  }

  //// mock attempt start

  static addMockAttempt(String mockAttempts, String key) async {
    print("incomimg valueeeeee=====>>>>$mockAttempts");

    mockAttempList.put(key, mockAttempts);
    if (mockAttempList.containsKey(key)) {
      print("===========added to box=========");
      print("mockAttempList.get  key: $key, Data: ${mockAttempList.get(key)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static Future<String> getMockAttemptData({String key}) async {
    return mockAttempList.get(key, defaultValue: "");
  }

  static ValueListenable<Box<String>> getMockTestAttemptListener() {
    return Hive.box<String>(MockAttemptsBox).listenable() ?? "";
  }

  //// mock attempt end

/////////////
  static setMockData({String value, String key}) async {
    // await Hive.openBox("userDataBox");
    // final box = Hive.box("userDataBox");

    MockQuestionBox.put(key, value);
    if (MockQuestionBox.containsKey(key)) {
      print("===========added to box=========");
      print("MockQuestionBox.get  Key: $key, Data:${MockQuestionBox.get(key)}");
    } else {
      print("===========box is empty=========");
    }
  }

// ///////////////
//   static Future<dynamic> getMockData({String key}) async {
//     final box = Hive.box("userDataBox");
//     return await box.get(key, defaultValue: "");
//   }

  static ValueListenable<Box<String>> getMockTestListener() {
    return Hive.box<String>(MockQuestionBoxKey).listenable() ?? '';
  }

  // static addPract(List<PracListModel> list) async {
  //   final Box<List<PracListModel>> practiceTestBox = await Hive.openBox<List<PracListModel>>(PracticeTestBox);
  //   practiceTestBox.put(PracticeTestKey, list);

  //   try {
  //     final List<PracListModel> storedPracti = PracTestBox.get(PracticeTestKey);
  //     print("storedPracti list length ${storedPracti.length}");
  //     return storedPracti;
  //   } catch (e) {
  //     return [];
  //   }
  // }

  static addCategory(List<CategoryListModel> list) async {
    final Box<List<CategoryListModel>> categoryListBox = await Hive.openBox<List<CategoryListModel>>(userDataBox);
    categoryListBox.put(userDataBoxKey, list);
  }

  static ValueListenable<Box<List<CategoryListModel>>> getCategoryListener() {
    return Hive.box<List<CategoryListModel>>(userDataBox).listenable();
  }

  static List<CategoryListModel> getCategoryList() {
    try {
      final List<CategoryListModel> storedCategories = categoryListBox.get(userDataBoxKey);
      print("storedCategories list length ${storedCategories.length}");
      return storedCategories;
    } catch (e) {
      return [];
    }
  }

  static addPracTest(List<PracTestModel> list) async {
    final Box<List<PracTestModel>> pracListBox = await Hive.openBox<List<PracTestModel>>(PracticeTestBox);
    pracListBox.put(PracticeTestKey, list);
  }

  static ValueListenable<Box<List<PracTestModel>>> getPracListener() {
    return Hive.box<List<PracTestModel>>(PracticeTestBox).listenable();
  }

  // static addCourseData(List<CourseDetails> list) async {
  //   final Box<List<CourseDetails>> courseListBox = await Hive.openBox<List<CourseDetails>>(CourseBox);
  //   courseListBox.put(CourseKey, list);

  //   if (courseListBox.isNotEmpty) {
  //     print("===========added to box=========");
  //     print("courseListBox.get ${courseListBox.get(CourseKey)}");
  //   } else {
  //     print("===========box is empty=========");
  //   }
  // }

  // static ValueListenable<Box<List<CourseDetails>>> getCourseListener() {
  //   return Hive.box<List<CourseDetails>>(CourseBox).listenable() ?? [];
  // }

  // static List<CourseDetails> getCourseDataList() {
  //   List<CourseDetails> storedCourseData;

  //   try {
  //     storedCourseData = courseListBox.get(CourseKey);

  //     print("storedCourseData list length ${storedCourseData.length}");
  //     return storedCourseData;
  //   } catch (e) {
  //     print("----- Exception Occured while getting getCourseDataList -----");
  //     print(e.toString());
  //     return [];
  //   }
  // }

  static addFlashDisplayData(String flashListResponse, String key) async {
    displayFlashBox.put(key, flashListResponse);

    if (displayFlashBox.containsKey(key)) {
      print("===========added to box=========");
      print("displayFlashBox.get ${displayFlashBox.get(key)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<String>> getDisplayFlashListener() {
    return Hive.box<String>(FlashCardBox).listenable() ?? "";
  }

  ///// cousers data end
  static addCourseData(String courseListResponse) async {
    // final Box<List<CourseDetails>> courseListBox = await Hive.openBox<List<CourseDetails>>(CourseBox);
    courseListBox.put(CourseKey, courseListResponse);

    if (courseListBox.isNotEmpty) {
      print("===========added to box=========");
      print("courseListBox.get ${courseListBox.get(CourseKey)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<String>> getCourseListener() {
    return Hive.box<String>(CourseBox).listenable() ?? "";
  }

  static List<CourseDetails> getCourseDataList() {
    List<CourseDetails> storedCourseData = [];

    try {
      String courseData = courseListBox.get(CourseKey);
      print(" >> courseData :  $courseData");
      List courselist = jsonDecode(courseData);

      storedCourseData = courselist.map((e) => CourseDetails.fromjson(e)).toList();
      print(" >> couserList : $storedCourseData");

      // storedCourseData =
      print("storedCourseData list length ${storedCourseData.length}");
      return storedCourseData;
    } catch (e) {
      print("----- Exception Occured while getting getCourseDataList -----");
      print(e.toString());
      return storedCourseData;
    }
  }

  ///// cousers data end

  ////// master data start
  ///
  ///
  ///
  static setSubmitMockData(String mockId, String data) {
    submitDataBox.put(mockId, data);
    print("datata====>$data");
    if (submitDataBox.isNotEmpty) {
      print("===========added to box=========");
      print("submitDataBox.get for key: $mockId = ${submitDataBox.get(mockId)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static removeFromSubmitMockBox(String mockId) {
    // mockRestartBox.put(mockId, atemNum);

    if (submitDataBox.isNotEmpty) {
      if (submitDataBox.containsKey(mockId)) {
        submitDataBox.delete(mockId);
      }
    } else {
      print("===========box is empty=========");
    }
  }

  static addToRestartBox(String mockId, RestartModel restartModel) {
    mockRestartBox.put(mockId, restartModel);

    if (mockRestartBox.isNotEmpty) {
      print("===========added to box=========");
      print("mockRestartBox.get for key: $mockId = ${mockRestartBox.get(mockId)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static removeFromRestartBox(String mockId) {
    // mockRestartBox.put(mockId, atemNum);

    if (mockRestartBox.isNotEmpty) {
      if (mockRestartBox.containsKey(mockId)) {
        mockRestartBox.delete(mockId);
      }
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<RestartModel>> getMockRestartListener() {
    return Hive.box<RestartModel>(MockRestartBoxKey).listenable();
  }

  static addMasterData(String masterListResponse, {String keyName}) async {
    masterListBox.put(keyName, masterListResponse);

    if (masterListBox.isNotEmpty) {
      print("===========added to box=========");
      print("masterListBox.get for key: $keyName = ${masterListBox.get(keyName)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<String>> getMasterListener() {
    return Hive.box<String>(MasterDataBox).listenable() ?? '';
  }

  static List<MasterDetails> getMasterDataList({String key}) {
    List<MasterDetails> storedMasterData = [];

    try {
      String masterData = masterListBox.get(key);
      print(" >> courseData :  $masterData");
      List masterList = jsonDecode(masterData);

      storedMasterData = masterList.map((e) => MasterDetails.fromjson(e)).toList();
      print(" >> couserList : $storedMasterData");

      // storedCourseData =
      print("storedMasterData list length ${storedMasterData.length}");
      return storedMasterData;
    } catch (e) {
      print("----- Exception Occured while getting getMasterDataList -----");
      print(e.toString());
      return storedMasterData;
    }
  }

  // static List<TestDataDetails> getTestDataList({String key}) {
  //   try {
  //     final List<TestDataDetails> storedTestData = TestPMListBox.get(key);
  //     print("storedFlashCateData list length ${storedTestData.length}");
  //     return storedTestData;
  //   } catch (e) {
  //     return [];
  //   }
  // }

  static setFlashCateData({dynamic value, String Key}) async {
    await Hive.openBox(FlashCateBox);
    final box = Hive.box(FlashCateBox);
    print("incomimg valueeeeee=====>>>>$value");
    await box.put(Key, jsonEncode(value));
    try {
      print("get boxxxxx=======${box.get(Key, defaultValue: "")}");
    } catch (e) {
      print("errororor====$e");
    }
  }

  ///// master data end

  ///// mock test data start
  static addTestMpData(String mockTestsList, String keyName) async {
    TestPMListBox.put(keyName, mockTestsList);
    if (TestPMListBox.isNotEmpty) {
      print("===========added to box=========");
      print("testDataListBox.get Key: $keyName , Data: ${TestPMListBox.get(keyName)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<String>> getTestDataListener() {
    return Hive.box<String>(TestDataBox).listenable();
  }

  static List<TestDataDetails> getTestDataList({String key}) {
    List<TestDataDetails> storedTestData = [];

    try {
      String testData = TestPMListBox.get(key);
      print(" >> testData :  $testData");
      List testsList = jsonDecode(testData);

      storedTestData = testsList.map((e) => TestDataDetails.fromjson(e)).toList();
      print(" >> couserList : $storedTestData");

      // storedCourseData =
      print("storedCourseData list length ${storedTestData.length}");
      return storedTestData;
    } catch (e) {
      print("----- Exception Occured while getting getCourseDataList -----");
      print(e.toString());
      return storedTestData;
    }
  }

  ///// mock test data end

  static addFlashCateData(String flashCardData, String keyName) async {
    flashListCateBox.put(keyName, flashCardData);

    if (flashListCateBox.containsKey(keyName)) {
      print("===========added to box=========");
      print("flashCateListBox.get Key: $keyName  ,Data: ${flashListCateBox.get(keyName)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<String>> getFlashCateListener() {
    return Hive.box<String>(FlashCateBox).listenable() ?? "";
  }

  static List<FlashCateDetails> getFlashCateDataList({String key}) {
    try {
      // final List<FlashCateDetails> storedFlashCateData = flashListCateBox.get(key);
      // print("storedFlashCateData list length ${storedFlashCateData.length}");
      // return storedFlashCateData;
    } catch (e) {
      return [];
    }
  }

  static addFlash(List<FlashCardDetails> list, {String KeyName}) async {
    final Box<List<FlashCardDetails>> flashListBox = await Hive.openBox<List<FlashCardDetails>>(FlashCardBox);
    flashListBox.put(KeyName, list);
    if (flashListBox.isNotEmpty) {
      print("===========added to box=========");
      print("flashListBox.get${flashListBox.get(KeyName)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<List<FlashCardDetails>>> getFlashListener() {
    return Hive.box<List<FlashCardDetails>>(FlashCardBox).listenable();
  }

  static List<FlashCardDetails> getflashCardsList({String keyName}) {
    try {
      final List<FlashCardDetails> storedflash = flashListBox.get(keyName);
      print("storedCategories list length ${storedflash.length}");
      return storedflash;
    } catch (e) {
      return [];
    }
  }

  static setDeviceToken(String val) async {
    var _userBox = Hive.box(deviceTokenBox);
    await _userBox.put(deviceTokenKey, val);
  }

  static Future<String> getDeviceToken() async {
    var _userBox = Hive.box(deviceTokenBox);
    return _userBox.get(deviceTokenKey).toString();
  }


  static void clearUser() {
    var _userBox = Hive.box(userDataBox);    
    _userBox.clear();
  }



}
