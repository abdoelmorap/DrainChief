// To parse this JSON data, do
//
//     final topCategory = topCategoryFromJson(jsonString);

// Dart imports:
import 'dart:convert';

import 'package:lms_flutter_app/Model/Course/CourseMain.dart';

List<TopCategory> topCategoryFromJson(String str) =>
    List<TopCategory>.from(json.decode(str).map((x) => TopCategory.fromJson(x)))
        .where((element) => element.courseCount != 0)
        .toList();

String topCategoryToJson(List<TopCategory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TopCategory {
  TopCategory({
    this.id,
    this.name,
    this.status,
    this.title,
    this.description,
    this.url,
    this.showHome,
    this.positionOrder,
    this.image,
    this.thumbnail,
    this.createdAt,
    this.updatedAt,
    this.courseCount,
    this.courses,
  });

  dynamic id;
  Map? name;
  dynamic status;
  String? title;
  Map? description;
  String? url;
  dynamic showHome;
  dynamic positionOrder;
  String? image;
  String? thumbnail;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic courseCount;
  List<CourseMain>? courses;

  factory TopCategory.fromJson(dynamic json) => TopCategory(
        id: json["id"],
        name: json["name"],
        status: json["status"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        showHome: json["show_home"],
        positionOrder: json["position_order"],
        image: json["image"],
        thumbnail: json["thumbnail"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        courseCount: json["courseCount"],
        courses:
            List<CourseMain>.from(json["courses"].map((x) => CourseMain.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "status": status,
        "title": title,
        "description": description,
        "url": url,
        "show_home": showHome,
        "position_order": positionOrder,
        "image": image,
        "thumbnail": thumbnail,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "courseCount": courseCount,
        "courses": List<dynamic>.from(courses?.map((x) => x.toJson()) ?? []),
      };
}