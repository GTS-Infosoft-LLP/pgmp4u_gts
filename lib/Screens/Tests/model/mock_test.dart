class MocktestApiModelList {
  List<MockTestListApiModel> mockList = [];
  MocktestApiModelList.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      mockList = List<MockTestListApiModel>.from(
          json['list'].map((x) => MockTestListApiModel.fromJson(x)));
    }
  }
}

class MockTestListApiModel {
  int id;
  String testName;
  int premium;
  int questionCount;
  int numAttemptes;
  int generated;
  int deleteStatus;
  int status;
  List<Attempts> attempts;

  MockTestListApiModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    testName = json['test_name'];
    premium = json['premium'];
    questionCount = json['question_count'];
    numAttemptes = json['num_attemptes'];
    generated = json['generated'];
    deleteStatus = json['deleteStatus'];
    status = json['status'];
    if (json['attempts'] != null) {
      attempts = <Attempts>[];
      json['attempts'].forEach((v) {
        attempts.add(Attempts.fromJson(v));
      });
    }
  }
}

class Attempts {
  int attempt;
  String perc;

  Attempts({this.attempt, this.perc});

  Attempts.fromJson(Map<String, dynamic> json) {
    attempt = json['attempt'];
    perc = json['perc'];
  }
}
