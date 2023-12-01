// import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pgmp4u/Process/processTask_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/Domain/screens/Models/taskModel.dart';
import '../Screens/Tests/local_handler/hive_handler.dart';
import '../Services/globalcontext.dart';
import '../api/apis.dart';
import '../provider/courseProvider.dart';

class ProcessDomainProvider extends ChangeNotifier {
  SharedPreferences prefs;

  initSharePreferecne() async {
    prefs = await SharedPreferences.getInstance();
  }

  List ProcessList = [];
  List SubProcessList = [];
  List ProcessTaskList = [];
  List ProcessTaskDetailsList = [];

  int selectedProcessTaskId;
  setSelectedProcessTaskId(int val) {
    selectedProcessTaskId = val;
    print("::::::selectedProcessTaskId:::::::$selectedProcessTaskId");
    notifyListeners();
  }

  int selectedProcessId;
  int selectedSubProcessId;
  setSelectedProcessId(int val) {
    selectedProcessId = val;
    notifyListeners();
  }

  setSelectedSubProcessId(int val) {
    selectedSubProcessId = val;
    notifyListeners();
  }

  String selectedProcessName;
  String selectedSubProcessName;

  setSubSelectedProcessName(String val) {
    selectedSubProcessName = val;
    notifyListeners();
  }

  setSelectedProcessName(String val) {
    selectedProcessName = val;
    notifyListeners();
  }

  bool subProcessApiCall = false;

  bool processTaskApiCall = false;
  bool processTaskDetailApiCall = false;
  bool processApiCall = false;

  updateProcessApiCall(bool val) {
    processApiCall = val;
    notifyListeners();
  }

  updateSubProcessApiCall(bool val) {
    subProcessApiCall = val;
    notifyListeners();
  }

  updateProcessTaskApiCall(bool val) {
    processTaskApiCall = val;
    notifyListeners();
  }

  updateProcessTaskDetailApiCall(bool val) {
    processTaskDetailApiCall = val;
    notifyListeners();
  }

  String bodyyyy;
  CourseProvider cp = Provider.of(GlobalVariable.navState.currentContext, listen: false);

  bool processStatus = true;
  Future<void> getProcessData(int crsId, int masterId) async {
    processStatus = true;
    updateProcessApiCall(true);
    ProcessList = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"courseId": crsId, "masterList": masterId};
    print("requesttttttt>>>>$request");
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
          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
          await cp.getTestDetails(cp.allTestListIdOfline);

