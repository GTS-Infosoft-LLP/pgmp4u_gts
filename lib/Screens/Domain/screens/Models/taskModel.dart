class TaskDetails {
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
  List<TaskPracQues> PracList;

  TaskDetails.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? "";
    description = json['description'] ?? "";
    Image = json['Image'] ?? "";
    domainId = json['domainId'] ?? "";
    subdomainId = json['subdomainId'] ?? 0;
    Keywords = json['Keywords'] ?? "";
    Examples = json['Examples'] ?? "";
    lable = json['lable'] ?? "";
    status = json['status'];
    deleteStatus = json['deleteStatus'];
    if (json['practiceTest'] != null) {
      PracList = new List<TaskPracQues>();
      if (json['Options'] != null) {
        json['Options'].forEach((v) {
          PracList.add(new TaskPracQues.fromJson(v));
        });
      }
    }
  }
}

class TaskPracQues {
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
  List<TaskOptions> options;
  TaskPracQues.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionNo = json['question_no'];
    course = json['course'];
    category = json['category'];
    question = json['question'];
    domain = json['domain'];
    questionType = json['question_type'];
    rightAnswer = json['right_answer'];
    explanation = json['explanation'];
    image = json['image'];
    isSent = json['isSent'];
    sendDate = json['sendDate'];
    status = json['status'];
    deleteStatus = json['deleteStatus'];
    sendDateFormat = json['sendDateFormat'];
    if (json['Options'] != null) {
      options = new List<TaskOptions>();
      json['Options'].forEach((v) {
        options.add(new TaskOptions.fromJson(v));
      });
    }
  }
}

class TaskOptions {
  int id;
  int question;
  String questionOption;
  int rightAnswer;
  int status;
  int deleteStatus;

  TaskOptions({
    this.id,
    this.question,
    this.questionOption,
    this.rightAnswer,
    this.status,
    this.deleteStatus,
  });

  TaskOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    questionOption = json['question_option'];
    rightAnswer = json['right_answer'];
    status = json['status'];
    deleteStatus = json['deleteStatus'];
  }
}
