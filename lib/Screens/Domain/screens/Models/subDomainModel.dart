
import 'package:hive/hive.dart';
part 'subDomainModel.g.dart';
class SunDomainApiModel{
  List<SubDomainDetails> subDomainList=[];
SunDomainApiModel.fromJson(Map<String,dynamic>json){
  subDomainList=List<SubDomainDetails>.from(json['list'].map((x)=>SubDomainDetails.fromjson(x)));
}


}
@HiveType(typeId: 22)
class SubDomainDetails {
    @HiveField(0)
  int id;
    @HiveField(1)
  String name;
    @HiveField(2)
  String lable;
    @HiveField(3)
  int position;
    @HiveField(4)
  int domainId;
    @HiveField(5)
  int status;
    @HiveField(6)
  int deleteStatus;
    @HiveField(7)
  int Tasks;
SubDomainDetails();
  SubDomainDetails.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lable = json['lable'];
    position = json['position'];
    domainId = json['domainId'];

    status = json['status'];
    deleteStatus = json['deleteStatus'];

    Tasks = json['Tasks'];
  }
}
