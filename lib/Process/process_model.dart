



import 'package:hive/hive.dart';
part 'process_model.g.dart';
class ProcessDetailApiModel{
  List<ProcessDetails> domainList=[];
ProcessDetailApiModel.fromJson(Map<String,dynamic>json){
  domainList=List<ProcessDetails>.from(json['list'].map((x)=>ProcessDetails.fromjson(x)));
}


}


@HiveType(typeId: 28)
class ProcessDetails {
     @HiveField(0)
  int id;
     @HiveField(1)
  String name;
     @HiveField(2)
  String lable;
     @HiveField(3)
  int position;
     @HiveField(4)
  int courseId;
     @HiveField(5)
  int masterList;
     @HiveField(6)
  int status;
     @HiveField(7)
  int deleteStatus;
     @HiveField(8)
  int SubProcesses;
     @HiveField(9)
  int TaskProceesses;
ProcessDetails();
  ProcessDetails.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lable = json['lable'];
    position = json['position'];
    courseId = json['courseId'];
    masterList = json['masterList'];
    status = json['status'];
    deleteStatus = json['deleteStatus'];
    SubProcesses = json['SubProcesses'];
    TaskProceesses = json['TaskProceesses'];
  }
}
