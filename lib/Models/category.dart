class CategoryApiResponse {
  int status;
  String message;
  Map<String, dynamic> data;

  CategoryApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }
}

class CategoryList {
  List<CategoryListItem> categoryList = [];

  CategoryList.fromJson(Map<String, dynamic> json) {
    categoryList = List<CategoryListItem>.from(
        json['CategoryList'].map((x) => CategoryList.fromJson(x)));
  }
}

class CategoryListItem {
  int id;
  String title;
  String thumbnail;
  String description;
  int deleteStatus;
  int status;

  CategoryListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    thumbnail = json['thumbnail'];
    description = json['description'];
    deleteStatus = json['deleteStatus'];
    status = json['status'];
  }
}
