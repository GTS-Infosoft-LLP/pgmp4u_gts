import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  static const String CourseBox = "courseBox";
  static const String CourseKey = "courseKey";

  static const String FlashCateBox = "flashCateBox";

  static const String TestDataBox = "testListBox";
  static const String TestDataKey = "testListBox";

  static const String TestPercentBox = "testPercentBox";
  static const String TestPercentKey = "testPercentBox";

  static const String MockAttemptsBox = "moclAttemptBox";

  static Box<String> courseListBox;
  static Box<String> displayFlashBox;
  static Box<List<FlashCateDetails>> flashListCateBox;

  static Box<List<CategoryListModel>> categoryListBox;
  static Box<List<FlashCardDetails>> flashListBox;
  static Box<List<MasterDetails>> masterListBox;
  static Box<List<MockTestListApiModel>> MockListBox;
  static Box<List<QuestionAnswerModel>> MockTextBox;
  static Box<List<PracListModel>> PracTestBox;

  static Box<List<TestDataDetails>> TestPMListBox;
  static Box<List<MockPercentModel>> TestPercentListBox;

  static Box<List<MockDataDetails>> mockAttempList;

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

    courseListBox = await Hive.openBox<String>(CourseBox);
    displayFlashBox = await Hive.openBox<String>(FlashCardBox);
    flashListCateBox = await Hive.openBox<List<FlashCateDetails>>(FlashCateBox);
    categoryListBox = await Hive.openBox<List<CategoryListModel>>(userDataBox);
    // flashListBox = await Hive.openBox<List<FlashCardDetails>>(FlashCardBox);

    masterListBox = await Hive.openBox<List<MasterDetails>>(MasterDataBox);

    MockListBox = await Hive.openBox<List<MockTestListApiModel>>(MockTestBox);
    PracTestBox = await Hive.openBox<List<PracListModel>>(PracticeTestBox);

    TestPMListBox = await Hive.openBox<List<TestDataDetails>>(TestDataBox);

    mockAttempList = await Hive.openBox<List<MockDataDetails>>(MockAttemptsBox);

    await Hive.openBox("deviceTokenBox");

    await Hive.openBox("testPercentBox");
    await Hive.openBox("userDataBox");

    MockTextBox = await Hive.openBox<List<QuestionAnswerModel>>(MockQuesBox);
  }

//TestPercentListBox

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

  static addMockAttempt(dynamic value, String key) async {
    await Hive.openBox("MockAttemptsBox");
    final box = Hive.box("MockAttemptsBox");
    print("*********************************");
    print("incomimg valueeeeee=====>>>>$value");

    await box.put(key, jsonEncode(value));
    try {
      print("get boxxxxx=======${box.get(key, defaultValue: "")}");
    } catch (e) {
      print("errororor====$e");
    }
  }

  static Future<dynamic> getMockAttemptData({String key}) async {
    final box = Hive.box("MockAttemptsBox");
    return await box.get(key, defaultValue: "");
  }

  static ValueListenable getMockTestAttemptListener() {
    return Hive.box("MockAttemptsBox").listenable();
  }

/////////////
  static setMockData({dynamic value, String key}) async {
    await Hive.openBox("userDataBox");
    final box = Hive.box("userDataBox");
    print("*********************************");
    print("incomimg valueeeeee=====>>>>$value");

    await box.put(key, jsonEncode(value));
    try {
      print("get boxxxxx=======${box.get(key, defaultValue: "")}");
    } catch (e) {
      print("errororor====$e");
    }
  }

///////////////
  static Future<dynamic> getMockData({String key}) async {
    final box = Hive.box("userDataBox");
    return await box.get(key, defaultValue: "");
  }

  static ValueListenable getMockTestListener() {
    return Hive.box("userDataBox").listenable();
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

  static addTestMpData(List<TestDataDetails> list, String keyName) async {
    final Box<List<TestDataDetails>> testDataListBox = await Hive.openBox<List<TestDataDetails>>(TestDataBox);
    testDataListBox.put(keyName, list);
    if (testDataListBox.isNotEmpty) {
      print("===========added to box=========");
      print("testDataListBox.get${testDataListBox.get(keyName)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<List<TestDataDetails>>> getTestDataListener() {
    return Hive.box<List<TestDataDetails>>(TestDataBox).listenable();
  }

  static List<TestDataDetails> getTestDataList({String key}) {
    try {
      final List<TestDataDetails> storedTestData = TestPMListBox.get(key);
      print("storedFlashCateData list length ${storedTestData.length}");
      return storedTestData;
    } catch (e) {
      return [];
    }
  }

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

  static addFlashCateData(List<FlashCateDetails> list, String keyName) async {
    final Box<List<FlashCateDetails>> flashCateListBox = await Hive.openBox<List<FlashCateDetails>>(FlashCateBox);
    flashCateListBox.put(keyName, list);
    if (flashCateListBox.isNotEmpty) {
      print("===========added to box=========");
      print("flashCateListBox.get${flashCateListBox.get(keyName)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<List<FlashCateDetails>>> getFlashCateListener() {
    var listte = Hive.box<List<FlashCateDetails>>(FlashCateBox);
    print("getFlashCateListener=========>");

    print("listte=============${listte.listenable().runtimeType}");
    return Hive.box<List<FlashCateDetails>>(FlashCateBox).listenable();
  }

  static List<FlashCateDetails> getFlashCateDataList({String key}) {
    try {
      final List<FlashCateDetails> storedFlashCateData = flashListCateBox.get(key);
      print("storedFlashCateData list length ${storedFlashCateData.length}");
      return storedFlashCateData;
    } catch (e) {
      return [];
    }
  }

  static addMasterData(List<MasterDetails> list, {String keyName}) async {
    final Box<List<MasterDetails>> masterListBox = await Hive.openBox<List<MasterDetails>>(MasterDataBox);
    masterListBox.put(keyName, list);
    if (masterListBox.isNotEmpty) {
      print("===========added to box=========");
      print("masterListBox.get${masterListBox.get(keyName)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<List<MasterDetails>>> getMasterListener() {
    return Hive.box<List<MasterDetails>>(MasterDataBox).listenable() ?? [];
  }

  static List<MasterDetails> getMasterDataList({String key}) {
    try {
      final List<MasterDetails> storedMasterData = masterListBox.get(key);
      print("storedCategories list length ${storedMasterData.length}");
      return storedMasterData;
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
}
