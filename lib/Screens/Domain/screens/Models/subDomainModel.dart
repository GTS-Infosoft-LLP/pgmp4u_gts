class SubDomainDetails {
  int id;
  String name;
  String lable;
  int position;
  int domainId;
  int status;
  int deleteStatus;
  int Tasks;

  SubDomainDetails.fromjson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lable = json['lable'];
    position = json['position'];
    domainId = json['domainId'];

    status = json['status'];
    deleteStatus = json['deleteStatus'];

    Tasks = json['Tasks'];
  }
}
