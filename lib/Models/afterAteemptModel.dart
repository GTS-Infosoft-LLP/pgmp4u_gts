class domainListModel{
   int id;
  String category;
  int totAns;
  String icon;
  int correctAns;
  int wrongAns;
  int skipAns;
   domainListModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    category = json['category'];
    totAns = json['Tot_Ans'];
    icon = json['icon'];
    correctAns = json['Correct_Ans'];
    wrongAns = json['Wrong_Ans'];
    skipAns = json['Skip_Ans'];
   }

}