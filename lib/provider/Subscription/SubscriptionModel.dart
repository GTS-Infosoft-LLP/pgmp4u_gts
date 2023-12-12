import 'dart:developer' as dev;
class SubscriptionDetails {
  int id;
  String title;
  double amount;
  String finalAmount;
  String price;
  int courseId;
  String planId;
  String priceId;
  int type;
  String description;
  int status;
  int deleteStatus;
  int durationType;
  int durationQuantity;
  String featureList;
  String features;

  SubscriptionDetails.fromjson(Map<String, dynamic> json) {
    // finalAmount = json['price'].toStringAsFixed(2)();
    id = json['id'];
    title = json['title'];
    price = json['price'];

    courseId = json['courseId'];
    planId = json['planId'];

    if (json['description'] != null) {
 
      description = json['description'];

      // dev.log("descriptiondescription:::;$description");
    } else {
      description = "";
    }

    priceId = json['priceId'];
    type = json['type'];
    status = json['status'];
    deleteStatus = json['deleteStatus'];
    featureList = json['featureList'];
    features = json['features'];
    durationType = json['durationType'];
    durationQuantity = json['durationQuantity'];
  }
}

class DurationDetail {
  int durationType;
  int durationQuantity;

  DurationDetail.fromjson(Map<String, dynamic> json) {
    durationType = json['durationType'];
    durationQuantity = json['durationQuantity'];
  }
}
