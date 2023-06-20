import 'dart:convert';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Screens/MockTest/model/courseModel.dart';
import '../Screens/MockTest/model/flashCardModel.dart';
import '../Screens/MockTest/model/flashCateModel.dart';
import '../Screens/MockTest/model/masterdataModel.dart';
import '../Screens/MockTest/model/testDetails.dart';
import '../Screens/MockTest/model/videoCateModel.dart';
import '../Screens/MockTest/model/videoModel.dart';

class CourseProvider extends ChangeNotifier {


   List<MasterDetails>masterList=[];
   List<CourseDetails>course=[];
   List<VideoCateDetails>videoCate=[];
   List<VideoDetails>Videos=[];
   List<FlashCateDetails>flashCate=[];
   List<FlashCardDetails>FlashCards=[];
   List<TestDetails>testDetails=[];

   int videoPresent=1;
  
 Future<void> getMasterData(int id) async {

 SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');


    print("token valued===${stringValue}");
    var request = {
      "id":id
    };

  var response = await http.post(
      Uri.parse("http://3.227.35.115:1011/api/getMasterData"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': stringValue
      },

      body: json.encode(request),
   
    );

print("response.statusCode===${response.body}");
print("response.statusCode===${response.statusCode}");

  

var resDDo=json.decode(response.body);
var resStatus=(resDDo["status"]);
videoPresent=1;
if(resStatus==400){

  masterList=[];
videoPresent=0;

notifyListeners();
return;
}

print("val of vid present===${videoPresent}");


    if(response.statusCode==200){
      masterList.clear();
      Map<String, dynamic> mapResponse=convert.jsonDecode(response.body);
       
    List temp1=mapResponse["data"];  
      print("temp list===${temp1}");
      masterList=temp1.map((e)=>MasterDetails.fromjson(e)).toList();

        notifyListeners();

if(masterList.isNotEmpty){
  print("masterList 0=== ${masterList[0].name}");
}

    }
    print("respponse=== ${response.body}");

  }



 Future<void> getFlashCate(int id) async {

 SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');


    print("token valued===${stringValue}");
    var request = {
      "id":id
    };

  var response = await http.post(
      Uri.parse("http://3.227.35.115:1011/api/getFlashCategories"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': stringValue
      },

      body: json.encode(request),
   
    );

print("response.statusCode===${response.statusCode}");
    if(response.statusCode==200){
      flashCate.clear();
      Map<String, dynamic> mapResponse=convert.jsonDecode(response.body);
       
    List temp1=mapResponse["data"];  
      print("temp list===${temp1}");
      flashCate=temp1.map((e)=>FlashCateDetails.fromjson(e)).toList();

        notifyListeners();

if(flashCate.isNotEmpty){
  print("flashCate name 0=== ${flashCate[0].name}");
}

    }
    print("respponse=== ${response.body}");



  }





  
 Future<void> getVideoCate(int id) async {

 SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');


    print("token valued===${stringValue}");
    var request = {
      "id":id
    };

  var response = await http.post(
      Uri.parse("http://3.227.35.115:1011/api/getVideoCategories"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': stringValue
      },

      body: json.encode(request),
   
    );

 print("http://3.227.35.115:1011/api/getVideoCategories");
    print("response====${response.body}");
    var resp=response.body;

var resDDo=json.decode(response.body);
var resStatus=(resDDo["status"]);
videoPresent=1;
if(resStatus==400){
videoPresent=0;

notifyListeners();
}
print("videoPresent=======${videoPresent}");

print("response.statusCode===${response.statusCode}");
    if(response.statusCode==200){
      videoCate.clear();
      Map<String, dynamic> mapResponse=convert.jsonDecode(response.body);
       
    List temp1=mapResponse["data"];  
      print("temp list===${temp1}");
      videoCate=temp1.map((e)=>VideoCateDetails.fromjson(e)).toList();

        notifyListeners();

if(videoCate.isNotEmpty){
  print("videoCate 0=== ${videoCate[0].name}");
}

    }
    print("respponse=== ${response.body}");



  }

Future<void> getCourse() async {

 SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');


    print("token valued===${stringValue}");

  var response = await http.get(
      Uri.parse("http://3.227.35.115:1011/api/getCourse"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': stringValue
      },
   
    );

print("response.statusCode===${response.statusCode}");
    if(response.statusCode==200){
      course.clear();
      Map<String, dynamic> mapResponse=convert.jsonDecode(response.body);
    List temp1=mapResponse["data"];
      print("temp list===${temp1}");
      course=temp1.map((e)=>CourseDetails.fromjson(e)).toList();
       notifyListeners();
if(course.isNotEmpty){
  print("course 0=== ${course[0].description}");
}
    }
    print("respponse=== ${response.body}");

  }


  
 Future<void> getVideos(int id) async {

 SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');


    print("token valued===${stringValue}");
    var request = {
      "id":id
    };

  var response = await http.post(
      Uri.parse("http://3.227.35.115:1011/api/getVideos"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': stringValue
      },

      body: json.encode(request),
   
    );
    print("http://3.227.35.115:1011/api/getVideos");

print("response.statusCode===${response.statusCode}");
print("response.body===${response.body}");

var resDDo=json.decode(response.body);
var resStatus=(resDDo["status"]);
videoPresent=1;
if(resStatus==400){

  Videos=[];
videoPresent=0;

notifyListeners();
return;
}


    if(response.statusCode==200){
      Videos.clear();
      Map<String, dynamic> mapResponse=convert.jsonDecode(response.body);
       
    List temp1=mapResponse["data"];  
      print("temp list===${temp1}");
      Videos=temp1.map((e)=>VideoDetails.fromjson(e)).toList();

        notifyListeners();

if(Videos.isNotEmpty){
  print("videoCate 0=== ${Videos[0].title}");
}

    }
    print("respponse=== ${response.body}");

  }


 Future<void> getFlashCards(int id) async {

 SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');


    print("token valued===${stringValue}");
    var request = {
      "id":id
    };

  var response = await http.post(
      Uri.parse("http://3.227.35.115:1011/api/getFlashCards"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': stringValue
      },

      body: json.encode(request),
   
    );

print("response.statusCode===${response.statusCode}");
    if(response.statusCode==200){
      FlashCards.clear();
      Map<String, dynamic> mapResponse=convert.jsonDecode(response.body);
       
    List temp1=mapResponse["data"];  
      print("temp list===${temp1}");
      FlashCards=temp1.map((e)=>FlashCardDetails.fromjson(e)).toList();

        notifyListeners();

if(FlashCards.isNotEmpty){
  print("FlashCards 0=== ${FlashCards[0].title}");
}

    }
    print("respponse=== ${response.body}");

  }





 Future<void> getTestDetails(int id) async {

 SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');


    print("token valued===${stringValue}");
    var request = {
      "id":id
    };

  var response = await http.post(
      Uri.parse("http://3.227.35.115:1011/api/getFlashCards"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': stringValue
      },

      body: json.encode(request),
   
    );

print("response.statusCode===${response.statusCode}");
    if(response.statusCode==200){
      FlashCards.clear();
      Map<String, dynamic> mapResponse=convert.jsonDecode(response.body);
       
    List temp1=mapResponse["data"];  
      print("temp list===${temp1}");
      FlashCards=temp1.map((e)=>FlashCardDetails.fromjson(e)).toList();

        notifyListeners();

if(FlashCards.isNotEmpty){
  print("FlashCards 0=== ${FlashCards[0].title}");
}

    }
    print("respponse=== ${response.body}");

  }
 







}