// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/payment_controller.dart';
import 'package:lms_flutter_app/utils/CustomSnackBar.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';

class InstaMojoPayment extends StatefulWidget {
  final Function? onFinish;
  final Map? paymentData;

  InstaMojoPayment({this.onFinish, this.paymentData});

  @override
  _InstaMojoPaymentState createState() => _InstaMojoPaymentState();
}

class _InstaMojoPaymentState extends State<InstaMojoPayment> {
  var kAndroidUserAgent =
      "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36";

  String? checkoutUrl;

  double progress = 0;
  String url = "";
  final GlobalKey webViewKey = GlobalKey();

  final PaymentController controller = Get.put(PaymentController());

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  Future createRequest() async {
    final amount = (double.parse(widget.paymentData?['amount'].toString() ?? '') * 100).toInt();

    String userFirstName = '${controller.firstName.value}';
    String userLastName = '${controller.lastName.value}';
    String userEmail = controller.email.value;

    Map<String, String> body = {
      "amount": amount.toString(), //amount to be paid
      "purpose": "Order",
      "buyer_name": userFirstName + "" + userLastName,
      "email": userEmail,
      "allow_repeated_payments": "true",
      "send_email": "false",
      "send_sms": "false",
      "redirect_url": "$rootUrl/instamojo-payment/status",
    };

    final url = Uri.parse('$instaMojoApiUrl/payment-requests/');
    var resp = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": instaMojoApiKey,
          "X-Auth-Token": instaMojoAuthToken
        },
        body: body);
    var jsonString = json.decode(resp.body);
    if (jsonString['success'] == true) {
      String selectedUrl =
          json.decode(resp.body)["payment_request"]['longurl'].toString() +
              "?embed=form";
      setState(() {
        checkoutUrl = selectedUrl;
      });
    } else {
      CustomSnackBar()
          .snackBarError(json.decode(resp.body)['message'].toString());
    }
  }

  @override
  void initState() {
    createRequest();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
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
                              Texth1("${stctrl.lang["Instamojo Payment"]}"),
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
                            if (checkoutUrl!.contains('$rootUrl/instamojo-payment/status')) {
                              Uri uri = Uri.parse(checkoutUrl ?? '');
                              String paymentRequestId =
                                  uri.queryParameters['payment_id'] ?? '';
                              await _checkPaymentStatus(paymentRequestId);
                            }
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
    final url = Uri.parse('$instaMojoApiUrl/payments/$paymentRequestId/');

    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "X-Api-Key": instaMojoApiKey,
      "X-Auth-Token": instaMojoAuthToken
    });
    var realResponse = json.decode(response.body);

    if (realResponse['success'] == true) {
      if (realResponse["payment"]['status'] == 'Credit') {
        widget.onFinish!(realResponse["payment"]['payment_id']);
        Get.back();
      } else {
        CustomSnackBar()
            .snackBarError('Payment cancelled/failed. Please try again.');
        Get.back();
      }
    } else {
      CustomSnackBar().snackBarError('PAYMENT STATUS FAILED');
      Get.back();
    }
  }
}
