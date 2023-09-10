// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/cart_controller.dart';
import 'package:lms_flutter_app/Controller/class_controller.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Controller/myCourse_controller.dart';
import 'package:lms_flutter_app/Model/Settings/Country.dart';
import 'package:lms_flutter_app/Model/User/MyAddress.dart';
import 'package:lms_flutter_app/Service/RemoteService.dart';
import 'package:lms_flutter_app/Views/Cart/paymeny_page.dart';

import 'course_and_class_tab_controller.dart';

class PaymentController extends GetxController {
  final CartController cartController = Get.put(CartController());

  final MyCourseController myCourseController = Get.put(MyCourseController());

  final ClassController classController = Get.put(ClassController());

  final DashboardController dashboardController =
      Get.put(DashboardController());

  final CourseClassQuizTabController _courseClassQuizTabController =
      Get.put(CourseClassQuizTabController());

  var paymentAmount = "".obs;

  var trackingId = "".obs;

  var isLoading = false.obs;

  var isCountryLoading = false.obs;

  var isCityLoading = false.obs;

  var tokenKey = "token";
  GetStorage userToken = GetStorage();

  // ignore: deprecated_member_use
  List<MyAddress> myAddress = <MyAddress>[].obs;

  var country = CountryList().obs;

  var city = CountryList().obs;

  var billingAddress = "".obs;
  var oldBilling = 0.obs;
  var firstName = "".obs;
  var lastName = "".obs;
  var countryName = "".obs;
  var cityName = "".obs;
  var address1 = "".obs;
  var phone = "".obs;
  var email = "".obs;
  var tracking = "".obs;
  var zipCode = "".obs;
  var getCountry = Country().obs;

  var countryId = 0.obs;
  var cityId = 0.obs;
  var stateId = 0.obs;

  var isPaymentLoading = false.obs;
  var paymentList = [].obs;

  var selectedGateway = "".obs;

  TextEditingController? firstNameController;
  TextEditingController? lastNameController;
  TextEditingController? addressController;
  TextEditingController? phoneController;
  TextEditingController? emailController;

  @override
  void onInit() {
    getMyAddress();
    getPaymentList();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    super.onInit();
  }

  Future<List<MyAddress>?> getMyAddress() async {
    String token = await userToken.read(tokenKey);
    try {
      isLoading(true);
      Uri myAddressUrl = Uri.parse(baseUrl + '/my-billing-address');
      var response = await http.get(
        myAddressUrl,
        headers: header(token: token),
      );
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        myAddress = myAddressFromJson(jsonEncode(jsonString['data']));
        if (myAddress.length > 0) {
          tracking.value = myAddress[0].trackingId ?? '';
          firstName.value = myAddress[0].firstName ?? '';
          lastName.value = myAddress[0].lastName ?? '';
          countryName.value = myAddress[0].country?.name ?? '';
          cityName.value = myAddress[0].city ?? '';
          address1.value = myAddress[0].address1 ?? '';
          zipCode.value = myAddress[0].zipCode ?? '';
          email.value = myAddress[0].email ?? '';
          getCountry.value = myAddress[0].country ?? Country();
          phone.value = myAddress[0].phone ?? '';
          oldBilling.value = myAddress[0].id;
          billingAddress.value = "previous";
        }
        return myAddress;
      } else {
        Get.snackbar(
          "${stctrl.lang["Error"]}",
          jsonString['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          borderRadius: 5,
        );
        return null;
      }
    } finally {
      isLoading(false);
    }
  }

