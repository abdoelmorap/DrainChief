// To parse this JSON data, do
//
//     final languageData = languageDataFromJson(jsonString);

import 'dart:convert';

LanguageData languageDataFromJson(String str) =>
    LanguageData.fromJson(json.decode(str));

String languageDataToJson(LanguageData data) => json.encode(data.toJson());

class LanguageData {
  LanguageData({
    this.rtl,
    this.code,
    this.lang,
  });

  String? rtl;
  String? code;
  Map<String, String>? lang;

  factory LanguageData.fromJson(Map<String, dynamic> json) => LanguageData(
        rtl: json["rtl"].toString(),
        code: json["code"],
        lang: Map.from(json["lang"]).map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "rtl": rtl,
        "code": code,
        "lang": Map.from(lang ?? Map()).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}
