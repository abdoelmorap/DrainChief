import 'dart:convert';

Setting settingFromJson(String str) => Setting.fromJson(json.decode(str));

String settingToJson(Setting data) => json.encode(data.toJson());

class Setting {
  Setting({
    this.success,
    this.data,
    this.message,
  });

  bool? success;
  Data? data;
  String? message;

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  Data({
    this.siteTitle,
    this.systemVersion,
    this.studentReg,
    this.instructorReg,
    this.themeColor,
    this.currencyCode,
    this.currencySymbol,
  });

  String? siteTitle;
  String? systemVersion;
  int? studentReg;
  int? instructorReg;
  ThemeColor? themeColor;
  String? currencyCode;
  String? currencySymbol;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        siteTitle: json["site_title"],
        systemVersion: json["system_version"],
        studentReg: json["student_reg"],
        instructorReg: json["instructor_reg"],
        themeColor: ThemeColor.fromJson(json["theme_color"]),
        currencyCode: json["currency_code"],
        currencySymbol: json["currency_symbol"],
      );

  Map<String, dynamic> toJson() => {
        "site_title": siteTitle,
        "system_version": systemVersion,
        "student_reg": studentReg,
        "instructor_reg": instructorReg,
        "theme_color": themeColor?.toJson(),
        "currency_code": currencyCode,
        "currency_symbol": currencySymbol,
      };
}

class ThemeColor {
  ThemeColor({
    this.primaryColor,
    this.secondaryColor,
    this.footerBackgroundColor,
    this.footerHeadlineColor,
    this.footerTextColor,
    this.footerTextHoverColor,
  });

  String? primaryColor;
  String? secondaryColor;
  String? footerBackgroundColor;
  String? footerHeadlineColor;
  String? footerTextColor;
  String? footerTextHoverColor;

  factory ThemeColor.fromJson(Map<String, dynamic> json) => ThemeColor(
        primaryColor: json["primary_color"],
        secondaryColor: json["secondary_color"],
        footerBackgroundColor: json["footer_background_color"],
        footerHeadlineColor: json["footer_headline_color"],
        footerTextColor: json["footer_text_color"],
        footerTextHoverColor: json["footer_text_hover_color"],
      );

  Map<String, dynamic> toJson() => {
        "primary_color": primaryColor,
        "secondary_color": secondaryColor,
        "footer_background_color": footerBackgroundColor,
        "footer_headline_color": footerHeadlineColor,
        "footer_text_color": footerTextColor,
        "footer_text_hover_color": footerTextHoverColor,
      };
}
