class DomainCategoryDetails{
  int id;
  String name;
  int position;
  int courseId;
  int masterList;
  int paymentStatus;
  String price;
  int status;
  int deleteStatus;
  int Domains;

  DomainCategoryDetails.fromjson(Map<String, dynamic> json) {
  id = json['id'];
  name = json['name'];
  position = json['position'];
  courseId = json['courseId'];
  masterList = json['masterList'];
  paymentStatus = json['payment_status'];
  price = json['price'];
  status = json['status'];
  deleteStatus = json['deleteStatus'];
  Domains = json['Domains'];
  }



}