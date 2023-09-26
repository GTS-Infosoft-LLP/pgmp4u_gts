// To parse this JSON data, do
//
//     final pdfListModel = pdfListModelFromJson(jsonString);

import 'dart:convert';

List<PdfModel> pdfListModelFromJson(String str) =>
    List<PdfModel>.from(json.decode(str).map((x) => PdfModel.fromJson(x)));

String pdfListModelToJson(List<PdfModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PdfResponseModel {
  int status;
  String message;
  PdfModel data;

  PdfResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory PdfResponseModel.fromJson(Map<String, dynamic> json) => PdfResponseModel(
        status: json["status"],
        message: json["message"],
        data: PdfModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class PdfModel {
  int id;
  String title;
  String ppt;
  int status;
  int deleteStatus;

  PdfModel({
    this.id,
    this.title,
    this.ppt,
    this.status,
    this.deleteStatus,
  });

  factory PdfModel.fromJson(Map<String, dynamic> json) => PdfModel(
        id: json["id"],
        title: json["title"],
        ppt: json["ppt"],
        status: json["status"],
        deleteStatus: json["deleteStatus"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "ppt": ppt,
        "status": status,
        "deleteStatus": deleteStatus,
      };
}
