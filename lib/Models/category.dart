class Resources {
  int status;
  String message;
  Map<String, dynamic> data;

  Resources.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
  }
}

class CategoryList {
  List<CategoryListItem> categoryList = [];

  CategoryList.fromJson(Map<String, dynamic> json) {
    categoryList = List<CategoryListItem>.from(
        json['CategoryList'].map((x) => CategoryListItem.fromJson(x)));
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
    id = json['id'] ?? 0;
    title = json['title'] ?? "";
    thumbnail = json['thumbnail'] ?? "";
    description = json['description'] ?? "";
    deleteStatus = json['deleteStatus'] ?? 0;
    status = json['status'] ?? 0;
  }
}
