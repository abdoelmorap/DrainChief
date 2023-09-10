// // To parse this JSON data, do
// //
// //     final myCourseViewDetails = myCourseViewDetailsFromJson(jsonString);

// // Dart imports:
// import 'dart:convert';

// import 'package:lms_flutter_app/Model/Course/CourseMain.dart';

// MyCourseViewDetails myCourseViewDetailsFromJson(String str) =>
//     MyCourseViewDetails.fromJson(json.decode(str));

// String myCourseViewDetailsToJson(MyCourseViewDetails data) =>
//     json.encode(data.toJson());

// class MyCourseViewDetails {
//   MyCourseViewDetails({
//     this.success,
//     this.data,
//     this.message,
//   });

//   bool success;
//   CourseMain data;
//   String message;

//   factory MyCourseViewDetails.fromJson(Map<String, dynamic> json) =>
//       MyCourseViewDetails(
//         success: json["success"],
//         data: CourseMain.fromJson(json["data"]),
//         message: json["message"],
//       );

//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "data": data.toJson(),
//         "message": message,
//       };
// }







