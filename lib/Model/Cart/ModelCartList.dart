// To parse this JSON data, do
//
//     final cartList = cartListFromJson(jsonString);

// Dart imports:
import 'dart:convert';

import 'package:lms_flutter_app/Model/Course/CourseMain.dart';

List<CartList> cartListFromJson(String str) => List<CartList>.from(json.decode(str).map((x) => CartList.fromJson(x)));

String cartListToJson(List<CartList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartList {
  CartList({
    this.id,
    this.courseId,
    this.userId,
    this.instructorId,
    this.tracking,
    this.price,
    this.createdAt,
    this.updatedAt,
    this.course,
  });

  dynamic id;
  dynamic courseId;
  dynamic userId;
  dynamic instructorId;
  String? tracking;
  double? price;
  DateTime? createdAt;
  DateTime? updatedAt;
  CourseMain? course;

  factory CartList.fromJson(Map<String, dynamic> json) => CartList(
    id: json["id"],
    courseId: json["course_id"],
    userId: json["user_id"],
    instructorId: json["instructor_id"],
    tracking: json["tracking"],
    price: double.parse(json["price"].toString()).toDouble(),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    course: CourseMain.fromJson(json["course"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "course_id": courseId,
    "user_id": userId,
    "instructor_id": instructorId,
    "tracking": tracking,
    "price": price,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "course": course?.toJson(),
  };
}