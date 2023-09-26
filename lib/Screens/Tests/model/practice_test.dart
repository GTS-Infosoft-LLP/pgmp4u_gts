import 'package:hive/hive.dart';
 part 'practice_test.g.dart';

class PracticeApiModel {
  List<PracticeListModel> list;

  PracticeApiModel.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list=List<PracticeListModel>.from(json['list'].map((x)=>PracticeListModel.fromJson(x)));
    }
  }

  
}
@HiveType(typeId: 4)
class PracticeListModel {
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
  String questionType;
    @HiveField(6)
  int rightAnswer;
    @HiveField(7)
  String explanation;
    @HiveField(8)
  String image;
    @HiveField(9)
  int status;
    @HiveField(10)
  int deleteStatus;
    @HiveField(11)
  List<Options> options;

  PracticeListModel();

  PracticeListModel.fromJson(Map<String, dynamic> json) {
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
      options = <Options>[];
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
  int status;
  int deleteStatus;

 
  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    questionOption = json['question_option'];
    status = json['status'];
    deleteStatus = json['deleteStatus'];
  }

 
}