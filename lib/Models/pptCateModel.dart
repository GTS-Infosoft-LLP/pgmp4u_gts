

import 'package:hive/hive.dart';
part 'pptCateModel.g.dart';
class pptCateApiModel{
  List<PPTCateDetails> pptCateList=[];
pptCateApiModel.fromJson(Map<String,dynamic>json){
  pptCateList=List<PPTCateDetails>.from(json['list'].map((x)=>PPTCateDetails.fromjson(x)));
}


}
@HiveType(typeId: 23)
class PPTCateDetails {
     @HiveField(0)
  int id;
     @HiveField(1)
  String name;
     @HiveField(2)
  int position;
     @HiveField(3)
  int courseId;
     @HiveField(4)
  int masterList;
     @HiveField(5)
  int paymentStatus;
     @HiveField(6)
  String price;
     @HiveField(7)
  String label;
     @HiveField(8)
  int status;
     @HiveField(9)
  int deleteStatus;
     @HiveField(10)
  int pptLibraries;
PPTCateDetails();
  PPTCateDetails.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    position = json['position'];
    courseId = json['courseId'];
    masterList = json['masterList'];
    paymentStatus = json['payment_status'];
    price = json['price'];
    label = json['label'] ?? "";
    status = json['status'];
    deleteStatus = json['deleteStatus'];
    pptLibraries = json['pptLibraries'];
  }
}
