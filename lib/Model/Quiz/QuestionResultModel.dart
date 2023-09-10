// To parse this JSON data, do
//
//     final quizResultModel = quizResultModelFromJson(jsonString);

// Dart imports:
import 'dart:convert';

QuizResultModel quizResultModelFromJson(String str) =>
    QuizResultModel.fromJson(json.decode(str));

String quizResultModelToJson(QuizResultModel data) =>
    json.encode(data.toJson());

class QuizResultModel {
  QuizResultModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory QuizResultModel.fromJson(Map<String, dynamic> json) =>
      QuizResultModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  Data({
    this.id,
    this.userId,
    this.courseId,
    this.quizId,
    this.createdAt,
    this.updatedAt,
    this.pass,
    this.startAt,
    this.endAt,
    this.duration,
    this.publish,
    this.quizType,
    this.questions,
  });

  dynamic id;
  dynamic userId;
  dynamic courseId;
  dynamic quizId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic pass;
  DateTime? startAt;
  DateTime? endAt;
  String? duration;
  dynamic publish;
  dynamic quizType;
  List<Question>? questions;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        courseId: json["course_id"],
        quizId: json["quiz_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        pass: json["pass"],
        startAt: DateTime.parse(json["start_at"]),
        endAt: json["end_at"] == null ? null : DateTime.parse(json["end_at"]),
        duration: json["duration"] == null ? null : json["duration"],
        publish: json["publish"],
        quizType: json["quiz_type"],
        questions: List<Question>.from(
            json["questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "course_id": courseId,
        "quiz_id": quizId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "pass": pass,
        "start_at": startAt?.toIso8601String(),
        "end_at": endAt == null ? null : endAt?.toIso8601String(),
        "duration": duration == null ? null : duration,
        "publish": publish,
        "quiz_type": quizType,
        "questions": List<dynamic>.from(questions?.map((x) => x.toJson()) ?? []),
      };
}

class Question {
  Question({
    this.qus,
    this.type,
    this.isSubmit,
    this.isWrong,
    this.answer,
    this.option,
  });

  String? qus;
  String? type;
  bool? isSubmit;
  bool? isWrong;
  String? answer;
  List<Option>? option;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        qus: json["qus"],
        type: json["type"],
        isSubmit: json["isSubmit"],
        isWrong: json["isWrong"],
        answer: json["answer"] == null ? null : json["answer"],
        option: json["option"] == null
            ? null
            : List<Option>.from(json["option"].map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "qus": qus,
        "type": type,
        "isSubmit": isSubmit,
        "isWrong": isWrong,
        "answer": answer == null ? null : answer,
        "option": option == null
            ? null
            : List<dynamic>.from(option?.map((x) => x.toJson()) ?? []),
      };
}

class Option {
  Option({
    this.title,
    this.right,
    this.wrong,
  });

  String? title;
  bool? right;
  bool? wrong;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        title: json["title"],
        right: json["right"],
        wrong: json["wrong"] == null ? null : json["wrong"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "right": right,
        "wrong": wrong == null ? null : wrong,
      };
}
