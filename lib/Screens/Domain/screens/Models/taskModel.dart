class TaskDetails {
  int id;
  String name;
  String description;
  String Image;

  int domainId;
  int subdomainId;

  String Keywords;
  String Examples;
  int status;
  int deleteStatus;

  TaskDetails.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? "";
    description = json['description'] ?? "";
    Image = json['Image'] ?? "";
    domainId = json['domainId'] ?? "";
    subdomainId = json['subdomainId'] ?? "";
    Keywords = json['Keywords'] ?? "";
    Examples = json['Examples'] ?? "";
    status = json['status'];
    deleteStatus = json['deleteStatus'];
  }
}
