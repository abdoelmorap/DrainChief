import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.roleId,
    this.name,
    this.photo,
    this.image,
    this.avatar,
    this.notificationPreference,
    this.isActive,
    this.username,
    this.email,
    this.emailVerify,
    this.headline,
    this.phone,
    this.address,
    this.city,
    this.country,
    this.state,
    this.zip,
    this.dob,
    this.about,
    this.shortDetails,
    this.facebook,
    this.twitter,
    this.linkedin,
    this.instagram,
    this.youtube,
    this.subscribe,
    this.provider,
    this.providerId,
    this.languageId,
    this.languageCode,
    this.languageName,
    this.status,
    this.balance,
    this.currencyId,
    this.specialCommission,
    this.payout,
    this.payoutIcon,
    this.payoutEmail,
    this.referral,
    this.addedBy,
    this.zoomApiKeyOfUser,
    this.zoomApiSerectOfUser,
    this.bankName,
    this.branchName,
    this.bankAccountNumber,
    this.accountHolderName,
    this.bankType,
    this.subscriptionMethod,
    this.subscriptionApiKey,
    this.subscriptionApiStatus,
    this.totalRating,
    this.languageRtl,
    this.firstName,
    this.lastName,
    this.blockedByMe,
    this.position,
    this.branch,
  });

  int? id;
  dynamic roleId;
  String? name;
  String? photo;
  String? image;
  String? avatar;
  String? notificationPreference;
  dynamic isActive;
  String? username;
  String? email;
  String? emailVerify;
  String? headline;
  String? phone;
  dynamic address;
  dynamic city;
  dynamic country;
  dynamic state;
  dynamic zip;
  dynamic dob;
  String? about;
  String? shortDetails;
  dynamic facebook;
  dynamic twitter;
  dynamic linkedin;
  dynamic instagram;
  dynamic youtube;
  dynamic subscribe;
  dynamic provider;
  dynamic providerId;
  String? languageId;
  String? languageCode;
  String? languageName;
  dynamic status;
  dynamic balance;
  dynamic currencyId;
  dynamic specialCommission;
  String? payout;
  String? payoutIcon;
  String? payoutEmail;
  String? referral;
  dynamic addedBy;
  String? zoomApiKeyOfUser;
  String? zoomApiSerectOfUser;
  dynamic bankName;
  dynamic branchName;
  dynamic bankAccountNumber;
  dynamic accountHolderName;
  dynamic bankType;
  dynamic subscriptionMethod;
  dynamic subscriptionApiKey;
  dynamic subscriptionApiStatus;
  double? totalRating;
  dynamic languageRtl;
  String? firstName;
  String? lastName;
  dynamic blockedByMe;

  UserPosition? position;
  UserPosition? branch;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        roleId: json["role_id"],
        name: json["name"],
        photo: json["photo"],
        image: json["image"],
        avatar: json["avatar"],
        notificationPreference: json["notification_preference"],
        isActive: json["is_active"],
        username: json["username"],
        email: json["email"],
        emailVerify: json["email_verify"],
        headline: json["headline"],
        phone: json["phone"],
        address: json["address"],
        city: json["city"],
        country: json["country"],
        state: json["state"],
        zip: json["zip"],
        dob: json["dob"],
        about: json["about"],
        shortDetails: json["short_details"],
        facebook: json["facebook"],
        twitter: json["twitter"],
        linkedin: json["linkedin"],
        instagram: json["instagram"],
        youtube: json["youtube"],
        subscribe: json["subscribe"],
        provider: json["provider"],
        providerId: json["provider_id"],
        languageId: json["language_id"],
        languageCode: json["language_code"],
        languageName: json["language_name"],
        status: json["status"],
        balance: json["balance"],
        currencyId: json["currency_id"],
        specialCommission: json["special_commission"],
        payout: json["payout"],
        payoutIcon: json["payout_icon"],
        payoutEmail: json["payout_email"],
        referral: json["referral"],
        addedBy: json["added_by"],
        zoomApiKeyOfUser: json["zoom_api_key_of_user"],
        zoomApiSerectOfUser: json["zoom_api_serect_of_user"],
        bankName: json["bank_name"],
        branchName: json["branch_name"],
        bankAccountNumber: json["bank_account_number"],
        accountHolderName: json["account_holder_name"],
        bankType: json["bank_type"],
        subscriptionMethod: json["subscription_method"],
        subscriptionApiKey: json["subscription_api_key"],
        subscriptionApiStatus: json["subscription_api_status"],
        totalRating: json["total_rating"] == null
            ? null
            : double.parse(json["total_rating"].toString()).toDouble(),
        languageRtl: json["language_rtl"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        blockedByMe: json["blocked_by_me"],
        position: json["position"] == null || json['position'] is List
            ? null
            : UserPosition.fromJson(json["position"]),
        branch: json["branch"] == null || json['branch'] is List
            ? null
            : UserPosition.fromJson(json["branch"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role_id": roleId,
        "name": name,
        "photo": photo,
        "image": image,
        "avatar": avatar,
        "notification_preference": notificationPreference,
        "is_active": isActive,
        "username": username,
        "email": email,
        "email_verify": emailVerify,
        "headline": headline,
        "phone": phone,
        "address": address,
        "city": city,
        "country": country,
        "state": state,
        "zip": zip,
        "dob": dob,
        "about": about,
        "short_details": shortDetails,
        "facebook": facebook,
        "twitter": twitter,
        "linkedin": linkedin,
        "instagram": instagram,
        "youtube": youtube,
        "subscribe": subscribe,
        "provider": provider,
        "provider_id": providerId,
        "language_id": languageId,
        "language_code": languageCode,
        "language_name": languageName,
        "status": status,
        "balance": balance,
        "currency_id": currencyId,
        "special_commission": specialCommission,
        "payout": payout,
        "payout_icon": payoutIcon,
        "payout_email": payoutEmail,
        "referral": referral,
        "added_by": addedBy,
        "zoom_api_key_of_user": zoomApiKeyOfUser,
        "zoom_api_serect_of_user": zoomApiSerectOfUser,
        "bank_name": bankName,
        "branch_name": branchName,
        "bank_account_number": bankAccountNumber,
        "account_holder_name": accountHolderName,
        "bank_type": bankType,
        "subscription_method": subscriptionMethod,
        "subscription_api_key": subscriptionApiKey,
        "subscription_api_status": subscriptionApiStatus,
        "total_rating": totalRating,
        "language_rtl": languageRtl,
        "first_name": firstName,
        "last_name": lastName,
        // "blocked_by_me": blockedByMe,
        // "position": position.toJson(),
        // "branch": branch.toJson(),
      };
}

class UserPosition {
  UserPosition({
    this.name,
    this.code,
    this.group,
    this.order,
    this.lmsId,
  });

  String? name;
  String? group;
  String? code;
  int? order;
  int? lmsId;

  factory UserPosition.fromJson(Map<String, dynamic> json) => UserPosition(
        name: json["name"],
        code: json["code"],
        group: json["group"],
        order: json["order"],
        lmsId: json["lms_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "group": group,
        "code": code,
        "order": order,
        "lms_id": lmsId,
      };
}
