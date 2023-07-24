import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pgmp4u/Models/mockquestionanswermodel.dart';
import 'package:pgmp4u/Screens/PracticeTests/practice_test_response_model.dart';
import 'package:pgmp4u/Screens/Tests/local_handler/hive_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../../api/apis.dart';
import '../MockTest/model/pracTestModel.dart';
import '../MockTest/model/quesOfDayModel.dart';

class PracticeTextProvider extends ChangeNotifier {
  bool practiceApiLoader = false;
  PracitceTextResponseModelList pracitceTextResponseModel;
  List<PracitceTextResponseModel> questionsList = [];

  List<PracitceTextResponseModelList> pracQuesList = [];

  List<PracTestModel> pList = [];
  List<Optionss> quesDayOption = [];

  List<QuesDayModel> qdList = [];

  String quesDayQues;
  int quesDayId;

  int selectedAnswer;
  int realAnswer;

  int selectedPracTestId;

  setSelectedPracTestId(int val) {
    selectedPracTestId = val;
    notifyListeners();
  }

  PracListModel plm = new PracListModel();

  setSelectedAns(int val) {
    selectedAnswer = val;
    print("selected answer===$selectedAnswer");
    notifyListeners();
  }

  setRealAns(int val) {
    realAnswer = val;
    print("realAnswer answer===$realAnswer");
    notifyListeners();
  }

  updateLoader(bool val) {
    practiceApiLoader = val;
  }

  Future apiCall(int id, String type) async {
    print("iddd=======>>>>>>>>>>>$id");

    updateLoader(true);
    Map body = {"id": id, "type": type};

    print("body of pratice $id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print("stringValue  $stringValue");
    // http.Response response;
    // response = await http.post(Uri.parse(getSubCategoryDetails),
    try {
      var response = await http.get(
        Uri.parse(MOCK_TEST_QUES + "/$id"),

        headers: {'Content-Type': 'application/json', 'Authorization': stringValue},
        // body: convert.jsonEncode(body)
      );

      // print("calling this api========>>>./api/v2/MockTestQuestions/$id");
      // print("body=========>$body");

      if (response.statusCode == 200) {
        pList = [];
        print(convert.jsonDecode(response.body));
        //  HiveHandler.setstringdata(key: "PracTestModel", value: response.body);
        var _mapResponse = convert.jsonDecode(response.body);
        print("map respoanse========$_mapResponse");
        print("map resposne datat=====>>>${_mapResponse["data"]}");

        List temp = _mapResponse["data"];
        HiveHandler.setstringdata(key: id.toString(), value: _mapResponse['data']);

        var v1 = await HiveHandler.getstringdata(key: id.toString());
        print("v1===========================================${(v1.toString())}");

        // List<PracTestModel> p1List = v1.map((e) => PracTestModel.fromJson(e)).toList();

        pList = temp.map((e) => PracTestModel.fromJson(e)).toList();

        List<PracListModel> pltm = [];
        plm.myList = pList.toString();

        practiceApiLoader = false;
        print("pList=============$pList");

        if (pList.isNotEmpty) {
          // print("pList[0]============${pList[0].ques.options[1].questionOption}");
        }

        notifyListeners();
      }

      print('api res:  ${response.body}');
    } on Exception {
      // TODO
    }
  }

  Future<void> getQuesDay(int id) async {
    updateLoader(true);
    // id = 34;
    print("id =================*********************$id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');

    print("token valued===$stringValue");
    var request = {"id": id};

    var response = await http.post(
      Uri.parse(GET_QUES_OF_DAY),
      headers: {"Content-Type": "application/json", 'Authorization': stringValue},
      body: json.encode(request),
    );

    print("response.statusCode===${response.body}");

    print("response.statusCode===${response.statusCode}");

    var resDDo = json.decode(response.body);
    print("response.body.data===${resDDo['data']}");
    var resStatus = (resDDo["status"]);
    practiceApiLoader = true;

    if (resDDo['data'] == []) {
      qdList = [];
      updateLoader(false);
      return;
    }

    if (resStatus == 400) {
      // masterList = [];
      // videoPresent = 0;
      updateLoader(false);
      notifyListeners();
      return;
    }

    // print("val of vid present===$videoPresent");

    if (response.statusCode == 200) {
      qdList = [];
      // masterList.clear();
      Map<String, dynamic> mapResponse = convert.jsonDecode(response.body);
      List temp = mapResponse["data"];
      print("temp========$temp");
      qdList = temp.map((e) => QuesDayModel.fromJson(e)).toList();
      practiceApiLoader = false;
      if (qdList.isNotEmpty) {
        print("data.qdList=======${qdList.length}");
        print("qdList[0]============${qdList[0].question}");
      }
      updateLoader(false);
      notifyListeners();
    }
    print("respponse=== ${response.body}");
  }
}
