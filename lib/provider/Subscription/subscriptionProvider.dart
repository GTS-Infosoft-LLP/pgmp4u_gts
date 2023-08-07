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

  List<String> sliverList = [
    "Access To Glossary",
    "Access To Formulas",
    "Access To Flash Cards",
    "Access to Mock and Practice Exam",
    "Access to Application Support(Except Expert View)"
  ];
  List<String> GoldList = ["Silver", "Chat", "Application Support(Assisted by Expert)+ CRG"];
  List<String> platinumList = ["Gold", "Access to Recording", "Exam Strategy Session with Mentor PDUs/Contact hours"];

  int radioSelected;
  setSelectedRadioVal(int val) {
    Future.delayed(Duration.zero, () async {
      radioSelected = val;
      notifyListeners();
    });
  }

  int selectedIval;
  setSelectedIval(int val) {
    print("new value of I====$val");
    print("PackList[$val].description====  ${SubscritionPackList[val].description}");
    Future.delayed(Duration.zero, () async {
      selectedIval = val;
      notifyListeners();
    });
  }

  bool getSubsPackApiCall = false;

  updateSubsPackApiCall(bool val) {
    Future.delayed(Duration.zero, () async {
      getSubsPackApiCall = val;
      notifyListeners();
    });
  }

  List<SubscriptionDetails> SubscritionPackList = [];
  List<String> description = [];
  Future<void> getSubscritionData(int idCrs) async {
    description = [];
    print(">>>>>>>>>>>>>>getSubscritionData>>>>>>>>>>>>>>");
    // domainStatus = true;
    updateSubsPackApiCall(true);
    SubscritionPackList = [];
    print("idCrs=========>>>>>>>>>>>>>>>$idCrs");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("issyue in this api....");

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
      // (resDDo["data"]);
      print("check data=====${resDDo["data"]}");

      print("satusss====${resDDo["success"]}");

      if (resDDo["success"] == false) {
        updateSubsPackApiCall(false);
        SubscritionPackList = [];
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
        // description = mapResponse['description'];
        print("description====$description");
        if (mapResponse['status'] == 400) {
          SubscritionPackList = [];
          print("SubscritionPackList=====$SubscritionPackList");
          return;
        }
        if (mapResponse["success"] == true) {
          List temp1 = mapResponse["data"];
          print("temp list===$temp1");
          SubscritionPackList = temp1.map((e) => SubscriptionDetails.fromjson(e)).toList();
          // description = mapResponse["data"]["description"];
          print("SubscritionPackList=========$SubscritionPackList");
          permiumbutton.clear();
          for (int i = 0; i < SubscritionPackList.length; i++) {
            // description.add(SubscritionPackList[i].description.toString());

            permiumbutton.add(newButton(
                amount: SubscritionPackList[i].price,
                name: SubscritionPackList[i].title,
                id: SubscritionPackList[i].id,
                type: SubscritionPackList[i].type));
          }
          print("description====$description");
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

  var selectedSubsType;
  void setSelectedSubsType(int id) {
    Future.delayed(Duration.zero, () async {
      selectedSubsType = id;
      notifyListeners();
    });
  }

  var selectedSubsId;
  void setSelectedSubsId(int id) {
    selectedSubsId = id;
    notifyListeners();
  }

  Future<void> cancelSubscription(
    int id,
  ) async {
    print("idddd=========>>>>>>>>>>>>>>>$id");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"courseId": id};
    print("request==============$request");
    updateLoader(true);
    try {
      var response = await http.post(
        Uri.parse(CANCEL_SUBSCRIPTION),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      print("response.statusCode===${response.body}");
      print("response.statusCode===${response.statusCode}");

      var resDDo = json.decode(response.body);
      var resStatus = (resDDo["status"]);

      if (response.statusCode == 400) {
        updateLoader(false);

        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        if (mapResponse['success'] == false) {
          updateLoader(false);
          // EasyLoading.showSuccess("Plan for this course is already cancelled");
          EasyLoading.showInfo("Plan for this course is already cancelled");
          notifyListeners();
          return;
        }
      }
      if (response.statusCode == 200) {
        updateLoader(false);
        print("");
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        print("mapResponse====$mapResponse");

        // EasyLoading.showSuccess("Your Subscription Pack will be Expired at the end the Period.");

        if (mapResponse['success'] == true) {
          updateLoader(false);
          EasyLoading.showSuccess("Your Subscription Pack will be Expired at the end the Period.");
          return;
        } else if (mapResponse['success'] == false) {
          updateLoader(false);
          EasyLoading.showSuccess("Plan for this course is already cancelled");
          return;
        }

        // if (mapResponse["status"] == 200) {
        //   print("respponse=== ${response.body}");
        // }
      }
      print("respponse=== ${response.body}");
    } on Exception {
      updateLoader(false);
    }
    notifyListeners();
  }
}
