class ReviewMokeText {
  bool success;
  List<Data> data;
  Timings timings;
  String spendTime;

  ReviewMokeText.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
    timings = Timings.fromJson(json['timings']);

    spendTime = json['spend_time'];
  }
}

class Data {
  int id;
  int mocktest;
  int questionid;
  int status;
  int deleteStatus;
  Question question;
  List<int> youranswer;

  Data.fromJson(Map<String, dynamic> json) {
    youranswer = [];
    id = json['id'];
    mocktest = json['mocktest'];
    questionid = json['question'];
    status = json['status'];
    deleteStatus = json['deleteStatus'];
    question = Question.fromJson(json['Question']);
    // youranswer = List<int>.from(json['youranswer'].map((x) => int.parse(x)));

    if (json['youranswer'] != null) {
      try {
        print(json['youranswer']);
        List<String> temp = json['youranswer'].toString().split(",");
        print("json['youranswer'] ${temp}");
        for (var element in temp) {
          print(element);
          youranswer.add(int.parse(element.trim()));
        }
      } on Exception catch (e) {
        print(e);
        youranswer.add(int.parse(json['youranswer'].toString().trim()));
      }
    }
  }
}

class Question {
  int id;
  int questionNo;
  int course;
  int category;
  String question;
  String questionType;
  List<int> rightAnswer;
  String explanation;
  String image;
  int status;
  int deleteStatus;
  List<Options> options;

  Question.fromJson(Map<String, dynamic> json) {
    rightAnswer=[];
    id = json['id'];
    questionNo = json['question_no'];
    course = json['course'];
    category = json['category'];
    question = json['question'];
    questionType = json['question_type'];
    
    if (json['right_answer'] != null) {
      try {
        print(json['right_answer']);
        List<String> temp = json['right_answer'].toString().split(",");
        temp.removeWhere((element) => element==",");
        for (var element in temp) {
          print(element);
          rightAnswer.add(int.parse(element.trim()));
        }
      } on Exception catch (e) {
        String value=json['right_answer'].toString().replaceAll(",", "");
        print(e);
        rightAnswer.add(int.parse(value.trim()));
      }
    }
    // rightAnswer = json['right_answer'];
    // if (temp != null) {
    //   try {
    //     for (var item in temp) {
    //       print("item value is $temp $item " );
    //       rightAnswer.add(int.parse(item.toString().trim()));
    //     }
    //     // temp.forEach((element) {
    //     //   if (element != null) {
    //     //
    //     //   }
    //     // });
    //   } catch (e) {
    //     print("e is $e");
    //     int val = int.parse(json['right_answer'].toString().trim());
    //     print("val is $val");
    //     rightAnswer = [val];
    //   }
    // }
    explanation = json['explanation'];
    image = json['image'];
    status = json['status'];
    deleteStatus = json['deleteStatus'];
    if (json['Options'] != null) {
      options = <Options>[];
      json['Options'].forEach((v) {
        options.add(new Options.fromJson(v,rightAnswer));
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
  bool customRight;

  Options.fromJson(Map<String, dynamic> json,List customList) {
    id = json['id'];
    question = json['question'];
    questionOption = json['question_option'];
    rightAnswer = json['right_answer'];
    status = json['status'];
    deleteStatus = json['deleteStatus'];
    if(customList.contains(json['id'])){
      customRight=true;
    }else{
       customRight=false;
    }
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['question_option'] = this.questionOption;
    data['right_answer'] = this.rightAnswer;
    data['status'] = this.status;
    data['deleteStatus'] = this.deleteStatus;
    return data;
  }
}

class Timings {
  String startDate;
  String date;

  Timings({this.startDate, this.date});

  Timings.fromJson(Map<String, dynamic> json) {
    startDate = json['start_date'];
    date = json['date'];
  }
}
