import 'dart:convert';

import 'package:hive/hive.dart';
part 'pracTestModel.g.dart';

/// make use of this model
///
///
///
@HiveType(typeId: 6)
class PracListModel {
  List<PracTestModel> list = [];
  @HiveField(0)
  String myList = "";
  PracListModel();
  PracListModel.fromjson(List data) {
    print("this is printing=======");
    list = data.map((e) => PracTestModel.fromJson(e)).toList();
    myList = jsonEncode(data);
    print("************************************************************");
    print("list is $myList");
    //  quesAns
  }
}


class PracTestModel {
  int id;
  int mocktest;
  int question;
  int status;
  int deleteStatus;
  Question ques;
  PracTestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mocktest = json['mocktest'];
    question = json['question'];
    status = json['status'];
    deleteStatus = json['deleteStatus'];
    ques = json['Question'] != null ? new Question.fromJson(json['Question']) : null;
  }
}

class Question {
  int id;
  int questionNo;
  int course;
  int category;
  String question;
  String questionType;
  String rightAnswer;
  String explanation;
  Null image;
  int status;
  int deleteStatus;
  List<Options> options;

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionNo = json['question_no'];
    course = json['course'];
    category = json['category'];
    question = json['question'];
    questionType = json['question_type'];
    rightAnswer = json['right_answer'];
    explanation = json['explanation'];
    image = json['image'];
    status = json['status'];
    deleteStatus = json['deleteStatus'];

    if (json['Options'] != null) {
     
      options = new List<Options>();

      json['Options'].forEach((v) {
        options.add(new Options.fromJson(v));
      });
    }
  }
}

class Options {
  int id;
  int question;
  String questionOption;
  int rightAnswer;
  int status;
  int deleteStatus;
  bool isseleted;

  Options({
    this.id,
    this.question,
    this.questionOption,
    this.rightAnswer,
    this.status,
    this.deleteStatus,
    this.isseleted = false,
  });

  Options.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        question = json['question'],
        questionOption = json['question_option'],
        rightAnswer = json['right_answer'],
        status = json['status'],
        deleteStatus = json['deleteStatus'],
        isseleted = false;
}
