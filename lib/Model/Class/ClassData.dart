import 'BbbMeeting.dart';
import 'JitsiMeeting.dart';
import 'ZoomMeeting.dart';

class ClassData {
  ClassData({
    this.id,
    this.title,
    this.duration,
    this.categoryId,
    this.subCategoryId,
    this.fees,
    this.type,
    this.startDate,
    this.endDate,
    this.time,
    this.image,
    this.host,
    this.langId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.totalClass,
    this.zoomMeetings,
    this.bbbMeetings,
    this.jitsiMeetings,
  });

  dynamic id;
  Map? title;
  String? duration;
  dynamic categoryId;
  dynamic subCategoryId;
  dynamic fees;
  dynamic type;
  DateTime? startDate;
  DateTime? endDate;
  String? time;
  String? image;
  String? host;
  dynamic langId;
  dynamic status;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic totalClass;
  List<ZoomMeeting>? zoomMeetings;
  List<BbbMeeting>? bbbMeetings;
  List<JitsiMeeting>? jitsiMeetings;

  factory ClassData.fromJson(Map<String, dynamic> json) => ClassData(
        id: json["id"],
        title: json["title"],
        duration: json["duration"],
        categoryId: json["category_id"],
        subCategoryId: json["sub_category_id"],
        fees: json["fees"],
        type: json["type"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        time: json["time"],
        image: json["image"],
        host: json["host"],
        langId: json["lang_id"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        totalClass: json["total_class"],
        zoomMeetings: json["zoom_meetings"] == null
            ? null
            : List<ZoomMeeting>.from(
                json["zoom_meetings"].map((x) => ZoomMeeting.fromJson(x))),
        bbbMeetings: json["bbb_meetings"] == null
            ? null
            : List<BbbMeeting>.from(
                json["bbb_meetings"].map((x) => BbbMeeting.fromJson(x))),
        jitsiMeetings: json["jitsi_meetings"] == null
            ? null
            : List<JitsiMeeting>.from(
                json["jitsi_meetings"].map((x) => JitsiMeeting.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "duration": duration,
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "fees": fees,
        "type": type,
        "start_date":
            "${startDate?.year.toString().padLeft(4, '0')}-${startDate?.month.toString().padLeft(2, '0')}-${startDate?.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate?.year.toString().padLeft(4, '0')}-${endDate?.month.toString().padLeft(2, '0')}-${endDate?.day.toString().padLeft(2, '0')}",
        "time": time,
        "image": image,
        "host": host,
        "lang_id": langId,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "total_class": totalClass,
        "zoom_meetings":
            List<dynamic>.from(zoomMeetings?.map((x) => x.toJson()) ?? []),
        "bbb_meetings": List<dynamic>.from(bbbMeetings?.map((x) => x.toJson()) ?? []),
        "jitsi_meetings":
            List<dynamic>.from(jitsiMeetings?.map((x) => x.toJson()) ?? []),
      };
}