  Future makeOrderNew() async {
    String token = await userToken.read(tokenKey);
    try {
      isLoading(true);

      var postUri = Uri.parse(baseUrl + '/make-order');
      var request = new http.MultipartRequest("POST", postUri);
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      request.headers['$authHeader'] = '$isBearer' + '$token';
      request.headers['ApiKey'] = '$apiKey';

      request.fields['tracking_id'] = trackingId.value;
      request.fields['billing_address'] = "new";
      request.fields['old_billing'] = "0";
      request.fields['first_name'] = firstNameController?.text ?? '';
      request.fields['last_name'] = lastNameController?.text ?? '';
      request.fields['country'] = countryId.value.toString();
      request.fields['city'] = cityId.value.toString();
      request.fields['state'] = stateId.value.toString();
      request.fields['address1'] = addressController?.text ?? '';
      request.fields['phone'] = phoneController?.text ?? '';
      request.fields['email'] = emailController?.text ?? '';

      request
          .send()
          .then((result) async {
            http.Response.fromStream(result).then((response) {
              var jsonString = jsonDecode(response.body);
              if (response.statusCode == 200) {
                email.value = emailController?.text ?? '';

                if (jsonString['type'] == 'Free') {
                  cartController.cartList.value = [];
                  cartController.update();
                  cartController.getCartList();
                  myCourseController.myCourses.value = [];
                  myCourseController.fetchMyCourse();
                  classController.allMyClass.value = [];
                  classController.fetchAllMyClass();
                  Future.delayed(Duration(seconds: 2), () {
                    Get.back();
                    dashboardController.changeTabIndex(2);
                    Get.snackbar(
                      "${stctrl.lang["Done"]}",
                      jsonString['message'].toString(),
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Get.theme.primaryColor,
                      colorText: Colors.white,
                      borderRadius: 5,
                    );
                  }).then((value) async {
                    dashboardController.changeTabIndex(2);
                    _courseClassQuizTabController.myCoursesController.myCourses
                        .clear();
                    await _courseClassQuizTabController.myCoursesController
                        .fetchMyCourse();

                    _courseClassQuizTabController.myClassController.allMyClass
                        .clear();
                    await _courseClassQuizTabController.myClassController
                        .fetchAllMyClass();

                    _courseClassQuizTabController.myQuizController.allMyQuiz
                        .clear();
                    await _courseClassQuizTabController.myQuizController
                        .fetchAllMyQuiz();
                  });
                } else {
                  Get.snackbar(
                    "${stctrl.lang["Done"]}",
                    jsonString['message'].toString(),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Get.theme.primaryColor,
                    colorText: Colors.white,
                    borderRadius: 5,
                  );
                  Future.delayed(Duration(seconds: 4), () {
                    getPaymentList();
                    Get.to(() => PaymentScreen());
                  });
                }
              } else {
                Get.snackbar(
                  "${stctrl.lang["Failed"]}",
                  jsonString['message'].toString(),
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                  borderRadius: 5,
                );
              }

              return response.body;
            });
          })
          .catchError((err) {
        print('error : ' + err.toString());
      } )
          .whenComplete(() {});
    } finally {
      isLoading(false);
    }
  }

  Future makeOrderOld() async {
    String token = await userToken.read(tokenKey);
    try {
      isLoading(true);

      var postUri = Uri.parse(baseUrl + '/make-order');
      var request = new http.MultipartRequest("POST", postUri);
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      request.headers['$authHeader'] = '$isBearer' + '$token';
      request.headers['ApiKey'] = '$apiKey';
      request.fields['tracking_id'] = tracking.value;
      request.fields['billing_address'] = "previous";
      request.fields['old_billing'] = oldBilling.value.toString();

      request
          .send()
          .then((result) async {
            http.Response.fromStream(result).then((response) {
              var jsonString = jsonDecode(response.body);
              if (response.statusCode == 200) {
                if (jsonString['type'] == 'Free') {
                  cartController.cartList.value = [];
                  cartController.update();
                  cartController.getCartList();
                  myCourseController.myCourses.value = [];
                  myCourseController.fetchMyCourse();
                  classController.allMyClass.value = [];
                  classController.fetchAllMyClass();
                  Future.delayed(Duration(seconds: 2), () {
                    Get.back();
                    dashboardController.changeTabIndex(2);
                    Get.snackbar(
                      "${stctrl.lang["Done"]}",
                      jsonString['message'].toString(),
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Get.theme.primaryColor,
                      colorText: Colors.white,
                      borderRadius: 5,
                    );
                  }).then((value) async {
                    _courseClassQuizTabController.myCoursesController.myCourses
                        .clear();
                    await _courseClassQuizTabController.myCoursesController
                        .fetchMyCourse();

                    _courseClassQuizTabController.myClassController.allMyClass
                        .clear();
                    await _courseClassQuizTabController.myClassController
                        .fetchAllMyClass();

                    _courseClassQuizTabController.myQuizController.allMyQuiz
                        .clear();
                    await _courseClassQuizTabController.myQuizController
                        .fetchAllMyQuiz();
                  });
                } else {
                  Get.snackbar(
                    "${stctrl.lang["Done"]}",
                    jsonString['message'].toString(),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Get.theme.primaryColor,
                    colorText: Colors.white,
                    borderRadius: 5,
                  );
                  Future.delayed(Duration(seconds: 4), () {
                    getPaymentList();
                    Get.to(() => PaymentScreen());
                  });
                }
              } else {
                Get.snackbar(
                  "${stctrl.lang["Failed"]}",
                  jsonString['message'].toString(),
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                  borderRadius: 5,
                );
              }

              return response.body;
            });
          })
          .catchError((err) {
        print('error : ' + err.toString());
      } )
          .whenComplete(() {});
    } finally {
      isLoading(false);
    }
  }

