class PracitceTextResponseModelList {
  List<PracitceTextResponseModel> list;

  PracitceTextResponseModelList.fromJson(Map<String, dynamic> json) {
    list = List<PracitceTextResponseModel>.from(
        json['data'].map((x) => PracitceTextResponseModel.fromJson(x)));
  }
}

class PracitceTextResponseModel {
  int id;
  int questionNo;
  int course;
  int category;
  String questions;
  String questionType;
  int rightAnswer;
  String explantions;
  String image;
  //String status;
  // String deleteStatus;
  List<Option> optionsList = [];

  PracitceTextResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    questionNo = json['question_no'] ?? 0;
    course = json['course'] ?? "";
    category = json['category'] ?? 0;
    questions = json['question'] ?? "";
    questionType = json['question_type'] ?? "";
    rightAnswer = json['right_answer'] ?? 0;
    explantions = json['explanation'] ?? "";
    image = json['image'] ?? "";
    //status = int.parse(json['status'] ?? 0).toInt();
    //  deleteStatus = json['deleteStatus'];
    optionsList =
        List<Option>.from(json['Options'].map((x) => Option.fromJson(x)));
  }
}

class Option {
  int id;
  int questions;
  String questionsOptions;
  int status;
  int deleteStatus;

  Option.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    questions = json['question'] ?? 0;
    questionsOptions = json['question_option'] ?? "";
    status = json['status'] ?? 0;
    deleteStatus = json['deleteStatus'] ?? 0;
  }
}

// "explanation": "Option \"c\" - wrong Options \"a\" & \"d\" - Partially right.  Only option \"b\" is the perfect choice SPM4 7.2.2.5, page 102",
//             "image": null,
//             "status": 1,
//             "deleteStatus": 1,
//              "Options": [
//                 {
//                     "id": 705,
//                     "question": 13544,
//                     "question_option": "Close project, close program, close program contract",
//                     "status": 1,
//                     "deleteStatus": 1
//                 },