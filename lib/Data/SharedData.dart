import 'dart:convert';

import 'package:flutterapp/Model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals.dart' as globals;

class SharedData {
  SharedPreferences sharedPreferences;

  saveUser(var jsonResponse) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String stringuser = jsonEncode(jsonResponse);
    sharedPreferences.setString('user', stringuser);
  }

  saveToken(String token) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("token", token);
  }

  Future<String> loadToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("token");
  }

  // ignore: missing_return
  Future<bool> loadGlobals() async {
    sharedPreferences = await SharedPreferences.getInstance();

    Map userMap = jsonDecode(sharedPreferences.getString('user'));
    User user = User.fromJson(userMap['user']);
    globals.user = user;

    String token = sharedPreferences.getString("token");
    globals.myheaders = {
      'content-type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    globals.token = token;
    if (sharedPreferences.getBool("descsort") != null &&
        sharedPreferences.getString("appliedsort") != null) {
      globals.descsort = sharedPreferences.getBool("descsort");
      globals.appliedsort = sharedPreferences.getString("appliedsort");
    }
  }
}
