// Dart imports:
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Controller/payment_controller.dart';
import 'package:lms_flutter_app/Model/Cart/PaymentListModel.dart';
import 'package:lms_flutter_app/Views/Cart/PayTmPaymentScreen.dart';
import 'package:lms_flutter_app/Views/Cart/midtrans_payment.dart';
import 'package:lms_flutter_app/Views/Cart/paypal/paypal_payment.dart';
import 'package:lms_flutter_app/Views/Cart/sslcommerz/ssl_commerz.dart';
import 'package:lms_flutter_app/Views/Cart/stripe/stripe_payment.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';
import 'package:octo_image/octo_image.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'instamojo_payment.dart';

class PaymentScreen extends StatefulWidget {
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentController controller = Get.put(PaymentController());
  final DashboardController dashboardController =
      Get.put(DashboardController());

  int radioSelector = 0;

  bool isFilterDrawer = false;
  double? width;
  double? percentageWidth;
  double? height;
  double? percentageHeight;
  int selectedIndex = 3;
  String coupon = "";
  bool isCouponAvailable = false;

  String selectedMethod = "";

  double? finalAmount;

  var orderId = "";

  // static const platform = const MethodChannel("razorpay_flutter");

  Razorpay? _razorpay;

  String? paymentResponse;

  String? paymentTracking;

  GetStorage userToken = GetStorage();

