class Chapter {
  Chapter({
    this.id,
    this.courseId,
    this.name,
    this.chapterNo,
    this.isLock,
    this.unlockDate,
    this.unlockDays,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic courseId;
  String? name;
  dynamic chapterNo;
  dynamic isLock;
  dynamic unlockDate;
  dynamic unlockDays;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        id: json["id"],
        courseId: json["course_id"],
        name: json["name"],
        chapterNo: json["chapter_no"],
        isLock: json["is_lock"],
        unlockDate: json["unlock_date"],
        unlockDays: json["unlock_days"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "name": name,
        "chapter_no": chapterNo,
        "is_lock": isLock,
        "unlock_date": unlockDate,
        "unlock_days": unlockDays,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}