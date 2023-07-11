import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:pgmp4u/Screens/Pdf/model/pdf_list_model.dart';
import 'package:pgmp4u/Screens/Pdf/model/pdf_list_response_model.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PdfProvider extends ChangeNotifier {
  SharedPreferences prefs;

  initSharePreferecne() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool isDetailsLoading = false;
  updateLoader(bool v) {
    isDetailsLoading = v;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  PdfModel pdf;
  getPdfDetails(BuildContext context, int id) async {
    updateLoader(true);

    String stringValue = prefs.getString('token');
    print(stringValue);
    http.Response response;

    try {
      response = await http.post(
        Uri.parse(GET_PPTS_DETAILS),
        headers: {'Content-Type': 'application/json', 'Authorization': "Bearer " + stringValue},
        body: jsonEncode({"id": id}),
      );

      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        PdfResponseModel pdfListResponseTemp = PdfResponseModel.fromJson(jsonDecode(response.body));

        pdf = pdfListResponseTemp.data;

        // pdfList = pdfListResponseTemp.data;

        updateLoader(false);
      } else {
        updateLoader(false);
        GFToast.showToast(
          "Error while getting details",
          context,
          toastPosition: GFToastPosition.BOTTOM,
        );
        print('error while calling api status ${response.statusCode}');
        print(jsonDecode(response.body));
      }
    } on Exception {
      updateLoader(false);
      GFToast.showToast(
        "Error while getting details",
        context,
        toastPosition: GFToastPosition.BOTTOM,
      );
      print('error while calling api');
    }
  }

  List<PdfModel> pdfList = [];
  bool isPdfListLoading = false;
  updatePdfListLoader(bool v) {
    isPdfListLoading = v;
    Future.delayed(Duration.zero, () {
      notifyListeners();
    });
  }

  getPdfList() async {
    updatePdfListLoader(true);

    String stringValue = prefs.getString('token');
    print(stringValue);
    http.Response response;

    try {
      response = await http.get(
        Uri.parse(GET_PPTS),
        headers: {'Content-Type': 'application/json', 'Authorization': "Bearer " + stringValue},
      );

      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        PdfListResponseModel pdfListResponseTemp = PdfListResponseModel.fromJson(jsonDecode(response.body));

        pdfList = pdfListResponseTemp.data;

        updatePdfListLoader(false);
      } else {
        updatePdfListLoader(false);
        print('error while calling api status ${response.statusCode}, message: ${response.body}');
        print(jsonDecode(response.body));
      }
    } on Exception {
      updatePdfListLoader(false);
      print('error while calling api');
    }
  }
}
