// Dart imports:
import 'dart:core';
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart' ;

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/cart_controller.dart';
import 'package:lms_flutter_app/Controller/payment_controller.dart';
import 'package:lms_flutter_app/Views/Cart/paypal/paypal_service.dart';
import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';

class PaypalPayment extends StatefulWidget {
  final Function? onFinish;

  PaypalPayment({this.onFinish});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  final PaymentController controller = Get.put(PaymentController());
  final CartController cartController = Get.put(CartController());
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? checkoutUrl;
  String? executeUrl;
  String? accessToken;
  PaypalServices services = PaypalServices();

  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "$paypalCurrency ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": paypalCurrency
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  String? orderID;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();

        final transactions = getOrderParams();
        final res =
            await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {

        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  Map<String, dynamic> getOrderParams() {

    orderID =
        'PAYPAL_${math.Random().nextInt(100)}${DateFormat("yyyyMMddHHmmss").format(DateTime.now())}';

    List itemDetails = [];
    cartController.cartList.forEach((element) {
      itemDetails.add({
        "name": element.course?.title,
        "quantity": 1,
        "price": element.price?.toStringAsFixed(2),
      });
    });

    var sub = 0.0;
    cartController.cartList.forEach((element) {
      sub += (element.price ?? 0) * 1;
    });

    String subTotalAmount = sub.toStringAsFixed(2);

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": subTotalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBarWidget(
          showSearch: false,
          goToSearch: false,
          showFilterBtn: false,
          showBack: true,
        ),
       body: WebViewWidget(
          controller: WebViewController()..loadRequest(Uri.https(checkoutUrl!))
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
         ..setNavigationDelegate( NavigationDelegate(
    onProgress: (int progress) {
    // Update loading bar.
    },
    onPageStarted: (String url) {},
    onPageFinished: (String url) {},
    onWebResourceError: (WebResourceError error) {},
    onNavigationRequest:(NavigationRequest request) {
           if (request.url.contains(returnURL)) {
             final uri = Uri.parse(request.url);
             final payerID = uri.queryParameters['PayerID'];
             if (payerID != null) {
               services
                   .executePayment(executeUrl, payerID, accessToken)
                   .then((id) {
                 widget.onFinish!(id);
                 Get.back();
               });
             } else {
               Get.back();
             }
           }
           if (request.url.contains(cancelURL)) {
             Get.back();
           }
           return NavigationDecision.navigate;
         },)

        ),
      ));
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}