          Response response = await http.get(Uri.parse(MOCK_TEST + '/${cp.attempListIdOffline}'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), cp.attempListIdOffline.toString());
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
      var response = await http.post(
        Uri.parse(GET_PROCESS),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      print("response.statusCode===${response.body}");
      print("response.statusCode===${response.statusCode}");

      var resDDo = json.decode(response.body);
      var resStatus = (resDDo["status"]);
      print("satusss for process api====${resDDo["success"]}");

      if (resDDo["success"] == false) {
        processStatus = false;
        return;
      }

      if (response.statusCode == 400) {
        updateProcessApiCall(false);
        print("statussssssss");
        ProcessList = [];
        notifyListeners();
        return;
      }
      if (response.statusCode == 200) {
        updateProcessApiCall(false);
        ProcessList.clear();
        print("");
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        print("mapResponse====${mapResponse['status']}");
        if (mapResponse['status'] == 400) {
          ProcessList = [];

          return;
        }

        if (mapResponse["status"] == 200) {
          List temp1 = mapResponse["data"];
          print("temp list===$temp1");
          HiveHandler.addProcessDetailData(jsonEncode(mapResponse["data"]), masterId.toString());

          // ProcessList = temp1.map((e) => SubDomainDetails.fromjson(e)).toList();
          print("process List=========$ProcessList");
        } else {}
      }
      print("respponse=== ${response.body}");
    } on Exception {
      updateProcessApiCall(false);
    }
    notifyListeners();
  }

  Future<void> getSubProcessData(int id) async {
    updateSubProcessApiCall(true);
    SubProcessList = [];
    print("idMaster=========>>>>>>>>>>>>>>>$id");

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};
    print("api request-----$request");

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
          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
          await cp.getTestDetails(cp.allTestListIdOfline);

          Response response = await http.get(Uri.parse(MOCK_TEST + '/${cp.attempListIdOffline}'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), cp.attempListIdOffline.toString());
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
      var response = await http.post(
        Uri.parse(GET_SUB_PROCESS),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      print("response.statusCode===${response.body}");
      print("response.statusCode===${response.statusCode}");

      var resDDo = json.decode(response.body);
      var resStatus = (resDDo["status"]);

      if (response.statusCode == 400) {
        updateSubProcessApiCall(false);
        print("statussssssss");
        SubProcessList = [];

        notifyListeners();
        return;
      }
      if (response.statusCode == 200) {
        updateSubProcessApiCall(false);
        SubProcessList.clear();
        print("");
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        print("mapResponse====${mapResponse['status']}");
        if (mapResponse['status'] == 400) {
          SubProcessList = [];

          return;
        }

        if (mapResponse["status"] == 200) {
          List temp1 = mapResponse["data"];
          print("temp list===$temp1");
          HiveHandler.addsubProcessDetailData(jsonEncode(mapResponse["data"]), id.toString());

          // SubProcessList = temp1.map((e) => SubDomainDetails.fromjson(e)).toList();
          print("SubProcessList=========$SubProcessList");
        }
      }
      print("respponse=== ${response.body}");
    } on Exception {
      updateSubProcessApiCall(false);
    }
    notifyListeners();
  }

  Future<void> getProcessTaskData(int processId, int subProcessId) async {
    updateProcessTaskApiCall(true);
    print("tast loader lOADER====$processTaskApiCall");
    ProcessTaskList = [];

    print("idddd=========>>>>>>>>>>>>>>>$processId");
    // print("subProcessId=========>>>>>>>>>>>>>>>$subProcessId");

    // dynamic subProcessId = selectedProcessId;
    // if (subProcessId == "") {
    //   subProcessId = "";
    // } else {
    //   subProcessId = subProcessId;
    // }

    print("domnId======$subProcessId");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"processId": processId, "subProcessId": subProcessId};
    print("request==============$request");
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
          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
          await cp.getTestDetails(cp.allTestListIdOfline);
          // await apiCall(attempListIdOffline);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/${cp.attempListIdOffline}'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), cp.attempListIdOffline.toString());
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
      var response = await http.post(
        Uri.parse(GET_TASKS_PROCESS),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      print("response.statusCode===${response.body}");
      print("response.statusCode===${response.statusCode}");

      var resDDo = json.decode(response.body);
      var resStatus = (resDDo["status"]);

      if (response.statusCode == 400) {
        updateProcessTaskApiCall(false);
        print("statussssssss");
        ProcessTaskList = [];
        notifyListeners();
        return;
      }
      if (response.statusCode == 200) {
        updateProcessTaskApiCall(false);
        ProcessTaskList.clear();
        print("");
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        print("mapResponse====${mapResponse['status']}");
        if (mapResponse['status'] == 400) {
          ProcessTaskList = [];
          print("TaskList====$ProcessTaskList");
          return;
        }

        if (mapResponse["status"] == 200) {
          List temp1 = mapResponse["data"];
          print('mapResponse["data"]>>>>>>>${mapResponse["data"]}');
          // print('mapResponse["data"] lableee:::::::::::::${mapResponse["data"][0]["lable"]}');

          HiveHandler.setProcessTaskItemsData(key: processId.toString(), value: jsonEncode(mapResponse["data"]));
          print("temp list===$temp1");
          ProcessTaskList = temp1.map((e) => TaskDetails.fromjson(e)).toList();
          print("ProcessTaskList=========$ProcessTaskList");
          // taskCount = ProcessTaskList.length;
          // print("taskCount======$taskCount");
        }
      }
      print("respponse=== ${response.body}");
    } on Exception {
      updateProcessTaskApiCall(false);
    }
    notifyListeners();
  }

  List<TaskPracQues> ProcessQues = [];
  Future<void> getProcessTasksDetailData(int id) async {
    updateProcessTaskDetailApiCall(true);
    ProcessTaskDetailsList = [];
    print("this apiii====");
    print("idddd=========>>>>>>>>>>>>>>>$id");
    print("idddd selectedDomainId=====>>>>$selectedProcessId");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};
    print("request:::::$request");
    print("api name::::::::$GET_TASKS_PROCESS_DETAIL");
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
          HiveHandler.removeFromRestartBox(cp.notSubmitedMockID);
          HiveHandler.removeFromSubmitMockBox(cp.notSubmitedMockID);
          await cp.getTestDetails(cp.allTestListIdOfline);
          // await apiCall(attempListIdOffline);
          Response response = await http.get(Uri.parse(MOCK_TEST + '/${cp.attempListIdOffline}'),
              headers: {'Content-Type': 'application/json', 'Authorization': stringValue});
          Map getit;
          if (response.statusCode == 200) {
            getit = convert.jsonDecode(response.body);
            print("mock data==================>>>>>>>>>>1 ${jsonEncode(getit["data"])}");
            await HiveHandler.addMockAttempt(jsonEncode(getit["data"]), cp.attempListIdOffline.toString());
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
      var response = await http.post(
        Uri.parse(GET_TASKS_PROCESS_DETAIL),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      print("response.statusCode===${response.body}");
      print("response.statusCode===${response.statusCode}");

      var resDDo = json.decode(response.body);
      var resStatus = (resDDo["status"]);

      if (response.statusCode == 400) {
        updateProcessTaskDetailApiCall(false);
        print("statussssssss");
        ProcessTaskDetailsList = [];
        notifyListeners();
        return;
      }
      if (response.statusCode == 200) {
        updateProcessTaskDetailApiCall(false);
        ProcessTaskDetailsList.clear();
        print("");
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        print("mapResponse====${mapResponse['status']}");
        debugPrint("mapResponse data====${mapResponse['data']}");
        print("mapResponse data practiceTest====${mapResponse['data'][0]["practiceTest"]}");
        if (mapResponse['status'] == 400) {
          ProcessTaskDetailsList = [];
          return;
        }

        if (mapResponse["status"] == 200) {
          List temp1 = mapResponse["data"];
          print("addinggg to the boxxxX::::::::;");
          HiveHandler.setTaskItemsData(key: id.toString(), value: jsonEncode(mapResponse["data"]));
          print("temp1:::::temp1:::::$temp1");
          HiveHandler.setProcessTaskQuesData(
              key: id.toString(), value: jsonEncode(mapResponse['data'][0]["practiceTest"]));
          List temp2 = temp1[0]["practiceTest"];
          print(":::::temp2:::::$temp2");
          ProcessQues = temp2.map((e) => TaskPracQues.fromJson(e)).toList();
          print("Tpq=======$ProcessQues");
          ProcessTaskDetailsList = temp1.map((e) => ProcessTskDetails.fromjson(e)).toList();
          print("TaskDetailList=========${ProcessTaskDetailsList[0].name}");
        }
      }
      print("respponse=== ${response.body}");
    } on Exception {
      updateProcessTaskDetailApiCall(false);
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
