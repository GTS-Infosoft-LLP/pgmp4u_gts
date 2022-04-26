import 'package:flutter/material.dart';
import 'package:pgmp4u/Models/category.dart';
import 'package:http/http.dart' as http;
import 'package:pgmp4u/api/apis.dart';
import 'package:pgmp4u/utils/user_object.dart';

class ResponseProvider extends ChangeNotifier {
  CategoryList categoryList;
  final user = UserObject().getUser;

  Future getcategoryList() async {
    var categoruUrl = Uri.parse(GetCategoryListUrl);
    var response =
        await http.get(categoruUrl, headers: {"Authorization": user.token});
    print(" response of category APi $response");

    notifyListeners();
  }
}
