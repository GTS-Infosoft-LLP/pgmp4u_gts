import 'dart:convert';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/Domain/screens/Models/domainCategoryModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/apis.dart';
import 'Models/taskModel.dart';
class DomainProvider extends ChangeNotifier {
  SharedPreferences prefs;

List<DomainCategoryDetails>DomainCateList=[];
List<TaskDetails> TaskList=[];



bool domainCateApiCall=false;
bool taskApiCall=false;

  updateTaskApiCall(bool val) {
    taskApiCall = val;
    notifyListeners();
  }


  updateDomainCateApiCall(bool val) {
    domainCateApiCall = val;
    notifyListeners();
  }




Future<void> getDomainCateData(int id) async {
    updateDomainCateApiCall(true);
    DomainCateList = [];
    print("idddd=========>>>>>>>>>>>>>>>$id");

    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

    try {
      var response = await http.post(
        Uri.parse(GET_DOMAIN_CATEGORIES),
        headers: {"Content-Type": "application/json", 'Authorization': stringValue},
        body: json.encode(request),
      );

      print("response.statusCode===${response.body}");
      print("response.statusCode===${response.statusCode}");

      var resDDo = json.decode(response.body);
      var resStatus = (resDDo["status"]);

      if (response.statusCode == 400) {
        updateDomainCateApiCall(false);
        print("statussssssss");
        DomainCateList = [];
     
        notifyListeners();
        return;
      }
      if (response.statusCode == 200) {
        updateDomainCateApiCall(false);
        DomainCateList.clear();
        print("");
        Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
        print("mapResponse====${mapResponse['status']}");
        if (mapResponse['status'] == 400) {
          DomainCateList = [];
       
          return;
        }

        if (mapResponse["status"] == 200) {
          List temp1 = mapResponse["data"];
          print("temp list===$temp1");
          DomainCateList = temp1.map((e) => DomainCategoryDetails.fromjson(e)).toList();
          print("DomainCateList=========$DomainCateList");

        
        }
      }
      print("respponse=== ${response.body}");
    } on Exception {
      updateDomainCateApiCall(false);
    }
    notifyListeners();
  }



Future<void> getDomainTasksData(int id) async {
    updateTaskApiCall(true);
    TaskList = [];
    print("idddd=========>>>>>>>>>>>>>>>$id");

    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

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
        }
      }
      print("respponse=== ${response.body}");
    } on Exception {
      updateTaskApiCall(false);
    }
    notifyListeners();
  }







}