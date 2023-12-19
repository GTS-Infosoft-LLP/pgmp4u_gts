import 'package:hive/hive.dart';

import '../../dropdown.dart';
part 'courseModel.g.dart';

@HiveType(typeId: 13)
class CourseDetails implements DropDownModel {
  @HiveField(0)
  int id;
  @HiveField(1)
  String course;
  @HiveField(2)
  String description;
  @HiveField(3)
  String exam_Time;
  @HiveField(4)
  String lable;
  @HiveField(5)
  int skip_content_progress;
  @HiveField(6)
  int status;
  @HiveField(7)
  int deleteStatus;
  @HiveField(8)
  int isSubscribed;
  @HiveField(9)
  int isChatSubscribed;

  @HiveField(10)
  int isJoinNotification;

  @HiveField(11)
  int subscriptionType;

  @HiveField(12)
  List Mocktests;

  @HiveField(13)
  int isCancelSubscription;
    @HiveField(14)
  int inAppPurchaseEnabled;
    @HiveField(15)
  int subscriptionDurationType;
    @HiveField(16)
  int subscriptionDurationQuantity;

  @HiveField(17)
  int availableQuestionOfTheDay;
  @HiveField(18)
  int isFree;

  CourseDetails();

  CourseDetails.fromjson(Map<String, dynamic> json) {
    id = json["id"];
    course = json["course"];
    description = json["description"];
    lable = json["lable"] ?? "";
    exam_Time = json["exam_Time"];
    skip_content_progress = json["skip_content_progress"];
         status = json["status"];
          deleteStatus = json["deleteStatus"];
          isSubscribed = json["isSubscribed"];
         isChatSubscribed = json["isChatSubscribed"];
         isJoinNotification = json["isJoinNotification"];
        subscriptionType = json["subscriptionType"];
         Mocktests = json["Mocktests"];
        isCancelSubscription = json["isCancelSubscription"];
        inAppPurchaseEnabled=json["inAppPurchaseEnabled"];
        subscriptionDurationQuantity=json["subscriptionDurationQuantity"];
        subscriptionDurationType=json["subscriptionDurationType"];
        availableQuestionOfTheDay=json["availableQuestionOfTheDay"];
        isFree=json["isFree"];

  }

  @override
  String getOptionName() {
    return lable;
  }
}
