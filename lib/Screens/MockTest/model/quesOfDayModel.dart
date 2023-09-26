


import 'dart:convert';

import 'package:hive/hive.dart';
part 'quesOfDayModel.g.dart';

@HiveType(typeId: 25)
class AllDayQuestionModel{
  List<QuesDayModel> allTaskList=[];
   @HiveField(0)
  String myList = "";
  AllDayQuestionModel();
  AllDayQuestionModel.fromjson(List data){
    allTaskList=data.map((e) => QuesDayModel.fromJson(e)).toList();
    myList=jsonEncode(data);

  }

}


class QuesDayModel {
  int id;
  int questionNo;
  int course;
  int category;
  String question;
  String questionType;
  String rightAnswer;
  String explanation;
  String lable;
  String image;
  int sendDate;
  String sendDateFormat;
  int status;
  int deleteStatus;
  List<OptionsDay> options;

  QuesDayModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionNo = json['question_no'];
    course = json['course'];
    category = json['category'];
    question = json['question'];
    questionType = json['question_type'];
    rightAnswer = json['right_answer'];
    explanation = json['explanation'];
    lable = json['lable'];
    image = json['image'];
    sendDate = json['sendDate'];
    sendDateFormat = json['sendDateFormat'];
    status = json['status'];
    deleteStatus = json['deleteStatus'];

    if (json['Options'] != null) {
      options = new List<OptionsDay>();

      json['Options'].forEach((v) {
        options.add(new OptionsDay.fromJson(v));
      });
    }
  }
}

class OptionsDay {
  int id;
  int question;
  String questionOption;
  int rightAnswer;
  int status;
  int deleteStatus;
  bool isseleted;

  OptionsDay({
    this.id,
    this.question,
    this.questionOption,
    this.rightAnswer,
    this.status,
    this.deleteStatus,
    this.isseleted = false,
  });

  OptionsDay.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        question = json['question'],
        questionOption = json['question_option'] ?? "",
        rightAnswer = json['right_answer'],
        status = json['status'],
        deleteStatus = json['deleteStatus'],
        isseleted = false;
}
