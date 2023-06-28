import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../Models/mockquestionanswermodel.dart';
import '../../MockTest/model/flashCardModel.dart';
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

  static Box<List<CategoryListModel>> categoryListBox;
  static Box<List<FlashCardDetails>> flashListBox;
  static Box<List<MockTestListApiModel>> MockListBox;


  static Box<List<QuestionAnswerModel>> MockTextBox;

  static Future hiveRegisterAdapter() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CategoryListModelAdapter());
    Hive.registerAdapter(FlashCardDetailsAdapter());
    Hive.registerAdapter(MockTestListApiModelAdapter());
    Hive.registerAdapter(QuestionAnswerModelAdapter());
;

    categoryListBox = await Hive.openBox<List<CategoryListModel>>(userDataBox);
    flashListBox = await Hive.openBox<List<FlashCardDetails>>(FlashCardBox);
    MockListBox = await Hive.openBox<List<MockTestListApiModel>>(MockTestBox);

    await Hive.openBox("deviceTokenBox");
    MockTextBox = await Hive.openBox<List<QuestionAnswerModel>>(MockQuesBox);
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

  // static List<PracTestModel> getPracTestList() {
  //   try {
  //     final List<PracTestModel> storedPracTest = PracticeListBox.get(PracticeTestKey);
  //     print("storedCategories list length ${storedPracTest.length}");
  //     return storedPracTest;
  //   } catch (e) {
  //     return [];
  //   }
  // }

  static addFlash(List<FlashCardDetails> list) async {
    final Box<List<FlashCardDetails>> flashListBox = await Hive.openBox<List<FlashCardDetails>>(FlashCardBox);
    flashListBox.put(FlashCardKey, list);
    if (flashListBox.isNotEmpty) {
      print("===========added to box=========");
      print("flashListBox.get${flashListBox.get(FlashCardKey)}");
    } else {
      print("===========box is empty=========");
    }
  }

  static ValueListenable<Box<List<FlashCardDetails>>> getFlashListener() {
    return Hive.box<List<FlashCardDetails>>(FlashCardBox).listenable();
  }

  static List<FlashCardDetails> getflashCardsList() {
    try {
      final List<FlashCardDetails> storedflash = flashListBox.get(FlashCardKey);
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
