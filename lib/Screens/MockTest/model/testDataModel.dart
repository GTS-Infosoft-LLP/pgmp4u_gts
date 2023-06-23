class TestDataDetails {
  int id;
  int course;
  String test_name;
  int premium;
  String price;
  int masterList;
  String type;
  String question_count;
  int num_attemptes;
  int generated;
  int status;
  int deleteStatus;

  TestDataDetails.fromjson(Map<String, dynamic> json) {
    id = json["id"];
    test_name = json["test_name"];
    course = json["course"];
    premium = json["premium"];
    masterList = json["masterList"];
    type = json["type"];
    price = json["price"].toString();
    if (json["price"] == null) {
      print("inside this conditon");
      price = "0";
    }

    print("price===========>>>>>>>$price");

    question_count = json["question_count"];
    num_attemptes = json["num_attemptes"];
    generated = json["generated"];
    status = json["status"];
    deleteStatus = json["deleteStatus"];
  }
}
