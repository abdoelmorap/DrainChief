// To parse this JSON data, do
//
//     final myAddress = myAddressFromJson(jsonString);

// Dart imports:
import 'dart:convert';

List<MyAddress> myAddressFromJson(String str) => List<MyAddress>.from(json.decode(str).map((x) => MyAddress.fromJson(x)));

// String myAddressToJson(MyAddress data) => json.encode(data.toJson());

String myAddressToJson(List<MyAddress> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class MyAddress {
  MyAddress({
    this.id,
    this.trackingId,
    this.userId,
    this.firstName,
    this.lastName,
    this.companyName,
    this.country,
    this.address1,
    this.address2,
    this.city,
    this.zipCode,
    this.phone,
    this.email,
    this.details,
    this.paymentMethod,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  String? trackingId;
  dynamic userId;
  String? firstName;
  String? lastName;
  String? companyName;
  Country? country;
  String? address1;
  String? address2;
  String? city;
  String? zipCode;
  String? phone;
  String? email;
  String? details;
  dynamic paymentMethod;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory MyAddress.fromJson(Map<String, dynamic> json) => MyAddress(
    id: json["id"],
    trackingId: json["tracking_id"],
    userId: json["user_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    companyName: json["company_name"],
    country: Country.fromJson(json["country"]),
    address1: json["address1"],
    address2: json["address2"],
    city: json["city"].toString(),
    zipCode: json["zip_code"],
    phone: json["phone"],
    email: json["email"],
    details: json["details"],
    paymentMethod: json["payment_method"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tracking_id": trackingId,
    "user_id": userId,
    "first_name": firstName,
    "last_name": lastName,
    "company_name": companyName,
    "country": country?.toJson(),
    "address1": address1,
    "address2": address2,
    "city": city,
    "zip_code": zipCode,
    "phone": phone,
    "email": email,
    "details": details,
    "payment_method": paymentMethod,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class Country {
  Country({
    this.id,
    this.name,
    this.iso3,
    this.iso2,
    this.phonecode,
    this.currency,
    this.capital,
    this.activeStatus,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  String? name;
  String? iso3;
  String? iso2;
  String? phonecode;
  String? currency;
  String? capital;
  dynamic activeStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    name: json["name"],
    iso3: json["iso3"],
    iso2: json["iso2"],
    phonecode: json["phonecode"],
    currency: json["currency"],
    capital: json["capital"],
    activeStatus: json["active_status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "iso3": iso3,
    "iso2": iso2,
    "phonecode": phonecode,
    "currency": currency,
    "capital": capital,
    "active_status": activeStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
