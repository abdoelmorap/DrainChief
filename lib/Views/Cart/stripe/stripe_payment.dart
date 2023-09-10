import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/utils/CustomSnackBar.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/styles.dart';
import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';
// import 'package:stripe_sdk/stripe_sdk.dart';
// import 'package:stripe_sdk/stripe_sdk_ui.dart';
import 'package:http/http.dart' as http;

class StripePaymentScreen extends StatefulWidget {
  final Function? onFinish;
  final Map? paymentData;

  StripePaymentScreen({this.onFinish, this.paymentData});

  @override
  _StripePaymentScreenState createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends State<StripePaymentScreen> {
  final String postCreateIntentURL = "$stripeServerURL/payment-intent";

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // final StripeCard card = StripeCard();

  // final Stripe stripe = Stripe(
  //   "$stripePublishableKey", //Your Publishable Key
  // );

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool paymentLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBarWidget(
          showSearch: false,
          goToSearch: false,
          showFilterBtn: false,
          showBack: true,
        ),
        body: Opacity(
          opacity: paymentLoading ? 0.3 : 1.0,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Texth1(
                        "${stctrl.lang["Stripe Payment"]}",
                      ),
                    ],
                  ),
                ),
                // CardForm(
                //   formKey: formKey,
                //   card: card,
                //   displayAnimatedCard: true,
                // ),
                paymentLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppStyles.appThemeColor,
                        ),
                      )
                    : Container(
                        child: ElevatedButton(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              alignment: Alignment.center,
                              height: 40,
                              child: Text(
                                "${stctrl.lang["Continue"]}",
                                textAlign: TextAlign.center,
                                style: Get.textTheme.titleSmall
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              formKey.currentState?.validate();
                              formKey.currentState?.save();
                              buy(context);
                            }),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void buy(context) async {
    // final StripeCard stripeCard = card;
    // final String customerEmail = widget.paymentData?['email'];
    //
    // if (!stripeCard.validateCVC()) {
    //   showAlertDialog(context, "${stctrl.lang["Error"]}",
    //       "${stctrl.lang["CVC not valid"]}");
    //   return;
    // }
    // if (!stripeCard.validateDate()) {
    //   showAlertDialog(context, "${stctrl.lang["Error"]}",
    //       "${stctrl.lang["Date not valid"]}");
    //   return;
    // }
    // if (!stripeCard.validateNumber()) {
    //   showAlertDialog(context, "${stctrl.lang["Error"]}",
    //       "${stctrl.lang["Number not valid"]}");
    //   return;
    // }
    //
    // setState(() {
    //   paymentLoading = true;
    // });
    //
    // Map<String, dynamic> paymentIntentRes =
    //     await createPaymentIntent(stripeCard, customerEmail);
    // String clientSecret = paymentIntentRes['client_secret'];
    // String paymentMethodId = paymentIntentRes['payment_method'];
    // String status = paymentIntentRes['status'];
    // if (status == 'requires_action' || status == 'requires_confirmation') {
    //   paymentIntentRes =
    //       await confirmPayment3DSecure(clientSecret, paymentMethodId);
    //   if (paymentIntentRes['status'] == 'succeeded') {
    //     CustomSnackBar().snackBarSuccessBottom(
    //       "${stctrl.lang["Success! Thanks for buying."]}",
    //     );
    //     Future.delayed(Duration(seconds: 4), () {
    //       setState(() {
    //         paymentLoading = false;
    //       });
    //       widget.onFinish!(paymentIntentRes['id']);
    //       Get.back();
    //     });
    //   }
    // } else if (status != 'succeeded') {
    //   CustomSnackBar()
    //       .snackBarWarning("${stctrl.lang["Warning! Canceled Transaction."]}");
    //   Future.delayed(Duration(seconds: 4), () {
    //     setState(() {
    //       paymentLoading = false;
    //     });
    //   });
    // } else if (status == 'succeeded') {
    //   CustomSnackBar().snackBarSuccessBottom(
    //       "${stctrl.lang["Success! Thanks for buying."]}");
    //   Future.delayed(Duration(seconds: 4), () {
    //     setState(() {
    //       paymentLoading = false;
    //     });
    //     widget.onFinish!(paymentIntentRes['id']);
    //     Get.back();
    //   });
    // } else {
    //   CustomSnackBar().snackBarWarning(
    //     "${stctrl.lang["Warning! Transaction rejected.Something went wrong"]}",
    //   );
    //   Future.delayed(Duration(seconds: 4), () {
    //     setState(() {
    //       paymentLoading = false;
    //     });
    //   });
    // }
  }

  // Future<Map<String, dynamic>> createPaymentIntent(
    //   StripeCard stripeCard, String customerEmail) async {
    // String? clientSecret;
    // Map<String, dynamic> paymentIntentRes = Map(), paymentMethod;
    // try {
    //   paymentMethod = await stripe.api.createPaymentMethodFromCard(stripeCard);
    //   clientSecret =
    //       await postCreatePaymentIntent(customerEmail, paymentMethod['id']);
    //   paymentIntentRes = await stripe.api.retrievePaymentIntent(clientSecret ?? '');
    // } catch (e) {
    //
    //   showAlertDialog(context, "${stctrl.lang["Error"]}",
    //       "${stctrl.lang["Something went wrong"]}");
    // }
    // return paymentIntentRes;

  // }

  Future<String?> postCreatePaymentIntent(
      String email, String paymentMethodId) async {
    final amount =
        (double.parse(widget.paymentData?['amount'].toString() ?? '') * 100).toInt();
    final url = Uri.parse(postCreateIntentURL +
        "?amount=$amount&payment_method_id=$paymentMethodId&email=$email");
    http.Response response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    final stripeIntentResponse = stripeIntentResponseFromJson(response.body);
    return stripeIntentResponse.paymentIntent?.clientSecret;
  }

  // Future<Map<String, dynamic>> confirmPayment3DSecure(
  //     String clientSecret, String paymentMethodId) async {
  //   Map<String, dynamic> paymentIntentRes_3dSecure = Map();
  //   try {
  //     await stripe.confirmPayment(clientSecret, context,
  //         paymentMethodId: paymentMethodId);
  //     paymentIntentRes_3dSecure =
  //         await stripe.api.retrievePaymentIntent(clientSecret);
  //   } catch (e) {
  //     showAlertDialog(context, "${stctrl.lang["Error"]}",
  //         "${stctrl.lang["Something went wrong"]}");
  //   }
  //   return paymentIntentRes_3dSecure;
  // }

  showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(), // dismiss dialog
            ),
          ],
        );
      },
    );
  }
}

