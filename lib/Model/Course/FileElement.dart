class FileElement {
  FileElement({
    this.id,
    this.courseId,
    this.fileName,
    this.file,
    this.lock,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic courseId;
  String? fileName;
  String? file;
  dynamic lock;
  dynamic status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        id: json["id"],
        courseId: json["course_id"],
        fileName: json["fileName"],
        file: json["file"],
        lock: json["lock"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "fileName": fileName,
        "file": file,
        "lock": lock,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}