import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pgmp4u/Models/card_category_response.dart';
import 'package:pgmp4u/Models/category.dart';
import 'package:http/http.dart' as http;
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/utils/user_object.dart';

import '../Models/get_video_by_type_response.dart';
import '../Models/hideshowmodal.dart';

class ResponseProvider extends ChangeNotifier {
  CategoryList categoryList;
  CardDetails cardDetails;
  // GetVideoByType getvideo;
//  HideShowResponse hideShowRes;
//  setHideShowData(HideShowResponse data){
//   hideShowRes=data;
//   print("idddddd${hideShowRes.id}   statusssessssssssssss${hideShowRes.is_applicationsupport}${hideShowRes.is_flashcard} " );
//   notifyListeners();
//  }
 
  final user = UserObject().getUser;
  bool apiStatus = false;
  int categoryId;

  Future<GetVideoByType> getCardVideoTypeApi(int videoTypeId) async {
    // print(" call Get Video Type APi");
    // updatestatusLoader(true);
    Map body = {"videoType": videoTypeId.toString()};
    var getVideoByTypeUrl = Uri.parse(videoListByTypeUrl);
    print("URL OF GET VIDEO ${videoListByTypeUrl}");
    print("video get body ${body}");
    //print(" api url $getVideoByTypeUrl");

    print("user.token ${user.token}");
    var response = await http.post(Uri.parse("http://3.227.35.115:1011/api/videoListByViType"),
        headers: {"Authorization": user.token}, body: body);
    print("response is >> ${response.body}");
    //print("video body $body");
    // print(" response of video api ${response.body}");
    if (response.statusCode == 200) {
      
      Resources getVideoResponse =
          Resources.fromJson(jsonDecode(response.body));
      if (getVideoResponse.status == 200) {
        // updatestatusLoader(false);
       var getvideo = GetVideoByType.fromJson(getVideoResponse.data);
        return getvideo;
      }
    }else {
      return null;
    }
    // notifyListeners();
    // return getvideo;
  }

  Future getcategoryList() async {
    updatestatusLoader(true);
    var categoruUrl = Uri.parse(GetCategoryListUrl);
    var response = await http
        .get(categoruUrl, headers: {"Authorization": user.token})
        .timeout(Duration(seconds: 20))
        .onError((error, stackTrace) {
          updatestatusLoader(false);
          notifyListeners();
          return;
        });

    if (response.statusCode == 200) {
       updatestatusLoader(false);
      Resources categoryApiResponse =
          Resources.fromJson(jsonDecode(response.body));
      if (categoryApiResponse.status == 200) {
        print("CategoryList>>>>>> ${categoryApiResponse.data}");
        updatestatusLoader(false);
        categoryList = CategoryList.fromJson(categoryApiResponse.data);
      }
    }
    notifyListeners();
  }

  Future getCardDetails() async {
    cardDetails=null;
    updatestatusLoader(true);
    var cardApiUrl = Uri.parse(GetCardUrl);
    Map body;
    body = {"categoryId": "$categoryId"};
     print("body of card api ${body}");
    var response = await http
        .post(cardApiUrl, headers: {"Authorization": user.token}, body: body)
        .timeout(Duration(seconds: 20))
        .onError((error, stackTrace) {
      notifyListeners();
      updatestatusLoader(false);
      return;
    });

    if (response.statusCode == 200) {
      updatestatusLoader(false);
      Resources resources = Resources.fromJson(jsonDecode(response.body));
      if (resources.status == 200) {
        updatestatusLoader(false);
        cardDetails = CardDetails.fromJson(resources.data);
        // print(
        //     " card details item ${cardDetails.cardDetailsList[0].description}");
      }
    }
    else
    { 
      updatestatusLoader(false);
      }
    notifyListeners();
  }

  updatestatusLoader(bool value) {
    apiStatus = value;
  }
  bool newLoader=false;
updateLoad(bool newload){
newLoader=newload;
notifyListeners();
}
  setCategoryid(int id) {
    categoryId = id;
    notifyListeners();
  }
}
