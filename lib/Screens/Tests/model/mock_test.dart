import 'package:hive/hive.dart';
part 'mock_test.g.dart';

class MocktestApiModelList {
  List<MockTestListApiModel> mockList = [];
  MocktestApiModelList.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      mockList = List<MockTestListApiModel>.from(
          json['list'].map((x) => MockTestListApiModel.fromJson(x)));
    }
  }
}

@HiveType(typeId: 3)
class MockTestListApiModel {
  @HiveField(0)
  int id;
  @HiveField(1)
  String testName;
  @HiveField(2)
  int premium;
  @HiveField(3)
  int questionCount;
  @HiveField(4)
  int numAttemptes;
  @HiveField(5)
  int generated;
  @HiveField(6)
  int deleteStatus;
  @HiveField(7)
  int status;
  @HiveField(8)
  String AttemptList;

  List<Attempts> attempts;

  MockTestListApiModel();

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

    AttemptList = json['attempts'].toString();
    print("attempt list====>>>>$AttemptList");
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
