// To parse this JSON data, do
//
//     final myQuizResultsModel = myQuizResultsModelFromJson(jsonString);

import 'dart:convert';

import 'Quiz.dart';

MyQuizResultsModel myQuizResultsModelFromJson(String str) =>
    MyQuizResultsModel.fromJson(json.decode(str));

String myQuizResultsModelToJson(MyQuizResultsModel data) =>
    json.encode(data.toJson());

class MyQuizResultsModel {
  MyQuizResultsModel({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  List<MyQuizResultsData>? data;
  String? message;

  factory MyQuizResultsModel.fromJson(Map<String, dynamic> json) =>
      MyQuizResultsModel(
        success: json["success"],
        data: List<MyQuizResultsData>.from(
            json["data"].map((x) => MyQuizResultsData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
        "message": message,
      };
}

class MyQuizResultsData {
  MyQuizResultsData({
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
    this.quiz,
    this.result,
    this.details,
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
  Quiz? quiz;
  List<Result>? result;
  List<Detail>? details;

  factory MyQuizResultsData.fromJson(Map<String, dynamic> json) =>
      MyQuizResultsData(
        id: json["id"],
        userId: json["user_id"],
        courseId: json["course_id"],
        quizId: json["quiz_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        pass: json["pass"],
        startAt: DateTime.parse(json["start_at"]),
        endAt: json["end_at"] == null ? null : DateTime.parse(json["end_at"]),
        duration: json["duration"],
        publish: json["publish"],
        quizType: json["quiz_type"],
        quiz: json["quiz"] == null ? null : Quiz.fromJson(json["quiz"]),
        result: json["result"] == null
            ? null
            : List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
        details: json["details"] == null
            ? null
            : List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
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
        "duration": duration,
        "publish": publish,
        "quiz_type": quizType,
        "quiz": quiz?.toJson(),
        "result": List<dynamic>.from(result?.map((x) => x.toJson()) ?? []),
        "details": List<dynamic>.from(details?.map((x) => x.toJson()) ?? []),
      };
}

class Detail {
  Detail({
    this.id,
    this.quizTestId,
    this.qusId,
    this.ansId,
    this.status,
    this.mark,
    this.createdAt,
    this.updatedAt,
    this.answer,
  });

  dynamic id;
  dynamic quizTestId;
  dynamic qusId;
  dynamic ansId;
  dynamic status;
  dynamic mark;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? answer;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["id"],
        quizTestId: json["quiz_test_id"],
        qusId: json["qus_id"],
        ansId: json["ans_id"],
        status: json["status"],
        mark: json["mark"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        answer: json["answer"] == null ? null : json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quiz_test_id": quizTestId,
        "qus_id": qusId,
        "ans_id": ansId,
        "status": status,
        "mark": mark,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "answer": answer == null ? null : answer,
      };
}

class Result {
  Result({
    this.quizTestId,
    this.totalQus,
    this.date,
    this.totalAns,
    this.totalCorrect,
    this.totalWrong,
    this.score,
    this.totalScore,
    this.passMark,
    this.mark,
    this.publish,
    this.status,
    this.textColor,
  });

  dynamic quizTestId;
  dynamic totalQus;
  String? date;
  dynamic totalAns;
  dynamic totalCorrect;
  dynamic totalWrong;
  dynamic score;
  dynamic totalScore;
  dynamic passMark;
  dynamic mark;
  dynamic publish;
  String? status;
  String? textColor;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        quizTestId: json["quiz_test_id"],
        totalQus: json["totalQus"],
        date: json["date"],
        totalAns: json["totalAns"],
        totalCorrect: json["totalCorrect"],
        totalWrong: json["totalWrong"],
        score: json["score"],
        totalScore: json["totalScore"],
        passMark: json["passMark"],
        mark: json["mark"],
        publish: json["publish"],
        status: json["status"],
        textColor: json["text_color"],
      );

  Map<String, dynamic> toJson() => {
        "quiz_test_id": quizTestId,
        "totalQus": totalQus,
        "date": date,
        "totalAns": totalAns,
        "totalCorrect": totalCorrect,
        "totalWrong": totalWrong,
        "score": score,
        "totalScore": totalScore,
        "passMark": passMark,
        "mark": mark,
        "publish": publish,
        "status": status,
        "text_color": textColor,
      };
}
