import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../model/categorymodel.dart';

class HiveHandler {
  static const String userDataBox = "categoryData";
  static const String userDataBoxKey = "categoryKey";
  static Box<List<CategoryListModel>> categoryListBox;

  static Future hiveRegisterAdapter() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CategoryListModelAdapter());
    categoryListBox =await Hive.openBox<List<CategoryListModel>>(userDataBox);
  
    // await Hive.openBox<List<CategoryListModel>>(userDataBox);
    
  }

  static addCategory(List<CategoryListModel> list) async {
    final Box<List<CategoryListModel>> categoryListBox = await Hive.openBox<List<CategoryListModel>>(userDataBox);
    categoryListBox.put(userDataBoxKey, list);
  }

    static ValueListenable<Box<List<CategoryListModel>>> getCategoryListener() {
    return Hive.box<List<CategoryListModel>>(userDataBox).listenable();
  }



  static List<CategoryListModel> getCategoryList() {
    try{
    final List<CategoryListModel> storedCategories = categoryListBox.get(userDataBoxKey);
    print("storedCategories list length ${storedCategories.length}");
    return storedCategories;
    }catch(e){
        return [];
    }
    
  }
}
