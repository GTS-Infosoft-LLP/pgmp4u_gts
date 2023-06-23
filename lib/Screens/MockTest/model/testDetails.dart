class TestDetails {
  int id;
  String testName;
  int premium;
  Null questionCount;
  int numAttemptes;
  int generated;
  int deleteStatus;
  int status;
  int noOfattempts;
  List<Attempts> attempts = [];

  TestDetails.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    testName = json['test_name'];
    premium = json['premium'];
    questionCount = json['question_count'];
    numAttemptes = json['num_attemptes'];
    generated = json['generated'];
    deleteStatus = json['deleteStatus'];
    status = json['status'];
    noOfattempts = json['noOfattempts'];
    List _attemptListTemp = json["attempts"] ?? [];
    attempts = _attemptListTemp.map((e) => Attempts.fromJson(e)).toList();
  }
}

class Attempts {
  int attempt;
  String perc;

  Attempts.fromJson(Map<String, dynamic> json) {
    attempt = json['attempt'];
    perc = json['perc'];
  }
}
