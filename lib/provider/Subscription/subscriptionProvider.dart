import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pgmp4u/Services/globalcontext.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:pgmp4u/provider/profileProvider.dart';
import 'package:provider/provider.dart';
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

  int radioSelected;
  setSelectedRadioVal(int val) {
    Future.delayed(Duration.zero, () async {
      radioSelected = val;
      print(":::::radioSelected::::::$radioSelected");
      notifyListeners();
    });
  }

  int selectedIval;
  setSelectedIval(int val) {
    print("new value of I====$val");

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

  List ftchList = [];
  List<SubscriptionDetails> SubscritionPackList = [];

  List<DurationDetail> durationPackData = [];

  int selectedDurationTyp;
  int selectedDurationQt;
  Future<void> setSelectedDurTimeQt(int type, int quntity, {int isFirtTime = 0}) {
    print("durationQuantity===$quntity");
    Future.delayed(Duration.zero, () async {
      selectedDurationTyp = type;
      selectedDurationQt = quntity;
      notifyListeners();
    }).then((value) {
      CourseProvider cp = Provider.of(GlobalVariable.navState.currentContext, listen: false);
      getSubscritionData(cp.selectedCourseId).then((value) {
        ProfileProvider pp = Provider.of(GlobalVariable.navState.currentContext, listen: false);
        if (isFirtTime == 1) {
          if (permiumbutton.length > 2) {
            setSelectedSubsId(permiumbutton[2].id);
          }
        } else {
          setSelectedSubsId(permiumbutton[0].id);
        }

        // isFirtTime == 1 ? setSelectedSubsId(permiumbutton[2].id) : setSelectedSubsId(permiumbutton[0].id);
      }

          //  isFirtTime == 1 ? setSelectedSubsId(permiumbutton[2].id) : setSelectedSubsId(permiumbutton[0].id)

          );
    });
  }

  String desc1;
  String desc2;
  String desc3;

  int SelectedPlanType;
  setSelectedPlanType(int val) {
    Future.delayed(Duration.zero, () async {
      SelectedPlanType = val;
      notifyListeners();
    }).then((value) {
      CourseProvider cp = Provider.of(GlobalVariable.navState.currentContext, listen: false);
      getSubscritionData(cp.selectedCourseId);
    });
  }

  Future<void> freeSubscription(int idCrs) async {
    updateLoader(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // print("issyue in this api....");

    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {
      "courseId": idCrs,
    };
    print("requestt::::::$request");
    try {
      var response = await http.post(
        Uri.parse(FREE_SUBSCRIPTION),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      print("response.statusCode===${response.body}");

      print("response.statusCode===${response.statusCode}");
      var resDDo = json.decode(response.body);
      var resStatus = (resDDo["status"]);
      // (resDDo["data"]);
      print("check data=====${resDDo["data"]}");

      print("satusss====${resDDo["success"]}");
      if (resDDo["success"] == false) {
        return;
      }
      if (response.statusCode == 400) {
        print("statussssssss");

        updateLoader(false);
        notifyListeners();
        return;
      }
      if (response.statusCode == 200) {
        updateLoader(false);
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        print("mapResponsemapResponse=====$mapResponse");
        print("mapResponse====${mapResponse['data']}");

        if (mapResponse['status'] == 400) {
          print("here");
          EasyLoading.showInfo("You have already used Free Pack for this Course");
          return;
        } else if (mapResponse['status'] == 200) {
          print("now here");
          EasyLoading.showSuccess("Free Pack Activated Successfully");
        }
      }
    } catch (e) {
      print("error======$e");
      updateLoader(false);
    }
  }

  Future<void> getSubscritionData(int idCrs) async {
    // updateLoader(true);
    // ftchList = [];
    print(">>>>>>>>>>>>>>getSubscritionData>>>>>>>>>>>>>>");
    // domainStatus = true;
    updateSubsPackApiCall(true);
    updateLoader(true);
    // SubscritionPackList = [];
    print("idCrs=========>>>>>>>>>>>>>>>$idCrs");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // print("issyue in this api....");

    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {
      "courseId": idCrs,
      "durationType": selectedDurationTyp,
      "durationQuantity": selectedDurationQt,
      "type": SelectedPlanType
    };
    print("requestt::::::$request");
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
        updateLoader(false);
        SubscritionPackList = [];
        permiumbutton = [];
        desc1 = "";
        durationPackData = [];
        ftchList = [];
        updateLoader(false);
        return;
      }

      if (response.statusCode == 400) {
        updateSubsPackApiCall(false);
        print("statussssssss");
        SubscritionPackList = [];
        ftchList = [];
        durationPackData = [];
        updateLoader(false);
        notifyListeners();
        return;
      }
      if (response.statusCode == 200) {
        updateLoader(false);
        ftchList = [];
        SubscritionPackList = [];
        updateSubsPackApiCall(false);
        SubscritionPackList.clear();
        print("");
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        print("mapResponsemapResponse=====$mapResponse");
        print("mapResponse====${mapResponse['data']}");
        // description = mapResponse['description'];

        if (mapResponse['status'] == 400) {
          SubscritionPackList = [];
          print("SubscritionPackList=====$SubscritionPackList");
          return;
        }
        if (mapResponse["success"] == true) {
          List temp1 = mapResponse["data"]['list'];
          List temp2 = mapResponse["data"]['duration'];
          ftchList = mapResponse["data"]['featureList'];

          print("List of featuess====$ftchList");
          print("temp list===$temp1");
          SubscritionPackList = temp1.map((e) => SubscriptionDetails.fromjson(e)).toList();
          durationPackData = temp2.map((e) => DurationDetail.fromjson(e)).toList();
          print("durationPackDatadurationPackDatadurationPackData=========$durationPackData");
          // description = mapResponse["data"]["description"];
          print("SubscritionPackList=========$SubscritionPackList");
          permiumbutton.clear();
          desc1 = SubscritionPackList[0].description;
          for (int i = 0; i < SubscritionPackList.length; i++) {
            // description.add(SubscritionPackList[i].description.toString());

            permiumbutton.add(newButton(
                amount: SubscritionPackList[i].price,
                name: SubscritionPackList[i].title,
                id: SubscritionPackList[i].id,
                type: SubscritionPackList[i].type));
          }

          print("permiumbutton=====$permiumbutton");
        }
      } else if (response.statusCode == 400) {
        print("status is 400");
      }
      print("respponse=== ${response.body}");
    } on Exception {
      updateSubsPackApiCall(false);
    }
    notifyListeners();
  }

  String finUrl;

  int alredyPurchase = 0;

  Future<void> createSubscritionOrder(int id) async {
    alredyPurchase = 0;

    finUrl = "";
    print(">>>>>>>>>>>>>>getSubscritionData>>>>>>>>>>>>>>");

    print("idCrs=========>>>>>>>>>>>>>>>$id");
    finUrl = CREATE_SUBSCRIPTION_ORDER + "/$id";
    // print("finUrl=========>>>>>>>>>>>>>>>$finUrl");
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
      if (resStatus == 400) {
        alredyPurchase = 1;
        EasyLoading.showInfo("${resDDo['message']}");
        print("alredyPurchase $alredyPurchase");
        print("resposnse is 400");
        print("resDDo[message]::::${resDDo['message']}");
        return;
      }

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
          SubscritionPackList = [];
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
    Future.delayed(Duration.zero, () async {
      selectedSubsId = id;
      print("selectedSubsId********$selectedSubsId");
      notifyListeners();
    });
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
        if (mapResponse['success'] == true) {
          updateLoader(false);
          EasyLoading.showSuccess("Your Subscription Pack will be Expired at the end the Period.");
          return;
        } else if (mapResponse['success'] == false) {
          updateLoader(false);
          EasyLoading.showSuccess("Plan for this course is already cancelled");
          return;
        }
      }
      print("respponse=== ${response.body}");
    } on Exception {
      updateLoader(false);
    }
    notifyListeners();
  }
}
