class QuestionMu {
  QuestionMu({
    this.id,
    this.title,
    this.status,
    this.activeStatus,
    this.createdAt,
    this.updatedAt,
    this.questionBankId,
    this.createdBy,
    this.updatedBy,
  });

  dynamic id;
  String? title;
  int? status;
  dynamic activeStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic questionBankId;
  dynamic createdBy;
  dynamic updatedBy;

  factory QuestionMu.fromJson(Map<String, dynamic> json) => QuestionMu(
        id: json["id"],
        title: json["title"],
        status: int.parse(json["status"].toString()),
        activeStatus: json["active_status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        questionBankId: json["question_bank_id"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "status": status,
        "active_status": activeStatus,
        "created_at": createdAt == null ? null : createdAt?.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "question_bank_id": questionBankId,
        "created_by": createdBy,
        "updated_by": updatedBy,
      };
}