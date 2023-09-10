// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Views/Home/Course/all_course_view.dart';
import 'package:lms_flutter_app/utils/CustomSnackBar.dart';
import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  double iconSize = 16.0;

  double hintFontSize = 14.0;

  final _formKey = GlobalKey<FormState>();

  final DashboardController controller = Get.put(DashboardController());

  bool inResponse = false;
  bool obscureMainPass = true;
  bool obscureNewPass = true;
  bool obscureConfirmPass = true;

  Future update(token) async {
    try {
      setState(() {
        inResponse = true;
      });
      var postUri = Uri.parse(baseUrl + '/change-password');
      var request = new http.MultipartRequest("POST", postUri);
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      request.headers['$authHeader'] = '$isBearer' + '$token';
      request.headers['ApiKey'] = '$apiKey';

      request.fields['old_password'] = controller.oldPassword.text;
      request.fields['new_password'] = controller.newPassword.text;
      request.fields['confirm_password'] = controller.confirmPassword.text;

      request
          .send()
          .then((result) async {
            http.Response.fromStream(result).then((response) {
              // print(response.statusCode);
              var jsonString = jsonDecode(response.body);
              // print(jsonString['message']);
              if (jsonString['success'] == false) {
                CustomSnackBar().snackBarError(jsonString['message']);
                setState(() {
                  inResponse = false;
                });
              } else {
                CustomSnackBar().snackBarSuccess(jsonString['message']);
                controller.removeToken('token');
                Navigator.pop(context);
                controller.oldPassword.clear();
                controller.newPassword.clear();
                controller.confirmPassword.clear();
              }
              return response.body;
            });
          })
          .catchError((err) {
        print('error : ' + err.toString());
      } )
          .whenComplete(() {
            setState(() {
              inResponse = false;
            });
          });
      setState(() {});
    } catch (e) {
      setState(() {
        inResponse = false;
      });
    }
  }

  static GetStorage userToken = GetStorage();
  String tokenKey = "token";

  @override
  void initState() {
    super.initState();
    // profileData.getProfileData(userToken.read(tokenKey));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(
          showSearch: false,
          goToSearch: false,
          showFilterBtn: false,
          showBack: false,
        ),
        body: SingleChildScrollView(child: Obx(() {
          if (controller.isLoading.value) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          child: InkWell(
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 50,
                          ),
                        ),
                        Text(
                          "${stctrl.lang['Change Password']}",
                          style: Get.textTheme.titleMedium,
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          child: InkWell(
                            child: Icon(
                              Icons.search,
                              size: 20,
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              // controller.changeTabIndex(0);
                              controller.persistentTabController.jumpToTab(0);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AllCourseView()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                    child: TextFormField(
                      controller: controller.oldPassword,
                      obscureText: obscureMainPass,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 15, top: 3, bottom: 3, right: 15),
                        filled: true,
                        fillColor: Get.theme.canvasColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(142, 153, 183, 0.4),
                              width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(142, 153, 183, 0.4),
                              width: 1.0),
                        ),
                        hintText: "${stctrl.lang['Old Password']}",
                        hintStyle: TextStyle(
                            color: Color(0xff8E99B7), fontSize: hintFontSize),
                        suffixIcon: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            setState(() {
                              obscureMainPass = !obscureMainPass;
                            });
                          },
                          child: Icon(
                            obscureMainPass
                                ? Icons.lock_rounded
                                : Icons.lock_open,
                            size: iconSize,
                            color: Color.fromRGBO(142, 153, 183, 0.5),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "${stctrl.lang['Please type your password']}";
                        }
                        if (value.length < 8) {
                          return "${stctrl.lang['Password must be at-least 8 characters']}";
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                    child: TextFormField(
                      controller: controller.newPassword,
                      obscureText: obscureNewPass,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 15, top: 3, bottom: 3, right: 15),
                        filled: true,
                        fillColor: Get.theme.canvasColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(142, 153, 183, 0.4),
                              width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(142, 153, 183, 0.4),
                              width: 1.0),
                        ),
                        hintText: "${stctrl.lang['New Password']}",
                        hintStyle: TextStyle(
                            color: Color(0xff8E99B7), fontSize: hintFontSize),
                        suffixIcon: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            setState(() {
                              obscureNewPass = !obscureNewPass;
                            });
                          },
                          child: Icon(
                            obscureNewPass
                                ? Icons.lock_rounded
                                : Icons.lock_open,
                            size: iconSize,
                            color: Color.fromRGBO(142, 153, 183, 0.5),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "${stctrl.lang['Please type your password']}";
                        }
                        if (value.length < 8) {
                          return "${stctrl.lang['Password must be at-least 8 characters']}";
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                    child: TextFormField(
                      controller: controller.confirmPassword,
                      obscureText: obscureConfirmPass,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 15, top: 3, bottom: 3, right: 15),
                        filled: true,
                        fillColor: Get.theme.canvasColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(142, 153, 183, 0.4),
                              width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(142, 153, 183, 0.4),
                              width: 1.0),
                        ),
                        hintText: "${stctrl.lang['Confirm Password']}",
                        hintStyle: TextStyle(
                            color: Color(0xff8E99B7), fontSize: hintFontSize),
                        suffixIcon: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            setState(() {
                              obscureConfirmPass = !obscureConfirmPass;
                            });
                          },
                          child: Icon(
                            obscureConfirmPass
                                ? Icons.lock_rounded
                                : Icons.lock_open,
                            size: iconSize,
                            color: Color.fromRGBO(142, 153, 183, 0.5),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "${stctrl.lang['Please type your password']}";
                        }
                        if (value.length < 8) {
                          return "${stctrl.lang['Password must be at-least 8 characters']}";
                        }
                        if (value != controller.newPassword.text) {
                          return "${stctrl.lang['New Password and Confirm Password is not same']}";
                        }
                        return null;
                      },
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 30, bottom: 20),
                      height: 46,
                      width: 185,
                      decoration: BoxDecoration(
                        color: Get.theme.primaryColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: inResponse == true
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                             "${stctrl.lang['Update Password']}",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                    ),
                    onTap: () {
                      if (isDemo) {
                        CustomSnackBar().snackBarWarning("Disabled for demo");
                      } else {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            inResponse = true;
                          });
                          update(userToken.read(tokenKey));
                        }
                      }
                    },
                  ),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 40),
                      child: Text(
                         "${stctrl.lang['Cancel']}",
                        style: TextStyle(color: Color(0xff8E99B7)),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          }
        })),
      ),
    );
  }
}
