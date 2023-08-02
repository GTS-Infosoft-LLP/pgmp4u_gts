class SubscriptionDetails {
  int id;
  String title;
  String price;
  int courseId;
  String planId;
  String priceId;
  int type;
  String description;
  int status;
  int deleteStatus;

  SubscriptionDetails.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];

    courseId = json['courseId'];
    planId = json['planId'];
    description = json['description'];
    priceId = json['priceId'];
    type = json['type'];
    status = json['status'];
    deleteStatus = json['deleteStatus'];
  }
}
