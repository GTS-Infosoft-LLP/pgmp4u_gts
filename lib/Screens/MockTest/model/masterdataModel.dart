
import 'package:hive/hive.dart';
part 'masterdataModel.g.dart';

@HiveType(typeId: 12)
class MasterDetails {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String type;
  @HiveField(3)
  int position;
  @HiveField(4)
  String label;
  @HiveField(5)
  int courseId;
  @HiveField(6)
  int status;
  @HiveField(7)
  int deleteStatus;
 @HiveField(8)
  int payment_status;
  @HiveField(9)
  String price;


  MasterDetails();

  MasterDetails.fromjson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    type = json["type"];
    position = json["position"];
    label = json["lable"];
    courseId = json["courseId"];
    status = json["status"];
    deleteStatus = json["deleteStatus"];
    payment_status = json["payment_status"];
    price = json["price"];
  }
}