  final plugin = PaystackPlugin();

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    plugin.initialize(publicKey: payStackPublicKey);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay?.clear();
  }

  Future createOrder() async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$razorPayKey:$razorPaySecret'));
    var amount = finalAmount?.toInt();

    Map<String, dynamic> bodyData = {
      "amount": (amount ?? 0) * 100,
      "currency": "INR",
      "receipt": controller.tracking.toString(),
    };

    Uri orderCreate = Uri.parse('https://api.razorpay.com/v1/orders');
    var body = json.encode(bodyData);

    await http
        .post(
      orderCreate,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'authorization': basicAuth,
      },
      body: body,
    )
        .then((response) {
      var jsonString = jsonDecode(response.body);
      setState(() {
        orderId = jsonString['id'];
      });
    }).catchError((err) {
      print('error : ' + err.toString());
    } );
  }

  Future openCheckout() async {
    await getAmount().then((value) async {
      await createOrder().then((value) {
        var amount = finalAmount?.toInt();
        var options = {
          'key': razorPayKey,
          'amount': (amount ?? 0) * 100,
          'name': companyName,
          'description': orderId.toString(),
          'order_id': orderId.toString(),
        };
        try {
          _razorpay?.open(options);
        } catch (e) {
          debugPrint('Error: e');
        }
      });
    });
  }

  Future getAmount() async {
    if (enableCurrencyConvert) {
      var postUri = Uri.parse(
          "https://free.currconv.com/api/v7/convert?q=USD_INR&compact=ultra&apiKey=$currencyConvApiKey");
      var request = new http.MultipartRequest("GET", postUri);
      await request.send().then((result) async {
        await http.Response.fromStream(result).then((response) {
          var jsonString = jsonDecode(response.body);
          if (response.statusCode == 200) {
            setState(() {
              var amountConverted = jsonString['USD_INR'];
              finalAmount = amountConverted *
                  double.parse(controller.paymentAmount.value.toString());
            });
          }
          return response.body;
        });
      }).catchError((err) {
        print('error : ' + err.toString());
      } );
    } else {
      finalAmount = double.parse(controller.paymentAmount.value.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log("SUCCESS PAYMENT ID: ${response.paymentId} ORDER ID: ${response.orderId} SIGNATURE: ${response.signature} ");
    Get.snackbar(
      "${stctrl.lang["Order Completed"]}",
      "Payment ID: ${response.paymentId}",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor,
      colorText: Colors.white,
      borderRadius: 5,
      duration: Duration(seconds: 10),
    );

    Map<String, dynamic> resp = {
      'amount': controller.paymentAmount,
      'tracking': controller.tracking,
      'razorpay_payment_id': response.paymentId,
      'razorpay_order_id': response.orderId,
      'razorpay_signature': response.signature,
    };

    controller.makePayment("RazorPay", resp);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log("ERROR CODE: ${response.code} ERROR MESSAGE: ${response.message.toString()}");
    var jsonString = jsonDecode(response.message ?? '');

    Get.snackbar(
      "${stctrl.lang["Error"]}",
      (jsonString['error']['description']).toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xfff95555),
      colorText: Colors.white,
      borderRadius: 5,
      duration: Duration(seconds: 5),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log("External Wallet: walletName: ${response.walletName}");
    Get.snackbar(
      "${stctrl.lang["Error"]}",
      response.walletName.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.primaryColor,
      colorText: Colors.white,
      borderRadius: 5,
      duration: Duration(seconds: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    percentageWidth = (width ?? 0) / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = (height ?? 0) / 100;
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(
          showSearch: false,
          goToSearch: false,
          showFilterBtn: false,
          showBack: true,
        ),
        body: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            Texth1("${stctrl.lang["Select Payment Method"]}"),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Get.theme.canvasColor,
              ),
              child: Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${stctrl.lang["Amount to checkout"]}",
                      style: Get.textTheme.titleSmall,
                    ),
                    Text(
                      appCurrency + ' ' + controller.paymentAmount.toString(),
                      style: Get.textTheme.titleSmall?.copyWith(
                        color: Get.theme.primaryColor,
                      ),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(
              height: 20,
            ),
            Container(child: Obx(() {
              if (controller.isPaymentLoading.value) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: controller.paymentList.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                    itemBuilder: (BuildContext context, int position) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Get.theme.canvasColor,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            width: 0.2,
                            color: controller.paymentList[position] ==
                                    controller.paymentList[radioSelector]
                                ? Get.textTheme.titleMedium?.color ?? Color(0xFFFFFFFF)
                                : Get.theme.canvasColor,
                          ),
                        ),
                        child: RadioListTile<PaymentListModel>(
                          value: controller.paymentList[position],
                          activeColor: Get.theme.primaryColor,
                          groupValue: controller.paymentList[radioSelector],
                          onChanged: (value) {
                            radioSelector = position;

                            setState(() {
                              radioSelector = position;
                              controller.paymentList[radioSelector] = value;
                              controller.selectedGateway.value = value?.method ?? '';

                              selectedMethod = controller.selectedGateway.value;
                            });
                          },
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(controller.paymentList[position].method),
                              Container(
                                height: 35,
                                width: 70,
                                child: OctoImage(
                                  image: NetworkImage(
                                      "$rootUrl/${controller.paymentList[position].logo}"),
                                  placeholderBuilder: OctoPlaceholder.blurHash(
                                    'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                  ),
                                  fit: BoxFit.fitWidth,
                                  errorBuilder: (BuildContext context,
                                      Object exception, StackTrace? stackTrace) {
                                    return Image.asset('images/fcimg.png');
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              }
            })),
          ],
        ),
        bottomNavigationBar: Container(
          height: 40,
          child: ElevatedButton(
            onPressed: () async {
              if (controller.selectedGateway.value == "Wallet") {
                Get.snackbar(
                  "${stctrl.lang["Processing Wallet Payment"]}",
                  "${stctrl.lang["Please wait"]}" + '...',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Get.theme.primaryColor,
                  colorText: Colors.white,
                  borderRadius: 5,
                  duration: Duration(seconds: 5),
                );
                Map<String, dynamic> resp = {
                  'amount': controller.paymentAmount,
                  'tracking': controller.tracking,
                };

                controller.makePayment("Wallet", resp);
              } else if (controller.selectedGateway.value == "RazorPay") {
                Get.snackbar(
                  "${stctrl.lang["Processing RazorPay Payment"]}",
                  "${stctrl.lang["Please wait"]}" + '...',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Get.theme.primaryColor,
                  colorText: Colors.white,
                  borderRadius: 5,
                  duration: Duration(seconds: 5),
                );
                openCheckout();
              } else if (controller.selectedGateway.value == "Midtrans") {
                Map<String, dynamic> resp = {
                  'amount': controller.paymentAmount,
                  'tracking': controller.tracking,
                };
                Get.to(() => MidTransPaymentPage(
                      paymentData: resp,
                    ));
              }
              else if (controller.selectedGateway.value == "PayPal") {
                Get.snackbar(
                  "${stctrl.lang["Processing Paypal Payment"]}",
                  "${stctrl.lang["Please wait"]}" + '...',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Get.theme.primaryColor,
                  colorText: Colors.white,
                  borderRadius: 5,
                  duration: Duration(seconds: 5),
                );

                Map<String, dynamic> resp = {
                  'amount': controller.paymentAmount,
                  'tracking': controller.tracking,
                };
                Get.to(
                  () => PaypalPayment(
                    onFinish: (number) async {
                      // payment done
                      resp.addAll({
                        'transection_id': number,
                      });

                      await controller.makePayment('Paypal', resp);
                    },
                  ),
                );
              }

              else if (controller.selectedGateway.value == "Sslcommerz") {
                Get.snackbar(
                  "Processing SSL Payment",
                  // "${stctrl.lang["Processing Paypal Payment"]}",
                  "${stctrl.lang["Please wait"]}" + '...',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Get.theme.primaryColor,
                  colorText: Colors.white,
                  borderRadius: 5,
                  duration: Duration(seconds: 5),
                );

                // Map<String, dynamic> resp = {
                //   'amount': controller.paymentAmount,
                //   'tracking': controller.tracking,
                // };

                print('tracking id iss:: ${controller.tracking.value}');
                // return;
                var result = await Get.to(SslCommerz(
                  trackingId: controller.tracking.value,
                ));
                if(result!=null){
                  controller.getCadList(result);
                } else {

                }
              }

              else if (controller.selectedGateway.value == "PayTM") {
                Get.snackbar(
                  "${stctrl.lang["Processing PayTM Payment"]}",
                  "${stctrl.lang["Please wait"]}" + '...',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Get.theme.primaryColor,
                  colorText: Colors.white,
                  borderRadius: 5,
                  duration: Duration(seconds: 5),
                );
                getAmount().then((value) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PayTmPaymentScreen(
                        amount: finalAmount?.toStringAsFixed(2),
                        orderData: {
                          "custID": "USER_" +
                              dashboardController.profileData.id.toString(),
                          "custEmail":
                              dashboardController.profileData.email.toString(),
                          "custPhone":
                              dashboardController.profileData.phone.toString(),
                        },
                      ),
                    ),
                  );
                });
              } else if (controller.selectedGateway.value == "PayStack") {
                Get.snackbar(
                  "${stctrl.lang["Processing PayStack Payment"]}",
                  "${stctrl.lang["Please wait"]}" + '...',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Get.theme.primaryColor,
                  colorText: Colors.white,
                  borderRadius: 5,
                  duration: Duration(seconds: 5),
                );

                Charge charge = Charge()
                  ..amount =
                      (double.parse(controller.paymentAmount.toString()) * 100)
                          .toInt()
                  ..currency = payStackCurrency
                  ..reference = _getReference()
                  ..email = controller.email.value;
                CheckoutResponse response = await plugin.checkout(
                  context,
                  method: CheckoutMethod.card,
                  fullscreen: false,
                  charge: charge,
                );

                if (response.status == true) {
                  Map payment = {
                    'amount': controller.paymentAmount.toString(),
                    'payment_method': 'PayStack',
                    'transaction_id': response.reference,
                  };
                  await controller.makePayment('PayStack', payment);
                } else {
                  Get.snackbar(
                    "${stctrl.lang["Payment cancelled"]}",
                    '...',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    borderRadius: 5,
                    duration: Duration(seconds: 5),
                  );
                }
              } else if (controller.selectedGateway.value == "Instamojo") {
                Get.snackbar(
                  "${stctrl.lang["Processing Instamojo Payment"]}",
                  "${stctrl.lang["Please wait"]}" + '...',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Get.theme.primaryColor,
                  colorText: Colors.white,
                  borderRadius: 5,
                  duration: Duration(seconds: 5),
                );

                Map payment = {
                  'amount': controller.paymentAmount.toString(),
                };
                Get.to(
                  () => InstaMojoPayment(
                    paymentData: payment,
                    onFinish: (number) async {
                      if (number != null) {
                        Map payment = {
                          'amount': controller.paymentAmount.toString(),
                          'payment_method': 'PayStack',
                          'transaction_id': number,
                        };
                        await controller.makePayment('Instamojo', payment);
                      }
                    },
                  ),
                );
              } else if (controller.selectedGateway.value == "Stripe") {
                Get.snackbar(
                  "${stctrl.lang["Processing Stripe Payment"]}",
                  "${stctrl.lang["Please wait"]}" + '...',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Get.theme.primaryColor,
                  colorText: Colors.white,
                  borderRadius: 5,
                  duration: Duration(seconds: 5),
                );

                Map payment = {
                  'amount': controller.paymentAmount.toString(),
                  'email': controller.email.value
                };
                Get.to(
                  () => StripePaymentScreen(
                    paymentData: payment,
                    onFinish: (number) async {
                      if (number != null) {
                        Map payment = {
                          'amount': controller.paymentAmount.toString(),
                          'payment_method': 'PayStack',
                          'transaction_id': number,
                        };
                        await controller.makePayment('Stripe', payment);
                      }
                    },
                  ),
                );
              } else {
                Get.snackbar(
                  "${stctrl.lang["Select a payment method"]}",
                  "${stctrl.lang["Error"]}",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Get.theme.primaryColor,
                  colorText: Colors.white,
                  borderRadius: 5,
                  duration: Duration(seconds: 5),
                );
              }
            },
            child: Text(
              "${stctrl.lang["Continue"]}" +
                  " ${controller.selectedGateway.value} " +
                  "${stctrl.lang["Payment"]}",
              style: Get.textTheme.titleSmall?.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'LMS-${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }
}
