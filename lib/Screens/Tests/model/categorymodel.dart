import 'package:hive/hive.dart';
part 'categorymodel.g.dart';


class CategoryApiModel {
  List<CategoryListModel> categoryList=[];

  CategoryApiModel.fromJson(Map<String,dynamic> json){
    categoryList=List<CategoryListModel>.from(json['list'].map((x)=>CategoryListModel.fromJson(x)));
  }
}

@HiveType(typeId: 1)
class CategoryListModel {
  @HiveField(0)
  int id;
  @HiveField(1)
  int course;
  @HiveField(2)
  String mainCategory;
  @HiveField(3)
  String type;
  @HiveField(4)
  String webType;
  @HiveField(5)
  int paymentStatus;
  @HiveField(6)
  String price;
  @HiveField(7)
  int status;
  @HiveField(8)
  String icon;

 CategoryListModel();
 

  CategoryListModel.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    course = json['course']??0;
    mainCategory = json['mainCategory']??"";
    type = json['type']??"";
    webType = json['web_type']??"";
    paymentStatus = json['payment_status']??0;
    price = json['price']??"";
    status = json['status']??0;
    icon = json['icon']??"";
  }

 
}