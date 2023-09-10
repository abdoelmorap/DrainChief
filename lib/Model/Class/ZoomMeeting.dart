class ZoomMeeting {
  ZoomMeeting({
    this.id,
    this.classId,
    this.createdBy,
    this.instructorId,
    this.meetingId,
    this.password,
    this.startTime,
    this.endTime,
    this.topic,
    this.description,
    this.attachedFile,
    this.dateOfMeeting,
    this.timeOfMeeting,
    this.meetingDuration,
    this.joinBeforeHost,
    this.hostVideo,
    this.participantVideo,
    this.muteUponEntry,
    this.waitingRoom,
    this.audio,
    this.autoRecording,
    this.approvalType,
    this.isRecurring,
    this.recurringType,
    this.recurringRepectDay,
    this.recurringEndDate,
    this.status,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic classId;
  dynamic createdBy;
  dynamic instructorId;
  String? meetingId;
  String? password;
  DateTime? startTime;
  DateTime? endTime;
  String? topic;
  String? description;
  String? attachedFile;
  String? dateOfMeeting;
  String? timeOfMeeting;
  String? meetingDuration;
  dynamic joinBeforeHost;
  dynamic hostVideo;
  dynamic participantVideo;
  dynamic muteUponEntry;
  dynamic waitingRoom;
  String? audio;
  String? autoRecording;
  String? approvalType;
  dynamic isRecurring;
  dynamic recurringType;
  dynamic recurringRepectDay;
  dynamic recurringEndDate;
  dynamic status;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ZoomMeeting.fromJson(Map<String, dynamic> json) => ZoomMeeting(
        id: json["id"],
        classId: json["class_id"],
        createdBy: json["created_by"],
        instructorId: json["instructor_id"],
        meetingId: json["meeting_id"],
        password: json["password"],
        startTime: DateTime.parse(json["start_time"]),
        endTime: DateTime.parse(json["end_time"]),
        topic: json["topic"],
        description: json["description"],
        attachedFile: json["attached_file"],
        dateOfMeeting: json["date_of_meeting"],
        timeOfMeeting: json["time_of_meeting"],
        meetingDuration: json["meeting_duration"],
        joinBeforeHost: json["join_before_host"],
        hostVideo: json["host_video"],
        participantVideo: json["participant_video"],
        muteUponEntry: json["mute_upon_entry"],
        waitingRoom: json["waiting_room"],
        audio: json["audio"],
        autoRecording: json["auto_recording"],
        approvalType: json["approval_type"],
        isRecurring: json["is_recurring"],
        recurringType: json["recurring_type"],
        recurringRepectDay: json["recurring_repect_day"],
        recurringEndDate: json["recurring_end_date"],
        status: json["status"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "class_id": classId,
        "created_by": createdBy,
        "instructor_id": instructorId,
        "meeting_id": meetingId,
        "password": password,
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
        "topic": topic,
        "description": description,
        "attached_file": attachedFile,
        "date_of_meeting": dateOfMeeting,
        "time_of_meeting": timeOfMeeting,
        "meeting_duration": meetingDuration,
        "join_before_host": joinBeforeHost,
        "host_video": hostVideo,
        "participant_video": participantVideo,
        "mute_upon_entry": muteUponEntry,
        "waiting_room": waitingRoom,
        "audio": audio,
        "auto_recording": autoRecording,
        "approval_type": approvalType,
        "is_recurring": isRecurring,
        "recurring_type": recurringType,
        "recurring_repect_day": recurringRepectDay,
        "recurring_end_date": recurringEndDate,
        "status": status,
        "updated_by": updatedBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}