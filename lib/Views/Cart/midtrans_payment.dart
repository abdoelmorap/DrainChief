// Dart imports:
import 'dart:convert';
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/cart_controller.dart';
import 'package:lms_flutter_app/Controller/payment_controller.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';

class MidTransPaymentPage extends StatefulWidget {
  final Map? paymentData;

  MidTransPaymentPage({this.paymentData});

  @override
  _MidTransPaymentPageState createState() => _MidTransPaymentPageState();
}

class _MidTransPaymentPageState extends State<MidTransPaymentPage> {
  final PaymentController controller = Get.put(PaymentController());
  final CartController cartController = Get.put(CartController());

  bool paymentProcessing = false;

  // final _formKey = GlobalKey<FormState>();
  String? orderID;
  String? checkoutUrl;

  double progress = 0;
  String url = "";
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        javaScriptCanOpenWindowsAutomatically: true,
      ),
      android: AndroidInAppWebViewOptions(
          useHybridComposition: true, useWideViewPort: true),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
        enableViewportScale: true,
      ));

  @override
  void initState() {
    _createPayment();
    super.initState();
  }

  Future _createPayment() async {
    String userFirstName = '${controller.firstName.value}';
    String userLastName = '${controller.lastName.value}';
    String userEmail = controller.email.value;
    String userPhone = controller.phone.value;
    String userAddress = controller.address1.value;
    String addressCity = controller.cityName.value;

    orderID =
        'MID_${math.Random().nextInt(100)}${DateFormat("yyyyMMddHHmmss").format(DateTime.now())}';

    List itemDetails = [];
    cartController.cartList.forEach((element) {
      itemDetails.add({
        "name": element.course?.title?['${stctrl.code.value}'].substring(0, 10) + "...",
        "quantity": 1,
        "price": (element.price ?? 0) * 100,
        "sku": element.tracking
      });
    });

    Map<String, dynamic> temp = {
      "transaction_details": {
        "order_id": orderID,
        "gross_amount":
            (double.parse(widget.paymentData?['amount'].toString() ?? '') * 100).toInt()
      },
      "credit_card": {"secure": true},
      "item_details": itemDetails,
      "customer_details": {
        "first_name": userFirstName,
        "last_name": userLastName,
        "email": userEmail,
        "phone": userPhone,
        "shipping_address": {
          "first_name": userFirstName,
          "last_name": " ",
          "email": userEmail,
          "phone": userPhone,
          "address": userAddress,
          "city": addressCity,
        }
      }
    };
    final url = Uri.parse('$midTransServerUrl/create_midtrans_trxToken');

    var body = jsonEncode(temp);
    await http.post(url, body: body, headers: {
      'Accept': '*/*',
      'Content-Type': 'application/json'
    }).then((value) {
      var jsonString = json.decode(value.body);
      setState(() {
        checkoutUrl = jsonString['redirect_url'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBar(
            backgroundColor: Get.theme.appBarTheme.backgroundColor,
            centerTitle: false,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              Container(),
            ],
            flexibleSpace: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        alignment: Alignment.centerLeft,
                        width: 80,
                        height: 30,
                        child: Image.asset(
                          'images/$appLogo',
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container()
                ],
              ),
            ),
          ),
        ),
        body: checkoutUrl != null
            ? Column(
                children: [
                  progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : Container(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_outlined,
                            size: 18,
                          ),
                          onPressed: () => Navigator.pop(context)),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Texth1("${stctrl.lang["Midtrans Payment"]}"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        InAppWebView(
                          key: webViewKey,
                          initialUrlRequest:
                              URLRequest(url: Uri.parse(checkoutUrl ?? '')),
                          initialOptions: options,
                          onWebViewCreated: (controller) {
                            webViewController = controller;
                          },
                          onLoadStart: (controller, url) async {
                            setState(() {
                              this.url = url.toString();
                              checkoutUrl = this.url;
                            });
                            await _checkPaymentStatus(orderID ?? '');
                          },
                          androidOnPermissionRequest:
                              (controller, origin, resources) async {
                            return PermissionRequestResponse(
                                resources: resources,
                                action: PermissionRequestResponseAction.GRANT);
                          },
                          shouldOverrideUrlLoading:
                              (controller, navigationAction) async {
                            var uri = navigationAction.request.url;

                            if (![
                              "http",
                              "https",
                              "file",
                              "chrome",
                              "data",
                              "javascript",
                              "about"
                            ].contains(uri?.scheme)) {
                              // ignore: deprecated_member_use
                              if (await canLaunch(url)) {
                                // Launch the App
                                // ignore: deprecated_member_use
                                await launch(
                                  url,
                                );
                                // and cancel the request
                                return NavigationActionPolicy.CANCEL;
                              }
                            }

                            return NavigationActionPolicy.ALLOW;
                          },
                          onLoadStop: (controller, url) async {
                            setState(() {
                              this.url = url.toString();
                              checkoutUrl = this.url;
                            });
                          },
                          onLoadError: (controller, url, code, message) {},
                          onProgressChanged: (controller, progress) {
                            if (progress == 100) {
                              // pullToRefreshController.endRefreshing();
                            }
                            setState(() {
                              this.progress = progress / 100;
                              checkoutUrl = this.url;
                            });
                          },
                          onUpdateVisitedHistory:
                              (controller, url, androidIsReload) {
                            setState(() {
                              this.url = url.toString();
                              checkoutUrl = this.url;
                            });
                          },
                          onConsoleMessage: (controller, consoleMessage) {

                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Center(child: Container(child: CupertinoActivityIndicator())),
      ),
    );
  }

  Future _checkPaymentStatus(String paymentRequestId) async {
    final url = Uri.parse(
        '$midTransServerUrl/check_midtrans_transaction?trxID=$paymentRequestId');

    var response = await http.post(url);
    var realResponse = json.decode(response.body);
    if (realResponse['success'] == true) {
      if (realResponse["response"]['transaction_status'] == 'capture' ||
          realResponse["response"]['transaction_status'] == 'settlement') {

        if (realResponse["response"]['fraud_status'] != null) {
          if (realResponse["response"]['fraud_status'] == 'accept') {
            controller.makePayment('Midtrans', realResponse);
          } else {
            Get.snackbar(
              'Error',
              'Payment cancelled. Please try again',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              borderRadius: 5,
              duration: Duration(seconds: 3),
            );
            Get.back();
          }
        } else {
          Get.back();
        }
      } else {
        Get.snackbar(
          'Error',
          'Payment cancelled/failed. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 5,
          duration: Duration(seconds: 3),
        );

        Get.back();
      }
    } else {
      Get.snackbar(
        'Error',
        'PAYMENT FAILED',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 5,
        duration: Duration(seconds: 3),
      );
      Get.back();
    }
  }
}
