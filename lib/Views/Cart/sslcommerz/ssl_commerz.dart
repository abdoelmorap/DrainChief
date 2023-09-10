import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import '../../../Config/app_config.dart';
import '../../../utils/widgets/AppBarWidget.dart';

class SslCommerz extends StatefulWidget {
  final String? trackingId;

  SslCommerz({
    Key? key,
    @required this.trackingId,
  }) : super(key: key);

  @override
  State<SslCommerz> createState() => _SslCommerzState();
}

class _SslCommerzState extends State<SslCommerz> {
  bool loading = true;
  String initialUrl = '';

  @override
  void initState() {
    getAllInitialValue();
    super.initState();
  }

  void getAllInitialValue() async {
    initialUrl = await getSSLPaymentResponse();
    if (initialUrl.isEmpty) {
      Get.back();
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
    return Scaffold(
      appBar: AppBarWidget(
        showSearch: false,
        goToSearch: false,
        showFilterBtn: false,
        showBack: true,
      ),
      body:

      WebViewWidget(
        controller: WebViewController()..loadRequest(Uri.https(initialUrl!))
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate( NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest:(NavigationRequest request) {
              print('url iss: ${request.url}');
              print('url iss: ${request.url.contains('ssl/app?type=success')}');
              if (request.url.contains('sslcommerz/app/success')) {
                Get.back(result: 'success');
              }
              if (request.url.contains('sslcommerz/app/failed')) {
                Get.back(result: 'failed');
              }
              if (request.url.contains('sslcommerz/app/cancel')) {
                Get.back(result: 'cancel');
              }
              // if (request.url.contains(cancelURL)) {
              //   Get.back();
              // }
              return NavigationDecision.navigate;
            }

          ),
      )));
  }

  Future<String> getSSLPaymentResponse() async {
    try {
      Uri sslPayment = Uri.parse('$baseUrl/make-order-ssl');
      GetStorage userToken = GetStorage();
      String token = await userToken.read('token');
      var response = await http.post(
        sslPayment,
        headers: header(token: token),
        body: json.encode({
          'tracking_id': widget.trackingId,
        }),
      );
      if (response.statusCode == 200) {
        var res = convert.jsonDecode(response.body);
        print('resonse');
        print(res);
        if (res['success'] == true) {
          return res['data'];
        } else {
          return '';
        }
      } else {
        return '';
      }
    } catch (e, t) {
      print(e.toString());
      print(t.toString());
      return '';
    }
  }
}
