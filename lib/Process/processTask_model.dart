import 'dart:convert';

import 'package:hive/hive.dart';
part 'processTask_model.g.dart';

@HiveType(typeId: 21)
class AllProcessTaskModel {
  List<ProcessTskDetails> allProcessTaskList = [];
  @HiveField(0)
  String myList = "";
  AllProcessTaskModel();
  AllProcessTaskModel.fromjson(List data) {
    allProcessTaskList = data.map((e) => ProcessTskDetails.fromjson(e)).toList();
    myList = jsonEncode(data);
    print("************************************************************");
    print("list is $myList");
  }
}

class ProcessTskDetails {
  int id;
  String name;
  String description;
  String Image;
  int domainId;
  int subdomainId;
  String Keywords;
  String Examples;
  String lable;
  int status;
  int deleteStatus;
  List<ProcessTaskPracQues> ProcPracList;
  ProcessTskDetails();

  ProcessTskDetails.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? "";
    description = json['description'] ?? "";
    Image = json['Image'] ?? "";
    domainId = json['domainId'] ?? 0;
    subdomainId = json['subdomainId'] ?? 0;
    Keywords = json['Keywords'] ?? "";
    Examples = json['Examples'] ?? "";
    lable = json['lable'] ?? "";
    status = json['status'];
    deleteStatus = json['deleteStatus'];
    if (json['practiceTest'] != null) {
      ProcPracList = new List<ProcessTaskPracQues>();
      if (json['Options'] != null) {
        json['Options'].forEach((v) {
          ProcPracList.add(new ProcessTaskPracQues.fromJson(v));
        });
      }
    }
  }
}

class ProcessTaskPracQues {
  int id;
  int questionNo;
  int course;
  int category;
  String question;
  String domain;
  String questionType;
  String rightAnswer;
  String explanation;
  String image;
  int isSent;
  String sendDate;
  int status;
  int deleteStatus;
  String sendDateFormat;
  List<ProcTaskOptions> options;

  ProcessTaskPracQues.fromJson(Map<String, dynamic> json) {
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
      options = new List<ProcTaskOptions>();
      json['Options'].forEach((v) {
        options.add(new ProcTaskOptions.fromJson(v));
      });
    }
  }
}

class ProcTaskOptions {
  int id;
  int question;
  String questionOption;
  int rightAnswer;
  int status;
  int deleteStatus;

  ProcTaskOptions({
    this.id,
    this.question,
    this.questionOption,
    this.rightAnswer,
    this.status,
    this.deleteStatus,
  });

  ProcTaskOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    questionOption = json['question_option'] ?? "";
    rightAnswer = json['right_answer'];
    status = json['status'];
    deleteStatus = json['deleteStatus'];
  }
}
