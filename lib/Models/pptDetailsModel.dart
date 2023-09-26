import 'package:hive/hive.dart';
part 'pptDetailsModel.g.dart';
class pptDataApiModel {
  List<PPTDataDetails> pptDataList = [];
  pptDataApiModel.fromJson(Map<String, dynamic> json) {
    pptDataList = List<PPTDataDetails>.from(json['list'].map((x) => PPTDataDetails.fromjson(x)));
  }
}

@HiveType(typeId: 24)
class PPTDataDetails {
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  int categoryId;
  @HiveField(3)
  String filename;
  @HiveField(4)
  int position;
  @HiveField(5)
  int status;
  @HiveField(6)
  int deleteStatus;
  PPTDataDetails();
  PPTDataDetails.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    position = json['position'];
    categoryId = json['categoryId'];
    filename = json['filename'] ?? "";
    status = json['status'];
    deleteStatus = json['deleteStatus'];
  }
}
