class Enroll {
  Enroll({
    this.id,
    this.tracking,
    this.userId,
    this.courseId,
    this.purchasePrice,
    this.coupon,
    this.discountAmount,
    this.status,
    this.reason,
    this.createdAt,
    this.updatedAt,
    this.enrolledDate,
  });

  dynamic id;
  String? tracking;
  int? userId;
  dynamic courseId;
  dynamic purchasePrice;
  dynamic coupon;
  dynamic discountAmount;
  dynamic status;
  dynamic reason;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? enrolledDate;

  factory Enroll.fromJson(Map<String, dynamic> json) => Enroll(
    id: json["id"],
    tracking: json["tracking"],
    userId: int.parse(json["user_id"].toString()),
    courseId: json["course_id"],
    purchasePrice: json["purchase_price"],
    coupon: json["coupon"],
    discountAmount: json["discount_amount"],
    status: json["status"],
    reason: json["reason"],
    // createdAt: DateTime.parse(json["created_at"]),
    // updatedAt: DateTime.parse(json["updated_at"]),
    enrolledDate: json["enrolledDate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tracking": tracking,
    "user_id": userId,
    "course_id": courseId,
    "purchase_price": purchasePrice,
    "coupon": coupon,
    "discount_amount": discountAmount,
    "status": status,
    "reason": reason,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "enrolledDate": enrolledDate,
  };
}