import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../../api/apis.dart';
import '../../subscriptionModel.dart';
import 'SubscriptionModel.dart';

class SubscriptionProvider extends ChangeNotifier {
  SharedPreferences prefs;

  initSharePreferecne() async {
    prefs = await SharedPreferences.getInstance();
  }

  loaderUpdate(bool status) {
    if (status) {
      EasyLoading.show(status: "Loading", maskType: EasyLoadingMaskType.clear);
    } else {
      print("dismiss loader");
      EasyLoading.dismiss();
    }
  }

  bool loader = false;

  updateLoader(bool status) async {
    loaderUpdate(status);

    loader = status;
    await Future.delayed(Duration(seconds: 0));
    notifyListeners();
  }






 bool getSubsPackApiCall = false;

 updateSubsPackApiCall(bool val) {
    getSubsPackApiCall = val;
    notifyListeners();
  }





  List<SubscriptionDetails> SubscritionPackList = [];

  Future<void> getSubscritionData(int idCrs) async {
    print(">>>>>>>>>>>>>>getSubscritionData>>>>>>>>>>>>>>");
    // domainStatus = true;
    updateSubsPackApiCall(true);
    SubscritionPackList = [];
    print("idCrs=========>>>>>>>>>>>>>>>$idCrs");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"courseId": idCrs};

    try {
      var response = await http.post(
        Uri.parse(GET_SUBSCRIPTION_PACK),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      print("response.statusCode===${response.body}");

      print("response.statusCode===${response.statusCode}");

      // domainStatus;

      var resDDo = json.decode(response.body);
      var resStatus = (resDDo["status"]);

      print("satusss====${resDDo["success"]}");

      if (resDDo["success"] == false) {
        return;
      }

      if (response.statusCode == 400) {
        updateSubsPackApiCall(false);
        print("statussssssss");
        SubscritionPackList = [];

        notifyListeners();
        return;
      }
      if (response.statusCode == 200) {
        updateSubsPackApiCall(false);
        SubscritionPackList.clear();
        print("");
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        print("mapResponsemapResponse=====$mapResponse");
        print("mapResponse====${mapResponse['status']}");
        if (mapResponse['status'] == 400) {
          SubscritionPackList = [];
          print("SubscritionPackList=====$SubscritionPackList");
          return;
        }
        if (mapResponse["success"] == true) {
          List temp1 = mapResponse["data"];
          print("temp list===$temp1");
          SubscritionPackList = temp1.map((e) => SubscriptionDetails.fromjson(e)).toList();
          print("SubscritionPackList=========$SubscritionPackList");
          permiumbutton.clear();
          for (int i = 0; i < SubscritionPackList.length; i++) {
            permiumbutton.add(newButton(
                amount: SubscritionPackList[i].price,
                name: SubscritionPackList[i].title,
                id: SubscritionPackList[i].id));
          }
          print("permiumbutton=====$permiumbutton");
        }
      }
      print("respponse=== ${response.body}");
    } on Exception {
      updateSubsPackApiCall(false);
    }
    notifyListeners();
  }

  String finUrl;

  Future<void> createSubscritionOrder(int id) async {
    finUrl = "";
    print(">>>>>>>>>>>>>>getSubscritionData>>>>>>>>>>>>>>");

    print("idCrs=========>>>>>>>>>>>>>>>$id");
    finUrl = CREATE_SUBSCRIPTION_ORDER + "/$id";
    print("finUrl=========>>>>>>>>>>>>>>>$finUrl");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");

    try {
      var response = await http.get(
        Uri.parse(CREATE_SUBSCRIPTION_ORDER + "/$id"),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
      );

      print("response.statusCode===${response.body}");

      print("response.statusCode===${response.statusCode}");

      // domainStatus;

      var resDDo = json.decode(response.body);
      var resStatus = (resDDo["status"]);

      print("satusss====${resDDo["success"]}");

      if (resDDo["success"] == false) {
        return;
      }

      if (response.statusCode == 400) {
        // updateDomainApiCall(false);
        print("statussssssss");
        SubscritionPackList = [];

        notifyListeners();
        return;
      }
      if (response.statusCode == 200) {
        // updateDomainApiCall(false);
        SubscritionPackList.clear();
        print("");
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        print("mapResponsemapResponse=====$mapResponse");
        print("mapResponse====${mapResponse['status']}");
        if (mapResponse['status'] == 400) {
          return;
        }
        if (mapResponse["success"] == true) {
          List temp1 = mapResponse["data"];
          print("temp list===$temp1");
          SubscritionPackList = temp1.map((e) => SubscriptionDetails.fromjson(e)).toList();
          print("SubscritionPackList=========$SubscritionPackList");
          permiumbutton.clear();
        }
      }
      print("respponse=== ${response.body}");
    } on Exception {
      // updateDomainApiCall(false);
    }
    notifyListeners();
  }

  var selectedSubsId;
  void setSelectedSubsId(int id) {
    selectedSubsId = id;
    notifyListeners();
  }
}