// To parse this JSON data, do
//
//     final stripeIntentResponse = stripeIntentResponseFromJson(jsonString);

StripeIntentResponse stripeIntentResponseFromJson(String str) =>
    StripeIntentResponse.fromJson(json.decode(str));

String stripeIntentResponseToJson(StripeIntentResponse data) =>
    json.encode(data.toJson());

class StripeIntentResponse {
  StripeIntentResponse({
    this.paymentIntent,
  });

  PaymentIntent? paymentIntent;

  factory StripeIntentResponse.fromJson(Map<String, dynamic> json) =>
      StripeIntentResponse(
        paymentIntent: PaymentIntent.fromJson(json["paymentIntent"]),
      );

  Map<String, dynamic> toJson() => {
        "paymentIntent": paymentIntent?.toJson(),
      };
}

class PaymentIntent {
  PaymentIntent({
    this.id,
    this.object,
    this.amount,
    this.amountCapturable,
    this.amountReceived,
    this.application,
    this.applicationFeeAmount,
    this.canceledAt,
    this.cancellationReason,
    this.captureMethod,
    this.charges,
    this.clientSecret,
    this.confirmationMethod,
    this.created,
    this.currency,
    this.customer,
    this.description,
    this.invoice,
    this.lastPaymentError,
    this.livemode,
    this.metadata,
    this.nextAction,
    this.onBehalfOf,
    this.paymentMethod,
    this.paymentMethodOptions,
    this.paymentMethodTypes,
    this.receiptEmail,
    this.review,
    this.setupFutureUsage,
    this.shipping,
    this.source,
    this.statementDescriptor,
    this.statementDescriptorSuffix,
    this.status,
    this.transferData,
    this.transferGroup,
  });

  String? id;
  String? object;
  int? amount;
  int? amountCapturable;
  int? amountReceived;
  dynamic application;
  dynamic applicationFeeAmount;
  dynamic canceledAt;
  dynamic cancellationReason;
  String? captureMethod;
  Charges? charges;
  String? clientSecret;
  String? confirmationMethod;
  int? created;
  String? currency;
  dynamic customer;
  dynamic description;
  dynamic invoice;
  dynamic lastPaymentError;
  bool? livemode;
  Metadata? metadata;
  dynamic nextAction;
  dynamic onBehalfOf;
  String? paymentMethod;
  PaymentMethodOptions? paymentMethodOptions;
  List<String>? paymentMethodTypes;
  String? receiptEmail;
  dynamic review;
  dynamic setupFutureUsage;
  dynamic shipping;
  dynamic source;
  dynamic statementDescriptor;
  dynamic statementDescriptorSuffix;
  String? status;
  dynamic transferData;
  dynamic transferGroup;

