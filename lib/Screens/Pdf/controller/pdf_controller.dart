import 'dart:convert';
import 'dart:convert'as convert;
import 'package:flutter/material.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pgmp4u/Screens/Pdf/model/pdf_list_model.dart';
import 'package:pgmp4u/Screens/Pdf/model/pdf_list_response_model.dart';
import 'package:pgmp4u/Services/globalcontext.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Tests/local_handler/hive_handler.dart';

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

  String bodyyyy;
  CourseProvider cp=Provider.of(GlobalVariable.navState.currentContext,listen: false);
  PdfModel pdf;
  getPdfDetails(BuildContext context, int id) async {
    updateLoader(true);

    String stringValue = prefs.getString('token');
    print(stringValue);
    http.Response response;
 bool checkConn = await checkInternetConn();
    if (checkConn) {
      bodyyyy = HiveHandler.getNotSubmittedMock(keyName: cp.notSubmitedMockID);
      if (bodyyyy == null) {
        bodyyyy = "";
      }
      if (bodyyyy.isNotEmpty) {
        Response response = await http.post(
          Uri.parse(SUBMIT_MOCK_TEST),
          headers: {"Content-Type": "application/json", 'Authorization': stringValue},
          body: bodyyyy,
        ).whenComplete(() async {
 await cp.getTestDetails(cp.selectedMockId);
        await cp.apiCall(cp.selectedTstPrcentId);
              Response response=await http.get(Uri.parse(MOCK_TEST + '/${cp.selectedTstPrcentId}'),
            headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
               Map getit;
              if (response.statusCode == 200) {
        getit = convert.jsonDecode(response.body);
        print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
        await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), cp.setPendindIndex.toString());
        } 
        });
        if (response.statusCode == 200) {
          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
          cp.setnotSubmitedMockID("");
          cp.setToBeSubmitIndex(1000);
        }
      }
    }

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
 bool checkConn = await checkInternetConn();
    if (checkConn) {
      bodyyyy = HiveHandler.getNotSubmittedMock(keyName: cp.notSubmitedMockID);
      if (bodyyyy == null) {
        bodyyyy = "";
      }
      if (bodyyyy.isNotEmpty) {
        Response response = await http.post(
          Uri.parse(SUBMIT_MOCK_TEST),
          headers: {"Content-Type": "application/json", 'Authorization': stringValue},
          body: bodyyyy,
        ).whenComplete(() async {
           await cp.getTestDetails(cp.selectedMockId);
        await cp.apiCall(cp.selectedTstPrcentId);
              Response response=await http.get(Uri.parse(MOCK_TEST + '/${cp.selectedTstPrcentId}'),
            headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
               Map getit;
              if (response.statusCode == 200) {
        getit = convert.jsonDecode(response.body);
        print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
        await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), cp.setPendindIndex.toString());
        } 
        });
        if (response.statusCode == 200) {
          HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
          cp.setnotSubmitedMockID("");
          cp.setToBeSubmitIndex(1000);
        }
      }
    }

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


  Future checkInternetConn() async {
    bool result = await InternetConnectionChecker().hasConnection;
    print("result while call fun $result");
    if (result == false) {
      Future.delayed(Duration(seconds: 1), () async {
        //  await EasyLoading.showToast("Internet Not Connected",toastPosition: EasyLoadingToastPosition.bottom);
      });
      return result;
    } else {}
    return result;
  }



}
