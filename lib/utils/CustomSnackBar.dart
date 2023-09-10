// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:lms_flutter_app/Config/app_config.dart';

class CustomSnackBar {
  SnackbarController snackBarSuccess(message) {
    return Get.snackbar(
      "${stctrl.lang["Success"]}",
      message.toString().capitalizeFirst.toString(),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: 5,
      duration: Duration(seconds: 3),
    );
  }

  SnackbarController snackBarSuccessBottom(message) {
    return Get.snackbar(
      "${stctrl.lang["Success"]}",
      message.toString().capitalizeFirst.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: 5,
      duration: Duration(seconds: 3),
    );
  }

  SnackbarController snackBarError(message) {
    return Get.snackbar(
      "${stctrl.lang["Error"]}",
      message.toString().capitalizeFirst.toString(),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      borderRadius: 5,
      duration: Duration(seconds: 3),
    );
  }

  SnackbarController snackBarWarning(message) {
    return Get.snackbar(
      "${stctrl.lang["Warning"]}",
      message.toString().capitalizeFirst.toString(),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Color(0xffF89406),
      colorText: Colors.white,
      borderRadius: 5,
      duration: Duration(seconds: 3),
    );
  }

  SnackbarController snackBarNotification(title, body) {
    return Get.snackbar(
      "${title.toString().capitalizeFirst}",
      "${body.toString().capitalizeFirst}",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: 5,
      duration: Duration(seconds: 10),
    );
  }
}