  factory PaymentIntent.fromJson(Map<String, dynamic> json) => PaymentIntent(
        id: json["id"],
        object: json["object"],
        amount: json["amount"],
        amountCapturable: json["amount_capturable"],
        amountReceived: json["amount_received"],
        application: json["application"],
        applicationFeeAmount: json["application_fee_amount"],
        canceledAt: json["canceled_at"],
        cancellationReason: json["cancellation_reason"],
        captureMethod: json["capture_method"],
        charges: Charges.fromJson(json["charges"]),
        clientSecret: json["client_secret"],
        confirmationMethod: json["confirmation_method"],
        created: json["created"],
        currency: json["currency"],
        customer: json["customer"],
        description: json["description"],
        invoice: json["invoice"],
        lastPaymentError: json["last_payment_error"],
        livemode: json["livemode"],
        metadata: Metadata.fromJson(json["metadata"]),
        nextAction: json["next_action"],
        onBehalfOf: json["on_behalf_of"],
        paymentMethod: json["payment_method"],
        paymentMethodOptions:
            PaymentMethodOptions.fromJson(json["payment_method_options"]),
        paymentMethodTypes:
            List<String>.from(json["payment_method_types"].map((x) => x)),
        receiptEmail: json["receipt_email"],
        review: json["review"],
        setupFutureUsage: json["setup_future_usage"],
        shipping: json["shipping"],
        source: json["source"],
        statementDescriptor: json["statement_descriptor"],
        statementDescriptorSuffix: json["statement_descriptor_suffix"],
        status: json["status"],
        transferData: json["transfer_data"],
        transferGroup: json["transfer_group"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "amount": amount,
        "amount_capturable": amountCapturable,
        "amount_received": amountReceived,
        "application": application,
        "application_fee_amount": applicationFeeAmount,
        "canceled_at": canceledAt,
        "cancellation_reason": cancellationReason,
        "capture_method": captureMethod,
        "charges": charges?.toJson(),
        "client_secret": clientSecret,
        "confirmation_method": confirmationMethod,
        "created": created,
        "currency": currency,
        "customer": customer,
        "description": description,
        "invoice": invoice,
        "last_payment_error": lastPaymentError,
        "livemode": livemode,
        "metadata": metadata?.toJson(),
        "next_action": nextAction,
        "on_behalf_of": onBehalfOf,
        "payment_method": paymentMethod,
        "payment_method_options": paymentMethodOptions?.toJson(),
        "payment_method_types":
            List<dynamic>.from(paymentMethodTypes?.map((x) => x) ?? []),
        "receipt_email": receiptEmail,
        "review": review,
        "setup_future_usage": setupFutureUsage,
        "shipping": shipping,
        "source": source,
        "statement_descriptor": statementDescriptor,
        "statement_descriptor_suffix": statementDescriptorSuffix,
        "status": status,
        "transfer_data": transferData,
        "transfer_group": transferGroup,
      };
}

class Charges {
  Charges({
    this.object,
    this.data,
    this.hasMore,
    this.totalCount,
    this.url,
  });

  String? object;
  List<dynamic>? data;
  bool? hasMore;
  int? totalCount;
  String? url;

  factory Charges.fromJson(Map<String, dynamic> json) => Charges(
        object: json["object"],
        data: List<dynamic>.from(json["data"].map((x) => x)),
        hasMore: json["has_more"],
        totalCount: json["total_count"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "object": object,
        "data": List<dynamic>.from(data?.map((x) => x) ?? []),
        "has_more": hasMore,
        "total_count": totalCount,
        "url": url,
      };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata();

  Map<String, dynamic> toJson() => {};
}

class PaymentMethodOptions {
  PaymentMethodOptions({
    this.card,
  });

  Card? card;

  factory PaymentMethodOptions.fromJson(Map<String, dynamic> json) =>
      PaymentMethodOptions(
        card: Card.fromJson(json["card"]),
      );

  Map<String, dynamic> toJson() => {
        "card": card?.toJson(),
      };
}

class Card {
  Card({
    this.installments,
    this.network,
    this.requestThreeDSecure,
  });

  dynamic installments;
  dynamic network;
  String? requestThreeDSecure;

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        installments: json["installments"],
        network: json["network"],
        requestThreeDSecure: json["request_three_d_secure"],
      );

  Map<String, dynamic> toJson() => {
        "installments": installments,
        "network": network,
        "request_three_d_secure": requestThreeDSecure,
      };
}
