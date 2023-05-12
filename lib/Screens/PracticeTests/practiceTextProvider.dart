import 'package:flutter/material.dart';
import 'package:pgmp4u/Screens/PracticeTests/practice_test_response_model.dart';
import 'package:pgmp4u/api/apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PracticeTextProvider extends ChangeNotifier {
  bool practiceApiLoader = false;
  PracitceTextResponseModelList pracitceTextResponseModel;
  List<PracitceTextResponseModel> questionsList = [];
  
  updateLoader(bool val) {
    practiceApiLoader = val;
  }

  Future apiCall() async {
    updateLoader(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print("stringValue  $stringValue");
    http.Response response;
    response = await http.get(Uri.parse(PRACTICE_TEST_QUESTIONS), headers: {
      'Content-Type': 'application/json',
      'Authorization': stringValue
    });
    if (response.statusCode == 200) {
      print(convert.jsonDecode(response.body));
      var _mapResponse = convert.jsonDecode(response.body);
      pracitceTextResponseModel =
          PracitceTextResponseModelList.fromJson(_mapResponse);

      updateLoader(false);
      questionsList = pracitceTextResponseModel.list;
      notifyListeners();
      // print(convert.jsonDecode(response.body));
    }
  }
}
