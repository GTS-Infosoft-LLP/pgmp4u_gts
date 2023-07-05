import 'dart:convert';

import 'package:hive/hive.dart';
part 'mockquestionanswermodel.g.dart';

@HiveType(typeId: 5)
class QuestionAnswerModel {
  List<Queans> list = [];
  @HiveField(0)
  String myList = "";
  QuestionAnswerModel();
  QuestionAnswerModel.fromjson(List data) {
    list = data.map((e) => Queans.fromjss(e)).toList();
    myList = jsonEncode(data);
    print("************************************************************");
    print("list is $myList");
    //  quesAns
  }
}

class Queans {
  int id;
  int mocktest;
  int question;
  int status;
  int deleteStatus;
  QuestionDetail questionDetail;

  Queans.fromjss(Map<String, dynamic> js) {
    id = js["id"];
    mocktest = js["mocktest"];
    question = js["question"];
    status = js["status"];
    deleteStatus = js["deleteStatus"];
    var _questionnamemap = js["Question"] ?? {};
    // print("options length===${questionDetail.Options.length}");
    questionDetail = QuestionDetail.fromjsons(_questionnamemap);
    questionDetail.Options.removeWhere(
      (element) => (element.question_option == null || element.question_option.isEmpty),
    );

    print("options length===${questionDetail.Options.length}");
  }
}

class QuestionDetail {
  int queID;
  int question_no;
  int course;
  int category;
  String questiondata;
  String question_type;
  String explanation;
  String image;
  int questatus;
  int quedeleteStatus;
  List<String> rightAnswer;
  List<Optionss> Options;
  QuestionDetail.fromjsons(Map<String, dynamic> questionMap) {
    queID = questionMap["id"];
    question_no = questionMap["question_no"];
    course = questionMap["course"];
    category = questionMap["category"];
    questiondata = questionMap["question"];
    question_type = questionMap["question_type"];
    explanation = questionMap["explanation"];
    image = questionMap["image"];
    questatus = questionMap["status"];
    quedeleteStatus = questionMap["deleteStatus"];
    if (questionMap['right_answer'] != null) {
      rightAnswer = questionMap['right_answer'].toString().split(",");
    }

    List temp = questionMap["Options"];

    Options = temp.map((e) => Optionss.fromjsons(e)).toList();
  }
}

class Optionss {
  int id;
  int question;
  String question_option;
  int status;
  int deleteStatus;

  Optionss.fromjsons(Map<String, dynamic> js) {
    if (js["question_option"] == null || js["question_option"].isEmpty) {
    } else {
      id = js["id"];
      question = js["question"];
      question_option = js["question_option"];

      status = js["status"];
      deleteStatus = js["deleteStatus"];
    }
  }
}
