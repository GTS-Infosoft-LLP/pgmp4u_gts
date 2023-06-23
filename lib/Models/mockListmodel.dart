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

class MockDataDetails {
  int id;
  int course;
  String test_name;
  int premium;
  int price;
  int question_count;
  int num_attemptes;
  int generated;
  int status;
  int deleteStatus;
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
    }
  }
}
