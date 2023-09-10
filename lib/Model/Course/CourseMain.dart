import 'dart:convert';

import 'package:lms_flutter_app/Model/Class/ClassData.dart';
import 'package:lms_flutter_app/Model/Course/FileElement.dart';
import 'package:lms_flutter_app/Model/Course/Review.dart';
import 'package:lms_flutter_app/Model/User/User.dart';

import 'Chapter.dart';
import 'Comment.dart';
import 'Enroll.dart';
import 'Lesson.dart';
import '../Quiz/Quiz.dart';
import 'Level.dart';

class CourseMain {
  CourseMain({
    this.id,
    this.categoryId,
    this.subcategoryId,
    this.quizId,
    this.classId,
    this.userId,
    this.langId,
    this.title,
    this.slug,
    this.duration,
    this.image,
    this.thumbnail,
    this.price,
    this.discountPrice,
    this.publish,
    this.status,
    this.level,
    this.trailerLink,
    this.host,
    this.metaKeywords,
    this.metaDescription,
    this.about,
    this.specialCommission,
    this.totalEnrolled,
    this.type,
    this.sumRev,
    this.purchasePrice,
    this.enrollCount,
    this.user,
    this.chapters,
    this.lessons,
    this.files,
    this.comments,
    this.enrolls,
    this.reviews,
    this.review,
    this.requirements,
    this.outcomes,
    this.dataClass,
    this.quiz,
    this.totalCompletePercentage,
    this.courseLevel,
    this.iapProductId,
  });

  dynamic id;
  dynamic categoryId;
  dynamic subcategoryId;
  dynamic quizId;
  dynamic classId;
  dynamic userId;
  dynamic langId;
  Map? title;
  String? slug;
  String? duration;
  String? image;
  String? thumbnail;
  dynamic price;
  dynamic discountPrice;
  dynamic publish;
  dynamic status;
  dynamic level;
  String? trailerLink;
  String? host;
  dynamic metaKeywords;
  dynamic metaDescription;
  Map? about;
  Map? requirements;
  Map? outcomes;
  dynamic specialCommission;
  dynamic totalEnrolled;
  dynamic type;
  double? sumRev;
  dynamic purchasePrice;
  dynamic enrollCount;
  User? user;
  List<Chapter>? chapters;
  List<Lesson>? lessons;
  List<FileElement>? files;
  List<Comment>? comments;
  List<Enroll>? enrolls;
  List<Review>? reviews;
  dynamic review;
  ClassData? dataClass;
  Quiz? quiz;
  dynamic totalCompletePercentage;
  CourseLevel? courseLevel;
  String? iapProductId;

  factory CourseMain.fromJson(Map<String, dynamic> json) => CourseMain(
        id: json["id"],
        categoryId: json["category_id"],
        subcategoryId: json["subcategory_id"],
        quizId: json["quiz_id"],
        classId: json["class_id"],
        userId: json["user_id"],
        langId: json["lang_id"],
        title: json["title"] is String
            ? jsonDecode(json['title'].toString().replaceAll('\'', ''))
            : json['title'],
        slug: json["slug"],
        duration: json["duration"] == null || json["duration"] == ""
            ? "0"
            : json['duration'],
        image: json["image"] == null ? "" : json["image"],
        thumbnail: json["thumbnail"] == null ? "" : json["thumbnail"],
        price: json["price"],
        discountPrice:
            json["discount_price"] == null ? 0 : json["discount_price"],
        publish: json["publish"],
        status: json["status"],
         courseLevel: json["course_level"] == null
            ? null
            : CourseLevel.fromJson(json["course_level"]),
        trailerLink: json["trailer_link"],
        host: json["host"],
        metaKeywords: json["meta_keywords"],
        metaDescription: json["meta_description"],
        about: json['about'] == null ? {"en": ""} : json['about'],
        requirements:
            json['requirements'] == null ? {"en": ""} : json['requirements'],
        outcomes: json['outcomes'] == null ? {"en": ""} : json['outcomes'],
        specialCommission: json["special_commission"],
        totalEnrolled: json["total_enrolled"],
        type: json["type"],
        review: json["reveiw"],
        sumRev: json["sumRev"] == null ? null : json["sumRev"].toDouble(),
        purchasePrice: json["purchasePrice"],
        enrollCount: json["enrollCount"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        chapters: json["chapters"] == null
            ? null
            : List<Chapter>.from(
                json["chapters"].map((x) => Chapter.fromJson(x))),
        lessons: json["lessons"] == null
            ? null
            : List<Lesson>.from(json["lessons"].map((x) => Lesson.fromJson(x))),
        files: json["files"] == null
            ? null
            : List<FileElement>.from(
                json["files"].map((x) => FileElement.fromJson(x))),
        comments: json["comments"] == null
            ? null
            : List<Comment>.from(
                json["comments"].map((x) => Comment.fromJson(x))),
        enrolls: json["enrolls"] == null
            ? null
            : List<Enroll>.from(json["enrolls"].map((x) => Enroll.fromJson(x))),
        reviews: json["reviews"] == null
            ? null
            : List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
        dataClass: json["class"] == null
            ? null
            : json["class"].runtimeType == List
                ? null
                : ClassData.fromJson(json["class"]),
        quiz: json["quiz"] == null ? null : Quiz.fromJson(json["quiz"]),
        totalCompletePercentage: json["totalCompletePercentage"],
        iapProductId: json["iap_product_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "quiz_id": quizId,
        "class_id": classId,
        "user_id": userId,
        "lang_id": langId,
        "title": title,
        "slug": slug,
        "duration": duration,
        "image": image,
        "thumbnail": thumbnail,
        "price": price,
        "discount_price": discountPrice,
        "publish": publish,
        "status": status,
        "level": level,
        "review": review,
        "trailer_link": trailerLink,
        "host": host,
        "meta_keywords": metaKeywords,
        "meta_description": metaDescription,
        "about": about,
        "special_commission": specialCommission,
        "total_enrolled": totalEnrolled,
        "type": type,
        "sumRev": sumRev,
        "purchasePrice": purchasePrice,
        "enrollCount": enrollCount,
        "user": user?.toJson(),
        "enrolls": List<dynamic>.from(enrolls?.map((x) => x.toJson()) ?? []),
        "chapters": List<dynamic>.from(chapters?.map((x) => x.toJson()) ?? []),
        "lessons": List<dynamic>.from(lessons?.map((x) => x.toJson()) ?? []),
        "files": List<dynamic>.from(files?.map((x) => x.toJson()) ?? []),
        "comments": List<dynamic>.from(comments?.map((x) => x.toJson()) ?? []),
        "reviews": List<dynamic>.from(reviews?.map((x) => x.toJson()) ?? []),
        "class": dataClass?.toJson(),
        "quiz": quiz?.toJson(),
        "course_level": courseLevel?.toJson(),
        "iap_product_id": iapProductId,
      };
}
