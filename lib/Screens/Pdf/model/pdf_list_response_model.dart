// To parse this JSON data, do
//
//     final pdfListResponseModel = pdfListResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:pgmp4u/Screens/Pdf/model/pdf_list_model.dart';

PdfListResponseModel pdfListResponseModelFromJson(String str) => PdfListResponseModel.fromJson(json.decode(str));

String pdfListResponseModelToJson(PdfListResponseModel data) => json.encode(data.toJson());

class PdfListResponseModel {
  int status;
  String message;
  List<PdfModel> data;

  PdfListResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory PdfListResponseModel.fromJson(Map<String, dynamic> json) => PdfListResponseModel(
        status: json["status"],
        message: json["message"],
        data: List<PdfModel>.from(json["data"].map((x) => PdfModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
