// To parse this JSON data, do
//
//     final paymentListModel = paymentListModelFromJson(jsonString);

// Dart imports:
import 'dart:convert';

List<PaymentListModel> paymentListModelFromJson(String str) =>
    List<PaymentListModel>.from(
            json.decode(str).map((x) => PaymentListModel.fromJson(x)))
        .where((element) =>
            element.method == "Wallet" ||
            element.method == "RazorPay" ||
            element.method == "Midtrans" ||
            element.method == "PayPal" ||
            element.method == "PayTM" ||
            element.method == "Stripe" ||
            element.method == 'PayStack' ||
            element.method == 'FlutterWave' ||
            element.method == 'Instamojo' ||
            element.method == 'Sslcommerz')
        .toList();

String paymentListModelToJson(List<PaymentListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PaymentListModel {
  PaymentListModel({
    this.method,
    this.logo,
  });

  String? method;
  String? logo;

  factory PaymentListModel.fromJson(Map<String, dynamic> json) =>
      PaymentListModel(
        method: json["method"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "method": method,
        "logo": logo,
      };
}
