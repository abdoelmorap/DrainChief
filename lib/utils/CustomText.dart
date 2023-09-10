// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

import 'package:get/get.dart';
import 'package:lms_flutter_app/Config/app_config.dart';

// ignore: non_constant_identifier_names
Widget Texth1(String txt) {
  return Text(
    txt,
    style: Get.textTheme.titleMedium,
  );
}

// ignore: non_constant_identifier_names
Widget CatTitle(String txt) {
  return Text(
    txt,
    maxLines: 1,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      fontFamily: 'AvenirNext',
    ),
  );
}

// ignore: non_constant_identifier_names
Widget CatSubTitle(String txt) {
  return Text(
    txt,
    style: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );
}

Widget sellAllText() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(top: 3),
        child: Text("${stctrl.lang["See All"]}",
            style: Get.textTheme.titleSmall
                ?.copyWith(color: Get.theme.primaryColor)),
      ),
      Container(
        child: Icon(
          Icons.arrow_right,
          color: Get.theme.primaryColor,
        ),
      ),
    ],
  );
}

Widget courseTitle(String txt) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Text(
      txt,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Get.textTheme.titleMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontStyle: FontStyle.normal,
      ),
    ),
  );
}

Widget courseTPublisher(String txt) {
  return Text(txt,
      style: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xff8E99B7)));
}

Widget cartMoney(String txt) {
  return Text(txt,
      style: Get.textTheme.titleMedium?.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xffD7598F),
          fontFamily: 'AvenirNext'));
}

Widget cartTitle(String txt) {
  return Text(txt,
      style: Get.textTheme.titleMedium?.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          fontFamily: 'AvenirNext'));
}

Widget cartTotal(String txt) {
  return Text(txt,
      style: Get.textTheme.titleMedium?.copyWith(
          fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'AvenirNext'));
}

Widget couponTitle(String txt) {
  return Text(txt,
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          color: Color(0xff23BC20),
          fontFamily: 'AvenirNext'));
}

Widget couponTotal(String txt) {
  return Text(txt,
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xff23BC20),
          fontFamily: 'AvenirNext'));
}

Widget couponError(String txt) {
  return Text(txt,
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xffbc2020),
          fontFamily: 'AvenirNext'));
}

Widget courseDescriptionTitle(String txt) {
  return Text(
    txt,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: Color(0xffffffff),
      fontFamily: 'AvenirNext',
    ),
    textAlign: TextAlign.left,
  );
}

Widget courseDescriptionPublisher(String txt) {
  return Text(txt,
      style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xffffffff)));
}

Widget courseStructure(String txt) {
  return Text(
    txt.toString(),
    style: Get.textTheme.titleSmall?.copyWith(fontSize: 14),
  );
}

String getTimeString(int value) {
  final int hour = value ~/ 60;
  final int minutes = value % 60;
  return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
}

// ignore: non_constant_identifier_names
Widget PopularPostTitle(String txt) {
  return Text(txt,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Get.textTheme.titleMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'AvenirNext',
      ));
}
