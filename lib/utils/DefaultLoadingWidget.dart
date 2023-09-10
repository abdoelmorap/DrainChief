import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

final Widget defaultLoadingWidget = Center(
  child: SpinKitPulse(
    color: Get.theme.primaryColor,
    size: 30.0,
  ),
);
