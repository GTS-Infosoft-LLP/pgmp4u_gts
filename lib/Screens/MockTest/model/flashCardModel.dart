

import 'package:hive/hive.dart';
part 'flashCardModel.g.dart';



class FlashApiModel{
  List<FlashCardDetails> flashList=[];
FlashApiModel.fromJson(Map<String,dynamic>json){
  flashList=List<FlashCardDetails>.from(json['list'].map((x)=>FlashCardDetails.fromjson(x)));
}


}



@HiveType(typeId: 2)
class FlashCardDetails {
   @HiveField(0)
  int id;
  @HiveField(1)
  int position;
  @HiveField(2)
  int categoryId;
  @HiveField(3) 
  String description;
  @HiveField(4)
  String title;
  @HiveField(5)
  String thumbnail;
  @HiveField(6)
  int status;
  @HiveField(7)
  int deleteStatus;

FlashCardDetails();
 

  FlashCardDetails.fromjson(Map<String, dynamic> json) {
    id = json["id"];
    position = json["position"];
    categoryId = json["categoryId"];
    description = json["description"];
    title = json["title"];
    thumbnail = json["thumbnail"];
    status = json["status"];
    deleteStatus = json["deleteStatus"];
  }
}
