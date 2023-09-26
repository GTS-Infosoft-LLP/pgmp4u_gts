import 'package:hive/hive.dart';
part 'testDataModel.g.dart';

@HiveType(typeId: 15)
class TestDataDetails {
  @HiveField(0)
  int id;
  @HiveField(1)
  int course;
  @HiveField(2)
  String test_name;
  @HiveField(3)
  int premium;
  @HiveField(4)
  String price;
  @HiveField(5)
  int masterList;
  @HiveField(6)
  String type;
  @HiveField(7)
  String question_count;
  @HiveField(8)
  int num_attemptes;
  @HiveField(9)
  int generated;
  @HiveField(10)
  int status;
  @HiveField(11)
  int deleteStatus;
  @HiveField(12)
  TestDataDetails();

  TestDataDetails.fromjson(Map<String, dynamic> json) {
    id = json["id"];
    test_name = json["test_name"];
    course = json["course"];
    premium = json["premium"];
    masterList = json["masterList"];
    type = json["type"];
    price = json["price"].toString();
    if (json["price"] == null) {
      print("inside this conditon");
      price = "0";
    }

    print("price===========>>>>>>>$price");

    question_count = json["question_count"];
    num_attemptes = json["num_attemptes"];
    generated = json["generated"];
    status = json["status"];
    deleteStatus = json["deleteStatus"];
  }
}
