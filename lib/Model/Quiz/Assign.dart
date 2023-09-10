import 'QuestionBank.dart';

class Assign {
  Assign({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.onlineExamId,
    this.questionBankId,
    this.createdBy,
    this.updatedBy,
    this.questionBank,
  });

  dynamic id;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic onlineExamId;
  dynamic questionBankId;
  dynamic createdBy;
  dynamic updatedBy;
  QuestionBank? questionBank;

  factory Assign.fromJson(Map<String, dynamic> json) => Assign(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        onlineExamId: json["online_exam_id"],
        questionBankId: json["question_bank_id"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        questionBank: QuestionBank.fromJson(json["question_bank"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "online_exam_id": onlineExamId,
        "question_bank_id": questionBankId,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "question_bank": questionBank?.toJson(),
      };
}