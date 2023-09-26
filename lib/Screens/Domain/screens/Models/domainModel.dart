
import 'package:hive/hive.dart';
part 'domainModel.g.dart';
class DomainDetailApiModel{
  List<DomainDetails> domainList=[];
DomainDetailApiModel.fromJson(Map<String,dynamic>json){
  domainList=List<DomainDetails>.from(json['list'].map((x)=>DomainDetails.fromjson(x)));
}


}
@HiveType(typeId: 20)
class DomainDetails {
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
  int SubDomains;
     @HiveField(9)
  int Tasks;
DomainDetails();
  DomainDetails.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lable = json['lable'];
    position = json['position'];
    courseId = json['courseId'];
    masterList = json['masterList'];
    status = json['status'];
    deleteStatus = json['deleteStatus'];
    SubDomains = json['SubDomains'];
    Tasks = json['Tasks'];
  }
}
