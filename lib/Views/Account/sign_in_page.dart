// Flutter imports:
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io' show Platform;

// Package imports:

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lms_flutter_app/Config/app_config.dart';

// Project imports:
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Views/Account/register_page.dart';

import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// ignore: must_be_immutable
class SignInPage extends GetView<DashboardController> {
  final _googleSignIn = GoogleSignIn();

  Map<String, dynamic>? userData;
  AccessToken? _accessToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        showSearch: false,
        goToSearch: false,
        showFilterBtn: false,
        showBack: false,
      ),
      body: Obx(() {
        if (controller.isRegisterScreen.value) {
          return RegisterPage();
        } else {
          return Container(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CupertinoActivityIndicator());
              } else {
                return ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 25,
                      ),
                      height: 70,
                      width: 70,
                      child: Image.asset('images/signin_img.png'),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 30, bottom: 30),
                        child: Text(
                          "${stctrl.lang['Sign In']}",
                          style: Get.textTheme.titleMedium?.copyWith(
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: TextField(
                        controller: controller.email,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15, top: 13, bottom: 0, right: 15),
                          filled: true,
                          fillColor: Get.theme.canvasColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(142, 153, 183, 0.4),
                                width: 1.0),
                          ),
                          hintText: '${stctrl.lang['Enter Your Email']}',
                          hintStyle: Get.textTheme.titleMedium?.copyWith(
                            fontSize: 14,
                          ),
                          suffixIcon: Icon(
                            Icons.email,
                            size: 24,
                            color: Color.fromRGBO(142, 153, 183, 0.5),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: TextField(
                        controller: controller.password,
                        obscureText: controller.obscurePass.value,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15, top: 13, bottom: 0, right: 15),
                          filled: true,
                          fillColor: Get.theme.canvasColor,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(142, 153, 183, 0.4),
                                width: 1.0),
                          ),
                          hintText: "${stctrl.lang["Password"]}",
                          hintStyle: Get.textTheme.titleMedium?.copyWith(
                            fontSize: 14,
                          ),
                          suffixIcon: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              controller.obscurePass.value =
                                  !controller.obscurePass.value;
                            },
                            child: Icon(
                              controller.obscurePass.value
                                  ? Icons.lock_rounded
                                  : Icons.lock_open,
                              size: 24,
                              color: Color.fromRGBO(142, 153, 183, 0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Container(
                        child: Text(
                          controller.loginMsg.value,
                          style: TextStyle(
                            color: Color(0xff8E99B7),
                            fontSize: 14,
                            fontFamily: 'AvenirNext',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 70,
                      margin: EdgeInsets.symmetric(horizontal: 100),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "${stctrl.lang["Sign In"]}",
                          ),
                        ),
                        onTap: () async {
                          controller.obscurePass.value = true;
                          await controller.fetchUserLogin();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    (facebookLogin || googleLogin || (appleLogin && Platform.isIOS))
                        ? Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 5),
                            child: Text(
                              "${stctrl.lang["Or continue with"]}",
                              style: Get.textTheme.titleMedium?.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (appleLogin && Platform.isIOS)
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    AuthorizationCredentialAppleID? appCred =
                                        await controller.appleLogin();

                                    if (appCred != null) {
                                      print(appCred.email ??
                                          '${appCred.userIdentifier?.split('.')[0]}@apple.com');
                                      print(appCred.familyName ?? 'tour_user');
                                      print(appCred.userIdentifier ?? '');

                                      Map data = {
                                        "provider_id": '_getUser.id',
                                        "provider_name": 'apple',
                                        "name": appCred.familyName ??
                                            'infix_lms_user',
                                        "email": appCred.email ??
                                            '${appCred.userIdentifier?.split('.')[0]}@apple.com',
                                        "token": appCred.authorizationCode,
                                      };

                                      await controller
                                          .socialLogin(data)
                                          .then((value) async {
                                        if (value == true) {
                                          controller.isLoading(false);
                                        } else {
                                          // await FacebookAuth.instance.logOut();
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xff969599),
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: SvgPicture.asset('images/apple.svg'),
                                  ),
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                          if (facebookLogin)
                            InkWell(
                              onTap: () async {
                                final LoginResult result = await FacebookAuth
                                    .instance
                                    .login(); // by default we request the email and the public profile
                                if (result.status == LoginStatus.success) {
                                  _accessToken = result.accessToken;
                                  _printCredentials();

                                  final fbData =
                                      await FacebookAuth.instance.getUserData();
                                  userData = fbData;

                                  final _getToken = FacebookResponse.fromJson(
                                      _accessToken?.toJson() ?? Map());

                                  final _getUser =
                                      FacebookUser.fromJson(userData ?? Map());

                                  Map data = {
                                    "provider_id": _getUser.id,
                                    "provider_name": "facebook",
                                    "name": _getUser.name,
                                    "email": _getUser.email,
                                    "token": _getToken.token.toString(),
                                  };

                                  await controller
                                      .socialLogin(data)
                                      .then((value) async {
                                    if (value == true) {
                                      controller.isLoading(false);
                                    } else {
                                      await FacebookAuth.instance.logOut();
                                    }
                                  });
                                } else {
                                  controller.loginMsg.value =
                                      result.message.toString();
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xff969599),
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: SvgPicture.asset('images/facebook.svg'),
                              ),
                            ),
                          SizedBox(width: 20),
                          if (googleLogin)
                            InkWell(
                              onTap: () async {
                                try {
                                  GoogleSignInAccount? googleSignInAccount =
                                      await _googleSignIn.signIn();
                                  print(
                                      '----> ${googleSignInAccount?.displayName}');
                                  print('----> ${googleSignInAccount?.email}');
                                  print(
                                      '----> ${googleSignInAccount?.photoUrl}');

                                  await googleSignInAccount?.authentication
                                      .then((value) async {
                                    Map data = {
                                      "provider_id": googleSignInAccount.id,
                                      "provider_name": "google",
                                      "name": googleSignInAccount.displayName,
                                      "email": googleSignInAccount.email,
                                      "token": value.idToken.toString(),
                                    };

                                    await controller
                                        .socialLogin(data)
                                        .then((value) {
                                      if (value == true) {
                                        controller.isLoading(false);
                                      } else {
                                        _googleSignIn.signOut();
                                      }
                                    });
                                  });
                                } catch (e) {
                                  controller.loginMsg.value =
                                      "${stctrl.lang["Login Cancelled"]}";
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xff969599),
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: SvgPicture.asset('images/google.svg'),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          controller.showRegisterScreen();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Text(
                            "${stctrl.lang["Don\'t have an Account? Register now"]}",
                            style: Get.textTheme.titleMedium?.copyWith(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: kBottomNavigationBarHeight,
                    ),
                  ],
                );
              }
            }),
          );
        }
      }),
    );
  }

  void _printCredentials() {
    print(
      prettyPrint(_accessToken?.toJson() ?? Map()),
    );
  }
}

String prettyPrint(Map json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}

FacebookResponse facebookResponseFromJson(String str) =>
    FacebookResponse.fromJson(json.decode(str));

String facebookResponseToJson(FacebookResponse data) =>
    json.encode(data.toJson());

class FacebookResponse {
  FacebookResponse({
    this.userId,
    this.token,
  });

  String? userId;
  String? token;

  factory FacebookResponse.fromJson(Map<String, dynamic> json) =>
      FacebookResponse(
        userId: json["userId"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "token": token,
      };
}

FacebookUser facebookUserFromJson(String str) =>
    FacebookUser.fromJson(json.decode(str));

String facebookUserToJson(FacebookUser data) => json.encode(data.toJson());

class FacebookUser {
  FacebookUser({
    this.email,
    this.id,
    this.name,
  });

  String? email;
  String? id;
  String? name;

  factory FacebookUser.fromJson(Map<String, dynamic> json) => FacebookUser(
        email: json["email"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "id": id,
        "name": name,
      };
}
