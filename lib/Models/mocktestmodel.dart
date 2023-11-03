import 'dart:convert';

class MockTestModel{
List<MockText> mockList=[];
MockTestModel({
this.mockList
});
MockTestModel.fromjson(List json){

  
  List temp=json??[] as List;
  mockList=temp.map((e) =>  MockText.fromjs(e)).toList();
}
}
class MockText{
 int id;
 String test_name;
 int premium;
 int question_count;
 int num_attemptes;
 int generated;
 int deleteStatus;
 int status;
 List<Attempt> attempts=[];
 MockText();
 MockText.fromjs(Map<String,dynamic> json){
    id=int.parse(json["id"].toString()??0);
test_name=json["test_name"]??"";
premium=json["premium"];
question_count=json["question_count"];
num_attemptes=json["num_attemptes"];
generated=json["generated"];
deleteStatus=json["deleteStatus"];
status=json["status"];
print("in model");
List temp=json["attempts"];
 //print("kdsfhsdkjfhdkfjhadj{$temp}");
attempts = temp.map((e) => Attempt.fromJs(e)).toList();
//attempts=json["attempts"].map((e)=>Attempt.fromJs(e)).toList();
  }
}
class Attempt{
  int attempt;
  String perc;
  Attempt();
  Attempt.fromJs(Map<String,dynamic> json){
   print("inside  here");
    attempt=json["attempt"]??0;
      perc=json["perc"]??"";
  }
}