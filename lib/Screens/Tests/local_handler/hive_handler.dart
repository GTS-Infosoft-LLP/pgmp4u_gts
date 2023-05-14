import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/categorymodel.dart';

class HiveHandler {
  static const String userDataBox = "categoryData";
  static const String userDataBoxKey = "categoryKey";

  static Future hiveRegisterAdapter() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CategoryListModelAdapter());
    await Hive.openBox<List<CategoryListModel>>(userDataBox);
  }

  static addCategory(List<CategoryListModel> list) async {
    var _userBox = Hive.box<List<CategoryListModel>>(userDataBox);

    _userBox.put(userDataBoxKey, list);
  }

  static List<CategoryListModel> getCategoryList() {
    var userBox = Hive.box<List<CategoryListModel>>(userDataBox);
    List<CategoryListModel> categoryList = userBox.get(userDataBoxKey) ;
    return categoryList;
  }
}
