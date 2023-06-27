import 'package:flutter/material.dart';
import 'package:pgmp4u/Models/category.dart';
import 'package:pgmp4u/Screens/Tests/api/call_api.dart';
import 'package:pgmp4u/Screens/Tests/local_handler/hive_handler.dart';
import 'package:pgmp4u/Screens/Tests/model/sub_category_model.dart';

import '../model/categorymodel.dart';
import '../model/mock_test.dart';
import '../model/practice_test.dart';
import '../model/videos_model.dart';

class CategoryProvider extends ChangeNotifier {
  List<CategoryListModel> categoryList = [];
  List<SubCategoryListModel> subCategoryList = [];

  /// data
  List<MockTestListApiModel> mockList = [];
  List<VideosListApiModel> videosList = [];
  List<PracticeListModel> practiceQuestion = [];

  ApiController controller = ApiController();
  bool loader = false;
  bool subCategoryLoader = false;
  bool detailsLoader = false;

  int subCategoryId;
  String type;

  updateIds(int id, String tpe) {
    subCategoryId = id;
    type = tpe;
    Future.delayed(Duration(seconds: 0), () {
      notifyListeners();
    });
  }

  updateLoader(bool val) {
    loader = val;
    Future.delayed(Duration(seconds: 0), () {
      notifyListeners();
    });
  }

  updateSubLoader(bool val) {
    subCategoryLoader = val;
    Future.delayed(Duration(seconds: 0), () {
      notifyListeners();
    });
  }

  updatedetailsLoader(bool val) {
    detailsLoader = val;
    Future.delayed(Duration(seconds: 0), () {
      notifyListeners();
    });
  }

   checkLocalDataAvaialble()async {
    updateLoader(true);
    List<CategoryListModel> tempList=HiveHandler.getCategoryList() ?? [];
    if ( tempList.isNotEmpty) {
      categoryList = tempList;
      Future.delayed(Duration(seconds: 1),(){
          notifyListeners();
      });
    
      updateLoader(false);
    }
  }


  updatePlayValue(int index){
    videosList[index].isShowPlay=!videosList[index].isShowPlay;
    Future.delayed(Duration(seconds: 0),(){
          notifyListeners();
    });
  
  }

  Future callGetCategory() async {
    // updateLoader(true);
    await controller.callGetCategoryApi().then((value) {
      if (value != null) {
        CategoryApiModel categoryApiModel = CategoryApiModel.fromJson(value.data);
        categoryList = categoryApiModel.categoryList;
        HiveHandler.addCategory(categoryList);
       
        print("CategoryList ${categoryList.length}");
        notifyListeners();
      }
    }).whenComplete(() {
      updateLoader(false);
    });
    // .onError((error, stackTrace) {
    //   updateLoader(false);
    // });
    notifyListeners();
  }

  Future callGetSubCateogory({int id, String type}) async {
    subCategoryList = [];
    updateSubLoader(true);
    print("call data ");
    await controller.getSubCategory(id: id, type: type).then((value) {
      if (value != null) {
        SubCategoryApiModel categoryApiModel =
            SubCategoryApiModel.formJson(value.data);
        subCategoryList = categoryApiModel.subCateogyList;
        print("subCategoryList ${subCategoryList.length}");
        notifyListeners();
      }

      updateSubLoader(false);
    }).whenComplete(() {
      updateSubLoader(false);
    }).onError((error, stackTrace) {
      updateSubLoader(false);
    });
    notifyListeners();
  }


    Future getSubCategoryDetials(int id,String type) async {
      mockList=[];
      videosList=[];
      practiceQuestion=[];
      
      updatedetailsLoader(true);
      print("call data ");
       await controller.getSubCategoryDetail(
        id: id,
        type: type
       ).then((value) {
         if(value!=null){
            switch(type){
              case "Practice Test":
              PracticeApiModel practiceApiModel=PracticeApiModel.fromJson(value.data);
              practiceQuestion=practiceApiModel.list;
              break;
              case "Videos":
              VideoApiModel practiceApiModel=VideoApiModel.fromJson(value.data);
              videosList=practiceApiModel.videolist;
              break;
              
              case "Mock Test":
              MocktestApiModelList practiceApiModel=MocktestApiModelList.fromJson(value.data);
              mockList=practiceApiModel.mockList;
              break;

            }

            notifyListeners();
          }

      updatedetailsLoader(false);
    }).whenComplete(() {
      updatedetailsLoader(false);
    }).onError((error, stackTrace) {
      updatedetailsLoader(false);
    });
    notifyListeners();
  }
}