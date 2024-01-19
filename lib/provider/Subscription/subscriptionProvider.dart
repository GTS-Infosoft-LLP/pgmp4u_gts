import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pgmp4u/Services/globalcontext.dart';
import 'package:pgmp4u/provider/courseProvider.dart';
import 'package:pgmp4u/provider/profileProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../../Screens/Tests/local_handler/hive_handler.dart';
import '../../api/apis.dart';
import '../../subscriptionModel.dart';
import 'SubscriptionModel.dart';

class SubscriptionProvider extends ChangeNotifier {
  SharedPreferences prefs;
  String bodyyyy;
  CourseProvider cp = Provider.of(GlobalVariable.navState.currentContext, listen: false);

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

  int radioSelected = 0;
  setSelectedRadioVal(int val) {
    Future.delayed(Duration.zero, () async {
      radioSelected = val;
      dev.log(":::::radioSelected::::::$val");
      notifyListeners();
    });
  }

  // int isTime = ;
  bool isTimeOne;
  setisTimeOneVal(bool val) {
    Future.delayed(Duration.zero, () async {
      isTimeOne = val;
      dev.log(":::::setisTimeOneVal::::::$isTimeOne");
      notifyListeners();
    });
  }

  int selectedIval;
  setSelectedIval(int val) {
    // print("new value of I====$val");

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
    dev.log("in this conditionnn");
    // print("durationQuantity===$quntity");
    Future.delayed(Duration.zero, () async {
      selectedDurationTyp = type;
      selectedDurationQt = quntity;
      notifyListeners();
    }).then((value) async {
      CourseProvider cp = Provider.of(GlobalVariable.navState.currentContext, listen: false);
      await getSubscritionData(cp.selectedCourseId).then((value) async {
        ProfileProvider pp = Provider.of(GlobalVariable.navState.currentContext, listen: false);
        if (isFirtTime == 1) {
          if (permiumbutton.length > 2) {
            setSelectedSubsId(permiumbutton[0].id);
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

  int SelectedPlanDesc;
  setSelectedDescType(int val) {
    Future.delayed(Duration.zero, () async {
      SelectedPlanDesc = val;
      notifyListeners();
    });
  }

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

  CourseProvider courseProvider = Provider.of(GlobalVariable.navState.currentContext, listen: false);
  Future<void> freeSubscription(int idCrs) async {
    updateLoader(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {
      "courseId": idCrs,
    };
    bool checkConn = await checkInternetConn();
    if (checkConn) {
      bodyyyy = HiveHandler.getNotSubmittedMock(keyName: cp.notSubmitedMockID);
      if (bodyyyy == null) {
        bodyyyy = "";
      }
      if (bodyyyy.isNotEmpty) {
        Response response = await http
            .post(
          Uri.parse(SUBMIT_MOCK_TEST),
          headers: {"Content-Type": "application/json", 'Authorization': stringValue},
          body: bodyyyy,
        )
            .whenComplete(() async {
          await courseProvider.getTestDetails(courseProvider.selectedMockId);
          await courseProvider.apiCall(courseProvider.selectedTstPrcentId);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/${cp.selectedTstPrcentId}'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), cp.setPendindIndex.toString());
          }
        }).onError((error, stackTrace) {
          print("erroror::::$error");
          print("stackTrace::::$stackTrace");
          updateLoader(false);
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
      var response = await http
          .post(
        Uri.parse(FREE_SUBSCRIPTION),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      )
          .whenComplete(() {
        Navigator.pop(GlobalVariable.navState.currentContext);
      }).onError((error, stackTrace) {
        print("erroror::::$error");
        print("stackTrace::::$stackTrace");
        updateLoader(false);
      });

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
        print("map response staus===${mapResponse['status']}");

        if (mapResponse['status'] == 400) {
          print("here");
          EasyLoading.showInfo(mapResponse['message']);
          return;
        } else if (mapResponse['status'] == 200) {
          print("now here");

          CourseProvider cp = Provider.of(GlobalVariable.navState.currentContext, listen: false);
          cp.getCourse().whenComplete(() {
            EasyLoading.showSuccess("Free Pack Activated Successfully");
          });
        }
      }
    } catch (e) {
      print("error======$e");
      updateLoader(false);
    }
  }

  Future<void> getSubscritionData(int idCrs) async {
    updateSubsPackApiCall(true);
    updateLoader(true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    var request = {
      "courseId": idCrs,
      "durationType": selectedDurationTyp,
      "durationQuantity": selectedDurationQt,
      "type": SelectedPlanType
    };
    print("selected plan types$SelectedPlanType");
    dev.log("requestt::::::$request");

    try {
      var response = await http
          .post(
        Uri.parse(GET_SUBSCRIPTION_PACK),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      )
          .onError((error, stackTrace) {
        updateLoader(false);
      });

      var resDDo = json.decode(response.body);
      var resStatus = (resDDo["status"]);
      print("resDDo[success]----${resDDo["success"]}");

      if (resDDo["success"] == false) {
        updateSubsPackApiCall(false);
        updateLoader(false);
        setisTimeOneVal(false);
        SubscritionPackList = [];
        permiumbutton = [];
        desc1 = "";
        durationPackData = [];
        ftchList = [];
        updateLoader(false);
        return;
      }
      dev.log("response.statusCode::::::${response.statusCode}");
      if (response.statusCode == 400) {
        updateSubsPackApiCall(false);
        print("statussssssss");
        setisTimeOneVal(false);
        SubscritionPackList = [];
        ftchList = [];
        durationPackData = [];
        updateLoader(false);
        notifyListeners();
        return;
      }
      if (response.statusCode == 200) {
        try {
          updateLoader(false);
          ftchList = [];
          SubscritionPackList = [];
          updateSubsPackApiCall(false);
          SubscritionPackList.clear();

          Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);

          if (mapResponse['status'] == 400) {
            SubscritionPackList = [];
            return;
          }
          if (mapResponse["success"] == true) {
            List temp1 = mapResponse["data"]['list'];
            List temp2 = mapResponse["data"]['duration'];
            ftchList = mapResponse["data"]['featureList'];
            setisTimeOneVal(false);
            SubscritionPackList = temp1.map((e) => SubscriptionDetails.fromjson(e)).toList();
            durationPackData = temp2.map((e) => DurationDetail.fromjson(e)).toList();
            permiumbutton.clear();
            if (SubscritionPackList.isNotEmpty) {
              // desc1 = SubscritionPackList[0].description;
            }

            desc1 = "";
            dev.log("SelectedPlanType =====$SelectedPlanType}");
            // desc1 = SubscritionPackList[SelectedPlanType - 1].description;
            desc1 = SubscritionPackList[SelectedPlanDesc].description;
            for (int i = 0; i < SubscritionPackList.length; i++) {
              log("adding data to prem button----${SubscritionPackList[i].price}");
              permiumbutton.add(newButton(
                  amount: SubscritionPackList[i].price,
                  name: SubscritionPackList[i].title,
                  id: SubscritionPackList[i].id,
                  type: SubscritionPackList[i].type));
            }

            dev.log('SubscritionPackList["data" length]-----${SubscritionPackList.length}');
            dev.log('permiumbutton length-----${permiumbutton.length}');
          }
        } catch (error, stackTrace) {
          print("errror--- $error  stck---$stackTrace");
        }
      } else if (response.statusCode == 400) {}
    } catch (e) {
      updateSubsPackApiCall(false);
      setisTimeOneVal(false);
    }
    notifyListeners();
  }

  String finUrl;

  int alredyPurchase = 0;

  Future<void> createSubscritionOrder(int id) async {
    alredyPurchase = 0;

    finUrl = "";

    // print("idCrs=========>>>>>>>>>>>>>>>$id");
    finUrl = CREATE_SUBSCRIPTION_ORDER + "/$id";
    print("finUrlCREATE_SUBSCRIPTION_ORDER =========>>>>>>>>>>>>>>>$finUrl");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    bool checkConn = await checkInternetConn();
    if (checkConn) {
      bodyyyy = HiveHandler.getNotSubmittedMock(keyName: cp.notSubmitedMockID);
      if (bodyyyy == null) {
        bodyyyy = "";
      }
      if (bodyyyy.isNotEmpty) {
        Response response = await http
            .post(
          Uri.parse(SUBMIT_MOCK_TEST),
          headers: {"Content-Type": "application/json", 'Authorization': stringValue},
          body: bodyyyy,
        )
            .whenComplete(() async {
          await courseProvider.getTestDetails(courseProvider.selectedMockId);
          await courseProvider.apiCall(courseProvider.selectedTstPrcentId);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/${cp.selectedTstPrcentId}'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), cp.setPendindIndex.toString());
          }
        }).onError((error, stackTrace) {
          print("erroror::::$error");
          print("stackTrace::::$stackTrace");
          updateLoader(false);
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
      print("inside this try ");
      var response = await http.get(
        Uri.parse(CREATE_SUBSCRIPTION_ORDER + "/$id"),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
      ).onError((error, stackTrace) {
        print("erroror::::$error");
        print("stackTrace::::$stackTrace");
        updateLoader(false);
      });
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
        // print("mapResponsemapResponse=====$mapResponse");
        // print("mapResponse====${mapResponse['status']}");
        if (mapResponse['status'] == 400) {
          SubscritionPackList = [];
          return;
        }
        if (mapResponse["success"] == true) {
          List temp1 = mapResponse["data"];
          SubscritionPackList = temp1.map((e) => SubscriptionDetails.fromjson(e)).toList();
          permiumbutton.clear();
        }
      }
    } on Exception {
      // updateDomainApiCall(false);
    }
    notifyListeners();
  }

  var selectedSubsType;
  void setSelectedSubsType(int id) {
    Future.delayed(Duration.zero, () async {
      selectedSubsType = id;
      dev.log("selectedSubsType::::$selectedSubsType");
      notifyListeners();
    });
  }

  var selectedSubsId;
  void setSelectedSubsId(int id) {
    Future.delayed(Duration.zero, () async {
      selectedSubsId = id;
      // print("selectedSubsId********$selectedSubsId");
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
    bool checkConn = await checkInternetConn();
    if (checkConn) {
      bodyyyy = HiveHandler.getNotSubmittedMock(keyName: cp.notSubmitedMockID);
      if (bodyyyy == null) {
        bodyyyy = "";
      }
      if (bodyyyy.isNotEmpty) {
        Response response = await http
            .post(
          Uri.parse(SUBMIT_MOCK_TEST),
          headers: {"Content-Type": "application/json", 'Authorization': stringValue},
          body: bodyyyy,
        )
            .whenComplete(() async {
          await courseProvider.getTestDetails(courseProvider.selectedMockId);
          await courseProvider.apiCall(courseProvider.selectedTstPrcentId);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/${cp.selectedTstPrcentId}'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), cp.setPendindIndex.toString());
          }
        }).onError((error, stackTrace) {
          print("erroror::::$error");
          print("stackTrace::::$stackTrace");
          updateLoader(false);
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
      var response = await http
          .post(
        Uri.parse(CANCEL_SUBSCRIPTION),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      )
          .onError((error, stackTrace) {
        print("erroror::::$error");
        print("stackTrace::::$stackTrace");
        updateLoader(false);
      });

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
