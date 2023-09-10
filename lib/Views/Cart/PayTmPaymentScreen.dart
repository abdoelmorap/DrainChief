// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/payment_controller.dart';

class PayTmPaymentScreen extends StatefulWidget {
  final String? amount;
  final Map<String, dynamic>? orderData;

  PayTmPaymentScreen({this.amount, this.orderData});

  @override
  _PayTmPaymentScreenState createState() => _PayTmPaymentScreenState();
}

class _PayTmPaymentScreenState extends State<PayTmPaymentScreen> {
  final PaymentController controller = Get.put(PaymentController());

  WebViewController? _webController;
  bool _loadingPayment = true;
  String _responseStatus = STATUS_LOADING;

  String _loadHTML() {
    return "<html> <body onload='document.f.submit();'> <form id='f' name='f' method='post' action='$PAYMENT_URL'><input type='hidden' name='orderID' value='ORDER_${DateTime.now().millisecondsSinceEpoch}'/>" +
        "<input  type='hidden' name='custID' value='${widget.orderData?["custID"]}' />" +
        "<input  type='hidden' name='amount' value='${widget.amount}' />" +
        "<input type='hidden' name='custEmail' value='${widget.orderData?["custEmail"]}' />" +
        "<input type='hidden' name='custPhone' value='${widget.orderData?["custPhone"]}' />" +
        "</form> </body> </html>";
  }

  void getData() {
    _webController
        ?.runJavaScriptReturningResult("document.body.innerText")
        .then((data) {
      var decodedJSON = jsonDecode(data.toString());
      Map<String, dynamic> responseJSON =
          Platform.isIOS ? decodedJSON : jsonDecode(decodedJSON);
      final checksumResult = responseJSON["status"];
      final paytmResponse = responseJSON["data"];
      if (paytmResponse["STATUS"] == "TXN_SUCCESS") {
        if (checksumResult == 0) {
          _responseStatus = STATUS_SUCCESSFUL;
          controller.makePayment('PayTM', responseJSON);
        } else {
          _responseStatus = STATUS_CHECKSUM_FAILED;
        }
      } else if (paytmResponse["STATUS"] == "TXN_FAILURE") {
        _responseStatus = STATUS_FAILED;
      }
      this.setState(() {});
    });
  }

  Widget getResponseScreen() {
    switch (_responseStatus) {
      case STATUS_SUCCESSFUL:
        return PaymentSuccessfulScreen();
      case STATUS_CHECKSUM_FAILED:
        return CheckSumFailedScreen();
      case STATUS_FAILED:
        return PaymentFailedScreen();
    }
    return PaymentSuccessfulScreen();
  }

  @override
  void dispose() {
    _webController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child:   WebViewWidget(
              controller: WebViewController()..loadRequest(
               Uri.dataFromString(_loadHTML(), mimeType: 'text/html'))
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setNavigationDelegate( NavigationDelegate(
                  onProgress: (int progress) {
                    // Update loading bar.
                  },
                  onPageStarted: (String url) {},
                  onWebResourceError: (WebResourceError error) {},


              onPageFinished: (page) {
                if (page.contains("/process")) {
                  if (_loadingPayment) {
                    this.setState(() {
                      _loadingPayment = false;
                    });
                  }
                }
                if (page.contains("/paymentReceipt")) {
                  getData();
                }
              },
  )) ),
          ),
          (_loadingPayment)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Center(),
          (_responseStatus != STATUS_LOADING)
              ? Center(child: getResponseScreen())
              : Center()
        ],
      )),
    );
  }
}

class PaymentSuccessfulScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Great!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "${stctrl.lang["Thank you for making the payment"]}",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "${stctrl.lang["Close"]}",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Get.until(ModalRoute.withName("/"));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentFailedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${stctrl.lang["Error"]}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "${stctrl.lang["Payment was not successful, Please try again Later"]}",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "${stctrl.lang["Close"]}",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Get.until(ModalRoute.withName("/"));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class CheckSumFailedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${stctrl.lang["Error"]}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "${stctrl.lang["Problem Verifying Payment, If you balance is deducted please contact our customer support and get your payment verified"]}",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.black,
                  child: Text(
                    "${stctrl.lang["Close"]}",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Get.until(ModalRoute.withName("/"));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
