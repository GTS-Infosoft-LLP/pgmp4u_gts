class FreeTrialData {
  String course;
  String lable;
  int id;
  int days;

  FreeTrialData({
    this.course,
    this.lable,
    this.id,
    this.days,
  });

  FreeTrialData.fromJson(Map<String, dynamic> json) {
    course = json["course"];
    lable = json["lable"];
    id = json["id"];
    days = json["days"];
  }
}
