
class PlanDetail {
    int id;
    String title;
    String price;
    int courseId;
    String planId;
    String description;
    String priceId;
    int type;
    int durationType;
    int durationQuantity;
    int days;
    String features;
    int status;
    int deleteStatus;

    PlanDetail({
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
        this.features,
        this.status,
        this.deleteStatus,
    });
 
    factory PlanDetail.fromJson(Map<String, dynamic> json) => PlanDetail(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        courseId: json["courseId"],
        planId: json["planId"],
        description: json["description"],
        priceId: json["priceId"],
        type: json["type"],
        durationType: json["durationType"],
      
        durationQuantity:json["durationQuantity"]==null?0: json["durationQuantity"],
        days: json["days"],
        features: json["features"],
        status: json["status"],
        deleteStatus: json["deleteStatus"],
    );

  
}
