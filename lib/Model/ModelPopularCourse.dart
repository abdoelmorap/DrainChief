// // To parse this JSON data, do
// //
// //     final popularCourseModel = popularCourseModelFromJson(jsonString);

// // Dart imports:
// import 'dart:convert';

// import 'User/User.dart';

// List<PopularCourseModel> popularCourseModelFromJson(String str) =>
//     List<PopularCourseModel>.from(
//         json.decode(str).map((x) => PopularCourseModel.fromJson(x))).where((element) => element.status == 1 || element.status == "1").toList();

// String popularCourseModelToJson(List<PopularCourseModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class PopularCourseModel {
//   PopularCourseModel({
//     this.id,
//     this.categoryId,
//     this.subcategoryId,
//     this.quizId,
//     this.classId,
//     this.userId,
//     this.langId,
//     this.title,
//     this.slug,
//     this.duration,
//     this.image,
//     this.thumbnail,
//     this.price,
//     this.discountPrice,
//     this.publish,
//     this.status,
//     this.level,
//     this.trailerLink,
//     this.host,
//     this.metaKeywords,
//     this.metaDescription,
//     this.about,
//     this.specialCommission,
//     this.totalEnrolled,
//     this.reveune,
//     this.reveiw,
//     this.type,
//     this.sumRev,
//     this.purchasePrice,
//     this.enrollCount,
//     this.user,
//     this.enrolls,
//   });

//   dynamic id;
//   dynamic categoryId;
//   dynamic subcategoryId;
//   dynamic quizId;
//   dynamic classId;
//   dynamic userId;
//   dynamic langId;
//   Map title;
//   String slug;
//   Duration duration;
//   String image;
//   String thumbnail;
//   dynamic price;
//   dynamic discountPrice;
//   dynamic publish;
//   dynamic status;
//   int level;
//   String trailerLink;
//   String host;
//   dynamic metaKeywords;
//   dynamic metaDescription;
//   Map about;
//   dynamic specialCommission;
//   dynamic totalEnrolled;
//   dynamic reveune;
//   dynamic reveiw;
//   dynamic type;
//   double sumRev;
//   dynamic purchasePrice;
//   dynamic enrollCount;
//   User user;
//   List<Enroll> enrolls;

//   factory PopularCourseModel.fromJson(Map<String, dynamic> json) =>
//       PopularCourseModel(
//         id: json["id"],
//         categoryId: json["category_id"],
//         subcategoryId: json["subcategory_id"],
//         quizId: json["quiz_id"],
//         classId: json["class_id"],
//         userId: json["user_id"],
//         langId: json["lang_id"],
//         title: json["title"],
//         slug: json["slug"],
//         image: json["image"],
//         thumbnail: json["thumbnail"],
//         price: json["price"],
//         discountPrice: json["discount_price"] == null ? 0 : json["discount_price"],
//         publish: json["publish"],
//         status: json["status"],
//         level: int.parse(json["level"].toString()),
//         trailerLink: json["trailer_link"],
//         host: json["host"],
//         metaKeywords: json["meta_keywords"],
//         metaDescription: json["meta_description"],
//         about: json["about"],
//         specialCommission: json["special_commission"],
//         totalEnrolled: json["total_enrolled"],
//         reveune: json["reveune"],
//         reveiw: json["reveiw"],
//         type: json["type"],
//         sumRev: json["sumRev"].toDouble(),
//         purchasePrice: json["purchasePrice"],
//         enrollCount: json["enrollCount"],
//         user: User.fromJson(json["user"]),
//         enrolls:
//             List<Enroll>.from(json["enrolls"].map((x) => Enroll.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "category_id": categoryId,
//         "subcategory_id": subcategoryId,
//         "quiz_id": quizId,
//         "class_id": classId,
//         "user_id": userId,
//         "lang_id": langId,
//         "title": title,
//         "slug": slug,
//         "image": image,
//         "thumbnail": thumbnail,
//         "price": price,
//         "discount_price": discountPrice,
//         "publish": publish,
//         "status": status,
//         "level": level,
//         "trailer_link": trailerLink,
//         "host": host,
//         "meta_keywords": metaKeywords,
//         "meta_description": metaDescription,
//         "about": about,
//         "special_commission": specialCommission,
//         "total_enrolled": totalEnrolled,
//         "reveune": reveune,
//         "reveiw": reveiw,
//         "type": type,
//         "sumRev": sumRev,
//         "purchasePrice": purchasePrice,
//         "enrollCount": enrollCount,
//         "user": user.toJson(),
//         "enrolls": List<dynamic>.from(enrolls.map((x) => x.toJson())),
//       };
// }



// class Enroll {
//   Enroll({
//     this.id,
//     this.tracking,
//     this.userId,
//     this.courseId,
//     this.purchasePrice,
//     this.coupon,
//     this.discountAmount,
//     this.status,
//     this.reason,
//     this.createdAt,
//     this.updatedAt,
//     this.enrolledDate,
//   });

//   dynamic id;
//   String tracking;
//   dynamic userId;
//   dynamic courseId;
//   dynamic purchasePrice;
//   dynamic coupon;
//   dynamic discountAmount;
//   dynamic status;
//   dynamic reason;
//   DateTime createdAt;
//   DateTime updatedAt;
//   String enrolledDate;

//   factory Enroll.fromJson(Map<String, dynamic> json) => Enroll(
//         id: json["id"],
//         tracking: json["tracking"],
//         userId: json["user_id"],
//         courseId: json["course_id"],
//         purchasePrice: json["purchase_price"],
//         coupon: json["coupon"],
//         discountAmount: json["discount_amount"],
//         status: json["status"],
//         reason: json["reason"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         enrolledDate: json["enrolledDate"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "tracking": tracking,
//         "user_id": userId,
//         "course_id": courseId,
//         "purchase_price": purchasePrice,
//         "coupon": coupon,
//         "discount_amount": discountAmount,
//         "status": status,
//         "reason": reason,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "enrolledDate": enrolledDate,
//       };
// }