import 'package:hive/hive.dart';
part 'mockListmodel.g.dart';

class MockData {
  MockDataDetails detailsofMock;
  List<AvailableAttempts> attemptList = [];
  MockData.fromjd(Map<String, dynamic> jsons) {
    detailsofMock = MockDataDetails.fromjson(jsons["mocktest"]);

    //List<AvailableAttempts>.from(jsons["mocktest"]??[].map((e) =>AvailableAttempts.fromjsons(e) )).toList();
    //attemptList= jsons["mocktest"]??[].map((e) => null)
    List temp = jsons["attempts"];
    attemptList = temp.map((e) => AvailableAttempts.fromjsons(e)).toList();
  }
}

@HiveType(typeId: 17)
class MockDataDetails {
  @HiveField(0)
  int id;
  @HiveField(1)
  int course;
  @HiveField(2)
  String test_name;
  @HiveField(3)
  int premium;
  @HiveField(4)
  int price;
  @HiveField(5)
  int question_count;
  @HiveField(6)
  int num_attemptes;
  @HiveField(7)
  int generated;
  @HiveField(8)
  int status;
  @HiveField(9)
  int deleteStatus;

  MockDataDetails();

  MockDataDetails.fromjson(Map<String, dynamic> jsn) {
    id = jsn["id"];
    course = jsn["course"];
    test_name = jsn["test_name"];
    premium = jsn["premium"];
    price = jsn["price"];
    question_count = jsn["question_count"] ?? 0;
    num_attemptes = jsn["num_attemptes"];
    generated = jsn["generated"];
    status = jsn["status"];
    deleteStatus = jsn["deleteStatus"];
  }
}

class AvailableAttempts {
  int attempt;
  double percentage;
  int total_qns;
  int correct;
  int wrong;
  int answered;
  int notanswered;
  String attempted_date;
  String start_date;
  AvailableAttempts.fromjsons(Map<String, dynamic> jsn) {
    attempt = jsn["attempt"];
    percentage = double.parse(jsn["percentage"].toString());
    total_qns = jsn["total_qns"];
    correct = jsn["correct"];
    wrong = jsn["wrong"];
    answered = jsn["answered"];
    notanswered = jsn["notanswered"];
    if (jsn["attempted_date"] != null) {
      attempted_date = jsn["attempted_date"]["date"] ?? "";
      start_date = jsn["attempted_date"]["start_date"] ?? "";
    } else {
      jsn["attempted_date"] = "";
    }
  }
}
