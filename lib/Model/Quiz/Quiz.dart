import 'Assign.dart';

class Quiz {
  Quiz({
    this.id,
    this.title,
    this.percentage,
    this.instruction,
    this.status,
    this.isTaken,
    this.isClosed,
    this.isWaiting,
    this.isRunning,
    this.activeStatus,
    this.createdAt,
    this.updatedAt,
    this.categoryId,
    this.subCategoryId,
    this.courseId,
    this.createdBy,
    this.updatedBy,
    this.randomQuestion,
    this.questionTimeType,
    this.questionTime,
    this.questionReview,
    this.showResultEachSubmit,
    this.multipleAttend,
    this.assign,
    this.losingFocusAcceptanceNumber,
  });

  dynamic id;
  Map? title;
  String? percentage;
  Map? instruction;
  int? status;
  int? isTaken;
  int? isClosed;
  int? isWaiting;
  int? isRunning;
  int? activeStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic categoryId;
  dynamic subCategoryId;
  dynamic courseId;
  dynamic createdBy;
  dynamic updatedBy;
  int? randomQuestion;
  int? questionTimeType;
  int? questionTime;
  int? questionReview;
  int? showResultEachSubmit;
  int? multipleAttend;
  List<Assign>? assign;
  int? losingFocusAcceptanceNumber;

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        id: json["id"],
        title: json["title"],
        percentage: double.tryParse(json["percentage"].toString()).toString(),
        instruction: json["instruction"],
        status: json["status"] == null
            ? null
            : int.parse(json["status"].toString()),
        isTaken: json["is_taken"] == null
            ? null
            : int.parse(json["is_taken"].toString()),
        isClosed: json["is_closed"] == null
            ? null
            : int.parse(json["is_closed"].toString()),
        isWaiting: json["is_waiting"] == null
            ? null
            : int.parse(json["is_waiting"].toString()),
        isRunning: json["is_running"] == null
            ? null
            : int.parse(json["is_running"].toString()),
        activeStatus: json["active_status"] == null
            ? null
            : int.parse(json["active_status"].toString()),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        categoryId: json["category_id"],
        subCategoryId: json["sub_category_id"],
        courseId: json["course_id"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        randomQuestion: json["random_question"] == null
            ? null
            : int.parse(json["random_question"].toString()),
        losingFocusAcceptanceNumber: json["losing_focus_acceptance_number"] == null
            ? null
            : int.parse(json["losing_focus_acceptance_number"].toString()),
        questionTimeType: json["question_time_type"] == null
            ? null
            : int.parse(json["question_time_type"].toString()),
        questionTime: json["question_time"] == null
            ? null
            : int.parse(json["question_time"].toString()),
        questionReview: json["question_review"] == null
            ? null
            : int.parse(json["question_review"].toString()),
        showResultEachSubmit: json["show_result_each_submit"] == null
            ? null
            : int.parse(json["show_result_each_submit"].toString()),
        multipleAttend: json["multiple_attend"] == null
            ? null
            : int.parse(json["multiple_attend"].toString()),
        assign: json["assign"] == null
            ? null
            : List<Assign>.from(json["assign"].map((x) => Assign.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "percentage": percentage,
        "instruction": instruction,
        "status": status,
        "is_taken": isTaken,
        "is_closed": isClosed,
        "is_waiting": isWaiting,
        "is_running": isRunning,
        "active_status": activeStatus,
        "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "course_id": courseId,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "random_question": randomQuestion,
        "question_time_type": questionTimeType,
        "question_time": questionTime,
        "question_review": questionReview,
        "show_result_each_submit": showResultEachSubmit,
        "multiple_attend": multipleAttend,
        "assign": assign == null
            ? null
            : List<dynamic>.from(assign?.map((x) => x.toJson()) ?? []),
      };
}
