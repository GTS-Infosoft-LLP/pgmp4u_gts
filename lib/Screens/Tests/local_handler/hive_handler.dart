import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../Models/mockquestionanswermodel.dart';
import '../../MockTest/model/courseModel.dart';
import '../../MockTest/model/flashCardModel.dart';
import '../../MockTest/model/flashCateModel.dart';
import '../../MockTest/model/masterdataModel.dart';
import '../../MockTest/model/pracTestModel.dart';
import '../model/categorymodel.dart';
import '../model/mock_test.dart';

class HiveHandler {
  static const String userDataBox = "categoryData";
  static const String userDataBoxKey = "categoryKey";

  static const String FlashCardBox = "flashData";
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

  static Box<List<CourseDetails>> courseListBox;
  static Box<List<FlashCateDetails>> flashListCateBox;

  static Box<List<CategoryListModel>> categoryListBox;
  static Box<List<FlashCardDetails>> flashListBox;
  static Box<List<MasterDetails>> masterListBox;
  static Box<List<MockTestListApiModel>> MockListBox;
  static Box<List<QuestionAnswerModel>> MockTextBox;
  static Box<List<PracListModel>> PracTestBox;

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

    courseListBox = await Hive.openBox<List<CourseDetails>>(CourseBox);
    flashListCateBox = await Hive.openBox<List<FlashCateDetails>>(FlashCateBox);
    categoryListBox = await Hive.openBox<List<CategoryListModel>>(userDataBox);
    flashListBox = await Hive.openBox<List<FlashCardDetails>>(FlashCardBox);

    masterListBox = await Hive.openBox<List<MasterDetails>>(MasterDataBox);

    MockListBox = await Hive.openBox<List<MockTestListApiModel>>(MockTestBox);
    PracTestBox = await Hive.openBox<List<PracListModel>>(PracticeTestBox);

    await Hive.openBox("deviceTokenBox");
    MockTextBox = await Hive.openBox<List<QuestionAnswerModel>>(MockQuesBox);
  }

  static setstringdata({dynamic value, String key}) async {
    final box = Hive.box("deviceTokenBox");
    print("*********************************");
    print("incomimg valueeeeee=====>>>>$value");

    await box.put(key, jsonEncode(value));
  }

  static Future<dynamic> getstringdata({String key}) async {
    final box = Hive.box("deviceTokenBox");
    return await box.get(key, defaultValue: "");
  }

  static ValueListenable getPracTestListener() {
    return Hive.box("deviceTokenBox").listenable();
  }

  static setMockData({dynamic value, String key}) async {
    final box = Hive.box("userDataBox");
    print("*********************************");
    print("incomimg valueeeeee=====>>>>$value");

    await box.put(key, jsonEncode(value));
  }

  static Future<dynamic> getMockData({String key}) async {
    final box = Hive.box("userDataBox");
    return await box.get(key, defaultValue: "");
  }

  static ValueListenable getMockTestListener() {
    return Hive.box("userDataBox").listenable();
  }

  static addPract(List<PracListModel> list) async {
    final Box<List<PracListModel>> practiceTestBox = await Hive.openBox<List<PracListModel>>(PracticeTestBox);
    practiceTestBox.put(PracticeTestKey, list);

    try {
      final List<PracListModel> storedPracti = PracTestBox.get(PracticeTestKey);
      print("storedPracti list length ${storedPracti.length}");
      return storedPracti;
    } catch (e) {
      return [];
    }
  }

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

  static addCourseData(List<CourseDetails> list) async {
    final Box<List<CourseDetails>> courseListBox = await Hive.openBox<List<CourseDetails>>(CourseBox);
    courseListBox.put(CourseKey, list);
    if (courseListBox.isNotEmpty) {
      print("===========added to box=========");
      print("courseListBox.get${courseListBox.get(CourseKey)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<List<CourseDetails>>> getCourseListener() {
    return Hive.box<List<CourseDetails>>(CourseBox).listenable();
  }

  static List<CourseDetails> getCourseDataList() {
    try {
      final List<CourseDetails> storedCourseData = courseListBox.get(CourseKey);
      print("storedCourseData list length ${storedCourseData.length}");
      return storedCourseData;
    } catch (e) {
      return [];
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
    return Hive.box<List<MasterDetails>>(MasterDataBox).listenable();
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

  static addFlash(List<FlashCardDetails> list,{String KeyName}) async {
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

  static List<FlashCardDetails> getflashCardsList({ String keyName}) {
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
