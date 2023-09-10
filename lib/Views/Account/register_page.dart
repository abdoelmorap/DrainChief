// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:

import 'package:get/get.dart';
import 'package:lms_flutter_app/Config/app_config.dart';

// Project imports:
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';

class RegisterPage extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CupertinoActivityIndicator());
        } else {
          return ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Container(
                height: 70,
                width: 70,
                child: Image.asset('images/signin_img.png'),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "${stctrl.lang["Register"]}",
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: TextField(
                  controller: controller.registerName,
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
                    hintText: "${stctrl.lang["Name"]}",
                    hintStyle: Get.textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                    ),
                    suffixIcon: Icon(
                      Icons.person,
                      size: 24,
                      color: Color.fromRGBO(142, 153, 183, 0.5),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: TextField(
                  controller: controller.registerEmail,
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
                    hintText: "${stctrl.lang["Email"]}",
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
              // SizedBox(
              //   height: 15,
              // ),
              // Container(
              //   padding: EdgeInsets.only(left: 30, right: 30),
              //   child: TextField(
              //     controller: controller.registerPhone,
              //     decoration: InputDecoration(
              //       contentPadding: EdgeInsets.only(
              //           left: 15, top: 13, bottom: 0, right: 15),
              //       filled: true,
              //       fillColor: Get.theme.canvasColor,
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(5),
              //         borderSide: BorderSide(
              //             color: Color.fromRGBO(142, 153, 183, 0.4),
              //             width: 1.0),
              //       ),
              //       hintText: "${stctrl.lang["Phone"]}",
              //       hintStyle: Get.textTheme.titleMedium.copyWith(
              //         fontSize: 14,
              //       ),
              //       suffixIcon: Icon(
              //         Icons.phone,
              //         size: 24,
              //         color: Color.fromRGBO(142, 153, 183, 0.5),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: TextField(
                  controller: controller.registerPassword,
                  obscureText: controller.obscureNewPass.value,
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
                        controller.obscureNewPass.value =
                            !controller.obscureNewPass.value;
                      },
                      child: Icon(
                        controller.obscureNewPass.value
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
              Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                child: TextField(
                  controller: controller.registerConfirmPassword,
                  obscureText: controller.obscureConfirmPass.value,
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
                    hintText: "${stctrl.lang["Confirm Password"]}",
                    hintStyle: Get.textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                    ),
                    suffixIcon: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        controller.obscureConfirmPass.value =
                            !controller.obscureConfirmPass.value;
                      },
                      child: Icon(
                        controller.obscureConfirmPass.value
                            ? Icons.lock_rounded
                            : Icons.lock_open,
                        size: 24,
                        color: Color.fromRGBO(142, 153, 183, 0.5),
                      ),
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
                      "${stctrl.lang["Register"]}",
                    ),
                  ),
                  onTap: () async {
                    await controller.fetchUserRegister();
                  },
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
                      "${stctrl.lang["Already have an account? Login now"]}",
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          );
        }
      }),
    );
  }
}
