import 'dart:convert';

class CourseLevel {
    CourseLevel({
        this.id,
        this.title,
    });

    int? id;
    Map? title;

    factory CourseLevel.fromJson(Map<String, dynamic> json) => CourseLevel(
        id: json["id"],
        title: json["title"] is String
            ? jsonDecode(json['title'].toString().replaceAll('\'', ''))
            : json['title'],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
    };
}