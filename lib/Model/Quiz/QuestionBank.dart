import 'QuestionMu.dart';

class QuestionBank {
  QuestionBank({
    this.id,
    this.type,
    this.question,
    this.marks,
    this.trueFalse,
    this.suitableWords,
    this.numberOfOption,
    this.qGroupId,
    this.categoryId,
    this.subCategoryId,
    this.activeStatus,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.image,
    this.questionMu,
  });

  dynamic id;
  String? type;
  String? question;
  double? marks;
  dynamic trueFalse;
  dynamic suitableWords;
  int? numberOfOption;
  dynamic qGroupId;
  dynamic categoryId;
  dynamic subCategoryId;
  dynamic activeStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic userId;
  dynamic image;
  List<QuestionMu>? questionMu;

  factory QuestionBank.fromJson(Map<String, dynamic> json) => QuestionBank(
        id: json["id"],
        type: json["type"],
        question: json["question"],
        marks: double.parse(json["marks"].toString()),
        trueFalse: json["trueFalse"],
        suitableWords: json["suitable_words"],
        numberOfOption: json["number_of_option"] == null
            ? null
            : int.parse(json["number_of_option"].toString()),
        qGroupId: json["q_group_id"],
        categoryId: json["category_id"],
        subCategoryId: json["sub_category_id"],
        activeStatus: json["active_status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        userId: json["user_id"],
        image: json["image"],
        questionMu: List<QuestionMu>.from(
            json["question_mu"].map((x) => QuestionMu.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "question": question,
        "marks": marks,
        "trueFalse": trueFalse,
        "suitable_words": suitableWords,
        "number_of_option": numberOfOption == null ? null : numberOfOption,
        "q_group_id": qGroupId,
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "active_status": activeStatus,
        "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "user_id": userId,
        "image": image,
        "question_mu": List<dynamic>.from(questionMu?.map((x) => x.toJson()) ?? []),
      };
}
