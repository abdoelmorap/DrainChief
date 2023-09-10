// To parse this JSON data, do
//
//     final quizStartModel = quizStartModelFromJson(jsonString);

// Dart imports:
import 'dart:convert';

QuizStartModel quizStartModelFromJson(String str) => QuizStartModel.fromJson(json.decode(str));

String quizStartModelToJson(QuizStartModel data) => json.encode(data.toJson());

class QuizStartModel {
  QuizStartModel({
    this.result,
    this.data,
  });

  bool? result;
  QData? data;

  factory QuizStartModel.fromJson(Map<String, dynamic> json) => QuizStartModel(
    result: json["result"],
    data: QData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "data": data?.toJson(),
  };
}

class QData {
  QData({
    this.userId,
    this.courseId,
    this.quizId,
    this.quizType,
    this.startAt,
    this.endAt,
    this.duration,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  dynamic userId;
  String? courseId;
  String? quizId;
  dynamic quizType;
  DateTime? startAt;
  dynamic endAt;
  dynamic duration;
  DateTime? updatedAt;
  DateTime? createdAt;
  dynamic id;

  factory QData.fromJson(Map<String, dynamic> json) => QData(
    userId: json["user_id"],
    courseId: json["course_id"],
    quizId: json["quiz_id"],
    quizType: json["quiz_type"],
    startAt: DateTime.parse(json["start_at"]),
    endAt: json["end_at"],
    duration: json["duration"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "course_id": courseId,
    "quiz_id": quizId,
    "quiz_type": quizType,
    "start_at": startAt?.toIso8601String(),
    "end_at": endAt,
    "duration": duration,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
