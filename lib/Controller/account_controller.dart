// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:lms_flutter_app/Service/RemoteService.dart';

class AccountController extends GetxController{

  var isLoading = false.obs;

  var loginMsg = "".obs;

  String tokenKey = "token";

  var loadToken = '';

  var token = "";

  GetStorage userToken = GetStorage();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();


  // call login api
  Future fetchUserLogin() async {
    try {
      isLoading(true);
      var login = await RemoteServices.login(email.text, password.text);
      token = login['data']['access_token'];
      // print("data of login :${login['data']}");
      saveToken(token);
      loginMsg.value = login['message'];
      // loadUserToken();

      return login;
    } finally {
      isLoading(false);
    }
  }

  Future<void> saveToken(String msg) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (msg.length > 5) {
      await preferences.setString(tokenKey, msg);
      await userToken.write(tokenKey, msg);
    } else {

    }
  }

}
