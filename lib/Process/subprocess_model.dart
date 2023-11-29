



import 'package:hive/hive.dart';
part 'subprocess_model.g.dart';
class SubProcessDetailApiModel{
  List<SubProcessDetails> subProcessList=[];
SubProcessDetailApiModel.fromJson(Map<String,dynamic>json){
  subProcessList=List<SubProcessDetails>.from(json['list'].map((x)=>SubProcessDetails.fromjson(x)));
}
}


@HiveType(typeId: 29)
class SubProcessDetails {
     @HiveField(0)
  int id;
     @HiveField(1)
  String name;
     @HiveField(2)
  String lable;
     @HiveField(3)
  int position;
     @HiveField(4)
  int processId;
     @HiveField(5)
  int masterList;
     @HiveField(6)
  int status;
     @HiveField(7)
  int deleteStatus;
     @HiveField(8)
  int TaskProceesses;
SubProcessDetails();
  SubProcessDetails.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lable = json['lable'];
    position = json['position'];
    processId = json['processId'];
    status = json['status'];
    deleteStatus = json['deleteStatus'];
    TaskProceesses = json['TaskProceesses'];
  }
}
