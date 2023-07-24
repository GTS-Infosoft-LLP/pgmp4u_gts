class PPTCateDetails {
  int id;
  String name;
  int position;
  int courseId;
  int masterList;
  int paymentStatus;
  String price;
  String label;
  int status;
  int deleteStatus;
  int pptLibraries;

  PPTCateDetails.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    position = json['position'];
    courseId = json['courseId'];
    masterList = json['masterList'];
    paymentStatus = json['payment_status'];
    price = json['price'];
    label = json['label'] ?? "";
    status = json['status'];
    deleteStatus = json['deleteStatus'];
    pptLibraries = json['pptLibraries'];
  }
}
