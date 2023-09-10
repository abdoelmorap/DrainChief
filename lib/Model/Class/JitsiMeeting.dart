class JitsiMeeting {
  JitsiMeeting({
    this.id,
    this.createdBy,
    this.instructorId,
    this.classId,
    this.meetingId,
    this.topic,
    this.description,
    this.date,
    this.time,
    this.datetime,
    this.createdAt,
    this.updatedAt,
    this.duration,
  });

  int? id;
  int? createdBy;
  int? instructorId;
  int? classId;
  String? meetingId;
  String? topic;
  String? description;
  String? date;
  String? time;
  String? datetime;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? duration;

  factory JitsiMeeting.fromJson(Map<String, dynamic> json) => JitsiMeeting(
        id: json["id"],
        createdBy: json["created_by"],
        instructorId: json["instructor_id"],
        classId: json["class_id"],
        meetingId: json["meeting_id"],
        topic: json["topic"],
        description: json["description"],
        date: json["date"],
        time: json["time"],
        datetime: json["datetime"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_by": createdBy,
        "instructor_id": instructorId,
        "class_id": classId,
        "meeting_id": meetingId,
        "topic": topic,
        "description": description,
        "date": date,
        "time": time,
        "datetime": datetime,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "duration": duration,
      };
}