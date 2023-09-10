class Language {
  String? code;
  String? name;
  String? native;
  int? rtl;
  int? id;

  Language({this.code, this.name, this.native, this.rtl, this.id});

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: int.parse(json['id'].toString()),
      code: json['code'],
      name: json['name'],
      native: json['native'],
      rtl: int.parse(json['rtl'].toString()),
    );
  }
}

class LanguageList {
  List<Language>? languages = [];

  LanguageList({this.languages});

  factory LanguageList.fromJson(List<dynamic> json) {
    List<Language> languageList;

    languageList = json.map((i) => Language.fromJson(i)).toList();

    return LanguageList(languages: languageList);
  }
}
