import 'package:hive/hive.dart';
part 'taskQuesModel.g.dart';
@HiveType(typeId: 27)
class TaskQues{
      @HiveField(0)
  int id; 
    @HiveField(1)
  int questionNo;
    @HiveField(2)
  int course;
    @HiveField(3)
  int category;
    @HiveField(4)
  String question;
      @HiveField(5)
  String domain;
      @HiveField(6)
  String questionType;
      @HiveField(7)
  String rightAnswer;
      @HiveField(8)
  String explanation;
      @HiveField(9)
  String image;
      @HiveField(10)
  int isSent;
      @HiveField(11)
  String sendDate;
      @HiveField(12)
  int status;
      @HiveField(13)
  int deleteStatus;
      @HiveField(14)
  String sendDateFormat;
      @HiveField(15)
  List<TaskQuesOption> options;
  TaskQues();
    TaskQues.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionNo = json['question_no'];
    course = json['course'];
    category = json['category'];
    question = json['question'] ?? "";
    domain = json['domain'] ?? "";
    questionType = json['question_type'];
    rightAnswer = json['right_answer'] ?? "";
    explanation = json['explanation'] ?? "";
    image = json['image'] ?? "";
    isSent = json['isSent'];
    sendDate = json['sendDate'] ?? "";
    status = json['status'];
    deleteStatus = json['deleteStatus'];
    sendDateFormat = json['sendDateFormat'];
    if (json['Options'] != null) {
      options = new List<TaskQuesOption>();
      json['Options'].forEach((v) {
        options.add(new TaskQuesOption.fromJson(v));
      });
    }
  }
}
class TaskQuesOption {
  int id;
  int question;
  String questionOption;
  int rightAnswer;
  int status;
  int deleteStatus;

  TaskQuesOption({
    this.id,
    this.question,
    this.questionOption,
    this.rightAnswer,
    this.status,
    this.deleteStatus,
  });

  TaskQuesOption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    questionOption = json['question_option'] ?? "";
    rightAnswer = json['right_answer'];
    status = json['status'];
    deleteStatus = json['deleteStatus'];
  }
}