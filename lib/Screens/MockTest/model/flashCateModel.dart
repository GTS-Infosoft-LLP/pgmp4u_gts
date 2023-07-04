import 'package:hive/hive.dart';
part 'flashCateModel.g.dart';

@HiveType(typeId: 14)
class FlashCateDetails {
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
  int payment_status;
  @HiveField(6)
  String price;
  @HiveField(7)
  int status;
  @HiveField(8)
  int deleteStatus;
  @HiveField(9)
  int flashcards;

  FlashCateDetails();

  FlashCateDetails.fromjson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    position = json["position"];
    courseId = json["courseId"];
    masterList = json["masterList"];
    payment_status = json["payment_status"];
    price = json["price"];
    status = json["status"];
    deleteStatus = json["deleteStatus"];
    flashcards = json["flashcards"] ?? 0;
  }
}