  Future makePayment(gatewayName, Map resp) async {
    String token = await userToken.read(tokenKey);
    try {
      isLoading(true);
      var postUri = Uri.parse(baseUrl + '/make-payment/$gatewayName');
      var request = new http.MultipartRequest("POST", postUri);
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      request.headers['$authHeader'] = '$isBearer' + '$token';
      request.headers['ApiKey'] = '$apiKey';

      request.fields['response'] = resp.toString();

      request
          .send()
          .then((result) async {
            http.Response.fromStream(result).then((response) {
              var jsonString = jsonDecode(response.body);
              if (response.statusCode == 200 && jsonString['success'] == true) {
                cartController.cartList.value = [];
                cartController.update();
                cartController.getCartList();
                // myCourseController.myCourses.value = [];
                // myCourseController.fetchMyCourse();
                Future.delayed(Duration(seconds: 2), () {
                  Get.back();
                  Get.back();
                  dashboardController.changeTabIndex(2);
                  Get.snackbar(
                    "${stctrl.lang["Done"]}",
                    jsonString['message'].toString(),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Get.theme.primaryColor,
                    colorText: Colors.white,
                    borderRadius: 5,
                  );
                }).then((value) async {
                  dashboardController.changeTabIndex(2);
                  _courseClassQuizTabController.myCoursesController.myCourses
                      .clear();
                  await _courseClassQuizTabController.myCoursesController
                      .fetchMyCourse();

                  _courseClassQuizTabController.myClassController.allMyClass
                      .clear();
                  await _courseClassQuizTabController.myClassController
                      .fetchAllMyClass();

                  _courseClassQuizTabController.myQuizController.allMyQuiz
                      .clear();
                  await _courseClassQuizTabController.myQuizController
                      .fetchAllMyQuiz();
                });
              } else {
                Get.snackbar(
                  "${stctrl.lang["Failed"]}",
                  jsonString['message'].toString(),
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                  borderRadius: 5,
                );
              }

              return response.body;
            });
          })
          .catchError((err) {
        print('error : ' + err.toString());
      } )
          .whenComplete(() {
            Get.back();
          });
    } finally {
      isLoading(false);
    }
  }

  void getPaymentList() async {
    try {
      isPaymentLoading(true);
      var payment = await RemoteServices.getPaymentList();
      if (payment != null) {
        paymentList.value = payment;
        selectedGateway.value = paymentList[0].method;
      }
    } finally {
      isPaymentLoading(false);
    }
  }

  void getCadList(message) async {
    if (message == 'success') {
      Get.snackbar(
        "Thank you",
        "Payment success",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Colors.white,
        borderRadius: 5,
        duration: Duration(seconds: 5),
      );
      await makePayment('Sslcommerz', {});
    }
    else if (message == 'failed') {
      Get.snackbar(
        "Oops",
        "Payment failed",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Colors.white,
        borderRadius: 5,
        duration: Duration(seconds: 5),
      );
    }
    else if (message == 'cancel') {
      Get.snackbar(
        "Oops",
        "Payment failed",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Colors.white,
        borderRadius: 5,
        duration: Duration(seconds: 5),
      );
    }
  }
}
