import 'package:lms_flutter_app/Model/User/User.dart';

class Comment {
  Comment({
    this.userId,
    this.courseId,
    this.instructorId,
    this.status,
    this.comment,
    this.submittedDate,
    this.commentDate,
    this.user,
  });

  dynamic userId;
  dynamic courseId;
  dynamic instructorId;
  dynamic status;
  String? comment;
  String? submittedDate;
  String? commentDate;
  User? user;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        userId: json["user_id"],
        courseId: json["course_id"],
        instructorId: json["instructor_id"],
        status: json["status"],
        comment: json["comment"],
        submittedDate: json["submittedDate"],
        commentDate: json["commentDate"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "course_id": courseId,
        "instructor_id": instructorId,
        "status": status,
        "comment": comment,
        "submittedDate": submittedDate,
        "commentDate": commentDate,
        "user": user?.toJson(),
      };
}