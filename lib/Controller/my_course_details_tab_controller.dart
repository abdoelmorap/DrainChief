// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:lms_flutter_app/Config/app_config.dart';

class MyCourseDetailsTabController extends GetxController
    with GetTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(text: "${stctrl.lang["Curriculum"]}"),
    Tab(text: "${stctrl.lang["Files"]}"),
    Tab(text: "${stctrl.lang["Q/A"]}"),
  ];

  TabController? controller;

  @override
  void onInit() {
    super.onInit();
    controller = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void onClose() {
    controller?.dispose();
    super.onClose();
  }
}
