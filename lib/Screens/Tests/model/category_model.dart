class CategoryApiModel {
  List<CategoryListModel> categoryList=[];

  CategoryApiModel.fromJson(Map<String,dynamic> json){
    categoryList=List<CategoryListModel>.from(json['list'].map((x)=>CategoryListModel.fromJson(x)));
  }
}

class CategoryListModel {
  int id;
  int course;
  String mainCategory;
  String type;
  String webType;
  int paymentStatus;
  String price;
  int status;
  String icon;

 

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