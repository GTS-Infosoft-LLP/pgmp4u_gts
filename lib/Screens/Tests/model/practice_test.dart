class PracticeApiModel {
  List<PracticeListModel> list;

  PracticeApiModel.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list=List<PracticeListModel>.from(json['list'].map((x)=>PracticeListModel.fromJson(x)));
    }
  }

  
}

class PracticeListModel {
  int id;
  int questionNo;
  int course;
  int category;
  String question;
  String questionType;
  int rightAnswer;
  String explanation;
  String image;
  int status;
  int deleteStatus;
  List<Options> options;

 

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