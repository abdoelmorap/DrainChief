class Review {
  Review({
    this.id,
    this.star,
    this.comment,
    this.createdAt,
    this.userId,
    this.userName,
    this.userImage,
  });

  dynamic id;
  double? star;
  String? comment;
  DateTime? createdAt;
  dynamic userId;
  String? userName;
  String? userImage;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json["id"],
    star: double.parse(json["star"].toString()).toDouble(),
    comment: json["comment"],
    createdAt: DateTime.parse(json["created_at"]),
    userId: json["userId"],
    userName: json["userName"],
    userImage: json["userImage"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "star": star,
    "comment": comment,
    "created_at": createdAt?.toIso8601String(),
    "userId": userId,
    "userName": userName,
    "userImage": userImage,
  };
}