




import 'package:hive/hive.dart';
part 'get_reminder_model.g.dart';
class GetReminder {
    int daysDiff;
    int averageScore;
    int isStudyReminderAdded;
    dynamic studyReminder;
    int notification;
    CurrentSubscription currentSubscription;

    GetReminder({
        this.daysDiff,
        this.averageScore,
        this.isStudyReminderAdded,
        this.studyReminder,
        this.notification,
        this.currentSubscription,
    });

    factory GetReminder.fromJson(Map<String, dynamic> json) => GetReminder(
        daysDiff: json["daysDiff"],
        averageScore: json["averageScore"],
        isStudyReminderAdded: json["isStudyReminderAdded"],
        studyReminder: json["studyReminder"],
        notification: json["notification"],
        currentSubscription: json["currentSubscription"] == null ? null : CurrentSubscription.fromJson(json["currentSubscription"]),
    );

  
}

@HiveType(typeId: 30)
class CurrentSubscription {
    @HiveField(0)
    int id;
      @HiveField(1)
    String title;
      @HiveField(2)
    String price;
      @HiveField(3)
    int courseId;
      @HiveField(4)
    String planId;
      @HiveField(5)
    String description;
      @HiveField(6)
    String priceId;
    int type;
      @HiveField(7)
    int durationType;
      @HiveField(8)
    int durationQuantity;
      @HiveField(9)
    int days;
      @HiveField(10)
    int chat;
      @HiveField(11)
    int qOfDay;
      @HiveField(12)
    String features;
      @HiveField(13)
    int status;
      @HiveField(14)
    int deleteStatus;

    CurrentSubscription({
        this.id,
        this.title,
        this.price,
        this.courseId,
        this.planId,
        this.description,
        this.priceId,
        this.type,
        this.durationType,
        this.durationQuantity,
        this.days,
        this.chat,
        this.qOfDay,
        this.features,
        this.status,
        this.deleteStatus,
    });

    factory CurrentSubscription.fromJson(Map<String, dynamic> json) => CurrentSubscription(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        courseId: json["courseId"],
        planId: json["planId"],
        description: json["description"],
        priceId: json["priceId"],
        type: json["type"],
        durationType: json["durationType"],
        durationQuantity: json["durationQuantity"],
        days: json["days"],
        chat: json["chat"],
        qOfDay: json["QOfDay"],
        features: json["features"],
        status: json["status"],
        deleteStatus: json["deleteStatus"],
    );

  
}
