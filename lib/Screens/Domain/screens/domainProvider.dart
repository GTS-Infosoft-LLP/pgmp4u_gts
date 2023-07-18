import 'dart:convert';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/Domain/screens/Models/domainCategoryModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/apis.dart';
import 'Models/domainModel.dart';
import 'Models/subDomainModel.dart';
import 'Models/taskModel.dart';

class DomainProvider extends ChangeNotifier {
  SharedPreferences prefs;

  initSharePreferecne() async {
    prefs = await SharedPreferences.getInstance();
  }

  List<DomainCategoryDetails> DomainCateList = [];
  List<TaskDetails> TaskList = [];
  List<DomainDetails> DomainList = [];
  List<SubDomainDetails> SubDomainList = [];

  int selectedDomainId;
  int selectedSubDomainId;

  setSelectedSubDomainId(int val) {
    selectedSubDomainId = val;
    notifyListeners();
  }

  setSelectedDomainId(int val) {
    selectedDomainId = val;
    notifyListeners();
  }

  bool subDomainApiCall = false;
  bool domainCateApiCall = false;
  bool taskApiCall = false;
  bool domainApiCall = false;

  updateSubDomainApiCall(bool val) {
    subDomainApiCall = val;
    notifyListeners();
  }

  updateDomainApiCall(bool val) {
    domainApiCall = val;
    notifyListeners();
  }

  updateTaskApiCall(bool val) {
    taskApiCall = val;
    notifyListeners();
  }

  updateDomainCateApiCall(bool val) {
    domainCateApiCall = val;
    notifyListeners();
  }

  Future<void> getSubDomainData(int id) async {
    updateSubDomainApiCall(true);
    SubDomainList = [];
    print("idMaster=========>>>>>>>>>>>>>>>$id");

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

    try {
      var response = await http.post(
        Uri.parse(GET_SUB_DOMAIN),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      print("response.statusCode===${response.body}");
      print("response.statusCode===${response.statusCode}");

      var resDDo = json.decode(response.body);
      var resStatus = (resDDo["status"]);

      if (response.statusCode == 400) {
        updateSubDomainApiCall(false);
        print("statussssssss");
        SubDomainList = [];

        notifyListeners();
        return;
      }
      if (response.statusCode == 200) {
        updateSubDomainApiCall(false);
        SubDomainList.clear();
        print("");
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        print("mapResponse====${mapResponse['status']}");
        if (mapResponse['status'] == 400) {
          SubDomainList = [];

          return;
        }

        if (mapResponse["status"] == 200) {
          List temp1 = mapResponse["data"];
          print("temp list===$temp1");
          SubDomainList = temp1.map((e) => SubDomainDetails.fromjson(e)).toList();
          print("DomainList=========$SubDomainList");
        }
      }
      print("respponse=== ${response.body}");
    } on Exception {
      updateSubDomainApiCall(false);
    }
    notifyListeners();
  }

  Future<void> getDomainData(int idMaster, int idCrs) async {
    updateDomainApiCall(true);
    DomainList = [];
    print("idMaster=========>>>>>>>>>>>>>>>$idMaster");
    print("idCrs=========>>>>>>>>>>>>>>>$idCrs");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"courseId": idCrs, "masterList": idMaster};

    try {
      var response = await http.post(
        Uri.parse(GET_DOMAIN),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      print("response.statusCode===${response.body}");
      print("response.statusCode===${response.statusCode}");

      var resDDo = json.decode(response.body);
      var resStatus = (resDDo["status"]);

      if (response.statusCode == 400) {
        updateDomainApiCall(false);
        print("statussssssss");
        DomainList = [];

        notifyListeners();
        return;
      }
      if (response.statusCode == 200) {
        updateDomainApiCall(false);
        DomainList.clear();
        print("");
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        print("mapResponse====${mapResponse['status']}");
        if (mapResponse['status'] == 400) {
          DomainList = [];

          return;
        }

        if (mapResponse["status"] == 200) {
          List temp1 = mapResponse["data"];
          print("temp list===$temp1");
          DomainList = temp1.map((e) => DomainDetails.fromjson(e)).toList();
          print("DomainList=========$DomainList");
        }
      }
      print("respponse=== ${response.body}");
    } on Exception {
      updateDomainApiCall(false);
    }
    notifyListeners();
  }

  int taskCount;
  Future<void> getTasksData(int id) async {
    updateTaskApiCall(true);
    TaskList = [];
    print("this apiii====");
    print("idddd=========>>>>>>>>>>>>>>>$id");
    print("idddd=========>>>>>>>>>>>>>>>$selectedDomainId");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"domainId": selectedDomainId, "subdomainId": id};

    try {
      var response = await http.post(
        Uri.parse(GET_TASKS),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      print("response.statusCode===${response.body}");
      print("response.statusCode===${response.statusCode}");

      var resDDo = json.decode(response.body);
      var resStatus = (resDDo["status"]);

      if (response.statusCode == 400) {
        updateTaskApiCall(false);
        print("statussssssss");
        TaskList = [];

        notifyListeners();
        return;
      }
      if (response.statusCode == 200) {
        updateTaskApiCall(false);
        TaskList.clear();
        print("");
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        print("mapResponse====${mapResponse['status']}");
        if (mapResponse['status'] == 400) {
          TaskList = [];
          return;
        }

        if (mapResponse["status"] == 200) {
          List temp1 = mapResponse["data"];
          print("temp list===$temp1");
          TaskList = temp1.map((e) => TaskDetails.fromjson(e)).toList();
          print("TaskList=========$TaskList");
          taskCount = TaskList.length;
          print("taskCount======$taskCount");
        }
      }
      print("respponse=== ${response.body}");
    } on Exception {
      updateTaskApiCall(false);
    }
    notifyListeners();
  }
}
