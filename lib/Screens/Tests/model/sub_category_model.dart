class SubCategoryApiModel{
List<SubCategoryListModel> subCateogyList=[];


SubCategoryApiModel.formJson(Map<String,dynamic> json){
  subCateogyList=List<SubCategoryListModel>.from(json['list'].map((x)=>SubCategoryListModel.fromJson(x)));
}
   

}


class SubCategoryListModel{

  int id;
  int course;
  String testName;
  int premium;
  int questionCount;
  int numAttemptes;
  int generated;
  int status;
  int deleteStatus;

  SubCategoryListModel.fromJson(Map<String, dynamic> json) {
     id = json['id'];
    course = json['course'];
    testName = json['test_name'];
    premium = json['premium'];
    questionCount = json['question_count'];
    numAttemptes = json['num_attemptes'];
    generated = json['generated'];
    status = json['status'];
    deleteStatus = json['deleteStatus'];
  }
}