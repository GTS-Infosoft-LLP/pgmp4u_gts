class DomainDetails {
  int id;
  String name;
  int position;
  int courseId;
  int masterList;
  int status;
  int deleteStatus;
  int SubDomains;
  int Tasks;

  DomainDetails.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    position = json['position'];
    courseId = json['courseId'];
    masterList = json['masterList'];
    status = json['status'];
    deleteStatus = json['deleteStatus'];
    SubDomains = json['SubDomains'];
    Tasks = json['Tasks'];
  }
}
