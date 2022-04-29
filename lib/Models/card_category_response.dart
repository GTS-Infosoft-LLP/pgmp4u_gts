class CardDetails {
  List<CardDetailList> cardDetailsList = [];

  CardDetails.fromJson(Map<String, dynamic> json) {
    cardDetailsList = List<CardDetailList>.from(
        json['cardDetailList'].map((x) => CardDetailList.fromJson(x)));
  }
}

class CardDetailList {
  int id;
  String title;
  String description;
  int deleteStatus;
  int status;
  int categoryId;

  CardDetailList.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    title = json['title'] ?? "";
    description = json['description'] ?? "";
    deleteStatus = json['deleteStatus'] ?? 0;
    status = json['status'] ?? 0;
    categoryId = json['categoryId'] ?? 0;
  }
}
