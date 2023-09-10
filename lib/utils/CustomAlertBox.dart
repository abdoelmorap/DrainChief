// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:lms_flutter_app/Controller/cart_controller.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';

// import 'package:get_storage/get_storage.dart';


showCustomAlertDialog(title1, boday1,buttonName) {

  // GetStorage userToken = GetStorage();
  // String tokenKey = "token";
  final CartController cartView = Get.put(CartController());
  final DashboardController dashboardController = Get.put(DashboardController());
  // set up the button
  Widget okButton = TextButton(
    child: Text(buttonName,style: Get.textTheme.titleSmall,),
    onPressed: () async {
      cartView.cartList.value = [];
      await cartView
          .getCartList();
      Get.back();
      Get.back();
      dashboardController.changeTabIndex(1);
      // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(1),));
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title1,style: Get.textTheme.titleMedium,),
    content: Text(boday1,style: Get.textTheme.titleSmall,),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  Get.dialog(alert);
}


showLoginAlertDialog(title1, boday1,buttonName) {
  final DashboardController dashboardController = Get.put(DashboardController());
  // set up the button
  Widget okButton = TextButton(
    child: Text(buttonName),
    onPressed: () async {
      Get.back();
      Get.back();
      dashboardController.changeTabIndex(3);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title1),
    content: Text(boday1),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  Get.dialog(alert);
}
