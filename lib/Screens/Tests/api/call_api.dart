import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pgmp4u/Models/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/apis.dart';

class ApiController {
  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    return stringValue;
  }

  Future<Resources> callGetCategoryApi() async {
    print("user token is ${await getToken()}");
    Resources categoryResponse;
    await http.get(Uri.parse(getCourseCategory), headers: {
      "Authorization": await getToken(),
      'Content-Type': 'application/json',
    }).then((value) {
      if (value.statusCode == 200) {
        print("body is ${value.body}");
        categoryResponse = Resources.fromJson(jsonDecode(value.body));
        return categoryResponse;
      } else {
        // return CategoryApiModel.fromJson({});
      }
    }).onError((error, stackTrace) {
      print("error is $error");
      return Resources.fromJson({});
    });
    return categoryResponse;
  }

  Future<Resources> getSubCategory({int id, String type}) async {
    Map<String, dynamic> body = {"id": id, "type": type};
    Resources categoryResponse;
    print("body $body");

    var response = await http
        .post(Uri.parse(getCourseSubCategory),
            headers: {
              "Authorization": await getToken(),
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body))
        .then((value) {
      print("value body ${value.body}");
      if (value.statusCode == 200) {
        print("body is ${value.body}");
        categoryResponse = Resources.fromJson(jsonDecode(value.body));
        return categoryResponse;
      }
    });

    // .onError((error, stackTrace) {
    //     print("error is $error");
    //       return Resources.fromJson({});
    //   });
    return categoryResponse;
  }

  Future<Resources> getSubCategoryDetail({int id, String type}) async {
    Resources categoryResponse;
    Map<String, dynamic> body = {"id": id, "type": type};

    print("body value $body");

    var response = await http
        .post(Uri.parse(getSubCategoryDetails),
            headers: {
              "Authorization": await getToken(),
              'Content-Type': 'application/json',
            },
            body: jsonEncode(body))
        .then((value) {
      print("value body ${value.body}");
      if (value.statusCode == 200) {
        print("body is ${value.body}");
        categoryResponse = Resources.fromJson(jsonDecode(value.body));
        return categoryResponse;
      }
    });

    return categoryResponse;
  }
}
